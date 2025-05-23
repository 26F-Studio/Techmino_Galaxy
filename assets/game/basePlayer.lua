local min=math.min
local floor,ceil=math.floor,math.ceil
local abs=math.abs
local ins,rem=table.insert,table.remove

local sign,expApproach=MATH.sign,MATH.expApproach

---@class Techmino.Player
---@field gameMode Techmino.Player.Type
---@field id number limited to 1~1000
---@field team number Team ID, 0 as No Team
---@field isMain boolean
---@field sound boolean
---@field remote boolean
---@field settings Techmino.Mode.Setting.Brik | Techmino.Mode.Setting.Gela | Techmino.Mode.Setting.Acry
---@field buffedKey table
---@field modeData Techmino.PlayerModeData Warning: may contain anything, choose variable name carefully, suggested to be >=6 characters in total & multiple words (eg. `tspinCount`)
---@field soundTimeHistory table
---@field RND love.RandomGenerator
---@field pos {x:number, y:number, k:number, a:number, dx:number, dy:number, dk:number, da:number, vx:number, vy:number, vk:number, va:number}
---@field finished Techmino.EndReason | boolean Did game finish
---@field realTime number Real time, [float] s
---@field time number Inside timer for player, [int] ms
---@field gameTime number Game time of player, [int] ms
---@field timing boolean Is gameTime running?
---@field texts Zenitha.Text
---@field particles Techmino.ParticleSystems
---
---@field tickStep function
---@field scriptCmd function
---@field decodeScript function
---@field checkScriptSyntax function
---
---@field hand Techmino.Piece | false Current controlling piece object
---@field handX number
---@field handY number
---@field event table<string, Techmino.Event[]>
---@field soundEvent table
---@field _actions table<string, {press:fun(P:Techmino.Player), release:fun(P:Techmino.Player)}>
---
---@field receive function
---@field render function
local P={}

---@class Techmino.Player.TextArg
---@field text string "[TEXT]"
---@field duration number 2.6s
---@field style Zenitha.TextAnimStyle 'appear'
---@field styleArg any nil
---@field size number 60
---@field type string 'norm'
---@field x number 0
---@field y number 0
---@field i number 0.2
---@field o number 0.5
---@field c number[] {1,1,1,1}

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
    if self.time-self.soundTimeHistory[event]>=26 then
        self.soundTimeHistory[event]=self.time
        if self.soundEvent[event] then
            self.soundEvent[event](...)
        else
            MSG.log('warn',"Unknown sound event: "..event)
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
---@param method 'init' | 'drop' | string
function P:atkEvent(method,...)
    local sys=mechLib[self.gameMode].attackSys[self.settings.atkSys]
    assert(sys and sys[method],"Invalid attackSys / method")
    return sys[method](self,...)
end
local function parseTime(str)
    local num,unit=str:cutUnit()
    return
        unit=='s'  and num*1000 or
        unit=='ms' and num or
        unit=='m'  and num*60000
end
---@param arg Techmino.Player.TextArg
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
        k=arg.k or 1,
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

---Random Int or 0~1
function P:random(a,b)
    return self.RND:random(a,b)
end
---Random Float
function P:rand(a,b)
    return a+self.RND:random()*(b-a)
end
---Random value
function P:coin(head,tail)
    return self.RND:random()>.5 and head or tail
end
---Random boolean
function P:roll(chance)
    return self.RND:random()<(chance or .5)
end
---Random int with custom weight
function P:randFreq(fList)
    local sum=MATH.sum(fList)
    local r=self.RND:random()*sum
    for i=1,#fList do
        r=r-fList[i]
        if r<0 then return i end
    end
    error("WTF why not all positive")
