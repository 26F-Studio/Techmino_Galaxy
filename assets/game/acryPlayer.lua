local require=simpRequire('assets.game.')

local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setColor=gc.setColor
local gc_draw=gc.draw


local max,min=math.max,math.min
local abs=math.abs
local ceil,floor=math.ceil,math.floor
local ins,rem=table.insert,table.remove

---@class Techmino.Player.Acry: Techmino.Player
---@field stat Techmino.PlayerStatTable.Acry
---@field field Mat<Techmino.Acry.Cell | false>
local AP=setmetatable({},{__index=require'basePlayer',__metatable=true})

--------------------------------------------------------------
-- Function tables

---@type Map<fun(P:Techmino.Player.Acry): any>
AP.scriptCmd={
}

--------------------------------------------------------------
-- Actions

AP._actions={}
for k,v in next,mechLib.acry.actions do AP._actions[k]=AP:_getActionObj(v) end

--------------------------------------------------------------
-- Effects

--------------------------------------------------------------
-- Game methods

function AP:printField() -- For debugging
    local F=self.field
    print("----------")
    for y=self.settings.fieldSize,1,-1 do
        local s="|"
        for x=1,self.settings.fieldSize do
            s=s..(F[y][x] and F[y][x].color or '.')
        end
        print(s.."|")
    end
    print("----------")
end
function AP:getAcry(data)
    self.totalCellCount=self.totalCellCount+1
    ---@cast data Techmino.Acry.Cell
    ---@type Techmino.Acry.Cell
    local acry={
        id='_'..STRING.toHex(self.totalCellCount),
        createTime=self.time,

        color=math.random(7),
        prop={},propData={},
        gridX=1,gridY=9,
        biasX=0,biasY=0,

        state='idle',
        stableTime=self.time,
    }
    if data then TABLE.update(acry,data) end
    return acry
end
function AP:_moveToward(acry1,acry2,dx,dy,force)
    if not (acry1 and acry1.state=='idle') then return false end
    acry1.state='moveAhead'
    acry1.active=true
    local canMove
    if force==nil then
        canMove=not (acry2==nil or acry2 and acry2.state~='idle')
    else
        canMove=force
    end
    if canMove then
        -- Active Move
        acry1.moveDirection={dx,dy}
        acry1.wallHit=false
        acry1.moveDelay=self.settings.moveAheadDelay
        acry1.moveReadyDelay=0
    else
        -- Wall Hit
        acry1.moveDirection={dx*.26,dy*.26}
        acry1.wallHit=true
        acry1.moveDelay=self.settings.moveAheadWallDelay
        acry1.moveReadyDelay=0
    end
    acry1.moveTimer=acry1.moveDelay
    return true
end
function AP:swap(x,y,dx,dy)
    local F=self.field
    local acry1=F[y][x]
    local acry2=F[y+dy] and F[y+dy][x+dx]
    if self:_moveToward(acry1,acry2,dx,dy) and acry2 and acry2.state=='idle' then
        -- Passive Move
        self:_moveToward(acry2,acry1,-dx,-dy,true)
        acry2.active=false
    end
    self:freshSwapCursor()
end
function AP:twist(x,y,dir)
    local F=self.field
    local a1,a2,a3,a4=F[y][x],F[y+1][x],F[y+1][x+1],F[y][x+1]
    local i1,i2,i3,i4=a1 and a1.state=='idle',a2 and a2.state=='idle',a3 and a3.state=='idle',a4 and a4.state=='idle'
    if dir=='R' then
        local canMove=i1 and i2 and i3 and i4
        self:_moveToward(a1,a2,00,01,canMove)
        self:_moveToward(a2,a3,01,00,canMove)
        self:_moveToward(a3,a4,00,-1,canMove)
        self:_moveToward(a4,a1,-1,00,canMove)
    elseif dir=='L' then
        local canMove=i1 and i2 and i3 and i4
        self:_moveToward(a4,a3,00,01,canMove)
        self:_moveToward(a3,a2,-1,00,canMove)
        self:_moveToward(a2,a1,00,-1,canMove)
        self:_moveToward(a1,a4,01,00,canMove)
    elseif dir=='F' then
        self:_moveToward(a1,a3,01,01,i1 and i3)
        self:_moveToward(a3,a1,-1,-1,i1 and i3)
        self:_moveToward(a2,a4,01,-1,i2 and i4)
        self:_moveToward(a4,a2,-1,01,i2 and i4)
    end
