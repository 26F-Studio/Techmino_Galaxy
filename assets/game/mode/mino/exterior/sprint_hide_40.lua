return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                "P:addEvent('afterClear',mechLib.mino.progress.sprint_hide_40_afterClear)",
            },
            afterSpawn=function(P)
                local pieceCount=MATH.clamp(#P.dropHistory,0,99)
                P.settings.pieceVisTime=math.floor(MATH.interpolate(pieceCount,0,6e3,99,2e3))
                P.settings.pieceFadeTime=math.floor(MATH.interpolate(pieceCount,0,3e3,99,1e3))
            end,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
            },
            gameOver=mechLib.mino.misc.slowHide_event_gameOver,
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
