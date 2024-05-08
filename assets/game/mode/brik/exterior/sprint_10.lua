---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race',true)
    end,
    settings={brik={
        seqType='bag7_sprint',
        event={
            afterClear=mechLib.brik.sprint.event_afterClear[10],
            drawInField=mechLib.brik.sprint.event_drawInField[10],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[10],
            gameOver=mechLib.brik.progress.sprint_10_gameOver,
        },
    }},
}
