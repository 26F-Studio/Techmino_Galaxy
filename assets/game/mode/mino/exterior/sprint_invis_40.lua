local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        pieceVisTime=260,
        pieceFadeTime=260,
        event={
            playerInit=mechLib.mino.statistics.event_playerInit,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            gameOver=mechLib.mino.misc.fastHide_event_gameOver,
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
