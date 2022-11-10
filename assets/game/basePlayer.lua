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
local _jmpOP={
    j=0,
    jz=1,jnz=1,
    jeq=2,jne=2,jge=2,jle=2,jg=2,jl=2,
}
local baseScriptCmds={
    jm=function(self,arg)-- Jump if gameMode match
        if self.gameMode==arg.v then
            return self.scriptLabels[arg.d] or error("No label called '"..arg.d.."'")
        end
    end,
    setc=function(self,arg)-- Set constant
        self.modeData[arg.v]=arg.c
    end,
    setd=function(self,arg)-- Set data
        self.modeData[arg.v]=self.modeData[arg.d]
    end,
    setm=function(self,arg)-- Set mode value
        self.modeData[arg.v]=self:getScriptValue(arg)
    end,
    wait=function(self,arg)-- Wait some time (by keep cursor to current line)
        if not (self.modeData[arg.v] and self.modeData[arg.v]~=0) then
            return self.scriptLine
        end
    end,
    say=function(self,arg)-- Show text
        local str=arg.text
        if type(str)=='string' then
            if str:sub(1,1)=='\\' then
                str=str:sub(2)
            elseif str:sub(1,1)=='@' then
                str=Text[str] or str
            end
        end
        local D=arg.duration
        if type(D)=='string' then
            D=parseTime(D)/1000
        elseif not D then
            D=2.6
        end
        self.texts:add{
            duration=D,
            text=str or "[TEXT]",
            style=arg.style or 'appear',
            fontSize=arg.size or 60,
            fontType=arg.type or 'norm',
            x=arg.x or 0,
            y=arg.y or 0,
            inPoint=(arg.i or 0.2)/D,
            outPoint=(arg.o or 0.5)/D,
            r=arg.c and arg.c[1] or 1,
            g=arg.c and arg.c[2] or 1,
            b=arg.c and arg.c[3] or 1,
            a=arg.c and arg.c[4] or 1,
        }
    end,
    sfx=function(_,arg)
        SFX.play(unpack(arg))
    end,
}
function P:runScript(cmd,arg)-- Run single lua-table assembly command
    if type(cmd)=='string' then
        if baseScriptCmds[cmd] then
            return baseScriptCmds[cmd](self,arg)
        elseif _jmpOP[cmd] then-- Sorry cannot move these jumps into `baseScriptCmds`
            local v1=arg.v  if v1~=nil then v1=self.modeData[v1] end
            local v2=arg.v2 if v2==nil then v2=arg.c end
            if
                cmd=='j'              or
                cmd=='jz'  and v1==0  or
                cmd=='jnz' and v1~=0  or
                cmd=='jeq' and v1==v2 or
                cmd=='jne' and v1~=v2 or
                cmd=='jge' and v1>=v2 or
                cmd=='jle' and v1<=v2 or
                cmd=='jg'  and v1>v2  or
                cmd=='jl'  and v1<v2
            then
                return self.scriptLabels[arg.d] or error("No label called '"..arg.d.."'")
            end
        elseif self.scriptCmd[cmd] then
            return self.scriptCmd[cmd](self,arg)
        else
            error("Script command '"..cmd.."' not exist")
        end
    elseif type(cmd)=='function' then
        return cmd(self)
    elseif cmd~=nil then
        error("WTF why script command is "..type(cmd))
    end
