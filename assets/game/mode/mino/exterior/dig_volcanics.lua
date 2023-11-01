---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.dig.volcanics_event_playerInit[6],
            afterClear={
                mechLib.mino.dig.volcanics_event_afterClear['20,6'],
                mechLib.mino.progress.dig_volcanics_afterClear,
            },
            drawOnPlayer=mechLib.mino.dig.event_drawOnPlayer[20],
            gameOver=mechLib.mino.progress.dig_volcanics_gameOver,
        },
    }},
}
