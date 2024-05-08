---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        pieceVisTime=260,
        pieceFadeTime=260,
        event={
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.progress.sprint_invis_40_afterClear,
                mechLib.brik.music.sprint_invis_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver={
                mechLib.brik.misc.fastHide_event_gameOver,
                mechLib.brik.progress.sprint_invis_40_gameOver,
            },
        },
    }},
}
