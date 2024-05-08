---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.dig.sprint_event_playerInit[10],
            afterClear={
                mechLib.brik.dig.sprint_event_afterClear['40,10'],
                mechLib.brik.music.dig_40_afterClear,
            },
            drawOnPlayer=mechLib.brik.dig.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.dig_40_gameOver,
        },
    }},
}
