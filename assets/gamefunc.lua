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