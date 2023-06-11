local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.statistics.event_playerInit,
            afterSpawn=function(P)
                local pieceCount=MATH.clamp(#P.dropHistory,0,99)
                P.settings.pieceVisTime=math.floor(MATH.interpolate(pieceCount,0,6e3,99,2e3))
                P.settings.pieceFadeTime=math.floor(MATH.interpolate(pieceCount,0,3e3,99,1e3))
            end,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            gameOver=mechLib.mino.misc.slowHide_event_gameOver,
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
