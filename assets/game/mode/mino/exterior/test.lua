return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        dropDelay=1e99,
        lockDelay=1e99,
        infHold=true,
        readyDelay=1000,
        event={
            afterLock=mechLib.mino.misc.invincible_event_afterLock,
        },
    }},
}