end
function AP:triggerAcryEvent(acry,name)
    ---@cast acry Techmino.Acry.Cell
    local propList=acry.prop
    local propSys=mechLib.acry.propSys
    for i=1,#propList do
        local eventFunc=propSys[propList[i]][name]
        if eventFunc then
            eventFunc(self,acry)
        end
    end
end
function AP:linkProbe(clr,x,y,dx,dy)
    local F=self.field
    local dist=0
    while true do
        x,y=x+dx,y+dy
        local acry=(F[y] or NONE)[x]
        if acry and acry.color==clr then
            dist=dist+1
        else
            break
        end
    end
    return dist
end
-- Acry at F[y][x] requests starting a match
function AP:requestMatch(acry)
    ---@cast acry Techmino.Acry.Cell

    -- print("Check at:",acry.gridX,acry.gridY)
    -- self:printField()

    local clr=acry.color
    if clr==0 then return end
    local matchSet={}
    local scanStream={acry.gridX,acry.gridY}

    local probe=1
    while scanStream[probe] do
        local x,y=scanStream[probe],scanStream[probe+1]
        if not matchSet[x..'LR'..y] then
            matchSet[x..'LR'..y]=true
            local linkL=self:linkProbe(clr,x,y,-1,0)
            local linkR=self:linkProbe(clr,x,y,1,0)
            if linkL+linkR>=2 then
                for _x=x-linkL,x+linkR do
                    matchSet[_x..'LR'..y]=true
                    ins(scanStream,_x)
                    ins(scanStream,y)
                end
            end
        end
        if not matchSet[x..'UD'..y] then
            matchSet[x..'UD'..y]=true
            local linkU=self:linkProbe(clr,x,y,0,1)
            local linkD=self:linkProbe(clr,x,y,0,-1)
            if linkU+linkD>=2 then
                for _y=y-linkD,y+linkU do
                    matchSet[x..'UD'.._y]=true
                    ins(scanStream,x)
                    ins(scanStream,_y)
                end
            end
        end
        probe=probe+2
    end

    if #scanStream>=6 then
        local F=self.field
        for i=1,#scanStream,2 do
            local x,y=scanStream[i],scanStream[i+1]
            ins(self.acryProcessQueue.match,F[y][x])
        end
    elseif acry.state=='moveWait' then
        acry._newState='idle'
    end
end
function AP:matchExist()
    -- TODO
    return false
end
function AP:changeFieldSize(w,h,origX,origY)
end
function AP:receive(data)
    local B={
        power=data.power,
        sharpness=data.sharpness,
        hardness=data.hardness,
        mode=data.mode,
        time=floor(data.time+.5),
        _time=0,
        fatal=data.fatal,
        speed=data.speed,
    }
    ins(self.garbageBuffer,B)
end
function AP:getScriptValue(arg)
    return
        arg.d=='field_size' and self.settings.fieldSize or
        arg.d=='cell' and (self.field[arg.y][arg.x] and 1 or 0)
end

--------------------------------------------------------------
-- Press & Release & Update & Render

function AP:getMousePos(x,y)
    local pos=self.pos
    x,y=((x-pos.x)/pos.k/360+1)/2,((pos.y-y)/pos.k/360+1)/2
    if x>=0 and x<1 and y>=0 and y<1 then
        return x,y
    else
        return false,false
    end
end
function AP:getSwapPos(x,y)
    local size=self.settings.fieldSize
    x,y=floor(x*size+1),floor(y*size+1)
    if x>=1 and x<=size and y>=1 and y<=size then return x,y end
end
function AP:freshSwapCursor()
    self.swapLock=false
    if self.mouseX then
        local sx,sy=self:getSwapPos(self.mouseX,self.mouseY)
        if sx and (self.swapX~=sx or self.swapY~=sy) then
            self.swapX,self.swapY=sx,sy
        end
    end
end
function AP:getTwistPos(x,y)
    local size=self.settings.fieldSize
    x,y=floor(x*size+.5),floor(y*size+.5)
    if x>=1 and x<=size-1 and y>=1 and y<=size-1 then return x,y end
end
function AP:freshTwistCursor()
    if self.mouseX then
        local tx,ty=self:getTwistPos(self.mouseX,self.mouseY)
        if tx and (self.twistX~=tx or self.twistY~=ty) then
            self.twistX,self.twistY=tx,ty
        end
    end
