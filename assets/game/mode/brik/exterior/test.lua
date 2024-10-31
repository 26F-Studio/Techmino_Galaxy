---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
    end,
    settings={brik={
        dropDelay=1e99,
        lockDelay=1e99,
        infHold=true,
        readyDelay=1000,
        event={
            playerInit={
                "P:setAction('func1',mechLib.brik.stack.switch_auto)",
                function(P)
                    if not PROGRESS.getExteriorUnlock('combo') then
                        P.settings.combo_sound=true
                    end
                end,
            },
            afterLock=mechLib.brik.misc.invincible_event_afterLock,
        },
    }},
}
