local lastBackTime=-1e99
function tryBack()
    if love.timer.getTime()-lastBackTime<1 then
        SCN.back()
    else
        MES.new('info',"Press again to quit")
    end
    lastBackTime=love.timer.getTime()
end

local lastResetTime=-1e99
function tryReset()
    if love.timer.getTime()-lastResetTime<1 then
        return true
    else
        MES.new('info',"Press again to reset")
    end
    lastResetTime=love.timer.getTime()
end

function playBgm(name,args)
    if bgmList[name][1] then
        BGM.play(bgmList[name],args)
    else
        if not args then args='-full' end
        if args:sArg('-simp') then
            BGM.play(bgmList[name].base,args)
        elseif args:sArg('-base') then
            if not TABLE.compare(BGM.getPlaying(),bgmList[name].full) then
                BGM.play(bgmList[name].full,args)
                BGM.set(bgmList[name].add,'volume',0,0)
            else
                BGM.set(bgmList[name].add,'volume',0,1)
            end
        elseif args:sArg('-full') then
            BGM.play(bgmList[name].full,args)
        end
    end
end

function saveSettings()
    FILE.save({
        system=SETTINGS._system,
        game=SETTINGS.game,
    },'conf/settings','-json')
end

function saveKey()
    local M={}
    for i=1,#KEYMAP do
        M[i]=KEYMAP[i].keys
    end
    FILE.save(M,'conf/keymap','-json')
end

function saveTouch()
    FILE.save(VCTRL.exportSettings(),'conf/touch','-json')
end
