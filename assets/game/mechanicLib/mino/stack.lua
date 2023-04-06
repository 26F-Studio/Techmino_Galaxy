local stack={}

function stack.switch(P)
    if not P.modeData.inZone then
        P.modeData.inZone=true
        P.settings.clearFullLine=false
        BGM.set('all','highgain',.626,.26)
    else
        P.modeData.inZone=false
        P.settings.clearFullLine=true
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
