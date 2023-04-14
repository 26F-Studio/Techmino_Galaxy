local bgmTransBegin,bgmTransFinish=100,500

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('secret7th','base')
        BGM.set('secret7th/melody1','volume',0,0)
        BGM.set('all','pitch',2^(-1/12),0)
    end,
    settings={mino={
        event={
            playerInit={
                mechLib.mino.hypersonic.event_playerInit,
                mechLib.mino.hypersonic.hidden_event_playerInit,
            },
            always=mechLib.mino.hypersonic.hidden_event_always,
            afterSpawn={
                mechLib.mino.hypersonic.event_afterSpawn,
                function(P)
                    if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 and P.isMain then
                        BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
                    end
                end
            },
            afterClear=mechLib.mino.hypersonic.hidden_event_afterClear,
            drawOnPlayer=mechLib.mino.hypersonic.hidden_event_drawOnPlayer,
        },
    }},
}
