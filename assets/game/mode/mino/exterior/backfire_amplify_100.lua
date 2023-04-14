local bgmTransBegin,bgmTransFinish=50,75

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('echo','base')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        clearStuck=true,
        event={
            playerInit=mechLib.mino.statistics.event_playerInit,
            beforeCancel=mechLib.mino.backfire.triplePower_event_beforeCancel,
            beforeSend=mechLib.mino.backfire.easy_event_beforeSend,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[100],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[100],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[100],
        },
    }},
}
