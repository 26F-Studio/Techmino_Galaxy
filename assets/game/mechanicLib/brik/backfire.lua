---@type Techmino.Mech.brik
local backfire={}

function backfire.storePower_event_beforeCancel(P,atk)
    P.modeData._currentPower=atk.power
end

function backfire.triplePower_event_beforeCancel(_,atk)
    atk.power=atk.power*3
end

function backfire.easy_event_beforeSend(P,atk) -- Send nerfed attack (when cancelling) to self
    P:receive(atk)
end

function backfire.normal_event_beforeSend(P,atk) -- Recover attack's original power if exist after cancelling, then send it to self
    atk.power,P.modeData._currentPower=P.modeData._currentPower
    P:receive(atk)
end

function backfire.break_event_beforeSend(P,atk) -- Recover power Like "normal" one, but break it into small attacks
    local powerList={}
    local section=0
    for i=1,P.modeData._currentPower do
        section=section+1
        if P:random()<.5 or i==P.modeData._currentPower then
            table.insert(powerList,section)
            section=0
        end
    end
    for i=1,#powerList do
        atk.power=powerList[i]
        P:receive(atk)
    end
    P.modeData._currentPower=nil
end

return backfire
