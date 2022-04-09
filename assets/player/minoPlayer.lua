local gc=love.graphics

local max,min=math.max,math.min
local int,ceil=math.floor,math.ceil

local ins,rem=table.insert,table.remove

local MP={}

--------------------------------------------------------------
-- Actions
local actions={}
function actions.moveLeft(self)
    self.moveDir=-1
    self.moveCharge=0
    if not self.hand then return end
    if not self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) then
        self.handX=self.handX-1
        self:freshGhost()
    end
end
function actions.moveRight(self)
    self.moveDir=1
    self.moveCharge=0
    if not self.hand then return end
    if not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) then
        self.handX=self.handX+1
        self:freshGhost()
    end
end
function actions.rotateCW(self)
    if not self.hand then return end
    self:rotate('R')
end
function actions.rotateCCW(self)
    if not self.hand then return end
    self:rotate('L')
end
function actions.rotate180(self)
    if not self.hand then return end
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
    if not self.hand then return end
    if self.handY>self.ghostY then
        self.handY=self.ghostY
        self:freshDelay('drop')
    end
end
function actions.hardDrop(self)
    if not self.hand then return end
    self.handY=min(self.handY,self.ghostY)
    self:minoDropped()
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
    self:triggerEvent('afterHold')
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
function MP:triggerEvent(name,...)
    local L=self.event[name]
    if L then
        for i=1,#L do L[i](self,...) end
    end
end
function MP:restoreMinoState(mino)-- Restore a mino object's state (only inside, like shape, name, direction)
    if not mino._origin then return end
    for k,v in next,mino._origin do
        mino[k]=v
    end
    return mino
end
function MP:restoreHandPos()-- Move hand piece to the normal spawn position
    self.handX=int(self.field:getWidth()/2-#self.hand.matrix[1]/2+1)
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
        self.ghostY=min(self.field:getHeight()+1,self.handY)

        -- Move ghost to bottom
        while not self:ifoverlap(self.hand.matrix,self.handX,self.ghostY-1) do
            self.ghostY=self.ghostY-1
        end

        if (self.settings.dropDelay==0 or self.downCharge and self.settings.sdarr==0) and self.ghostY<self.handY then-- if (temp) 20G on
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
    self:triggerEvent('afterSpawn')
end
function MP:getMino(shapeID)
    local shape=TABLE.shift(Minos[shapeID].shape)
    local c=math.random(64)
    for y=1,#shape do for x=1,#shape[1] do
        if shape[y][x] then
            shape[y][x]={color=defaultMinoColor[shapeID]}-- Should be player's color setting
        end
    end end
    self.minoCount=self.minoCount+1
    local mino={
        id=self.minoCount,
        shape=shapeID,
        direction=0,
        name=Minos[shapeID].name,
        matrix=shape,
    }
    mino._origin=TABLE.copy(mino,0)
    ins(self.nextQueue,mino)
end

function MP:ifoverlap(CB,cx,cy)
    local F=self.field

    -- Must in wall
    if cx<=0 or cx+#CB[1]-1>F:getWidth() or cy<=0 then return true end

    -- Must in air
    if cy>F:getHeight() then return false end

    -- Check field
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] and F:getCell(cx+x-1,cy+y-1) then
            return true
        end
    end end

    -- No collision
    return false
end
function MP:rotate(dir)
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
            self:freshDelay('move')
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
function MP:minoDropped()-- Lock mino and trigger a lot of things
    self:triggerEvent('afterDrop')
    self:lock()
    self:triggerEvent('afterLock')
    self:checkField(self.hand)
    if self.finished then return end
    self:discardMino()
    if self.clearTimer==0 and self.spawnTimer==0 then
        self:popNext()
    end
end
function MP:lock()-- Put mino into field
    local CB=self.hand.matrix
    local F=self.field
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            F:setCell(CB[y][x],self.handX+x-1,self.handY+y-1)
        end
    end end
    ins(self.dropHistory,{
        id=self.hand.id,
        x=self.handX,
        y=self.handY,
    })
