local stat={}

function stat.event_playerInit(P)
    P.modeData.line=0
end

function stat.event_afterClear(P,clear)
    P.modeData.line=P.modeData.line+clear.line
end

return stat
