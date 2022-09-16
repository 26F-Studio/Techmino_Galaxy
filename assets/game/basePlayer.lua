local gc=love.graphics

local max,min=math.max,math.min
local floor,ceil=math.floor,math.ceil
local abs=math.abs
local ins=table.insert

local sign,expApproach=MATH.sign,MATH.expApproach

local P={}

--------------------------------------------------------------
-- Effects
function P:shakeBoard(args,v)
    local shake=self.settings.shakeness
    if args:sArg('-drop') then
        self.pos.vy=self.pos.vy+.2*shake
    elseif args:sArg('-down') then
        self.pos.dy=self.pos.dy+.1*shake
    elseif args:sArg('-right') then
        self.pos.dx=self.pos.dx+.1*shake
    elseif args:sArg('-left') then
        self.pos.dx=self.pos.dx-.1*shake
    elseif args:sArg('-cw') then
        self.pos.va=self.pos.va+.002*shake
    elseif args:sArg('-ccw') then
        self.pos.va=self.pos.va-.002*shake
    elseif args:sArg('-180') then
        self.pos.vy=self.pos.vy+.1*shake
        self.pos.va=self.pos.va+((self.handX+#self.hand.matrix[1]/2-1)/self.settings.fieldW-.5)*.0026*shake
    elseif args:sArg('-clear') then
        self.pos.dk=self.pos.dk*(1+shake)
        self.pos.vk=self.pos.vk+.0002*shake*min(v^1.6,26)
    end
end
function P:playSound(event,...)
    if not self.sound then return end
    if self.time-self.soundTimeHistory[event]>=15 then
        self.soundTimeHistory[event]=self.time
        if self.soundEvent[event] then
            self.soundEvent[event](...)
        else
            MES.new('warn',"Unknown sound event: "..event)
        end
    end
end
function P:setPosition(x,y,k,a)
    self.pos.x=x or self.pos.x
    self.pos.y=y or self.pos.y
    self.pos.k=k or self.pos.k
    self.pos.a=a or self.pos.a
end
function P:movePosition(dx,dy,k,da)
    self.pos.x=self.pos.x+(dx or 0)
    self.pos.y=self.pos.y+(dy or 0)
    self.pos.k=self.pos.k*(k or 1)
    self.pos.a=self.pos.a+(da or 0)
end
--------------------------------------------------------------
-- Game methods
function P:triggerEvent(name,...)
    local L=self.event[name]
    if L then for i=1,#L do L[i](self,...) end end
end
function P:finish(reason)
    --[[ Reason:
        AC:  Win
        WA:  Block out
        CE:  Lock out
        MLE: Top out
        TLE: Time out
        OLE: Finesse fault
        ILE: Ran out pieces
        PE:  Mission failed
        RE:  Other reason
    ]]

    if self.finished then return end
    self.timing=false
    self.finished=true
    self.hand=false
    self.spawnTimer=1e99

    self:triggerEvent('gameOver',reason)
    GAME.checkFinish()

    -- <Temporarily>
    if self.isMain then
        MES.new(reason=='AC' and 'check' or 'error',reason,6.26)
        self:playSound(reason=='AC' and 'win' or 'fail')
    end
    -- </Temporarily>
end
--------------------------------------------------------------
-- Press & Release & Update & Render
function P:press(act)
    self:triggerEvent('beforePress',act)

    if not self.actions[act] or self.keyState[act] then return end
    self.keyState[act]=true
    ins(self.actionHistory,{0,self.time,act})
    self.actions[act].press(self)

    self:triggerEvent('afterPress',act)
end
function P:release(act)
    self:triggerEvent('beforeRelease',act)
    if not self.actions[act] or not self.keyState[act] then return end
    self.keyState[act]=false
    ins(self.actionHistory,{1,self.time,act})
    self.actions[act].release(self)
    self:triggerEvent('afterRelease',act)
end
local function parseTime(str)
    local num,unit=str:cutUnit()
    return
        unit=='s'  and num*1000 or
        unit=='ms' and num or
        unit=='m'  and num*60000
end
local _jmpOP={j=1,jz=1,jnz=1,jeq=1,jne=1,jge=1,jle=1,jg=1,jl=1}
function P:runScript(line)
    local arg=line.a
    if type(line.c)=='string' then
        if line.c=='say' then
            if arg.t:sub(1,1)=='$' then
                arg.t=Text[arg.t] or arg.t
            elseif arg.t:sub(1,1)=='\\' then
                arg.t=arg.t:sub(2)
            end
            self.texts:add{
                duration=parseTime(arg.d or 2600)/1000,
                fontSize=arg.f or 60,
                style=arg.s or 'appear',
                text=    arg.t or "[TEXT]",
                x=arg.x or 0,
                y=arg.y or 0,
            }
        elseif line.c=='wait' then
            if not (self.modeData[arg.v] and self.modeData[arg.v]~=0) then
                return self.scriptLine
            end
        elseif _jmpOP[line.c] then
            local v1=arg.v  if v1~=nil then v1=self.modeData[v1] end
            local v2=arg.v2 if v2==nil then v2=arg.c end
            if
                line.c=='j'              or
                line.c=='jz'  and v1==0  or
                line.c=='jnz' and v1~=0  or
                line.c=='jeq' and v1==v2 or
                line.c=='jne' and v1~=v2 or
                line.c=='jge' and v1>=v2 or
                line.c=='jle' and v1<=v2 or
                line.c=='jg'  and v1>v2  or
                line.c=='jl'  and v1<v2
            then
                return self.scriptLabels[arg.d] or error("No label called '"..arg.d.."'")
            end
        elseif line.c=='setc' then
            self.modeData[arg.v]=arg.c
        elseif line.c=='setd' then
            self.modeData[arg.v]=self.modeData[arg.n]
        elseif line.c=='setg' then
            self.modeData[arg.v]=self:getScriptValue(arg)
        else
            error("Script command '"..line.c.."' not exist")
        end
    elseif type(line.c)=='function' then
        return line.c(self)
    elseif line.c~=nil then
        error("WTF why script command is "..type(line.c))
    end
end
function P:update(dt)
    local df=floor((self.realTime+dt)*1000)-floor(self.realTime*1000)
    self.realTime=self.realTime+dt

    for _=1,df do
        -- Script
        if self.script then
            while true do
                local l=self.script[self.scriptLine]
                if not l then break end-- EOF

                if self.scriptWait<=0 then
                    -- Execute command
                    local nextPos=self:runScript(l)
                    self.scriptLine=nextPos or self.scriptLine+1
                    self.scriptWait=self.script[self.scriptLine].t or 0
                else
                    self.scriptWait=self.scriptWait-1
                    break
                end
            end
        end

        -- Step game time
        if self.timing then self.gameTime=self.gameTime+1 end

        self:triggerEvent('always')

        -- Calculate board animation
        local O=self.pos
        --                     sticky           force          soft
        O.vx=expApproach(O.vx,0,.02)-sign(O.dx)*.0001*abs(O.dx)^1.2
        O.vy=expApproach(O.vy,0,.02)-sign(O.dy)*.0001*abs(O.dy)^1.1
        O.va=expApproach(O.va,0,.02)-sign(O.da)*.0001*abs(O.da)^1.0
        O.vk=expApproach(O.vk,0,.01)-sign(O.dk)*.0001*abs(O.dk)^1.0
        O.dx=O.dx+O.vx
        O.dy=O.dy+O.vy
        O.da=O.da+O.va
        O.dk=O.dk+O.vk

        -- Step main time & Starting counter
        if self.time<self.settings.readyDelay then
            self.time=self.time+1
            local d=self.settings.readyDelay-self.time
            if floor((d+1)/1000)~=floor(d/1000) then
                self:playSound('countDown',ceil(d/1000))
            end
            if d==0 then
                self:playSound('countDown',0)
                self:triggerEvent('gameStart')
                self.timing=true
            end
        else
            self.time=self.time+1
        end

        self:updateFrame()
    end
    for _,v in next,self.particles do v:update(dt) end
    self.texts:update(dt)
end
function P:render()
    local settings=self.settings
    local skin=SKIN.get(settings.skin)
    SKIN.time=self.time

    gc.push('transform')

    -- applyPlayerTransform
    gc.translate(self.pos.x,self.pos.y)
    gc.scale(self.pos.k*(1+self.pos.dk))
    gc.translate(self.pos.dx,self.pos.dy)
    gc.rotate(self.pos.a+self.pos.da)

    -- applyFieldTransform
    gc.push('transform')
    gc.translate(-200,400)

    -- startFieldStencil
    GC.stc_setComp()
    GC.stc_rect(0,0,400,-920)
    gc.scale(10/settings.fieldW)


        self:triggerEvent('drawBelowField')


        -- Grid & Cells
        skin.drawFieldBackground(settings.fieldW)
        skin.drawFieldCells(self.field)


        self:triggerEvent('drawBelowBlock')


        if self.hand then
            local CB=self.hand.matrix

            -- Ghost
            if not self.deathTimer then
                skin.drawGhost(CB,self.handX,self.ghostY)
            end

            -- Mino
            if not self.deathTimer or (2600/(self.deathTimer+260)-self.deathTimer/260)%1>.5 then
                -- Smooth
                local movingX,droppingY=0,0
                if self.moveDir and self.moveCharge<self.settings.das then
                    movingX=15*self.moveDir*(self.moveCharge/self.settings.das-.5)
                end
                if self.handY>self.ghostY then
                    droppingY=40*(max(1-self.dropTimer/settings.dropDelay*2.6,0))^2.6
                end
                gc.translate(movingX,droppingY)

                skin.drawHand(CB,self.handX,self.handY)

                local RS=MinoRotSys[settings.rotSys]
                local minoData=RS[self.hand.shape]
                local state=minoData[self.hand.direction]
                local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(self)
                if centerPos then
                    gc.setColor(1,1,1)
                    GC.mDraw(RS.centerTex,(self.handX+centerPos[1]-1)*40,-(self.handY+centerPos[2]-1)*40)
                end
                gc.translate(-movingX,-droppingY)
            end
        end

        -- Float hold
        if #self.floatHolds>0 then
            for n=1,#self.floatHolds do
                local H=self.floatHolds[n]
                skin.drawFloatHold(n,H.hand.matrix,H.handX,H.handY,settings.holdMode=='float' and not settings.infHold and n<=self.holdTime)
            end
        end


        self:triggerEvent('drawBelowMarks')


        -- Height lines
        skin.drawHeightLines(
            settings.fieldW*40,  -- (pixels) Field Width
            settings.spawnH*40,  -- (pixels) Spawning height
            settings.lockoutH*40,-- (pixels) lock-out height
            settings.deathH*40,  -- (pixels) Death height
            1260*40              -- (pixels) Void height
        )


        self:triggerEvent('drawInField')


    -- stopFieldStencil
    GC.stc_stop()

    -- Particles
    gc.setColor(1,1,1)
    gc.draw(self.particles.star)
    gc.draw(self.particles.trail)

    -- popFieldTransform
    gc.pop()

    -- Field border
    skin.drawFieldBorder()

    -- Delay indicator
    if not self.hand then-- Spawn
        skin.drawDelayIndicator(COLOR.lB,self.spawnTimer/settings.spawnDelay)
    elseif self.deathTimer then-- Death
        skin.drawDelayIndicator(COLOR.R,self.deathTimer/settings.deathDelay)
    else-- Lock
        skin.drawDelayIndicator(COLOR.lY,self.lockTimer/settings.lockDelay)
    end

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Lock delay indicator
    skin.drawLockDelayIndicator(settings.freshCondition,self.freshChance)

    -- Next (Almost same as drawing hold(s), don't forget to change both)
    gc.push('transform')
    gc.translate(200,-400)
    skin.drawNextBorder(settings.nextSlot)
    for n=1,min(#self.nextQueue,settings.nextSlot) do
        skin.drawNext(n,self.nextQueue[n].matrix,settings.holdMode=='swap' and not settings.infHold and n<=self.holdTime)
    end
    gc.pop()

    -- Hold (Almost same as drawing next(s), don't forget to change both)
    gc.push('transform')
    gc.translate(-200,-400)
    skin.drawHoldBorder(settings.holdMode,settings.holdSlot)
    if #self.holdQueue>0 then
        for n=1,#self.holdQueue do
            skin.drawHold(n,self.holdQueue[n].matrix,settings.holdMode=='hold' and not settings.infHold and n<=self.holdTime)
        end
    end
    gc.pop()

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()


    self:triggerEvent('drawOnPlayer')


    -- Starting counter
    if self.time<settings.readyDelay then
        skin.drawStartingCounter(settings.readyDelay)
    end

    -- Upside fade out
    gc.setBlendMode('multiply','premultiplied')
    gc.setColorMask(false,false,false,true)
    for i=0,99,2 do
        gc.setColor(0,0,0,(1-i/100)^2)
        gc.rectangle('fill',-200,-422-i,400,-2)
    end
    gc.setBlendMode('alpha')
    gc.setColorMask()

    gc.pop()
end
--------------------------------------------------------------
-- Builder
function P:loadSettings(settings)
    -- Load data & events from mode settings
    for k,v in next,settings do
        if k=='event' then
            for name,E in next,v do
                assert(self.event[name],"Wrong event key: '"..tostring(name).."'")
                if type(E)=='table' then
                    for i=1,#E do
                        ins(self.event[name],E[i])
                    end
                elseif type(E)=='function' then
                    ins(self.event[name],E)
                end
            end
        elseif k=='soundEvent' then
            for name,E in next,v do
                if type(E)=='function' then
                    self.soundEvent[name]=E
                else
                    error("soundEvent must be function")
                end
            end
        else
            if type(v)=='table' then
                self.settings[k]=TABLE.copy(v)
            elseif v~=nil then
                self.settings[k]=v
            end
        end
    end
end
local function decodeScript()
    
end
function P:loadScript(script)
    if not script then return end
    assert(type(script)=='table',"script must be table")
    self.script=script
    self.scriptLabels={}

    for i=1,1e99 do
        local line=script[i]
        if not line then break end
        if type(line)=='string' then line=decodeScript(line) end

        local errMsg="line #"..i..": "
        if type(line)=='table' then
            if line.lbl then
                assert(type(line.lbl)=='string',errMsg.."Label must be string")
                assert(not self.scriptLabels[line.lbl],errMsg.."Label '"..line.lbl.."' already exist")
                self.scriptLabels[line.lbl]=i
            end
            if line.t then
                line.t=assert(parseTime(line.t),errMsg.."Wrong time stamp")
            end

            local c=line.c
            local arg=line.a
            if type(c)=='string' then
                if c=='say' then
                    assert(arg.t~=nil,errMsg.."Need arg 't'")
                    for k,v in next,arg do
                        if     k=='d' then if not (type(v)=='string' or type(v)=='number' and v>0) then error(errMsg.."Wrong arg 'd', need >0") end
                        elseif k=='f' then if not (type(v)=='number' and v>0 and v%5==0 and v<=120) then error(errMsg.."Wrong arg 's', need 5, 10, 15,... 120") end
                        elseif k=='s' then if type(v)~='string' then error(errMsg.."Wrong arg 's', need string") end
                        elseif k=='t' then if type(v)~='string' then error(errMsg.."Wrong arg 't', need string") end
                        elseif k=='x' then if type(v)~='number' then error(errMsg.."Wrong arg 'x', need number") end
                        elseif k=='y' then if type(v)~='number' then error(errMsg.."Wrong arg 'y', need number") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif c=='wait' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'")
                    if not line.t then line.t=1 end
                    for k,v in next,arg do
                        if k=='v' then if type(v)~='string' then error(errMsg.."Wrong arg 'v', need string") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif _jmpOP[c] then
                    if c=='j' then
                        if not (arg.v==nil and arg.v2==nil and arg.c==nil) then error(errMsg.."Command j need no arg") end
                    else
                        assert(arg.v~=nil,errMsg.."Need arg 'v'")
                        if c=='jz' or c=='jnz' then
                            if not (arg.v2==nil and arg.c==nil) then error(errMsg.."Command jz(jnz) need only arg 'v'") end
                        else
                            if not ((arg.v2==nil)~=(arg.c==nil)) then error(errMsg.."Command Jump-if-* not allow 'v2' and 'c' exist at same time") end
                        end
                    end
                    for k,v in next,arg do
                        if     k=='v'  then if type(v)~='string' then error(errMsg.."Wrong arg 'v', need string") end
                        elseif k=='v2' then if type(v)~='string' then error(errMsg.."Wrong arg 'v2', need string") end
                        elseif k=='c'  then if type(v)~='number' then error(errMsg.."Wrong arg 'c', need number") end
                        elseif k=='d'  then if type(v)~='string' then error(errMsg.."Wrong arg 'd', need string") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif c=='setc' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    assert(arg.c~=nil,errMsg.."Need arg 'c'")
                    for k in next,arg do if not (k=='v' or k~='c') then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif c=='setd' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    assert(arg.n~=nil,errMsg.."Need arg 'n'") assert(type(arg.n)=='string',errMsg.."Wrong arg 'n', need string")
                    for k in next,arg do if not (k=='v' or k=='n') then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif c=='setg' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                end
            elseif type(c)~='nil' and type(c)~='function' then
                error(errMsg.."Wrong command type: "..type(c))
            end
        else
            error(errMsg.."Wrong line type: "..type(line))
        end
    end
    self.scriptLine=1
    self.scriptWait=script[1].t or 0
end
--------------------------------------------------------------

return P
