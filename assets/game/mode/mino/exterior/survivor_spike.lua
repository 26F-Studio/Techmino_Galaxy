local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        initialRisingSpeed=0,
        risingAcceleration=.0006,
        risingDeceleration=.0002,
        maxRisingSpeed=0.5,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.mino.survivor.event_playerInit,
            always=mechLib.mino.survivor.spike_event_always,
            afterClear=function(P)
                local md=P.modeData
                if md.wave>bgmTransBegin and md.wave<=bgmTransFinish and P.isMain then
                    BGM.set(bgmList['here'].add,'volume',math.min((md.wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            drawOnPlayer=mechLib.mino.survivor.event_drawOnPlayer,
        },
    }},
}
