---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        event={
            afterClear={
                mechLib.brik.sprint.event_afterClear[200],
                mechLib.brik.music.sprint_200_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[200],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[200],
            gameOver=mechLib.brik.progress.sprint_200_gameOver,
        },
    }},
}