end
function MP:checkField(mino)-- Check line clear, top out checking, etc.
    local lineClear={}
    local F=self.field
    for y=F:getHeight(),1,-1 do
        local hasHole
        for x=1,F:getWidth() do
            if not F:getCell(x,y) then
                hasHole=true
                break
            end
        end
        if not hasHole then
            F:removeLine(y)
            ins(lineClear,y)
        end
    end
    if #lineClear>0 then
        self.clearTimer=self.settings.clearDelay
        local h={
            mino=mino,
            line=#lineClear,
            lines=lineClear,
        }
        ins(self.clearHistory,h)
        self:triggerEvent('afterClear',h)
    else
        if self.handY>self.settings.deathH then
            self:gameover('MLE')
        end
    end
end
function MP:discardMino()
    self.hand=false
    self.spawnTimer=self.settings.spawnDelay
end
function MP:gameover(reason)
    if self.finished then return end
    self.timing=false
    self.finished=true
    self.hand=false
    self.spawnTimer=1e99
    MES.new(reason=='AC' and 'check' or 'error',reason,6.26)
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
-- Press & Release
function MP:press(act)
    self:triggerEvent('beforePress',act)

    if not self.actions[act] or self.keyState[act] then return end
    self.keyState[act]=true
    ins(self.actionHistory,{0,self.time,act})
    self.actions[act].press(self)

    self:triggerEvent('afterPress',act)
end
function MP:release(act)
    self:triggerEvent('beforeRelease',act)
    if not self.actions[act] or not self.keyState[act] then return end
    self.keyState[act]=false
    ins(self.actionHistory,{1,self.time,act})
    self.actions[act].release(self)
    self:triggerEvent('afterRelease',act)
end
--------------------------------------------------------------
-- Updates
function MP:update(dt)
    local df=int((self.realTime+dt)*1000)-int(self.realTime*1000)
    self.realTime=self.realTime+dt
    local SET=self.settings

    for _=1,df do
        -- Step main time
        if self.timing then self.gameTime=self.gameTime+1--[[df]] end

        -- Starting counter
        if self.time<SET.readyDelay then
            self.time=self.time+1--[[df]]
            if self.time==SET.readyDelay then
                self:triggerEvent('gameStart')
                self.timing=true
            end
        else
            self.time=self.time+1--[[df]]
        end

        -- Auto shift
        if self.moveDir and (self.moveDir==-1 and self.keyState.moveLeft or self.moveDir==1 and self.keyState.moveRight) then-- Magic IF-statemant. I don't know why it works perfectly
            local c0=self.moveCharge
            local c1=c0+1--[[df]]
            self.moveCharge=c1
            local dist=0
            if c0>=SET.das then
                c0=c0-SET.das
                c1=c1-SET.das
                if SET.arr==0 then
                    dist=1e99
                else
                    dist=int(c1/SET.arr)-int(c0/SET.arr)
                end
            elseif c1>=SET.das then
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
                local c1=c0+1--[[df]]
                self.downCharge=c1

                local dist=SET.sdarr==0 and 1e99 or int(c1/SET.sdarr)-int(c0/SET.sdarr)
                while self.hand and dist>0 and not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) do
                    self.handY=self.handY-1
                    self:freshDelay('drop')
                    dist=dist-1
                end
            else
                self.downCharge=false
            end
        end

        repeat-- Update hand
            -- Wait clearing animation
            if self.clearTimer>0 then
                self.clearTimer=self.clearTimer-1--[[df]]
                break
            end

            -- Try spawn mino if don't have one
            if self.spawnTimer>0 then
                self.spawnTimer=self.spawnTimer-1--[[df]]
                if self.spawnTimer==0 then
                    self:popNext()
                end
                break
            elseif not self.hand then
                self:popNext()
            end

            -- Try lock/drop mino
            if self.handY==self.ghostY then
                self.lockTimer=self.lockTimer-1--[[df]]
                if self.lockTimer==0 then
                    self:minoDropped()
                end
                break
            else
                if self.dropDelay~=0 then
                    self.dropTimer=self.dropTimer-1--[[df]]
                    if self.dropTimer==0 then
                        self.dropTimer=SET.dropDelay
                        self.handY=self.handY-1
                    end
                elseif self.handY~=self.ghostY then-- If switch to 20G during game, mino won't dropped to bottom instantly so we force fresh it
                    self:freshDelay('drop')
                end
            end
        until true
    end
