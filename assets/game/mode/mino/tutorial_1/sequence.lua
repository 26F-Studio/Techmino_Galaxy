return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        readyDelay=1000,
        dropDelay=1e99,
        lockDelay=1e99,
        holdSlot=0,
    }},
}
