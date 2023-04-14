local bgmTransBegin,bgmTransFinish=5,15

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        dropDelay=1200,
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                mechLib.mino.misc.noRotate_event_playerInit,
            },
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[20],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[20],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[20],
        },
    }},
}
