local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        pieceVisTime=120,
        pieceFadeTime=120,
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                function(P)
                    P.modeData.coverAlpha=0
                end,
            },
            always=function(P)
                if P.finished then
                    if P.modeData.coverAlpha>2000 then
                        P.modeData.coverAlpha=P.modeData.coverAlpha-1
                    end
                else
                    if P.modeData.coverAlpha<2600 then
                        P.modeData.coverAlpha=P.modeData.coverAlpha+1
                    end
                end
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
            gameOver=function(P)
                P:showInvis()
            end,
            drawInField={
                function(P)
                    GC.setColor(.26,.26,.26,P.modeData.coverAlpha/2600)
                    GC.rectangle('fill',0,0,P.settings.fieldW*40,-P.settings.spawnH*40)
                end,
                mechLib.mino.sprint.event_drawInField[40],
            },
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
