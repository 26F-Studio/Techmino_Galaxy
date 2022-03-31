local gc=love.graphics

local max,min=math.max,math.min
local int,ceil=math.floor,math.ceil
local sin,cos=math.sin,math.cos

local ins,rem=table.insert,table.remove

local MP={}
setmetatable(MP,{__index=require'assets.player.basePlayer'})

--------------------------------------------------------------
-- Actions
local function _defaultPressEvent(self,act)
    if not self.actions[act] or self.keyState[act] then return end
    self.keyState[act]=true
    ins(self.actionHistory,{0,self.timer,act})
    self.actions[act].press(self)
end
local function _defaultPeleaseEvent(self,act)
    if not self.actions[act] or not self.keyState[act] then return end
    self.keyState[act]=false
    ins(self.actionHistory,{1,self.timer,act})
    self.actions[act].release(self)
end

local actions={}
function actions.moveLeft(self)
    if not self.hand then return end
    self.moveDir=-1
    self.moveCharge=0
    if not self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) then
        self.handX=self.handX-1
        self:freshGhost()
    end
end
function actions.moveRight(self)
    if not self.hand then return end
    self.moveDir=1
    self.moveCharge=0
    if not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) then
        self.handX=self.handX+1
        self:freshGhost()
    end
end
function actions.rotateCW(self)
    self:rotate('R')
end
function actions.rotateCCW(self)
    self:rotate('L')
end
function actions.rotate180(self)
    self:rotate('F')
end
function actions.softDrop(self)
    self.downCharge=0
    if not self.hand then return end
    if self.handY>self.ghostY then
        self.handY=self.handY-1
        self:freshDelay('drop')
    end
end
function actions.sonicDrop(self)
    self.downCharge=false
    if not self.hand then return end
    if self.handY>self.ghostY then
        self.handY=self.ghostY
        self:freshDelay('drop')
    end
end
function actions.hardDrop(self)
    if not self.hand then return end
    if self.handY>self.ghostY then
        self.handY=self.ghostY
    end
    self:dropMino()
end
function actions.holdPiece(self)
    if not self.hand then return end
    if self.holdChance<=0 then return end
    if self.settings.holdMode=='hold' then
        self:hold_hold()
    elseif self.settings.holdMode=='swap' then
        self:hold_swap()
    elseif self.settings.holdMode=='float' then
        self:hold_float()
    else
        error("wtf why holdMode is "..tostring(self.settings.holdMode))
    end
    self.holdChance=self.holdChance-1
end

actions.function1=NULL
actions.function2=NULL
actions.function3=NULL
actions.function4=NULL

actions.target1=NULL
actions.target2=NULL
actions.target3=NULL
actions.target4=NULL

function actions.sonicLeft(self)
    while self.hand and not self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) do
        self.handX=self.handX-1
        self:freshGhost()
    end
end
function actions.sonicRight(self)
    while self.hand and not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) do
        self.handX=self.handX+1
        self:freshGhost()
    end
end
function actions.dropLeft(self)
    actions.sonicLeft(self)
    actions.hardDrop(self)
end
function actions.dropRight(self)
    actions.sonicRight(self)
    actions.hardDrop(self)
end
function actions.zangiLeft(self)
    actions.sonicLeft(self)
    actions.sonicDrop(self)
    actions.sonicRight(self)
    actions.hardDrop(self)
end
function actions.zangiRight(self)
    actions.sonicRight(self)
    actions.sonicDrop(self)
    actions.sonicLeft(self)
    actions.hardDrop(self)
end

local function _getActionObj(a)
    if type(a)=='string' then
        return actions[a]
    elseif type(a)=='function' then
        return setmetatable({
            press=a,
            release=NULL,
        },{__call=function(self,P)
            self.press(P)
        end})
    elseif type(a)=='table' then
        assert(type(a.press)=='function' and type(a.release)=='function',"wtf why action do not contain func press() & func release()")
        return setmetatable({
            press=a.press,
            release=a.release,
        },{__call=function(self,P)
            self.press(P)
            self.release(P)
        end})
    else
        error("Invalid action: should be function or table contain 'press' and 'release' fields")
    end