end
function AP:mouseDown(x,y,id)
    if id==2 then
        if self.swapLock then
            self:freshSwapCursor()
        end
    else
        self:mouseMove(x,y,0,0,id)
        self.mousePressed=true
        if self.swapLock then
            local mx,my=self:getMousePos(x,y)
            if mx then
                local sx,sy=self:getSwapPos(mx,my)
                if sx==self.swapX and abs(sy-self.swapY)==1 or sy==self.swapY and abs(sx-self.swapX)==1 then
                    if self.settings.multiMove or #self.movingGroups==0 then
                        self:swap(self.swapX,self.swapY,sx-self.swapX,sy-self.swapY)
                    end
                else
                    if sx==self.swapX and sy==self.swapY then
                        self.swapLock=false
                    else
                        self.swapX,self.swapY=sx,sy
                    end
                end
            end
        else
            self.swapLock=true
        end
    end
end
function AP:mouseMove(x,y,_,_,_)
    self.mouseX,self.mouseY=self:getMousePos(x,y)

    if self.mouseX then
        if self.swapLock then
            if self.mousePressed then
                local sx,sy=self:getSwapPos(self.mouseX,self.mouseY)
                if not (sx==self.swapX and sy==self.swapY) then
                    if
                        (
                            sx==self.swapX and abs(sy-self.swapY)==1 or
                            sy==self.swapY and abs(sx-self.swapX)==1
                        ) and (self.settings.multiMove or #self.movingGroups==0) then
                        self:swap(self.swapX,self.swapY,sx-self.swapX,sy-self.swapY)
                    else
                        self:freshSwapCursor()
                    end
                end
            end
        else
            self:freshSwapCursor()
        end
        self:freshTwistCursor()
    end
end
function AP:mouseUp(_,_,_)
    self.mousePressed=false
end
function AP:acryStateSwitch(acry,newS)
    ---@cast acry Techmino.Acry.Cell
    if newS then acry._newState=newS end
    while acry._newState do
        acry.state,acry._newState=acry._newState,nil
        if acry.state=='idle' then
            acry.biasX,acry.biasY=0,0
            acry.fallSpeed=0
            acry.stableTime=self.time
            self:requestMatch(acry)
        elseif acry.state=='fall' then
            local y=acry.gridY
            while y>1 and not self.field[y-1][acry.gridX] do
                y=y-1
            end
            local dy=acry.gridY-y
            if dy>0 then
                self.field[acry.gridY][acry.gridX]=false
                acry.gridY=y
                self.field[acry.gridY][acry.gridX]=acry
                acry.biasY=dy
                acry.fallSpeed=0
            else
                acry._newState='idle'
            end
        elseif acry.state=='moveAhead' then
            -- Done in AP:swap() & AP:twist()
        elseif acry.state=='moveWait' then
            acry.waitDelay=self.settings.waitDelay
            acry.waitTimer=acry.waitDelay
            ins(self.acryProcessQueue.movement,acry)
        elseif acry.state=='moveBack' then
            acry.moveDelay=acry.wallHit and self.settings.moveBackWallDelay or self.settings.moveBackDelay
            acry.moveReadyDelay=acry.wallHit and 0 or self.settings.moveBackReadyDelay
            acry.moveTimer=acry.moveDelay
            ins(self.acryProcessQueue.backMovement,acry)
        elseif acry.state=='clear' then
            acry.clearDelay=self.settings.clearDelay
            acry.clearTimer=acry.clearDelay
        elseif acry.state=='_discard' then
            self.field[acry.gridY][acry.gridX]=false
        end
        self:triggerAcryEvent(acry,acry.state)
    end
end
function AP:tickStep()
    local SET=self.settings

    do -- Auto shift
        if self.moveDirH and (self.moveDirH==-1 and self.keyState.moveLeft or self.moveDirH==1 and self.keyState.moveRight) then
            if self.swapX~=MATH.clamp(self.swapX+self.moveDirH,1,self.settings.fieldSize) then
                self.moveChargeH=self.moveChargeH+1
                local dist=0
                if self.moveChargeH>=SET.asd then
                    if SET.asp==0 then
                        dist=1e99
                    elseif (self.moveChargeH-SET.asd)%SET.asp==0 then
                        dist=1
                    end
                end
                if dist>0 then
                    local moved
                    local x0=self.swapX
                    self.swapX=MATH.clamp(self.swapX+self.moveDirH*dist,1,self.settings.fieldSize)
                    if self.swapX~=x0 then moved=true end
                    x0=self.twistX
                    self.twistX=MATH.clamp(self.twistX+self.moveDirH*dist,1,self.settings.fieldSize-1)
                    if self.twistX~=x0 then moved=true end
                    if moved then self:playSound('move') end
                end
            else
                self.moveChargeH=SET.asd
                self:shakeBoard(self.moveDirH>0 and '-right' or '-left')
            end
        else
            self.moveDirH=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
            self.moveChargeH=0
        end
        if self.moveDirV and (self.moveDirV==-1 and self.keyState.moveDown or self.moveDirV==1 and self.keyState.moveUp) then
            if self.swapY~=MATH.clamp(self.swapY+self.moveDirV,1,self.settings.fieldSize) then
                self.moveChargeV=self.moveChargeV+1
                local dist=0
                if self.moveChargeV>=SET.asd then
                    if SET.asp==0 then
                        dist=1e99
                    elseif (self.moveChargeV-SET.asd)%SET.asp==0 then
                        dist=1
                    end
                end
                if dist>0 then
                    local moved
                    local x0=self.swapY
                    self.swapY=MATH.clamp(self.swapY+self.moveDirV*dist,1,self.settings.fieldSize)
                    if self.swapY~=x0 then moved=true end
                    x0=self.twistY
                    self.twistY=MATH.clamp(self.twistY+self.moveDirV*dist,1,self.settings.fieldSize-1)
                    if self.twistY~=x0 then moved=true end
                    if moved then self:playSound('move') end
                end
            else
                self.moveChargeV=SET.asd
                self:shakeBoard(self.moveDirV>0 and '-up' or '-down')
            end
        else
            self.moveDirV=self.keyState.moveDown and -1 or self.keyState.moveUp and 1 or false
            self.moveChargeV=0
        end
    end

    -- Update acries (Phase 1)
    local F=self.field
    local size=self.settings.fieldSize
    for y=1,size do
        for x=1,size do
            ---@type Techmino.Acry.Cell
            local acry=F[y][x]
            if acry then
                if acry.state=='idle' then
                    -- Attempt to fall & match every tick
                    if acry.gridY>1 then
                        local under=F[acry.gridY-1][acry.gridX]
                        if not under then
                            acry._newState='fall'
                        end
                    -- else
                    --     self:requestMatch(acry)
                    end
                elseif acry.state=='fall' then
                    -- Fall animation (until biasY back to 0)
                    acry.fallSpeed=acry.fallSpeed-self.settings.fallAcceleration
                    acry.biasY=acry.biasY+acry.fallSpeed
                    if acry.biasY<=0 then
                        acry._newState='idle'
                    end
                elseif acry.state=='moveAhead' then
                    -- The move ahead animation
                    acry.moveTimer=acry.moveTimer-1
                    local t=1-min(acry.moveTimer/(acry.moveDelay-acry.moveReadyDelay),1)
                    acry.biasX=acry.moveDirection[1]*t
                    acry.biasY=acry.moveDirection[2]*t
                    if acry.moveTimer<=0 then
                        if acry.wallHit then
                            acry._newState='moveBack'
                        else
                            acry._newState='moveWait'
                        end
                    end
                elseif acry.state=='moveBack' then
                    -- The move back animation
                    acry.moveTimer=acry.moveTimer-1
                    local t=min(acry.moveTimer/(acry.moveDelay-acry.moveReadyDelay),1)
                    acry.biasX=acry.moveDirection[1]*t
                    acry.biasY=acry.moveDirection[2]*t
                    if acry.moveTimer<=0 then
                        acry._newState='idle'
                    end
                elseif acry.state=='moveWait' then
                    -- Request match if stuck in 'moveWait' state, normally happen when doing BET
                    -- state changing handled in :requestMatch
                    self:requestMatch(acry)
                elseif acry.state=='clear' then
                    -- The clear animation
                    acry.clearTimer=acry.clearTimer-1
                    if acry.clearTimer<=0 then
                        acry._newState='_discard'
                    end
                end
                self:triggerAcryEvent(acry,'always')
                if acry._newState then
                    self:acryStateSwitch(acry)
                end
            end
        end
    end

    -- Update acries (Phase 2, process movement)
    if self.acryProcessQueue.movement[1] then
        local list=self.acryProcessQueue.movement
        -- 1: Move
        for i=1,#list do
            local acry=list[i]
            if acry.state=='moveWait' then
                local oX,oY=acry.gridX,acry.gridY
                local nX,nY=oX+acry.moveDirection[1],oY+acry.moveDirection[2]
                acry.gridX,acry.gridY=nX,nY
                acry.biasX,acry.biasY=0,0
                if F[oY][oX]==acry then
                    F[oY][oX]=false
                end
                F[nY][nX]=acry
            else
                error("Unexpected state in [movement]: "..acry.state)
            end
        end
        -- 2: Check link
        for i=1,#list do
            local acry=list[i]
            if acry.state=='moveWait' then
                self:requestMatch(acry)
                if acry._newState then
                    self:acryStateSwitch(acry)
                end
            end
        end
        TABLE.clear(list)
    end

    -- Update acries (Phase 3, process match)
    if self.acryProcessQueue.match[1] then
        local list=self.acryProcessQueue.match
        for i=1,#list do
            self:acryStateSwitch(list[i],'clear')
        end
        TABLE.clear(list)
    end

    -- Update acries (Phase 4, process backward movement for unmatched swaps)
    if self.acryProcessQueue.backMovement[1] then
        local list=self.acryProcessQueue.backMovement
        for i=1,#list do
            local acry=list[i]
            if acry.state=='moveBack' then
                if not acry.wallHit and acry.moveDirection[1]%1==0 and acry.moveDirection[2]%1==0 then
                    local newX,newY=acry.gridX-acry.moveDirection[1],acry.gridY-acry.moveDirection[2]
                    acry.gridX,acry.gridY=newX,newY
                    acry.biasX,acry.biasY=acry.moveDirection[1],acry.moveDirection[2]
                    F[newY][newX]=acry
                end
            else
                error("Unexpected state in [movement]: "..acry.state)
            end
            if acry._newState then
                self:acryStateSwitch(acry)
            end
        end
        TABLE.clear(list)
    end

    -- Update acries (Phase 5, process explosion)
    if self.acryProcessQueue.explosion[1] then
        local list=self.acryProcessQueue.explosion
        for i=1,#list do
            local acry=list[i]
        end
        TABLE.clear(list)
    end

    -- Update garbage
    for i=1,#self.garbageBuffer do
        local g=self.garbageBuffer[i]
        if g.mode==0 and g._time<g.time then
            g._time=g._time+1
        end
    end

    if love.keyboard.isDown('f4') then
        local acry=F[1][1]
        if acry then
            print("--------------------------")
            print('state',acry.state)
            print('gridX/Y',acry.gridX..','..acry.gridY)
            print('biasX/Y',acry.biasX..','..acry.biasY)
        end
    end
end
function AP:render()
    local SET=self.settings
    local skin=SKIN.get(SET.skin)
    SKIN.time=self.time

    gc_push('transform')

    -- Player's transform
    local pos=self.pos
    gc_translate(pos.x,pos.y)
    gc_scale(pos.k*(1+pos.dk))
    gc_translate(pos.dx,pos.dy)
    gc_rotate(pos.a+pos.da)

    -- Field's transform
    gc_push('transform')

        gc_translate(-360,360)

        -- Start field stencil
        GC.stc_setComp()
        GC.stc_rect(0,0,720,-720)
        gc_scale(16/SET.fieldSize)

            self:triggerEvent('drawBelowField') -- From frame's bottom-left, 45px a cell

            -- Grid & Cells
            skin.drawFieldBackground(SET.fieldSize)

            FONT.set(10)

            -- Field
            local F=self.field
            for y=1,#F do
                for x=1,#F[1] do
                    local acry=F[y][x]
                    if acry then
                        local ucsX,ucsY=45*(acry.gridX+acry.biasX-.5),-45*(acry.gridY+acry.biasY-.5)
                        gc_translate(ucsX,ucsY)
                        skin.drawFieldCell(acry,F)
                        gc_translate(-ucsX,-ucsY)
                        -- local txtX,txtY=45*(acry.gridX-.5),-45*(acry.gridY-.5)
                        -- gc_setColor(1,1,1)
                        -- gc.print(acry.id,txtX-20,txtY)
                        -- gc.print(acry.state,txtX,txtY)
                        -- if acry.moveTimer then
                        --     gc.rectangle('fill',txtX-20,txtY-20,acry.moveTimer/20,5)
                        -- end
                    end
                end
            end

            self:triggerEvent('drawInField') -- From frame's bottom-left, 45px a cell

        -- Stop field stencil
        GC.stc_stop()

        -- Particles
        gc_setColor(1,1,1)
        gc_draw(self.particles.star)
        gc_draw(self.particles.trail)

        -- Cursor(s)
        if self.settings.swap then
            skin.drawSwapCursor(self.swapX,self.swapY,self.swapLock)
        end
        if self.settings.twistR then
            skin.drawTwistCursor(self.twistX,self.twistY)
        end

    gc_pop()

    -- Field border
    skin.drawFieldBorder()

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()

    self:triggerEvent('drawOnPlayer') -- From player's center

    -- Starting counter
    if self.time<SET.readyDelay then
        skin.drawStartingCounter(SET.readyDelay)
    end

    gc_pop()
end

--------------------------------------------------------------
-- Other

function AP:decodeScript(line,errMsg)
    -- TODO (script)
    -- error(errMsg.."No string command '"..cmd.."'")
end
function AP:checkScriptSyntax(cmd,arg,errMsg)
    -- TODO (script)
end

--------------------------------------------------------------
-- Builder

---@class Techmino.Mode.Setting.Acry
---@field event table<Techmino.EventName, Techmino.Event.Acry[] | Techmino.Event.Acry>
local baseEnv={
    -- Size
    fieldSize=8,

    -- Generator
    colors=7,
    clearRule='line',
    linkLen=3,

    -- Delay
    readyDelay=3000,
    moveAheadDelay=300,
    moveBackDelay=450,
    moveBackReadyDelay=100,
    moveAheadWallDelay=60,
    moveBackWallDelay=90,
    waitDelay=5000,
    clearDelay=250,
    fallAcceleration=1/45000,

    -- Attack
    atkSys='none',
    mergeSys='modern',
    multiMove=true,
    swap=true,
    swapForce=true,
    twistR=false,twistL=false,twistF=false,
    twistForce=false,

    -- Control
    asd=122,
    asp=26,

    -- Other
    script=false,

    -- May be overrode with user setting
    skin='acry_template',
    shakeness=.26,
    inputDelay=0,
}
---@return Techmino.Player.Acry
function AP.new(remote)
    local self=setmetatable(require'basePlayer'.new(remote),{__index=AP,__metatable=true})
    ---@cast self Techmino.Player.Acry
    self.settings=TABLE.copyAll(baseEnv)
    self.event={
        -- Press & Release
        beforePress={},
        afterPress={},
        beforeRelease={},
        afterRelease={},

        -- Start & End
        playerInit={},
        gameStart={},
        gameOver={},

        -- Prop Event

        -- Update
        always={},

        -- Graphics
        drawBelowField={},
        drawBelowBlock={},
        drawBelowMarks={},
        drawInField={},
        drawOnPlayer={},
    }
    self.soundEvent=setmetatable({},gameSoundFunc)

    ---@class Techmino.PlayerStatTable.Acry: Techmino.PlayerStatTable
    self.stat={
        key=0,
        spawn=0,
        piece=0,
        line=0,
        clearTime=0,
        allclear=0,

        atk=0,
        sent=0,
    }

    return self
end
function AP:initialize()
    require'basePlayer'.initialize(self)

    self.movingGroups={}
    ---@type Map<Techmino.Acry.Cell[]>
    self.acryProcessQueue={
        movement={},
        match={},
        backMovement={},
        explosion={},
    }

    self.mouseX,self.mouseY=false,false
    self.mousePressed=false
    self.swapX,self.swapY=1,1
    self.swapLock=false
    self.twistX,self.twistY=1,1

    self.moveDirH=-1
    self.moveChargeH=0
    self.moveDirV=1
    self.moveChargeV=0

    self.garbageBuffer={}

    self.totalCellCount=0

    local size=self.settings.fieldSize
    local F=TABLE.newMat(false,size,size)
    for y=1,size do for x=1,size do
        F[y][x]=self:getAcry{gridX=x,gridY=y}
    end end
    self.field=F

    self:loadScript(self.settings.script)
end
function AP:unserialize_custom()
    setmetatable(self.soundEvent,gameSoundFunc)
end

--------------------------------------------------------------

return AP
