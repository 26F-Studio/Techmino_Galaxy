---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        dropDelay=1e99,
        lockDelay=1e99,
        readyDelay=1000,
        deathDelay=0,
        event={
            afterLock=mechLib.mino.misc.invincible_event_afterLock,
        },
    }},
}