end
for k,v in next,actions do actions[k]=_getActionObj(v) end
local actionPacks={
    classic={
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'softDrop',
    },
    modern={
        'dropLeft',
        'dropRight',
        'zangiLeft',
        'zangiRight',
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'rotate180',
        'softDrop',
        'sonicDrop',
        'hardDrop',
        'holdPiece',
    },
}
--------------------------------------------------------------
-- Events
function MP:restoreMinoState(mino)-- Restore a mino object's state (only inside, like shape, name, direction)
    if not mino._origin then return end
    for k,v in next,mino._origin do
        mino[k]=v
    end
    return mino
end
function MP:restoreHandPos()-- Move hand piece to the normal spawn position
    self.handX=int(self.field.width/2-#self.hand.matrix[1]/2+1)
    self.handY=self.settings.spawnH+1
    if self:ifoverlap(self.hand.matrix,self.handX,self.handY) then
        self:lock()
        self:gameover('WA')
        return
    end
    self.minY=self.handY
    self:freshGhost()
    self:freshDelay('spawn')
end
function MP:freshGhost()
    if self.hand then
        self.ghostY=min(#self.field.matrix+1,self.handY)

        -- Move ghost to bottom
        while not self:ifoverlap(self.hand.matrix,self.handX,self.ghostY-1) do
            self.ghostY=self.ghostY-1
        end

        if (self.settings.dropDelay==0 or self.downCharge and self.settings.sdarr==0) and self.ghostY<self.handY then-- TODO: if (temp) 20G on
            self.handY=self.ghostY
            self:freshDelay('drop')
        else
            self:freshDelay('move')
        end
    end
end
function MP:freshDelay(reason)-- reason can be 'move' or 'drop' or 'spawn'
    if self.handY<self.minY then self.minY=self.handY end
    if self.settings.freshCondition=='any' then
        if reason=='move' then
            if self.lockTimer<self.settings.lockDelay then
                self.lockTimer=self.settings.lockDelay
                -- TODO: self.freshTime-=1
            end
        elseif reason=='drop' or reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
        end
    elseif self.settings.freshCondition=='fall' then
        if reason=='drop' then
            self.dropTimer=self.settings.dropDelay
            if self.lockTimer<self.settings.lockDelay then
                self.lockTimer=self.settings.lockDelay
                -- TODO: self.freshTime-=1
            end
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
        end
    elseif self.settings.freshCondition=='never' then
        if reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
        end
    else
        error("wtf why settings.freshCondition is "..tostring(self.settings.freshCondition))
    end
end
function MP:popNext()
    if self.nextQueue[1] then-- Most cases there is pieces in next queue
        self.hand=rem(self.nextQueue,1)
        self:restoreHandPos()
        self.genNext()
        self.holdChance=min(self.holdChance+1,self.settings.holdCount)
    elseif self.holdQueue[1] then-- If no nexts, force using hold
        ins(self.nextQueue,rem(self.holdQueue,1))
        self:popNext()
    else-- If no piece to use, both Next and Hold queue are empty, game over
        self:gameover('ILE')
    end
end
function MP:getMino(shapeID)
    local shape=TABLE.shift(Blocks[shapeID].shape)
    local c=math.random(64)
    for y=1,#shape do
        for x=1,#shape[1] do
            if shape[y][x] then
                shape[y][x]={color=(c+math.random(-2,2))%64+1}-- Should be player's color setting
            end
        end
    end
    self.minoCount=self.minoCount+1
    local mino={
        id=self.minoCount,
        shape=shapeID,
        direction=0,
        name=Blocks[shapeID].name,
        matrix=shape,
    }
    mino._origin=TABLE.copy(mino,0)
    ins(self.nextQueue,mino)
end
local wallCell=setmetatable({},{__newIndex=NULL})
function MP:getCell(x,y)
    if x<=0 or x>self.field.width or y<=0 then return wallCell end
    if y>self.field.width then return false end
    return self.field.matrix[y][x]
end

function MP:ifoverlap(CB,cx,cy)
    local F=self.field.matrix
    if cx<=0 or cx+#CB[1]-1>self.field.width or cy<=0 then
        return true
    end
    if cy>#F then
        return
    end
    for y=1,#CB do
        if not F[cy+y-1] then return end
        for x=1,#CB[1] do
            if CB[y][x] and F[cy+y-1][cx+x-1] then
                return true
            end
        end
    end
end
function MP:rotate(dir)
    if not self.hand then return end
    local minoData=RotationSys[self.settings.rotSys][self.hand.shape]
    if dir~='R' and dir~='L' and dir~='F' then error("wtf why dir isn't R/L/F") end

    if minoData.rotate then-- Custom rotate function
        minoData.rotate(self,dir)
    else-- Normal rotate procedure
        local preState=minoData[self.hand.direction]
        if preState then
            -- Rotate matrix
            local kick=preState[dir]
            if not kick then return end-- This RS doesn't define this rotation

            local cb=self.hand.matrix
            local icb=TABLE.rotate(cb,dir)
            local baseX,baseY

            local afterState=minoData[kick.target]
            if kick.base then
                baseX=kick.base[1]
                baseY=kick.base[2]
            elseif preState.center and afterState.center then
                baseX=preState.center[1]-afterState.center[1]
                baseY=preState.center[2]-afterState.center[2]
            else
                error('cannot get baseX/Y')
            end

            for n=1,#kick.test do
                local ix,iy=self.handX+baseX+kick.test[n][1],self.handY+baseY+kick.test[n][2]
                if not self:ifoverlap(icb,ix,iy) then
                    self.hand.matrix=icb
                    self.handX,self.handY=ix,iy
                    self.hand.direction=kick.target
                    self:freshGhost()
                    return
                end
            end
        else
            error("wtf why no state in minoData")
        end
    end
end
function MP:hold_hold()
    if not self.settings.holdKeepState then
        self.hand=self:restoreMinoState(self.hand)
    end
    if self.holdQueue[1] then
        self.hand,self.holdQueue[1]=self.holdQueue[1],self.hand
        self:restoreHandPos()
    else
        self.holdQueue[1]=self.hand
        self.hand=false
        self:popNext()
    end
end
function MP:hold_swap()
    if self.nextQueue[1] then
        if not self.settings.holdKeepState then
            self.hand=self:restoreMinoState(self.hand)
        end
        self.hand,self.nextQueue[1]=self.nextQueue[1],self.hand
        self:restoreHandPos()
    end
end
function MP:hold_float()
    -- TODO
end
function MP:dropMino()
    self:lock()
    self:checkField()
    if self.finished then return end
    self:minoDropped()
    if self.settings.spawnDelay==0 then
        self:popNext()
    end
end
function MP:lock()
    local CB=self.hand.matrix
    local F=self.field.matrix
    for y=1,#CB do
        for x=1,#CB[1] do
            if CB[y][x] then
                F[self.handY+y-1][self.handX+x-1]=CB[y][x]
            end
        end
    end
end
function MP:minoDropped()
    self.hand=false
    self.spawnTimer=self.settings.spawnDelay
end
function MP:checkField()
    local lineClear={}
    local F=self.field.matrix
    for y=#F,1,-1 do
        local hasHole
        for x=1,self.field.width do
            if not F[y][x] then
                hasHole=true
                break
            end
        end
        if not hasHole then
            rem(F,y)
            ins(lineClear,y)
        end
    end
    if #lineClear>0 then
        ins(self.clearHistory,{
            lines=lineClear,
        })
    else
        if self.handY>self.settings.deathH then
            self:gameover('MLE')
        end
    end
end
function MP:gameover(reason)
    if self.finished then return end
    self.finished=true
    self.hand=false
    self.spawnTimer=1e99
    MES.new('error',reason,626)
    if reason=='AC' then-- Win
        -- TODO
    elseif reason=='WA' then-- Block out
        -- TODO
    elseif reason=='CE' then-- Lock out
        -- TODO
    elseif reason=='MLE' then-- Top out
        -- TODO
    elseif reason=='TLE' then-- Time out
        -- TODO
    elseif reason=='OLE' then-- Finesse fault
        -- TODO
    elseif reason=='ILE' then-- Ran out pieces
        -- TODO
    elseif reason=='PE' then-- Mission failed
        -- TODO
    elseif reason=='RE' then-- Other reason
        -- TODO
    end
end
--------------------------------------------------------------
-- Updates
local function step(self,d)
    if self.timer<=self.settings.readyDelay then
        local t0=self.settings.readyDelay-self.timer
        local t1=int((t0-1)/1000)
        t0=int(t0/1000)
        if t0~=t1 then
            MES.new('info',t0)
        end
    end

    self.timer=self.timer+d
    for i=1,#self.task do self.task[i].func(self,d) end
end
function MP:update(dt)
    local df=int((self.curTime+dt)*1000)-int(self.curTime*1000)
    self.curTime=self.curTime+dt

    local l=self.task
    while df>0 do
        local closestTime=df
        for i=1,#l do
            local waitFunc=l[i].wait
            closestTime=min(waitFunc and waitFunc(self) or 1,closestTime)
            if closestTime<=0 then
                error(STRING.repD("Invalid counter in task '$1'",l[i].name))
            end
        end
        if closestTime>1 then
            step(self,closestTime-1)
            step(self,1)
            df=df-closestTime
        else
            step(self,1)
            df=df-1
        end
    end
end
local updTasks={}
updTasks.control={
    name='control',
    wait=function(self)
        -- TODO
    end,
    func=function(self,df)
        -- Auto shift
        -- Magic, I think it should work
        if self.moveDir and (self.moveDir==-1 and self.keyState.moveLeft or self.moveDir==1 and self.keyState.moveRight) then
            local c0=self.moveCharge
            local c1=c0+df
            self.moveCharge=c1
            local dist=0
            if c0>=self.settings.das then
                c0=c0-self.settings.das
                c1=c1-self.settings.das
                if self.settings.arr==0 then
                    dist=1e99
                else
                    dist=int(c1/self.settings.arr)-int(c0/self.settings.arr)
                end
            elseif c1>=self.settings.das then
                dist=1
            end
            while self.hand and dist>0 and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) do
                self.handX=self.handX+self.moveDir
                self:freshGhost()
                dist=dist-1
            end
        else
            self.moveDir=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
            self.moveCharge=0
        end

        -- Auto drop
        if self.downCharge then
            if self.keyState.softDrop then
                local c0=self.downCharge
                local c1=c0+df
                self.downCharge=c1

                local dist=self.settings.sdarr==0 and 1e99 or int(c1/self.settings.sdarr)-int(c0/self.settings.sdarr)
                while self.hand and dist>0 and not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) do
                    self.handY=self.handY-1
                    self:freshDelay('drop')
                    dist=dist-1
                end
            else
                self.downCharge=false
            end
        end
    end,
}
updTasks.normal={
    name='normal',
    wait=function(self)
        -- TODO
    end,
    func=function(self,df)
        if self.spawnTimer>0 then
            self.spawnTimer=self.spawnTimer-df
            if self.spawnTimer==0 then
                self:popNext()
            end
            return
        end
        if self.handY==self.ghostY then
            self.lockTimer=self.lockTimer-df
            if self.lockTimer==0 then
                self:dropMino()
            end
            return
        else
            if self.dropDelay~=0 then
                self.dropTimer=self.dropTimer-df
                if self.dropTimer==0 then
                    self.dropTimer=self.settings.dropDelay
                    self.handY=self.handY-1
                end
            elseif self.handY~=self.ghostY then-- If switch to 20G during game, mino won't dropped to bottom instantly so we force fresh it
                self:freshDelay('drop')
            end
        end
    end
}
--------------------------------------------------------------
-- Draws
local _fieldCanvas=Zenitha.getBigCanvas(1)
local drawEvents={}
function drawEvents.applyPlayerTransform(self)
    gc.setCanvas({_fieldCanvas,stencil=true})
    gc.clear(1,1,1,0)
    gc.push('transform')
    gc.translate(self.pos.x,self.pos.y)
    gc.scale(self.pos.kx,self.pos.ky)
    gc.rotate(self.pos.angle)
