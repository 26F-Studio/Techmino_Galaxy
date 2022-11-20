function sureCheck(event)
    if TASK.lock('sureCheck_'..event,1) then
        MES.new('info',Text.sureText[event])
    else
        return true
    end
end

local _bgmPlaying,_bgmMode
---@param mode
---| 'full'
---| 'simp'
---| 'base'
---| ''
---| nil
---@param arg string
---| nil
function playBgm(name,mode,arg)
    if bgmList[name][1] then
        PROGRESS.setBgmUnlocked(name,1)
        BGM.play(bgmList[name],arg)
    else
        if mode=='simp' and PROGRESS.getBgmUnlocked(name)==2 then
            mode='base'
        else
            PROGRESS.setBgmUnlocked(name,mode=='simp' and 1 or 2)
        end
        if mode=='simp' then
            BGM.play(bgmList[name].base,arg)
        elseif mode=='base' then
            if not TABLE.compare(BGM.getPlaying(),bgmList[name].full) then
                BGM.play(bgmList[name].full,arg)
                BGM.set(bgmList[name].add,'volume',0,0)
            else
                BGM.set(bgmList[name].add,'volume',0,1)
            end
        else--if mode=='full' then
            BGM.play(bgmList[name].full,arg)
        end
    end
    _bgmPlaying,_bgmMode=name,mode
end
function getBgm()
    return _bgmPlaying,_bgmMode
end

local modeObjMeta={__call=function(self,...)
    local success,errInfo=pcall(GAME.getMode,self.name)
    if success then
        SCN.go('game_in',nil,self.name)
    else
        MES.new('warn',Text.noMode:repD(tostring(self.name),errInfo))
    end
end}
function playMode(name)
    return setmetatable({name=name},modeObjMeta)
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
