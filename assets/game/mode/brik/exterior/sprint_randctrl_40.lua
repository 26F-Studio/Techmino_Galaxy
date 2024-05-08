---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.misc.randomPress_event_playerInit,
            beforePress=mechLib.brik.misc.randomPress_event_beforePress,
            always=mechLib.brik.misc.randomPress_event_always,
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.music.sprint_randctrl_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.sprint_randctrl_40_gameOver,
        },
    }},
}
