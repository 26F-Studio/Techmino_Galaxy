return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[200],
                mechLib.mino.progress.sprint_200_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[200],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[200],
            gameOver=mechLib.mino.progress.sprint_200_gameOver,
        },
    }},
}