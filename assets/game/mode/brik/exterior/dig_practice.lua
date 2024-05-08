---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.dig.practice_event_playerInit[12],
            afterClear=mechLib.brik.dig.practice_event_afterClear,
            gameOver=mechLib.brik.progress.dig_practice_gameOver,
        },
    }},
}
