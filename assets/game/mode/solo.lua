return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.newPlayer(2,'mino')
        GAME.setMain(1)
        playBgm('battle','-base')
    end,
    settings={
        dropDelay=1000,
        lockDelay=1000,
        atkSys='Modern',
    },
    checkFinish=function()
        return #GAME.playerList==1
    end,
}
