return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        readyDelay=0,
        dropDelay=1e99,
        lockDelay=1e99,
        das=1e99,
        holdSlot=0,
        nextSlot=0,
    }},
}
