local bgmTransBegin,bgmTransFinish=40,60

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        fieldW=6,
        spawnH=12,
        event={
            playerInit=mechLib.mino.statistics.event_playerInit,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[80],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[80],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[80],
        },
    }},
}
