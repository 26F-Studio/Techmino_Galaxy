--- @type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[1000],
                mechLib.mino.progress.sprint_1000_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[1000],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[1000],
            gameOver=mechLib.mino.progress.sprint_1000_gameOver,
        },
    }},
}
