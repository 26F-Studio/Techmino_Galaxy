local lastTime=setmetatable({},{
    __index=function(self,k)
        self[k]=-1e99
        return self[k]
    end,
})
function sureCheck(event)
    if love.timer.getTime()-lastTime[event]<1 then
        SCN.back()
    else
        MES.new('info',Text.sureText[event])
    end
    lastTime[event]=love.timer.getTime()
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
