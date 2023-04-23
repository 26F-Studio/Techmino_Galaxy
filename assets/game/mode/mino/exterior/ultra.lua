return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('sakura','','-noloop')
        BGM.set('all','seek',0)
    end,
    settings={mino={
        event={
            always=mechLib.mino.misc.timeLimit_event_always[120],
            drawOnPlayer=mechLib.mino.misc.timeLimit_event_drawOnPlayer[120],
        },
    }},
}
