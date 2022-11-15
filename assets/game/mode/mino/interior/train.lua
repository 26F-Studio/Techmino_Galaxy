return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_interior',
        dropDelay=1e99,
        lockDelay=1e99,
        infHold=true,
        soundEvent={
            countDown=function(num)
                SFX.playSample('lead',num>0 and 'A3' or 'A4')
            end,
        },
        event={
            -- TODO: display ghost at not-bad places to help new players learn stacking
        },
    }},
}
