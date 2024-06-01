---@type Map<Techmino.Event.Brik>
local stat={}

function stat.event_playerInit(P) -- Directly called in brikPlayer.lua
    ---@class Techmino.Mech.Basic.StatisticTable
    P.modeData.stat={
        key=0,
        spawn=0,
        piece=0,
        line=0,
        clearTime=0,
        clears={0,0,0,0},
        allclear=0,
        atk=0,
        sent=0,
    }
    P:addEvent('afterPress',stat.event_afterPress)
    P:addEvent('afterResetPos',stat.event_afterResetPos)
    P:addEvent('afterLock',stat.event_afterLock)
    P:addEvent('afterClear',stat.event_afterClear)
    P:addEvent('beforeCancel',stat.event_beforeCancel)
    P:addEvent('beforeSend',stat.event_beforeSend)
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

function stat.event_afterClear(P,clear)
    local S=P.modeData.stat
    local line=clear.line
    S.clearTime=S.clearTime+1
    S.line=S.line+line
    if line%1==0 and line>0 then
        S.clears[line]=(S.clears[line] or 0)+1
    end
    if P.field:getHeight()==0 then
        S.allclear=S.allclear+1
    end
end

function stat.event_beforeCancel(P,atk)
    local S=P.modeData.stat
    S.atk=S.atk+atk.power
end

function stat.event_beforeSend(P,atk)
    local S=P.modeData.stat
    S.sent=S.sent+atk.power
end

-- Highest priority for all statistics events
for k,v in next,stat do
    ---@cast v fun(P:Techmino.Player.Brik):any
    stat[k]={-1e99,v}
end

return stat
