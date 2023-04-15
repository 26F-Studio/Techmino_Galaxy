local bgmTransBegin,bgmTransFinish=50,75

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
                mechLib.mino.dig.sprint_event_afterClear['100,10'],
                function(P)
                    if P.modeData.lineDig>bgmTransBegin and P.modeData.lineDig<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.lineDig-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawOnPlayer=mechLib.mino.dig.event_drawOnPlayer[100],
        },
    }},
}
