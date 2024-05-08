---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        event={
            afterSpawn=function(P)
                local pieceCount=MATH.clamp(#P.dropHistory,0,99)
                P.settings.pieceVisTime=math.floor(MATH.interpolate(0,6e3,99,2e3,pieceCount))
                P.settings.pieceFadeTime=math.floor(MATH.interpolate(0,3e3,99,1e3,pieceCount))
            end,
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.music.sprint_hide_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver={
                mechLib.brik.misc.slowHide_event_gameOver,
                mechLib.brik.progress.sprint_hide_40_gameOver,
            },
        },
    }},
}
