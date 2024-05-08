---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.dig.checker_event_playerInit[10],
            afterClear=mechLib.brik.dig.checker_event_afterClear,
            gameOver=mechLib.brik.progress.dig_checker_gameOver,
        },
    }},
}
