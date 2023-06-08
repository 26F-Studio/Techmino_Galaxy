--- @type Techmino.Mech.mino
local progress={}

function progress.marathon_afterClear(P)
    if not P.modeData.marathon_bgmLevel then P.modeData.marathon_bgmLevel=1 end
    if P.isMain and P.modeData.level>P.modeData.marathon_bgmLevel then
        if P.modeData.marathon_bgmLevel<15 then
            BGM.set(bgmPack('propel','a1','a3','b3'),'volume',math.min(P.modeData.level/15,1)^2)
        end
        if P.modeData.level>=25 and P.modeData.marathon_bgmLevel<25 then
            BGM.set(bgmPack('propel','a1','a3'),'volume',0,26)
        end
        if P.modeData.level>=22 then
            BGM.set('propel/drum','volume',math.min(.2+(P.modeData.level-20)*.8,1),6.26)
            PROGRESS.setMinoModeUnlocked('hypersonic_lo')
        end
        P.modeData.marathon_bgmLevel=P.modeData.level
    end
end

do-- hypersonic_lo
    local bgmTransBegin,bgmTransFinish=100,300
    function progress.hypersonic_lo_afterSpawn(P)
        if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 and P.isMain then
            BGM.set(bgmList['secret8th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
        end
    end
    function progress.hypersonic_lo_afterClear(P)
        if P.modeData.point==500 then
            PROGRESS.setMinoModeUnlocked('hypersonic_hi')
        end
    end
end

do-- hypersonic_hi
    local bgmTransBegin,bgmTransFinish=100,500
    function progress.hypersonic_hi_afterSpawn(P)
        if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 and P.isMain then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
        end
    end
    function progress.hypersonic_hi_afterClear(P,clear)
        if clear.line==4 then
            P.modeData.hypersonic_hi_techrash=(P.modeData.hypersonic_hi_techrash or 0)+1
            if P.modeData.hypersonic_hi_techrash==42 then
                PROGRESS.setMinoModeUnlocked('hypersonic_hd')
            end
        end
        if P.modeData.point==1000 then
            PROGRESS.setMinoModeUnlocked('hypersonic_ti')
            return true
        end
    end
end

return progress