end
function P:_getActionObj(a)
    if type(a)=='string' then
        return self._actions[a]
    elseif type(a)=='function' then
        return setmetatable({
            press=a,
            release=NULL,
        },{__call=function(_P,act)
            _P.press(act)
        end})
    elseif type(a)=='table' then
        assert(type(a.press)=='function' and type(a.release)=='function',"WTF why action do not contain func press() & func release()")
        return setmetatable({
            press=a.press,
            release=a.release,
        },{__call=function(_P,act)
            _P.press(act)
            _P.release(act)
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
    local L,i=self.event[name],1
    while L[i] do
        if L[i][2](self,...) then
            rem(L,i)
        else
            i=i+1
        end
    end
end
---- Statistic: -1e99
---- Music: 1e62
---- Default: 0
---@param name Techmino.EventName
---@param E Techmino.Event | Techmino.Event[]
function P:addEvent(name,E)
    local L=self.event[name]
    assert(L,"Wrong event key: '"..tostring(name).."'")
    if type(E)=='table' then
        if type(E[1])=='number' and type(E[2])=='function' then
            local i=1
            while i<=#L and L[i][1]<=E[1] do i=i+1 end
            ins(L,i,E)
        else
            for i=1,#E do
                self:addEvent(name,E[i])
            end
        end
    elseif type(E)=='string' then
        local errMsg
        ---@type Techmino.Event
        E,errMsg=loadstring('local P=...;'..E)
        if E then
            SetSafeEnv(E)
            self:addEvent(name,E)
        else
            error("Error in code string: "..errMsg)
        end
    elseif type(E)=='function' then
        self:addEvent(name,{0,E})
    else
        error("Wrong Event format")
    end
end
local function _scrap() return true end
---Mark an event as scrapped, it will destroy itself after next update
---@param E number | function | Techmino.Event
function P:delEvent(name,E)
    local L=self.event[name]
    assert(L,"Wrong event key: '"..tostring(name).."'")
    local pos
    if type(E)=='number' then
        for i=1,#L do if L[i][1]==E then pos=i break end end
    elseif type(E)=='function' then
        for i=1,#L do if L[i][2]==E then pos=i break end end
    else
        for i=1,#L do if L[i]==E then pos=i break end end
    end
    if pos then L[pos][2]=_scrap end
end
local finishTexts={
    win='AC',
    suffocate='WA',
    lockout='CE',
    topout='MLE',
    timeout='TLE',
    rule='OLE',
    exhaust='ILE',
    taskfail='PE',
    other='UKE',
}
---@param reason Techmino.EndReason
function P:finish(reason)
    if self.finished then return end
    self.timing=false
    self.finished=reason
    self.hand=false
    self.spawnTimer=1e99

    self:triggerEvent('gameOver',reason)
    if not self.finished then return end

    GAME.checkFinish()

    -- TODO: Just for temporary use
    if self.isMain then
        MSG(reason=='win' and 'check' or 'error',finishTexts[reason] or finishTexts.other,6.26)
        self:playSound('finish_'..reason)
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

    self.stat.key=self.stat.key+1

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
    setc=function(self,arg) -- Set constant
        self.modeData[arg.v]=arg.c
    end,
    setd=function(self,arg) -- Set data
        self.modeData[arg.v]=self.modeData[arg.d]
    end,
    setm=function(self,arg) -- Set mode value
        self.modeData[arg.v]=self:getScriptValue(arg)
    end,
    wait=function(self,arg) -- Wait until modeData value(s) all not 0 (by keep cursor to current line)
        for i=1,#arg do
            if self.modeData[arg[i]]==nil then
                return self.scriptLine
            end
        end
    end,
    say=function(self,arg) -- Show text
        self:say(arg)
    end,
    sfx=function(_,arg)
        SFX.play(unpack(arg))
    end,
    finish=function(self,arg)
        self:finish(arg)
    end,
}
function P:runScript(cmd,arg) -- Run single lua-table assembly command
    if type(cmd)=='string' then
        if baseScriptCmds[cmd] then
            return baseScriptCmds[cmd](self,arg)
        elseif _jmpOP[cmd] then -- Sorry cannot move these jumps into `baseScriptCmds`
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
                if not l then break end -- EOF

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

        self:tickStep()
    end
    for _,v in next,self.particles do v:update(dt) end
    self.texts:update(dt)
end

--------------------------------------------------------------
-- Builder

function P:addSoundEvent(name,F)
    assert(self.soundEvent[name],"Wrong soundEvent key: '"..tostring(name).."'")
    assert(type(F)=='function',"soundEvent must be function")
    self.soundEvent[name]=F
end
function P:delSoundEvent(name)
    assert(self.soundEvent[name],"Wrong soundEvent key: '"..tostring(name).."'")
    self.soundEvent[name]=nil
end
function P:loadSettings(settings) -- Load data & events from mode settings
    for k,v in next,settings do
        if k=='event' then
            for name,F in next,v do
                self:addEvent(name,F)
            end
        elseif k=='soundEvent' then
            for name,F in next,v do
                self:addSoundEvent(name,F)
            end
        else
            if type(v)=='table' then
                self.settings[k]=TABLE.copyAll(v)
            elseif v~=nil then
                self.settings[k]=v
            end
        end
    end
end
local function decodeScript(str,errMsg) -- Translate some string commands to lua-table assembly command
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
            assert(arg[1],errMsg.."Wait which var(s)?")
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
function P:loadScript(script) -- Parse time stamps and labels, check syntax of lua-table assembly commands
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
                        elseif k=='i' or k=='o' or k=='x' or k=='y' or k=='k' then if type(v)~='number' then error(errMsg.."Wrong arg '"..k.."', need number") end
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
                    assert(arg[1],errMsg.."Wait which var(s)?")
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
                elseif self.checkScriptSyntax then
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
local soundTimeMeta={
    __index=function(self,k) rawset(self,k,0) return -1e99 end,
    __metatable=true,
}
---@return Techmino.Player
function P.new(remote)
    local self={}
    self.isMain=false
    self.sound=false
    self.remote=not not remote

    self.buffedKey={}
    self.modeData={target={},music={id='intensity'}}
    self.soundTimeHistory=setmetatable({},soundTimeMeta)

    self.RND=love.math.newRandomGenerator(GAME.seed+626)

    self.pos={
        x=0,y=0,k=1,a=0,

        dx=0,dy=0,dk=0,da=0,
        vx=0,vy=0,vk=0,va=0,
    }

    ---@class Techmino.PlayerStatTable
    self.stat={key=0}
    self.finished=false
    self.realTime=0
    self.time=0
    self.gameTime=0
    self.timing=false

    self.texts=TEXT.new()
    self.particles=setmetatable({},{__index=function(p,k)
        p[k]=require'assets.game.particleSystemTemplate'[k]:clone()
        return p[k]
    end})

    return self
end
function P:initialize()
    self.actions=TABLE.copyAll(self._actions,0)
    self.actionHistory={}
    self.keyState={}
    for k in next,self.actions do
        self.keyState[k]=false
    end
end
local dumpIgnore={
    ['P.soundTimeHistory']=true,
    ['P.particles']=true,
    ['P.texts']=true,
}
local function dump(self,L,t,path)
    local s='{'
    local count=1
    for k,v in next,L do
        local nPath=path..'.'..tostring(k)
        if not dumpIgnore[nPath] then
            -- print(nPath,k,v)

            local T=type(k)
            if T=='number' then
                if k==count then
                    -- List part, no brackets needed
                    k=''
                    count=count+1
                else
                    k='['..k..']='
                end
            elseif T=='string' then
                -- if k is legal variable name
                if k:match('^[_a-zA-Z][_a-zA-Z0-9]*$') then
                    k=k..'='
                else
                    k='["'..k:gsub('["\\]','\\%1')..'"]='
                end
            elseif T=='boolean' then
                k='['..k..']='
            elseif T=='function' then
                k='["FUNC:'..regFuncToStr[k]..'"]='
            else
                k='["*'..tostring(k)..'"]='
                LOG('warn',"Wrong key type: "..T..", "..nPath)
            end

            T=type(v)
            if T=='number' or T=='boolean' then
                v=tostring(v)
            elseif T=='string' then
                v='"'..v:gsub('"','\\"')..'"'
            elseif T=='table' then
                v=t<10 and dump(self,v,t+1,nPath)
            elseif T=='function' then
                v='"FUNC:'..(regFuncToStr[v] or LOG('warn',"UNKNOWN_FUNCTION: "..nPath) or "unknown")..'"'
            elseif T=='userdata' then
                T=v:type()
                if T=='RandomGenerator' then
                    v=dump(self,{__type=T,state=v:getState()},t+1,nPath)
                elseif T=='ParticleSystem' then
                    v=nil -- Skip
                else
                    LOG('warn',"Un-handled type:"..T..", "..nPath)
                end
            else
                v='["*'..tostring(v)..'"]='
                LOG('warn',"Wrong value type: "..T..", "..nPath)
            end

            if v~=nil then
                s=s..(s=='{' and k or ','..k)..v
            end
        else
            -- print("Filtered: "..nPath)
        end
    end
    return s..'}'
end
function P:serialize()
    return dump(self,self,0,"P")
end
local function undump(self,L,t)
    for k,v in next,L do
        local T=type(k)
        if T=='number' or T=='boolean' then
        elseif T=='string' then
            if k:sub(1,5)=='FUNC:' then
                k=regStrToFunc[k:sub(6)] or LOG('warn',"UNKNOWN_FUNCTION: "..k)
            end
        else
            LOG('warn',"Abnormal key type: "..T)
        end

        T=type(v)
        if T=='table' then
            if v.__type then
                if v.__type=='RandomGenerator' then
                    self[k]=love.math.newRandomGenerator()
                    self[k]:setState(v.state)
                else
                    LOG('warn',"Un-handled type:"..v.__type)
                end
            elseif t<=10 then
                self[k]={}
                undump(self[k],v,t+1)
            else
                LOG('warn',"WARNING: table depth over 10, skipped")
            end
        else
            if T=='string' then
                if v:sub(1,5)=='FUNC:' then
                    v=regStrToFunc[v:sub(6)] or LOG('warn',"UNKNOWN_FUNCTION: "..v)
                end
            end
            self[k]=v
        end
    end
end
function P:unserialize(data)
    local f='return'..data
    f=loadstring(f)
    if type(f)~='function' then return LOG('warn',"Cannot parse data as luaon") end
    setfenv(f,{})
    local res=f()
    if type(res)~='table' then return LOG('warn',"Cannot parse data as luaon") end
    undump(self,res,0)

    self.soundTimeHistory=setmetatable({},soundTimeMeta)

    self:unserialize_custom()
end
function P:unserialize_custom()
    -- Flandre kawaii
end

--------------------------------------------------------------

return P
