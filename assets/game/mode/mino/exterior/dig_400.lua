local bgmTransBegin,bgmTransFinish=200,300

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
                mechLib.mino.dig.sprint_event_afterClear['400,10'],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[400],
        },
    }},
}
