return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.dig.vocanics_event_playerInit[6],
            afterClear={
                mechLib.mino.dig.vocanics_event_afterClear['20,6'],
                mechLib.mino.progress.dig_vocanics_afterClear,
            },
            drawOnPlayer=mechLib.mino.dig.event_drawOnPlayer[20],
        },
    }},
}
