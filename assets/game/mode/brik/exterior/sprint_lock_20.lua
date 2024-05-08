---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        dropDelay=1200,
        event={
            playerInit=mechLib.brik.misc.noRotate_event_playerInit,
            afterClear={
                mechLib.brik.sprint.event_afterClear[20],
                mechLib.brik.music.sprint_lock_20_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[20],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[20],
            gameOver=mechLib.brik.progress.sprint_lock_20_gameOver,
        },
    }},
}
