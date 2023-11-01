---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('beat5th','base')
    end,
    settings={mino={
        seqType='pento_bag_EZ8plusHD4fromBag10',
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.progress.sprint_pento_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.sprint_pento_40_gameOver,
        },
    }},
}
