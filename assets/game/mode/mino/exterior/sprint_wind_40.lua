local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        dropDelay=20,
        lockDelay=2600,
        das=126,
        arr=26,
        freshCount=1e99,
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                mechLib.mino.misc.wind_event_playerInit,
            },
            always=mechLib.mino.misc.wind_event_always,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.misc.wind_event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField={
                mechLib.mino.sprint.event_drawInField[40],
                mechLib.mino.misc.wind_event_drawInField,
            },
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