end
function drawEvents.applyFieldTransform(self)
    gc.push('transform')
    gc.translate(-200,400)
    GC.stc_setComp('equal',1)
    GC.stc_rect(0,0,400,-840)
    gc.scale(10/self.settings.fieldW)
end
function drawEvents.field(self)
    -- Grid
    gc.setColor(1,1,1,.26)
    local r,l=1,6-- Line width/length
    local gridHeight=min(max(self.settings.spawnH,self.settings.deathH),2*self.settings.fieldW)
    for x=1,self.settings.fieldW do
        x=(x-1)*40
        for y=1,gridHeight do
            y=-y*40
            gc.rectangle('fill',x,y,l,r)
            gc.rectangle('fill',x,y+r,r,l-r)
            gc.rectangle('fill',x+40,y,-l,r)
            gc.rectangle('fill',x+40,y+r,-r,l-r)
            gc.rectangle('fill',x,y+40,l,-r)
            gc.rectangle('fill',x,y+40-r,r,r-l)
            gc.rectangle('fill',x+40,y+40,-l,-r)
            gc.rectangle('fill',x+40,y+40-r,-r,r-l)
        end
    end

    -- Cells
    local f=self.field.matrix
    for y=1,#f do
        for x=1,#f[y] do
            if f[y][x] then
                gc.setColor(ColorTable[f[y][x].color])
                gc.rectangle('fill',(x-1)*40,-y*40,40,40)
            end
        end
    end
