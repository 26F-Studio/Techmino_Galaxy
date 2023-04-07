local stack={}

function stack.switch(P)
    if not P.modeData.inZone then
        P.modeData.inZone=true
        P.settings.clearFullLine=false

        -- Switch to 0G
        P.dropTimer=P.dropTimer/P.settings.dropDelay*1e99
        P.lockTimer=P.lockTimer/P.settings.lockDelay*1e99
        P.modeData.zone_dropDelay=P.settings.dropDelay
        P.modeData.zone_lockDelay=P.settings.lockDelay
        P.settings.dropDelay,P.settings.lockDelay=1e99,1e99

        BGM.set('all','highgain',.626,.26)
    else
        P.modeData.inZone=false
        P.settings.clearFullLine=true

        -- Recover gravity
        P.dropTimer=math.floor(P.dropTimer/P.settings.dropDelay*P.modeData.zone_dropDelay)
        P.lockTimer=math.floor(P.lockTimer/P.settings.lockDelay*P.modeData.zone_lockDelay)
        P.settings.dropDelay=P.modeData.zone_dropDelay
        P.settings.lockDelay=P.modeData.zone_lockDelay
        P.modeData.zone_dropDelay,P.modeData.zone_lockDelay=nil,nil

        local lines=P:getFullLines()
        if lines then
            P:clearLines(lines)
            P:freshGhost()
        end
        BGM.set('all','highgain',1,.1)
    end
end

function stack.event_whenSuffocate(P)
    if P.modeData.inZone then
        stack.switch(P,false)
    end
end

return stack
