local min=math.min
local floor,ceil=math.floor,math.ceil
local abs=math.abs
local ins,rem=table.insert,table.remove

local sign,expApproach=MATH.sign,MATH.expApproach

local P={}

--------------------------------------------------------------
-- Tools
function P:drawInfoPanel(x,y,w,h)
    return SKIN.get(self.settings.skin).drawInfoPanel(x,y,w,h)
end
--------------------------------------------------------------
-- Effects
function P:shakeBoard(args,v)
    local shake=self.settings.shakeness
    local pos=self.pos
    if args:sArg('-drop') then
        pos.vy=pos.vy+.2*shake*(v^.5 or 1)
    elseif args:sArg('-down') then
        pos.dy=pos.dy+.1*shake
    elseif args:sArg('-right') then
        pos.dx=pos.dx+.1*shake
    elseif args:sArg('-left') then
        pos.dx=pos.dx-.1*shake
    elseif args:sArg('-cw') then
        pos.va=pos.va+.002*shake
    elseif args:sArg('-ccw') then
        pos.va=pos.va-.002*shake
    elseif args:sArg('-180') then
        pos.vy=pos.vy+.1*shake
        pos.va=pos.va+((self.handX+#self.hand.matrix[1]/2-1)/self.settings.fieldW-.5)*.0026*shake
    elseif args:sArg('-clear') then
        pos.dk=pos.dk*(1+shake)
        pos.vk=pos.vk+.0002*shake*min((v or 2)^1.6,26)
    end
end
function P:playSound(event,...)
    if not self.sound then return end
    if self.time-self.soundTimeHistory[event]>=16 then
        self.soundTimeHistory[event]=self.time
        if self.soundEvent[event] then
            self.soundEvent[event](...)
        else
            MES.new('warn',"Unknown sound event: "..event)
        end
    end
end
function P:setPosition(x,y,k,a)
    local pos=self.pos
    pos.x=x or pos.x
    pos.y=y or pos.y
    pos.k=k or pos.k
    pos.a=a or pos.a
end
function P:movePosition(dx,dy,k,da)
    local pos=self.pos
    pos.x=pos.x+(dx or 0)
    pos.y=pos.y+(dy or 0)
    pos.k=pos.k*(k  or 1)
    pos.a=pos.a+(da or 0)
end
local function parseTime(str)
    local num,unit=str:cutUnit()
    return
        unit=='s'  and num*1000 or
        unit=='ms' and num or
        unit=='m'  and num*60000
end
--[[arg:
    text ("[TEXT]")
    duration ('2.6s')
    style ('appear')
    styleArg (nil)
    size (60)
    type ('norm')
    x,y (0,0)
    i,o (0.2,0.5)
    c ({1,1,1,1})
]]
function P:say(arg)
    local str=arg.text
    if type(str)=='string' then
        if str:sub(1,1)=='\\' then
            str=str:sub(2)
        elseif str:sub(1,1)=='@' then
            str=Text[str:sub(2)] or str
        end
    else
        str=tostring(str)
    end
    local D=arg.duration
    if type(D)=='string' then
        D=parseTime(D)/1000
    elseif not D then
        D=2.6
    end
    arg.duration=D
    self.texts:add{
        duration=D,
        text=str,
        style=arg.style or 'appear',
        styleArg=arg.styleArg,
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
end
--------------------------------------------------------------
-- Game methods
function P:random(a,b)
    return self.RND:random(a,b)
end
function P:_getActionObj(a)
    if type(a)=='string' then
        return self._actions[a]
    elseif type(a)=='function' then
        return setmetatable({
            press=a,
            release=NULL,
        },{__call=function(self,P)
            self.press(P)
        end})
    elseif type(a)=='table' then
        assert(type(a.press)=='function' and type(a.release)=='function',"WTF why action do not contain func press() & func release()")
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
function P:switchAction(act,state)
    assert(self._actions[act],"Invalid action name '"..act.."'")
    if state==nil or state==not self.actions[act] then
        if self.actions[act] then
            self:release(act)
            self.keyState[act]=nil
            self.actions[act]=nil
        else
            self.actions[act]=self:_getActionObj(act)
            self.keyState[act]=false
        end
    end
end
function P:setAction(act,data)
    assert(type(act)=='string',"Action name must be string")
    assert(self._actions[act],"Invalid action name '"..act.."'")
    self:release(act)
    self.actions[act]=self:_getActionObj(data)
end
function P:triggerEvent(name,...)
    -- if name~='always' and name:sub(1,4)~='draw' then print(name) end
    local L=self.event[name]
    if L then for i=1,#L do L[i](self,...) end end
end
---@param reason
---| 'AC'  Win
---| 'WA'  Block out
---| 'CE'  Lock out
---| 'MLE' Top out
---| 'TLE' Time out
---| 'OLE' Finesse fault
---| 'ILE' Ran out pieces
---| 'PE'  Mission failed
---| 'UKE' Other reason
function P:finish(reason)
    if self.finished then return end
    self.timing=false
    self.finished=reason
    self.hand=false
    self.spawnTimer=1e99

    self:triggerEvent('gameOver',reason)
    GAME.checkFinish()

    -- TODO: Just for temporary use
    if self.isMain then
        MES.new(reason=='AC' and 'check' or 'error',reason,6.26)
        self:playSound(reason=='AC' and 'win' or 'fail')
    end
end
--------------------------------------------------------------
-- Press & Release & Update & Render
function P:pressKey(act)
    if self.settings.inputDelay<=0 then
        self:press(act)
    else
        table.insert(self.buffedKey,{event='press',act=act,time=self.settings.inputDelay})
    end
end
function P:releaseKey(act)
    if self.settings.inputDelay<=0 then
        self:release(act)
    else
        table.insert(self.buffedKey,{event='release',act=act,time=self.settings.inputDelay})
    end
end
function P:press(act)
    self:triggerEvent('beforePress',act)

    if self.actions[act] and not self.keyState[act] then
        self.keyState[act]=true
        ins(self.actionHistory,{0,self.time,act})
        self.actions[act].press(self)
    end

    self:triggerEvent('afterPress',act)
end
function P:release(act)
    self:triggerEvent('beforeRelease',act)

    if self.actions[act] and self.keyState[act] then
        self.keyState[act]=false
        ins(self.actionHistory,{1,self.time,act})
        self.actions[act].release(self)
    end

    self:triggerEvent('afterRelease',act)
end
local _jmpOP={
    j=0,
    jz=1,jnz=1,
    jeq=2,jne=2,jge=2,jle=2,jg=2,jl=2,
}
local baseScriptCmds={
    setc=function(self,arg)-- Set constant
        self.modeData[arg.v]=arg.c
    end,
    setd=function(self,arg)-- Set data
        self.modeData[arg.v]=self.modeData[arg.d]
    end,
    setm=function(self,arg)-- Set mode value
        self.modeData[arg.v]=self:getScriptValue(arg)
    end,
    wait=function(self,arg)-- Wait until modeData value(s) all not 0 (by keep cursor to current line)
        for i=1,#arg do
            if self.modeData[arg[i]]==nil then
                return self.scriptLine
            end
        end
    end,
    say=function(self,arg)-- Show text
        self:say(arg)
    end,
    sfx=function(_,arg)
        SFX.play(unpack(arg))
    end,
    finish=function(self,arg)
        self:finish(arg)
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
                return self.scriptLabels[arg.d] or error("No label named '"..arg.d.."'")
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
        -- Simulate input-delay
        for k,obj in next,self.buffedKey do
            obj.time=obj.time-1
            if obj.time<=0 then
                if obj.event=='press' then
                    self:press(obj.act)
                elseif obj.event=='release' then
                    self:release(obj.act)
                else
                    error("?")
                end
                self.buffedKey[k]=nil
            end
        end

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
                        error(("Probably infinite loop in script. Last 100 cmds between #%d~%d"):format(minLoopLineNum,maxLoopLineNum))
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
                self.timing=true

                self:triggerEvent('gameStart')

            end
        else
            self.time=self.time+1
        end

        self:updateFrame()
    end
    for _,v in next,self.particles do v:update(dt) end
    self.texts:update(dt)
end
--------------------------------------------------------------
-- Builder
function P:addEvent(name,E)
    assert(self.event[name],"Wrong event key: '"..tostring(name).."'")
    if type(E)=='table' then
        for i=1,#E do
            self:addEvent(name,E[i])
        end
    else
        assert(type(E)=='function','event must be function or table of functions')
        ins(self.event[name],E)
    end
end
function P:delEvent(name,E)
    assert(self.event[name],"Wrong event key: '"..tostring(name).."'")
    assert(type(E)=='function','event must be function')
    local pos=TABLE.find(self.event[name],E)
    if pos then rem(self.event[name],pos) end
end
function P:addCodeSeg(name,S)
    assert(self.codeSeg[name],"Wrong codeSeg key: '"..tostring(name).."'")
    if type(S)=='table' then
        for i=1,#S do
            self:addCodeSeg(name,S[i])
        end
    else
        assert(type(S)=='function','codeSeg must be function or table of functions')
        ins(self.codeSeg[name],S)
    end
end
function P:delCodeSeg(name,S)
    assert(self.codeSeg[name],"Wrong codeSeg key: '"..tostring(name).."'")
    assert(type(S)=='function','codeSeg must be function')
    local pos=TABLE.find(self.codeSeg[name],S)
    if pos then rem(self.codeSeg[name],pos) end
end
function P:addSoundEvent(name,E)
    assert(self.soundEvent[name],"Wrong soundEvent key: '"..tostring(name).."'")
    assert(type(E)=='function',"soundEvent must be function")
    self.soundEvent[name]=E
end
function P:delSoundEvent(name)
    assert(self.soundEvent[name],"Wrong soundEvent key: '"..tostring(name).."'")
    self.soundEvent[name]=nil
end
function P:loadSettings(settings)-- Load data & events from mode settings
    for k,v in next,settings do
        if k=='event' then
            for name,E in next,v do
                self:addEvent(name,E)
            end
        elseif k=='codeSeg' then
            for name,S in next,v do
                self:addCodeSeg(name,S)
            end
        elseif k=='soundEvent' then
            for name,E in next,v do
                self:addSoundEvent(name,E)
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
        local cmd=p and str:sub(1,p-1) or str
        line.cmd=cmd

        local arg=p and str:sub(p+1):split(',') or {}
        for i=1,#arg do arg[i]=arg[i]:trim() end
        if cmd=='wait' then
            assert(#arg>0,errMsg.."Wait which var(s)?")
            line.arg=arg
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
            assert(#arg==2,errMsg.."Wrong arg count, need 2")
            local a2=arg[2]
            if a2:byte(1)==a2:byte(-1) and (a2:sub(1,1)=='"' or a2:sub(1,1)=="'") then
                a2=a2:sub(2,-2)
            elseif a2=='nil' then
                a2=nil
            elseif a2=='true' or a2=='false' then
                a2=a2=='true'
            elseif tonumber(a2) then
                a2=tonumber(a2)
            else
                error(errMsg.."Wrong data")
            end
            line.arg={v=arg[1],c=a2}
        elseif cmd=='setd' then
            assert(#arg==2,errMsg.."Wrong arg count, need 2")
            line.arg={v=arg[1],d=arg[2]}
        elseif cmd=='sfx' then
            assert(#arg>=1 and #arg<=4,errMsg.."Wrong arg count, need 1~4")
            line.arg=arg
        elseif cmd=='finish' then
            assert(#arg==1,errMsg.."Wrong arg count, need 1")
            line.arg=arg[1]
        else
            line.cmd=cmd
            line.arg=p and str:sub(p+1) or ""
            line._notbasic=true
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
            if line._notbasic then
                local cmd=line.cmd
                if self.decodeScript then
                    line._notbasic=nil
                    self:decodeScript(line,errMsg)
                else
                    error(errMsg.."No string command '"..cmd.."'")
                end
            end
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
                    assert(type(arg)=='table',errMsg.."arg must be table")
                    assert(arg.text~=nil,errMsg.."Need arg 't'")
                    for k,v in next,arg do
                        if     k=='text'     then if type(arg.text)~='string' and type(arg.text)~='table' then error(errMsg.."Wrong arg 'text', need string or str-list") end
                        elseif k=='duration' then if not (type(v)=='string' or type(v)=='number' and v>0) then error(errMsg.."Wrong arg 'duration', need >0") end
                        elseif k=='size'     then if not (type(v)=='number' and v>0 and v%5==0 and v<=120) then error(errMsg.."Wrong arg 'size', need 5, 10, 15,... 120") end
                        elseif k=='type' or k=='style' then if type(v)~='string' then error(errMsg.."Wrong arg 'type', need string") end
                        elseif k=='style'    then if type(v)~='string' then error(errMsg.."Wrong arg 'style', need string") end
                        elseif k=='i' or k=='o' or k=='x' or k=='y' then if type(v)~='number' then error(errMsg.."Wrong arg '"..k.."', need number") end
                        elseif k=='c'        then if type(v)~='table'  then error(errMsg.."Wrong arg 'c', need table") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif cmd=='sfx' then
                    assert(type(arg)=='table',errMsg.."arg must be table")
                    assert(arg[1]~=nil,errMsg.."Need arg #1 (name)")
                    for k,v in next,arg do
                        if     k==1 then if type(v)~='string' then error(errMsg.."Wrong arg #1 (name), need string") end
                        elseif k==2 then if not (v==nil or type(v)=='number') then error(errMsg.."Wrong arg #2 (vol), need number") end
                        elseif k==3 then if not (v==nil or type(v)=='number') then error(errMsg.."Wrong arg #3 (pos), need number") end
                        elseif k==4 then if not (v==nil or type(v)=='number') then error(errMsg.."Wrong arg #4 (pitch), need number") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif cmd=='finish' then
                    assert(type(arg)=='string',errMsg.."arg must be string")
                elseif cmd=='wait' then
                    assert(type(arg)=='table',errMsg.."arg must be table")
                    assert(#arg>0,errMsg.."Wait which var(s)?")
                    if not line.t then line.t=1 end
                elseif _jmpOP[cmd] then
                    assert(type(arg)=='table',errMsg.."arg must be table")
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
                        elseif k=='c'  then
                        elseif k=='d'  then if type(v)~='string' then error(errMsg.."Wrong arg 'd', need string") end
                        else error(errMsg.."Wrong arg name '"..k.."'")
                        end
                    end
                elseif cmd=='setc' then
                    assert(type(arg)=='table',errMsg.."arg must be table")
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    for k in next,arg do if not (k=='v' or k=='c') then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif cmd=='setd' then
                    assert(type(arg)=='table',errMsg.."arg must be table")
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    assert(arg.d~=nil,errMsg.."Need arg 'd'") assert(type(arg.d)=='string',errMsg.."Wrong arg 'd', need string")
                    for k in next,arg do if not (k=='v' or k=='d') then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif cmd=='setm' then
                    assert(type(arg)=='table',errMsg.."arg must be table")
                    assert(arg.v~=nil,errMsg.."Need arg 'v'") assert(type(arg.v)=='string',errMsg.."Wrong arg 'v', need string")
                    for k in next,arg do if not k=='v' then error(errMsg.."Wrong arg name '"..k.."'") end end
                elseif self.checkScriptLine then
                    self:checkScriptSyntax(cmd,arg,errMsg)
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
