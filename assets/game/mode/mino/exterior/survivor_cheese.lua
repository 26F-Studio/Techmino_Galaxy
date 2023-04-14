local max,min=math.max,math.min
local bgmTransBegin,bgmTransFinish=30,80

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='basic',
        allowCancel=true,
        clearStuck=false,
        initialRisingSpeed=0,
        risingAcceleration=.003,
        risingDeceleration=.001,
        maxRisingSpeed=1,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.mino.survivor.event_playerInit,
            always=mechLib.mino.survivor.cheese_event_always,
            afterClear=function(P)
                if P.modeData.wave>bgmTransBegin and P.modeData.wave<=bgmTransFinish and P.isMain then
                    BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            drawOnPlayer=mechLib.mino.survivor.event_drawOnPlayer,
        },
    }},
}