end
function drawEvents.ghost(self)
    if not self.hand then return end
    gc.setColor(1,1,1,.26)
    local CB=self.hand.matrix
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            gc.rectangle('fill',(self.handX+x-2)*40,-(self.ghostY+y-1)*40,40,40)
        end
    end end
end
function drawEvents.block(self)
    if not self.hand then return end
    gc.push('transform')
    if self.handY>self.ghostY then
        gc.translate(0,40-self.dropTimer/self.settings.dropDelay*40)
    end
    gc.setColor(1,1,1)
    local CB=self.hand.matrix
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            gc.setColor(ColorTable[CB[y][x].color])
            gc.rectangle('fill',(self.handX+x-2)*40,-(self.handY+y-1)*40,40,40)
        end
    end end
    local RS=RotationSys[self.settings.rotSys]
    local minoData=RS[self.hand.shape]
    local state=minoData[self.hand.direction]
    local center=state and state.center or type(minoData.center)=='function' and minoData.center(self)
    if center then
        gc.setColor(1,0,0)
        GC.draw(RS.centerTex,(self.handX+center[1]-1)*40,-(self.handY+center[2]-1)*40)
    end
    gc.pop()
end
function drawEvents.heightLines(self)
    local width=self.settings.fieldW*40

    -- Spawning height
    gc.setColor(0,.4,1,.8)
    gc.rectangle('fill',0,-self.settings.spawnH*40-2,width,4)

    -- Death height
    gc.setColor(1,0,0,.6)
    gc.rectangle('fill',0,-self.settings.deathH*40-2,width,4)

    -- Void height
    gc.setColor(0,0,0,.5)
    gc.rectangle('fill',0,-1260*40-40,width,40)
