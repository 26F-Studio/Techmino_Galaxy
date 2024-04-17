---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('echo')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        clearStuck=true,
        event={
            beforeCancel=mechLib.mino.backfire.triplePower_event_beforeCancel,
            beforeSend=mechLib.mino.backfire.easy_event_beforeSend,
            afterClear={
                mechLib.mino.sprint.event_afterClear[100],
                mechLib.mino.music.backfire_amplify_100_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[100],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[100],
            gameOver=mechLib.mino.progress.backfire_amplify_100_gameOver,
        },
    }},
}
