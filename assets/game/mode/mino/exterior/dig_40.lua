return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.dig.sprint_event_playerInit[10],
            afterClear={
                mechLib.mino.dig.sprint_event_afterClear['40,10'],
                mechLib.mino.progress.dig_40_afterClear,
            },
            drawOnPlayer=mechLib.mino.dig.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.dig_40_gameOver,
        },
    }},
}
