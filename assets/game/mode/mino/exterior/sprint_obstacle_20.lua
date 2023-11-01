---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.misc.obstacle_event_playerInit,
            afterClear={
                mechLib.mino.misc.obstacle_event_afterClear[20],
                mechLib.mino.progress.sprint_obstacle_20_afterClear,
            },
            drawOnPlayer=mechLib.mino.misc.obstacle_event_drawOnPlayer[20],
            gameOver=mechLib.mino.progress.sprint_obstacle_20_gameOver,
        },
    }},
}
