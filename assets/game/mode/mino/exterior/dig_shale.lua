return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.dig.shale_event_playerInit[8],
            afterClear={
                mechLib.mino.dig.shale_event_afterClear['40,8'],
                mechLib.mino.progress.dig_shale_40_afterClear,
            },
            drawOnPlayer=mechLib.mino.dig.event_drawOnPlayer[40],
        },
    }},
}
