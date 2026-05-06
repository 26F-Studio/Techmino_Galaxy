---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        dropDelay=1e99,
        lockDelay=1e99,
        readyDelay=1000,
        deathDelay=0,
        event={
            afterLock=mechLib.brik.misc.invincible_event_afterLock,
        },
    }},
}
