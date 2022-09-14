return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_simp',
        shakeness=0,
        readyDelay=1000,
        dropDelay=1e99,
        lockDelay=1e99,
        deathDelay=0,
        seqType='none',
    }},
}
