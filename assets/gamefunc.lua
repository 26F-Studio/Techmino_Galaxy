function sureCheck(event)
    if TASK.lock('sureCheck_'..event,1) then
        MSG.new('info',Text.sureText[event],1)
    else
        return true
    end
end

local _bgmPlaying ---@type string?
---@param full? boolean
---@param noProgress? boolean
function playBgm(name,full,noProgress)
    if name==_bgmPlaying then return end
    if not noProgress then PROGRESS.setBgmUnlocked(name,full and 2 or 1) end
    if full then
        FMOD.music(name)
    else
        FMOD.music(name,{param={'intensity',0,true}})
    end
    _bgmPlaying=name
end
function getBgm()
    return _bgmPlaying
end
function stopBgm(instant)
    FMOD.music.stop(instant)
    _bgmPlaying=nil
end
function playSample(...)
    local l={...}
    local inst
    for i=1,#l do
        if type(l[i])=='string' then
            inst=l[i]..'_wave'
        elseif type(l[i])=='table' then
            local note=l[i][1]
            if type(note)=='string' then note=SFX.getTuneHeight(l[i][1]) end
            local vol=l[i][2] or 1
            local len=l[i][3] or 420
            local rel=l[i][4] or 620
            local event=FMOD.effect(inst,{
                tune=note-33,
                volume=vol,
                param={'release',rel*1.0594630943592953^(note-33)},
            })
            TASK.new(function ()
                DEBUG.yieldT(len/1000)
                event:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT)
            end)
        end
    end
end

local interiorModeMeta={
    __call=function(self)
        local success,errInfo=pcall(GAME.getMode,self.name)
        if success then
            SCN.go('game_in','none',self.name)
        else
            MSG.new('warn',Text.noMode:repD(STRING.simplifyPath(tostring(self.name)),errInfo))
        end
    end
}
function playInterior(name)
    return setmetatable({name=name},interiorModeMeta)
end

local exteriorModeMeta={
    __call=function(self)
        local success,errInfo=pcall(GAME.getMode,self.name)
        if success then
            SCN.go('game_out','fade',self.name)
        else
            MSG.new('warn',Text.noMode:repD(STRING.simplifyPath(tostring(self.name)),errInfo))
        end
    end
}
function playExterior(name)
    return setmetatable({name=name},exteriorModeMeta)
end

function canPause()
    return not GAME.mode.name:find('/test')
end

local function task_interiorAutoQuit()
    local time=love.timer.getTime()
    repeat
        if SCN.swapping then return end
        coroutine.yield()
    until love.timer.getTime()-time>1.26
    SCN.back('none')
end
function autoQuitInterior(disable)
    TASK.removeTask_code(task_interiorAutoQuit)
    if not disable then
        TASK.new(task_interiorAutoQuit)
    end
end

function saveSettings()
    FILE.save({
        system=SETTINGS._system,
        game_mino=SETTINGS.game_mino,
        game_puyo=SETTINGS.game_puyo,
        game_gem=SETTINGS.game_gem,
    },'conf/settings','-json')
end
function saveKey()
    FILE.save({
        mino=KEYMAP.mino:export(),
        puyo=KEYMAP.puyo:export(),
        gem=KEYMAP.gem:export(),
        sys=KEYMAP.sys:export(),
    },'conf/keymap','-json')
end
function saveTouch()
    FILE.save(VCTRL.exportSettings(),'conf/touch','-json')
end

function backText()
    return CHAR.icon.back_chevron..' '..Text.button_back
end

function callDict(entry)
    SCN.go('dictionary','none',entry)
end

function task_unloadGame()
    coroutine.yield()
    DEBUG.yieldUntilNextScene()
    GAME.unload()
    collectgarbage()
end

local isKeyDown=love.keyboard.isDown
function isCtrlPressed() return isKeyDown('lctrl','rctrl') end
function isShiftPressed() return isKeyDown('lshift','rshift') end
function isAltPressed() return isKeyDown('lalt','ralt') end

local function _getActMode(mode,key)
    local act=KEYMAP[mode]:getAction(key)
    if act then
        return mode,act
    else
        return 'sys',KEYMAP.sys:getAction(key)
    end
end
local function _getActImg(mode,act)
    return IMG.actionIcons[mode][act]
end
function resetVirtualKeyMode(mode)
    VCTRL.reset()
    if not mode then return end

    for i=1,#VCTRL do
        local obj=VCTRL[i]
        if obj.type=='button' then
            local res,texture=pcall(_getActImg,_getActMode(mode,(obj.key)))
            obj:setTexture(res and texture)
        elseif obj.type=='stick2way' then
            for j,suffix in next,{'left','right'} do
                local res,texture=pcall(_getActImg,_getActMode(mode,'vj2'..suffix))
                obj:setTexture(j,res and texture)
            end
        elseif obj.type=='stick4way' then
            for j,suffix in next,{'down','left','up','right'} do
                local res,texture=pcall(_getActImg,_getActMode(mode,'vj4'..suffix))
                obj:setTexture(j,res and texture)
            end
        end
    end
end
function updateWidgetVisible(widgetList)
    if VCTRL.focus then
        widgetList.iconSize:setVisible(true)
        widgetList.button1:setVisible(VCTRL.focus.type=='button')
        widgetList.button2:setVisible(VCTRL.focus.type=='button')
        widgetList.stick2_1:setVisible(VCTRL.focus.type=='stick2way')
        widgetList.stick2_2:setVisible(VCTRL.focus.type=='stick2way')
        widgetList.stick4_1:setVisible(VCTRL.focus.type=='stick4way')
        widgetList.stick4_2:setVisible(VCTRL.focus.type=='stick4way')
    else
        widgetList.iconSize:setVisible(false)
        widgetList.button1:setVisible(false)
        widgetList.button2:setVisible(false)
        widgetList.stick2_1:setVisible(false)
        widgetList.stick2_2:setVisible(false)
        widgetList.stick4_1:setVisible(false)
        widgetList.stick4_2:setVisible(false)
    end
end

local sandBoxEnv={
    math=math,
    string=string,
    table=table,
    coroutine=coroutine,
    assert=assert,error=error,
    tonumber=tonumber,tostring=tostring,
    select=select,next=next,
    ipairs=ipairs,pairs=pairs,
    type=type,
    pcall=pcall,xpcall=xpcall,
    rawget=rawget,rawset=rawset,rawlen=rawlen,rawequal=rawequal,
    setmetatable=setmetatable,
}
function setSafeEnv(func)
    sandBoxEnv.mechLib=mechLib -- Update in case it changes during game
    setfenv(func,TABLE.copy(sandBoxEnv))
end

regFuncToStr={}
regStrToFunc={}
---Flatten a table of functions into string-to-function and function-to-string maps
---@param obj table|function
---@param path string
function regFuncLib(obj,path)
    if type(obj)=='table' then
        for k,v in next,obj do
            regFuncLib(v,path.."."..k)
        end
    elseif type(obj)=='function' then
        regFuncToStr[obj]=path
        regStrToFunc[path]=obj
    end
end

love_logo=GC.load{128,128,
    {'clear',0,0,0,0},
    {'move',64,64},
    {'setCL',COLOR.D},
    {'fCirc',0,0,64},
    {'setCL',.9,.3,.6},
    {'fCirc',0,0,60},
    {'setCL',.16,.66,.88},
    {'fBow',0,0,60,0,3.141593},
    {'move',-4,4},
    {'setCL',COLOR.L},
    {'fRect',-20,-20,40,40},
    {'fCirc',0,-20,20},
    {'fCirc',20,0,20},
}
