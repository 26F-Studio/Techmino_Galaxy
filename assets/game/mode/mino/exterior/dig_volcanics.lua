local bgmTransBegin,bgmTransFinish=0,10

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
                function(P)
                    if P.modeData.lineDig>bgmTransBegin and P.modeData.lineDig<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.lineDig-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end
            },
            drawOnPlayer=mechLib.mino.dig.event_drawOnPlayer[20],
        },
    }},
}
