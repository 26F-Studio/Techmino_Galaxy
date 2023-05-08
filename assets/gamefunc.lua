function sureCheck(event)
    if TASK.lock('sureCheck_'..event,1) then
        MSG.new('info',Text.sureText[event],1)
    else
        return true
    end
end

local _bgmPlaying,_bgmMode
--- @param mode 'full'|'simp'|'base'|''|nil
--- @param args? string
function playBgm(name,mode,args)
    if not args then args='' end

    if bgmList[name][1] then
        if not STRING.sArg(args,'-noProgress') then
            PROGRESS.setBgmUnlocked(name,1)
        end
        BGM.play(bgmList[name],args)
    else
        if mode=='simp' and PROGRESS.getBgmUnlocked(name)==2 then
            mode='base'
        else
            if not STRING.sArg(args,'-noProgress') then
                PROGRESS.setBgmUnlocked(name,mode=='simp' and 1 or 2)
            end
        end
        if mode=='simp' then
            BGM.play(bgmList[name].base,args)
        elseif mode=='base' then
            if not TABLE.compare(BGM.getPlaying(),bgmList[name].full) then
                BGM.play(bgmList[name].full,args)
                BGM.set(bgmList[name].add,'volume',0,0)
            else
                BGM.set(bgmList[name].add,'volume',0,1)
            end
        else-- if mode=='full' then
            BGM.play(bgmList[name].full,args)
        end
    end
    _bgmPlaying,_bgmMode=name,mode
    if not STRING.sArg(args,'-keepEffects') then
        BGM.set('all','highgain',1,.1)
        BGM.set('all','lowgain',1,.1)
        BGM.set('all','pitch',1,.1)
    end
end
function getBgm()
    return _bgmPlaying,_bgmMode
end

local interiorModeMeta={__call=function(self)
    local success,errInfo=pcall(GAME.getMode,self.name)
    if success then
        SCN.go('game_in','none',self.name)
    else
        MSG.new('warn',Text.noMode:repD(STRING.simplifyPath(tostring(self.name)),errInfo))
    end
end}
function playInterior(name)
    return setmetatable({name=name},interiorModeMeta)
end

local exteriorModeMeta={__call=function(self)
    local success,errInfo=pcall(GAME.getMode,self.name)
    if success then
        SCN.go('game_out','fade',self.name)
    else
        MSG.new('warn',Text.noMode:repD(STRING.simplifyPath(tostring(self.name)),errInfo))
    end
end}
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
        gem= KEYMAP.gem:export(),
        sys= KEYMAP.sys:export(),
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

local function _getImg(mode,act)
    return IMG.actionIcons[mode][act]
end
function resetVCTRL(mode)
    VCTRL.reset()
    if not mode then return end

    for i=1,#VCTRL do
        local obj=VCTRL[i]
        if obj.type=='button' then
            local act=KEYMAP[mode]:getAction(obj.key)
            local res,drawable=pcall(_getImg,mode,act)
            obj:setDrawable(res and drawable or act and GC.newText(FONT.get(30),act))
        elseif obj.type=='stick2way' then
            for j,suffix in next,{'left','right'} do
                local act=KEYMAP[mode]:getAction('vj2'..suffix)
                local res,drawable=pcall(_getImg,mode,act)
                obj:setDrawable(j,res and drawable or act and GC.newText(FONT.get(30),act))
            end
        elseif obj.type=='stick4way' then
            for j,suffix in next,{'down','left','up','right'} do
                local act=KEYMAP[mode]:getAction('vj4'..suffix)
                local res,drawable=pcall(_getImg,mode,act)
                obj:setDrawable(j,res and drawable or act and GC.newText(FONT.get(30),act))
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
    mechLib=mechLib,
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
    setfenv=setfenv,setmetatable=setmetatable,
}
function setSafeEnv(func)
    setfenv(func,TABLE.copy(sandBoxEnv))
end
