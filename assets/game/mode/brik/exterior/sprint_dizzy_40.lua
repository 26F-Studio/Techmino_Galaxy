---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        event={
            playerInit=   mechLib.brik.misc.swapDirection_event_playerInit,
            afterLock=    mechLib.brik.misc.swapDirection_event_afterLock,
            beforePress=  mechLib.brik.misc.swapDirection_event_key,
            afterPress=   mechLib.brik.misc.swapDirection_event_key,
            beforeRelease=mechLib.brik.misc.swapDirection_event_key,
            afterRelease= mechLib.brik.misc.swapDirection_event_key,
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.music.sprint_dizzy_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.sprint_dizzy_40_gameOver,
        },
    }},
}
