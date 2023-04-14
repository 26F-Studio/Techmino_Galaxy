local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                mechLib.mino.misc.swapDirection_event_playerInit,
            },
            afterLock=    mechLib.mino.misc.swapDirection_event_afterLock,
            beforePress=  mechLib.mino.misc.swapDirection_event_key,
            afterPress=   mechLib.mino.misc.swapDirection_event_key,
            beforeRelease=mechLib.mino.misc.swapDirection_event_key,
            afterRelease= mechLib.mino.misc.swapDirection_event_key,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
