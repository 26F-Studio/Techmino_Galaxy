---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('beat5th')
    end,
    settings={brik={
        seqType='bag8_pentoEZ_p4fromBag10_pentoHD',
        event={
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.music.sprint_pento_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.sprint_pento_40_gameOver,
        },
    }},
}
