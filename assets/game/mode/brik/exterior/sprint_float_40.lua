---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        clearRule='line_float',
        event={
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.music.sprint_float_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.sprint_float_40_gameOver,
        },
    }},
}
