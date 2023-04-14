local bgmTransBegin,bgmTransFinish=4,10

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        seqType=mechLib.mino.techrashChallenge.easy_seqType,
        event={
            playerInit=mechLib.mino.techrashChallenge.easy_event_playerInit,
            afterLock=mechLib.mino.techrashChallenge.easy_event_afterLock,
            afterClear={
                mechLib.mino.techrashChallenge.easy_event_afterClear,
                function(P)
                    if P.modeData.techrash>bgmTransBegin and P.modeData.techrash<=bgmTransFinish and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.techrash-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.techrashChallenge.easy_event_drawInField,
            drawOnPlayer=mechLib.mino.techrashChallenge.easy_event_drawOnPlayer,
        },
    }},
}
