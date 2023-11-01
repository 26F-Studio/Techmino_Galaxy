---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        nextSlot=0,
        holdSlot=0,
        seqType='mess',
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.progress.sprint_mph_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.sprint_mph_40_gameOver,
        },
    }},
}
