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
---| nil
function playBgm(name,mode)
    if bgmList[name][1] then
        BGM.play(bgmList[name],mode)
    else
        if mode=='simp' then
            BGM.play(bgmList[name].base,mode)
        elseif mode=='base' then
            if not TABLE.compare(BGM.getPlaying(),bgmList[name].full) then
                BGM.play(bgmList[name].full,mode)
                BGM.set(bgmList[name].add,'volume',0,0)
            else
                BGM.set(bgmList[name].add,'volume',0,1)
            end
        elseif mode=='full' or true then
            BGM.play(bgmList[name].full,mode)
        end
    end
    _bgmPlaying,_bgmMode=name,mode
end
function getBgm()
    return _bgmPlaying,_bgmMode
end

local modeObjMeta={__call=function(self,...) SCN.go('game_simp',nil,self.name) end}
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
