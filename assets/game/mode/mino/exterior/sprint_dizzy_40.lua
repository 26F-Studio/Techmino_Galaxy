--- @type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit=   mechLib.mino.misc.swapDirection_event_playerInit,
            afterLock=    mechLib.mino.misc.swapDirection_event_afterLock,
            beforePress=  mechLib.mino.misc.swapDirection_event_key,
            afterPress=   mechLib.mino.misc.swapDirection_event_key,
            beforeRelease=mechLib.mino.misc.swapDirection_event_key,
            afterRelease= mechLib.mino.misc.swapDirection_event_key,
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.progress.sprint_dizzy_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.sprint_dizzy_40_gameOver,
        },
    }},
}
