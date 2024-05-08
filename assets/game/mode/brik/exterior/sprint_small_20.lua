---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        fieldW=15,
        spawnH=30,
        event={
            afterClear={
                mechLib.brik.sprint.event_afterClear[20],
                mechLib.brik.music.sprint_small_20_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[20],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[20],
            gameOver=mechLib.brik.progress.sprint_small_20_gameOver,
        },
    }},
}
