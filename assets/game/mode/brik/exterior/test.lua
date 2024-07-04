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
            afterLock=mechLib.brik.misc.invincible_event_afterLock,
        },
    }},
}
