--- @type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        dropDelay=1200,
        event={
            playerInit=mechLib.mino.misc.noRotate_event_playerInit,
            afterClear={
                mechLib.mino.sprint.event_afterClear[20],
                mechLib.mino.progress.sprint_lock_20_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[20],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[20],
            gameOver=mechLib.mino.progress.sprint_lock_20_gameOver,
        },
    }},
}
