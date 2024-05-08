---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        fieldW=6,
        spawnH=12,
        event={
            afterClear={
                mechLib.brik.sprint.event_afterClear[80],
                mechLib.brik.music.sprint_big_80_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[80],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[80],
            gameOver=mechLib.brik.progress.sprint_big_80_gameOver,
        },
    }},
}
