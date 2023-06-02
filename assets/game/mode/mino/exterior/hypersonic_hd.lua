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
            playerInit="mechLib.mino.hypersonic.event_playerInit_auto(P,'hidden')",
            afterSpawn=function(P)
                if not P.isMain then return end
                if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 then
                    BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
                end
                if P.isMain then
                    if not P.modeData.hypersonic_bgmTransition1 then
                        if P.modeData.level>=2 then
                            BGM.set('secret7th/melody1','volume',1,26)
                            P.modeData.hypersonic_bgmTransition1=true
                        end
                    end
                    if not P.modeData.hypersonic_bgmTransition2 then
                        if P.modeData.level>=9 then
                            BGM.set(bgmPack('secret7th','m2','a'),'volume',0,26)
                            P.modeData.hypersonic_bgmTransition2=true
                        end
                    end
                end
            end,
        },
    }},
}
