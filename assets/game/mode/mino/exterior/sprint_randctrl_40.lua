---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.misc.randomPress_event_playerInit,
            beforePress=mechLib.mino.misc.randomPress_event_beforePress,
            always=mechLib.mino.misc.randomPress_event_always,
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.music.sprint_randctrl_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.sprint_randctrl_40_gameOver,
        },
    }},
}
