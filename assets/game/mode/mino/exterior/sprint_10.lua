return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','full')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.statistics.event_playerInit,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[10],
            },
            drawInField=mechLib.mino.sprint.event_drawInField[10],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[10],
        },
    }},
}