end
--------------------------------------------------------------
-- Draws
function MP:render()
    gc.push('transform')

    -- applyPlayerTransform
    gc.setCanvas({Zenitha.getBigCanvas('player'),stencil=true})
    gc.clear(1,1,1,0)
    gc.translate(self.pos.x,self.pos.y)
    gc.scale(self.pos.kx,self.pos.ky)
    gc.rotate(self.pos.angle)

    -- applyFieldTransform
    gc.push('transform')
    gc.translate(-200,400)
    GC.stc_setComp('equal',1)
    GC.stc_rect(0,0,400,-840)
    gc.scale(10/self.settings.fieldW)


    self:triggerEvent('drawBelowField')


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
    local F=self.field
    for y=1,F:getHeight() do for x=1,F:getWidth() do
        local C=F:getCell(x,y)
        if C then
            gc.setColor(ColorTable[C.color])
            gc.rectangle('fill',(x-1)*40,-y*40,40,40)
        end
    end end


    self:triggerEvent('drawBelowBlock')


    if self.hand then
        -- Ghost
        gc.setColor(1,1,1,.26)
        local CB=self.hand.matrix
        for y=1,#CB do for x=1,#CB[1] do
            if CB[y][x] then
                gc.rectangle('fill',(self.handX+x-2)*40,-(self.ghostY+y-1)*40,40,40)
            end
        end end

        -- Mino
        gc.push('transform')
        if self.handY>self.ghostY then
            gc.translate(0,40*(max(1-self.dropTimer/self.settings.dropDelay*2.6,0))^2.6)
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
        local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(self)
        if centerPos then
            gc.setColor(1,1,1)
            GC.draw(RS.centerTex,(self.handX+centerPos[1]-1)*40,-(self.handY+centerPos[2]-1)*40)
        end
        gc.pop()
    end


    self:triggerEvent('drawBelowMarks')


    -- Height lines
    local width=self.settings.fieldW*40
    gc.setColor(0,.4,1,.8)gc.rectangle('fill',0,-self.settings.spawnH*40-2,width,4)-- Spawning height
    gc.setColor(1,0,0,.6)gc.rectangle('fill',0,-self.settings.deathH*40-2,width,4)-- Death height
    gc.setColor(0,0,0,.5)gc.rectangle('fill',0,-1260*40-40,width,40)-- Void height


    self:triggerEvent('drawInField')


    -- popFieldTransform
    GC.stc_stop()
    gc.pop()

    -- Field border
    gc.setLineWidth(2)
    gc.setColor(1,1,1)
    gc.line(-201,-401,-201, 401,201, 401,201,-401)
    gc.setColor(1,1,1,.626)
    gc.line(-201,-401,201,-401)

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

    -- Next (Almost same as drawing hold(s), don't forget to change both)
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

    -- Hold (Almost same as drawing next(s), don't forget to change both)
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

    -- Info
    gc.setColor(COLOR.dL)
    FONT.set(30)
    gc.printf(("%.3f"):format(self.gameTime/1000),-210-260,380,260,'right')


    self:triggerEvent('drawOnPlayer')


    -- Starting counter
    if self.time<self.settings.readyDelay then
        gc.push('transform')
        local r,g,b
        local num=int((self.settings.readyDelay-self.time)/1000)+1
        local d=1-self.time%1000/1000-- d from 999 to 0
        if num==3 then
            r,g,b=.7,.8,.98
            if d>.75 then gc.rotate((d-.75)^3*40) end
        elseif num==2 then
            r,g,b=.98,.85,.75
            if d>.75 then gc.scale(1+(d/.25-3)^2,1) end
        elseif num==1 then
            r,g,b=1,.7,.7
            if d>.75 then gc.scale(1,1+(d/.25-3)^2) end
        end

        FONT.set(100)

        gc.push('transform')
            gc.scale((1.5-d*.6)^1.5)
            gc.setColor(r,g,b,d)
            GC.mStr(num,0,-70)
            gc.setColor(1,1,1,1.5*d-0.5)
            GC.mStr(num,0,-70)
        gc.pop()

        gc.scale(min(d/.333,1)^.4)
        gc.setColor(r,g,b)
        GC.mStr(num,0,-70)
        gc.setColor(1,1,1,1.5*d-0.5)
        GC.mStr(num,0,-70)
        gc.pop()
    end

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
local baseEnv={-- Generate from template in future
    fieldW=10,-- [WARNING] This is not the real field width, just for generate field object. If really want change it, you need change both 'self.field._width' and 'self.field._matrix'
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
    clearDelay=0,

    das=77,
    arr=0,
    sdarr=0,

    actionPack='modern',
    seqType='bag7',
    rotSys='TRS',

    freshCondition='any',
}
local seqGenerators={
    bag7=function(p)
        local l={}
        while true do
            while #p.nextQueue<p.settings.nextCount do
                if not l[1] then for i=1,7 do l[i]=i end end
                p:getMino(rem(l,math.random(#l)))
            end
            coroutine.yield()
        end
    end,
}
local modeDataMeta={
    __index=function(self,k)rawset(self,k,0)return 0 end,
    __newindex=function(self,k,v)rawset(self,k,v)end,
    __metatable=true,
}
function MP.new(data)
    assert(type(data)=='table',"function PLAYER.new(data): data must be table")
    local P=setmetatable({},{__index=MP})

    assert(type(data.id)=='number',"function PLAYER.new(data): need data.id")
    P.id=data.id

    if not mode then mode=NONE end

    P.settings=TABLE.copy(baseEnv)

    P.pos={
        x=0,y=0,
        kx=1,ky=1,
        angle=0,
    }

    P.realTime=0-- Real time, [float] s
    P.time=0-- Inside timer for player, [int] ms
    P.gameTime=0-- Game time of player, [int] ms
    P.timing=false-- Is gameTime running?

    P.field=require'assets.player.minoField'.new(P.settings.fieldW,P.settings.spawnH)
    P.fieldBeneath=0

    P.minoCount=0

    P.garbageBuffer={}

    P.nextQueue={}
    P.genNext=coroutine.wrap(seqGenerators[P.settings.seqType])
    P:genNext()

    P.holdQueue={}
    P.holdChance=0

    P.energy=0
    P.energyShow=0

    P.dropTimer=0
    P.lockTimer=0
    P.spawnTimer=P.settings.readyDelay
    P.clearTimer=0

    P.hand=false
    P.handX=false
    P.handY=false
    P.ghostY=false
    P.minY=false

    P.moveDir=false
    P.moveCharge=0
    P.downCharge=false

    P.dropHistory={}
    P.actionHistory={}
    P.clearHistory={}

    P.modeData=setmetatable({},modeDataMeta)
    P.event={
        -- Press & Release
        beforePress={},
        afterPress={},
        beforeRelease={},
        afterRelease={},

        -- Game events
        playerInit={},
        gameStart={},
        afterSpawn={},
        afterDrop={},
        afterLock={},
        afterClear={},

        -- Graphics
        drawBelowField={},
        drawBelowBlock={},
        drawBelowMarks={},
        drawInField={},
        drawOnPlayer={},
    }

    -- Load events from mode
    for k,L in next,P.event do
        local E=data.mode.settings.event[k]
        if type(E)=='table' then
            for _,E in next,data.mode.settings.event[k] do
                ins(L,E)
            end
        elseif type(E)=='function' then
            ins(L,E)
        end
    end

    do-- Generate available actions
        P.actions={}
        local pack=P.settings.actionPack
        if type(pack)=='string' then
            pack=actionPacks[pack]
            assert(pack,STRING.repD("Invalid actionPack '$1'",pack))
            for i=1,#pack do
                P.actions[pack[i]]=_getActionObj(pack[i])
            end
        elseif type(pack)=='table' then
            for k,v in next,pack do
                if type(k)=='number' then
                    P.actions[v]=_getActionObj(v)
                elseif type(k)=='string' then
                    assert(actions[k],STRING.repD("function PLAYER.new(data): no action called '$1'",k))
                    P.actions[k]=_getActionObj(v)
                else
                    error(STRING.repD("function PLAYER.new(data): wrong actionPack table format (type $1)",type(k)))
                end
            end
        else
            error("function PLAYER.new(data): actionPack must be string or table")
        end

        P.keyState={}
        for k in next,P.actions do
            P.keyState[k]=false
        end
    end

    P:triggerEvent('playerInit')

    return P
end
--------------------------------------------------------------

return MP
