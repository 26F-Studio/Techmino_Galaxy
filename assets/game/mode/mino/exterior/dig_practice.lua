return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.dig.practice_event_playerInit[12],
            afterClear=mechLib.mino.dig.practice_event_afterClear,
            gameOver=mechLib.mino.progress.dig_practice_gameOver,
        },
    }},
}
