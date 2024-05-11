---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('echo')
    end,
    settings={brik={
        atkSys='nextgen',
        allowCancel=true,
        allowBlock=true,
        event={
            beforeCancel=mechLib.brik.backfire.storePower_event_beforeCancel,
            beforeSend=mechLib.brik.backfire.normal_event_beforeSend,
            afterClear={
                mechLib.brik.sprint.event_afterClear[100],
                mechLib.brik.music.backfire_100_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[100],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[100],
            gameOver=mechLib.brik.progress.backfire_100_gameOver,
        },
    }},
}
