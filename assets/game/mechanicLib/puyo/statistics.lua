---@type Techmino.Mech.puyo
local stat={}

function stat.event_playerInit(P) -- Initially used in puyoPlayer.lua
    -- P.modeData.stat={
    --     key=0,
    --     spawn=0,
    --     piece=0,
    --     line=0,
    --     clearTime=0,
    --     clears={0,0,0,0},
    --     allclear=0,
    --     atk=0,
    --     sent=0,
    -- }
    -- P:addEvent('afterPress',stat.event_afterPress)
    -- P:addEvent('afterResetPos',stat.event_afterResetPos)
    -- P:addEvent('afterLock',stat.event_afterLock)
    -- P:addEvent('afterClear',stat.event_afterClear)
    -- P:addEvent('beforeCancel',stat.event_beforeCancel)
    -- P:addEvent('beforeSend',stat.event_beforeSend)
end

return stat
