return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('sakura','','-noloop')
        BGM.set('all','seek',0)
    end,
    settings={mino={
        event={
            playerInit="mechLib.mino.misc.timer_new(P,120e3,mechLib.mino.misc.finish_TLE,'info')",
        },
    }},
}
