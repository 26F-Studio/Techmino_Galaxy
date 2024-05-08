---@type Techmino.Mech.gela
local stat={}

function stat.event_playerInit(P) -- Initially used in gelaPlayer.lua
    P.modeData.stat={
        key=0,
        spawn=0,
        piece=0,
        line=0,
        clearTime=0,
        allclear=0,
    }
    P:addEvent('afterPress',stat.event_afterPress)
    P:addEvent('afterResetPos',stat.event_afterResetPos)
    P:addEvent('afterLock',stat.event_afterLock)
    P:addEvent('afterClear',stat.event_afterClear)
end

function stat.event_afterPress(P)
    local S=P.modeData.stat
    S.key=S.key+1
end

function stat.event_afterResetPos(P)
    local S=P.modeData.stat
    S.spawn=S.spawn+1
end

function stat.event_afterLock(P)
    local S=P.modeData.stat
    S.piece=S.piece+1
end

function stat.event_afterClear(P)
    local S=P.modeData.stat
    S.clearTime=S.clearTime+1
    if P.field:getHeight()==0 then
        S.allclear=S.allclear+1
    end
end

-- Highest priority for all statistics events
for k,v in next,stat do stat[k]={-1,v} end

return stat
