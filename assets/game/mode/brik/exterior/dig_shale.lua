---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.dig.shale_event_playerInit[8],
            afterClear={
                mechLib.brik.dig.shale_event_afterClear['40,8'],
                mechLib.brik.music.dig_shale_afterClear,
            },
            drawOnPlayer=mechLib.brik.dig.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.dig_shale_gameOver,
        },
    }},
}