end
function P:update(dt)
    local df=floor((self.realTime+dt)*1000)-floor(self.realTime*1000)
    self.realTime=self.realTime+dt

    for _=1,df do
        -- Script
        if self.script then
            local loopCount=0
            local minLoopLineNum,maxLoopLineNum
            while true do
                local l=self.script[self.scriptLine]
                if not l then break end-- EOF

                if self.scriptWait<=0 then
                    -- Execute command
                    local nextPos=self:runScript(l.cmd,l.arg)
                    self.scriptLine=nextPos or self.scriptLine+1
                    if not self.script[self.scriptLine] then break end
                    self.scriptWait=self.script[self.scriptLine].t or 0
                else
                    self.scriptWait=self.scriptWait-1
                    break
                end
                loopCount=loopCount+1
                if loopCount>=2500 then
                    if not minLoopLineNum then
                        minLoopLineNum=26000
                        maxLoopLineNum=0
                    end
                    minLoopLineNum=min(minLoopLineNum,self.scriptLine)
                    maxLoopLineNum=min(maxLoopLineNum,self.scriptLine)
                    if loopCount>=2600 then
                        error(("Probably infinite loop in scropt. Last 100 cmds between #%d~%d"):format(minLoopLineNum,maxLoopLineNum))
                    end
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
function P:render() end
--------------------------------------------------------------
-- Builder
function P:loadSettings(settings)-- Load data & events from mode settings
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
local function decodeScript(str,errMsg)-- Translate some string commands to lua-table assembly command
    str=str:trim()
    local line={}
    if str:find('[_0-9A-Za-z]*:')==1 then
        line.lbl=str:sub(1,str:find(':')-1)
        str=str:sub(str:find(':')+1):trim()
    end
    if str:sub(1,1)=='[' and str:find(']') then
        line.t=str:sub(2,str:find(']')-1)
        str=str:sub(str:find(']')+1):trim()
    end
    if #str>0 then
        local p=str:find('[^_0-9A-Za-z]')
        local cmd=str:sub(1,p-1)
        line.cmd=cmd

        local arg=str:sub(p+1):split(',')
        for i=1,#arg do arg[i]=arg[i]:trim() end
        if cmd=='wait' then
            assert(#arg==1,"How long to wait?")
            line.arg={v=arg[1]}
        elseif cmd=='jm' then
            assert(#arg==2,"Wrong arg count, need 2")
            assert(arg[2]:match("^[a-z]+$") and ("mino|puyo|gem"):find(arg[2]),"Mode must be mino/puyo/gem")
            line.arg={d=arg[1],v=arg[2]}
        elseif _jmpOP[cmd] then
            if #arg~=_jmpOP[cmd]+1 then error(errMsg.."Wrong arg count, "..cmd.." need "..(_jmpOP[cmd]+1).." args") end
            line.arg={d=arg[1],v=arg[2]}
            if arg[3] then
                local a3=arg[3]
                if a3:byte(1)==a3:byte(-1) and (a3:sub(1,1)=='"' or a3:sub(1,1)=="'") then
                    line.arg.c=a3:sub(2,-2)
                elseif tonumber(a3) then
                    line.arg.c=tonumber(a3)
                elseif a3=='true' or a3=='false' then
                    line.arg.c=a3=='true'
                else
                    line.arg.v2=a3
                end
            end
        elseif cmd=='setc' then
            assert(#arg==2)
            local a2=arg[2]
            if a2:byte(1)==a2:byte(-1) and (arg[3]:sub(1,1)=='"' or arg[3]:sub(1,1)=="'") then
                a2=a2:sub(2,-2)
            elseif a2=='true' or a2=='false' then
                a2=a2=='true'
            elseif tonumber(a2) then
                a2=tonumber(a2)
            else
                error(errMsg.."Wrong data")
            end
            line.arg={v=arg[1],c=a2}
        elseif cmd=='setd' then
            assert(#arg==2)
            line.arg={v=arg[1],d=arg[2]}
        else
            error(errMsg.."No string command '"..cmd.."'")
        end
    end
    return line
end
function P:loadScript(script)-- Parse time stamps and labels, check syntax of lua-table assembly commands
    if not script then return end
    assert(type(script)=='table',"script must be table")
    self.script=script
    self.scriptLabels={}

    for i=1,1e99 do
        local line=script[i]
        if not line then break end
        local errMsg="line #"..i..": "

        if type(line)=='string' then
            line=decodeScript(line,errMsg)
            script[i]=line
        end

        if type(line)=='table' then
            -- Load labels
            if line.lbl then
                assert(type(line.lbl)=='string',errMsg.."Label must be string")
                assert(not self.scriptLabels[line.lbl],errMsg.."Label '"..line.lbl.."' already exist")
                self.scriptLabels[line.lbl]=i
            end

            -- Parse time
            if line.t and type(line.t)=='string' then
                line.t=assert(parseTime(line.t),errMsg.."Wrong time stamp")
            end

            -- Check syntax
            local cmd=line.cmd
            local arg=line.arg
            if type(cmd)=='string' then
                if cmd=='say' then
                    assert(arg.text~=nil,errMsg.."Need arg 't'")
                    for k,v in next,arg do
                        if     k=='text'    then if type(arg.text)~='string' and type(arg.text)~='table' then error(errMsg.."Wrong arg 'text', need string or str-list") end
                        elseif k=='duration'then if not (type(v)=='string' or type(v)=='number' and v>0) then error(errMsg.."Wrong arg 'duration', need >0") end
                        elseif k=='size'    then if not (type(v)=='number' and v>0 and v%5==0 and v<=120) then error(errMsg.."Wrong arg 'size', need 5, 10, 15,... 120") end
                        elseif k=='type' or k=='style' then if type(v)~='string' then error(errMsg.."Wrong arg 'type', need string") end
                        elseif k=='style'   then if type(v)~='string' then error(errMsg.."Wrong arg 'style', need string") end
                        elseif k=='i' or k=='o' or k=='x' or k=='y' then if type(v)~='number' then error(errMsg.."Wrong arg '"..k.."', need number") end
                        elseif k=='c'       then if type(v)~='table'  then error(errMsg.."Wrong arg 'c', need table") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif cmd=='sfx' then
                    assert(arg[1]~=nil,"Need arg #1 (name)")
                    for k,v in next,arg do
                        if     k==1 then if type(v)~='string' then error(errMsg.."Wrong arg #1 (name), need string") end
                        elseif k==2 then if not (v==nil or type(v)=='number') then error(errMsg.."Wrong arg #2 (vol), need number") end
                        elseif k==3 then if not (v==nil or type(v)=='number') then error(errMsg.."Wrong arg #3 (pos), need number") end
                        elseif k==4 then if not (v==nil or type(v)=='number') then error(errMsg.."Wrong arg #4 (pitch), need number") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif cmd=='wait' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'")
                    if not line.t then line.t=1 end
                    for k,v in next,arg do
                        if k=='v' then if type(v)~='string' then error(errMsg.."Wrong arg 'v', need string") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif _jmpOP[cmd] then
                    if cmd=='j' then
                        if not (arg.v==nil and arg.v2==nil and arg.c==nil) then error(errMsg.."Command j need no arg") end
                    else
                        assert(arg.v~=nil,errMsg.."Need arg 'v'")
                        if cmd=='jz' or cmd=='jnz' then
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
                elseif cmd=='setc' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    assert(arg.c~=nil,errMsg.."Need arg 'c'")
                    for k in next,arg do if not (k=='v' or k=='c') then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif cmd=='setd' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    assert(arg.d~=nil,errMsg.."Need arg 'd'") assert(type(arg.d)=='string',errMsg.."Wrong arg 'd', need string")
                    for k in next,arg do if not (k=='v' or k=='d') then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif cmd=='setm' then
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    for k in next,arg do if not k=='v' then error(errMsg.."Wrong arg name '"..k.."'") end end
                end
            elseif type(cmd)~='nil' and type(cmd)~='function' then
                error(errMsg.."Wrong command type: "..type(cmd))
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
