---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.misc.obstacle_event_playerInit,
            afterClear={
                mechLib.brik.misc.obstacle_event_afterClear[20],
                mechLib.brik.music.sprint_obstacle_20_afterClear,
            },
            drawOnPlayer=mechLib.brik.misc.obstacle_event_drawOnPlayer[20],
            gameOver=mechLib.brik.progress.sprint_obstacle_20_gameOver,
        },
    }},
}
