return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_simp',
        shakeness=0,
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=6,
        holdSlot=1,
        deathDelay=0,
        seqType='none',
    }},
}
