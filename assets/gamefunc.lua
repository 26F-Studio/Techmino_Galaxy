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
        BGM.play(bgmList[name])
    else
        if args:sArg('-simp') then
            BGM.play(bgmList[name].base)
        elseif args:sArg('-base') then
            if not TABLE.compare(BGM.getPlaying(),bgmList[name].full) then
                BGM.play(bgmList[name].full)
                BGM.set(bgmList[name].add,'volume',0,0)
            else
                BGM.set(bgmList[name].add,'volume',0,1)
            end
        elseif args:sArg('-full') then
            BGM.play(bgmList[name].full)
        else
            error("Wrong bgm args: "..tostring(args))
        end
    end
end

function saveSetting()
    FILE.save({
        system=SETTINGS._system,
        game=SETTINGS.game,
    },'conf/settings','-json')
end
