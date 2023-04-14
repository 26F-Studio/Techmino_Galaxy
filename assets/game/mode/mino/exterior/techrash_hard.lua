local bgmTransBegin,bgmTransFinish=4,10

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.techrashChallenge.hard_event_playerInit,
            always=mechLib.mino.techrashChallenge.hard_event_always,
            afterClear={
                mechLib.mino.techrashChallenge.hard_event_afterClear,
                function(P)
                    if P.modeData.techrash>bgmTransBegin and P.modeData.techrash<=bgmTransFinish and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.techrash-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawBelowMarks=mechLib.mino.techrashChallenge.hard_event_drawBelowMarks,
            drawOnPlayer=mechLib.mino.techrashChallenge.hard_event_drawOnPlayer,
        },
    }},
}
