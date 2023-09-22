--- @type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        pieceVisTime=260,
        pieceFadeTime=260,
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.progress.sprint_invis_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver={
                mechLib.mino.misc.fastHide_event_gameOver,
                mechLib.mino.progress.sprint_invis_40_gameOver,
            },
        },
    }},
}