end
function drawEvents.popFieldTransform(self)
    GC.stc_stop()
    gc.pop()
end
function drawEvents.board(self)
    -- Field border
    gc.setColor(1,1,1)
    gc.setLineWidth(2)
    gc.rectangle('line',-201,-401,402,802)

    -- Delay indicator
    gc.setColor(1,1,1)
    gc.setLineWidth(2)
    gc.rectangle('line',-201,401,402,12)
    local color,value
    if not self.hand then
        color,value=COLOR.lR,self.spawnTimer/self.settings.spawnDelay
    elseif self.handY~=self.ghostY then
        color,value=COLOR.lG,self.dropTimer/self.settings.dropDelay
    else
        color,value=COLOR.L,self.lockTimer/self.settings.lockDelay
    end
    gc.setColor(color)
    gc.rectangle('fill',-199,403,398*math.min(value,1),8)
end
function drawEvents.next(self)-- Almost same as drawEvents.hold, don't forget to change both
    gc.push('transform')
    gc.translate(300,-400+50)
    gc.setColor(1,1,1)
    for n=1,#self.nextQueue do
        local NB=self.nextQueue[n].matrix
        local k=min(2.3/#NB,3/#NB[1],.86)
        gc.scale(k)
        for y=1,#NB do for x=1,#NB[1] do
            if NB[y][x] then
                gc.setColor(ColorTable[NB[y][x].color])
                gc.rectangle('fill',(x-#NB[1]/2-1)*40,(y-#NB/2)*-40,40,40)
            end
        end end
        gc.scale(1/k)
        gc.translate(0,100)
    end
    gc.pop()
end
function drawEvents.hold(self)-- Almost same as drawEvents.next, don't forget to change both
    gc.push('transform')
    gc.translate(-300,-400+50)
    gc.setColor(1,1,1)
    for n=1,#self.holdQueue do
        local NB=self.holdQueue[n].matrix
        local k=min(2.3/#NB,3/#NB[1],.86)
        gc.scale(k)
        for y=1,#NB do for x=1,#NB[1] do
            if NB[y][x] then
                gc.setColor(ColorTable[NB[y][x].color])
                gc.rectangle('fill',(x-#NB[1]/2-1)*40,(y-#NB/2)*-40,40,40)
            end
        end end
        gc.scale(1/k)
        gc.translate(0,100)
    end
    gc.pop()
end
function drawEvents.popPlayerTransform()
    -- Upside fade out
    gc.setBlendMode('multiply','premultiplied')
    gc.setColorMask(false,false,false,true)
    for i=0,39 do
        gc.setColor(0,0,0,(1-i/40)^2)
        gc.rectangle('fill',-200,-402-i,400,-1)
    end
    gc.setBlendMode('alpha')
    gc.setColorMask()

    gc.setCanvas()
    gc.pop()

    gc.push('transform')
    gc.replaceTransform(SCR.origin)
    gc.setColor(1,1,1)
    gc.draw(_fieldCanvas)
    gc.pop()
end
--------------------------------------------------------------
-- Useful methods
function MP:setPosition(x,y,kx,ky,angle)
    self.pos.x=x or self.pos.x
    self.pos.y=y or self.pos.y
    self.pos.kx=kx or self.pos.kx
    self.pos.ky=ky or self.pos.ky
    self.pos.angle=angle or self.pos.angle
end
function MP:movePosition(dx,dy,kx,ky,da)
    self.pos.x=self.pos.x+(dx or 0)
    self.pos.y=self.pos.y+(dy or 0)
    self.pos.kx=self.pos.kx*(kx or 1)
    self.pos.ky=self.pos.ky*(ky or 1)
    self.pos.angle=self.pos.angle+(da or 0)
end
--------------------------------------------------------------
-- Builder
function MP.new(data)
    assert(type(data)=='table',"function PLAYER.new(data): data must be table")
    local p=require'assets.player.basePlayer'.new(data)
    setmetatable(p,{__index=MP})

    p.settings={-- Generate from template in future
        fieldW=10,-- [WARNING] This is not the real field width, just for generate field object. If really want change it, you need change both 'self.field.width' and 'self.field.matrix'
        spawnH=20,-- [WARNING] This can be changed anytime. Field object actually do not contain height information
        deathH=21,
        barrierL=18,
        barrierH=21,

        nextCount=6,

        holdCount=1,
        holdMode='hold',
        holdKeepState=false,

        readyDelay=3000,
        dropDelay=1000,
        lockDelay=1000,
        spawnDelay=0,
        clearDelay=1000,

        das=70,
        arr=0,
        sdarr=0,

        seqData={},
        rotSys='TRS',

        freshCondition='any',
    }

    p.pos={
        x=0,y=0,
        kx=1,ky=1,
        angle=0,
    }

    p.field=require'assets.player.minoField'.new(p.settings.fieldW,p.settings.spawnH)
    p.fieldBeneath=0

    p.garbageBuffer={}

    p.holdQueue={}
    p.holdChance=0

    p.nextQueue={}
    p.genNext=coroutine.wrap(function()
        local l={}
        while true do
            while #p.nextQueue<p.settings.nextCount do
                if not l[1] then for i=1,7 do l[i]=i end end
                p:getMino(rem(l,math.random(#l)))
            end
            coroutine.yield()
        end
    end)

    p.minoCount=0

    p.energy=0
    p.energyShow=0

    p.dropTimer=0
    p.lockTimer=0
    p.spawnTimer=p.settings.readyDelay

    p.hand=false
    p.handX=false
    p.handY=false
    p.ghostY=false
    p.minY=false

    p.moveDir=false
    p.moveCharge=0
    p.downCharge=false

    p.curTime=0-- Real time, [double] ms
    p.timer=0-- Inside timer for player, [int] ms
    p.timing=false-- Are we timing?

    p.clearHistory={}
    p.actionHistory={}

    do-- Generate available actions
        p.actions={}
        local pack=data.actionPack or 'modern'
        if type(pack)=='string' then
            pack=actionPacks[pack]
            assert(pack,STRING.repD("Invalid actionPack '$1'",pack))
            for i=1,#pack do
                p.actions[pack[i]]=_getActionObj(pack[i])
            end
        elseif type(pack)=='table' then
            for k,v in next,pack do
                if type(k)=='number' then
                    p.actions[v]=_getActionObj(v)
                elseif type(k)=='string' then
                    assert(actions[k],STRING.repD("function PLAYER.new(data): no action called '$1'",k))
                    p.actions[k]=_getActionObj(v)
                else
                    error(STRING.repD("Invalid actionPack table's key type ($1)",type(k)))
                end
            end
        else
            error("function PLAYER.new(data): data.actionPack must be string or table")
        end

        p.keyState={}
        for k in next,p.actions do
            p.keyState[k]=false
        end
    end

    p.genNext()

    ins(p.pressEventList,_defaultPressEvent)
    ins(p.releaseEventList,_defaultPeleaseEvent)

    ins(p.drawEventList,drawEvents.applyPlayerTransform)
    ins(p.drawEventList,drawEvents.applyFieldTransform)
    ins(p.drawEventList,drawEvents.field)
    ins(p.drawEventList,drawEvents.ghost)
    ins(p.drawEventList,drawEvents.block)
    ins(p.drawEventList,drawEvents.heightLines)
    ins(p.drawEventList,drawEvents.popFieldTransform)
    ins(p.drawEventList,drawEvents.board)
    ins(p.drawEventList,drawEvents.next)
    ins(p.drawEventList,drawEvents.hold)
    ins(p.drawEventList,drawEvents.popPlayerTransform)

    p.task={}
    ins(p.task,updTasks.control)
    ins(p.task,updTasks.normal)

    return p
end
--------------------------------------------------------------

return MP
