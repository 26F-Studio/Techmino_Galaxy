---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.dig.checker_event_playerInit[10],
            afterClear=mechLib.mino.dig.checker_event_afterClear,
            gameOver=mechLib.mino.progress.dig_checker_gameOver,
        },
    }},
}
