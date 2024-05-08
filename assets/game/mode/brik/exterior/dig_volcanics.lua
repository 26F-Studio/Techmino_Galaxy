---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.dig.volcanics_event_playerInit[6],
            afterClear={
                mechLib.brik.dig.volcanics_event_afterClear['20,6'],
                mechLib.brik.music.dig_volcanics_afterClear,
            },
            drawOnPlayer=mechLib.brik.dig.event_drawOnPlayer[20],
            gameOver=mechLib.brik.progress.dig_volcanics_gameOver,
        },
    }},
}
