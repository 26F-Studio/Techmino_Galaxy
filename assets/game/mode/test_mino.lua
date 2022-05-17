return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={
        dropDelay=1e99,
        lockDelay=1e99,
        infHold=true,
        readyDelay=1000,
    },
}
