return {
    initialize=function()
        GAME.newPlayer(1,'puyo')
        GAME.setMain(1)
    end,
    settings={puyo={
        dropDelay=1e99,
        lockDelay=1e99,
        readyDelay=1000,
    }},
}
