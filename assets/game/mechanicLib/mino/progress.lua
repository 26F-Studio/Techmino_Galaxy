-- Music Progress: set volume of music tracks
-- Game Progress: unlock new game mode, needs check P.isMain

--- @type Techmino.Mech.mino
local progress={}

function progress.marathon_afterClear(P,clear)
    if not P.modeData.marathon_lastLevel then P.modeData.marathon_lastLevel=1 end
    if P.modeData.level>P.modeData.marathon_lastLevel then
        if P.modeData.marathon_lastLevel<15 then
            BGM.set(bgmPack('propel','a1','a3','b3'),'volume',math.min(P.modeData.level/15,1)^2)
        end
        if P.modeData.level>=22 then
            BGM.set('propel/drum','volume',math.min(.2+(P.modeData.level-20)*.8,1),6.26)
            if P.isMain then
                PROGRESS.setMinoModeUnlocked('hypersonic_lo')
            end
        end
        if P.modeData.level>=25 and P.modeData.marathon_lastLevel<25 then
            BGM.set(bgmPack('propel','a1','a3'),'volume',0,26)
        end
        P.modeData.marathon_lastLevel=P.modeData.level
    end
    if P.isMain and clear.line>=4 then
        P.modeData.marathon_techrash=(P.modeData.marathon_techrash or 0)+math.floor(clear.line/4)
        if P.modeData.marathon_techrash==16 then
            PROGRESS.setMinoModeUnlocked('techrash_easy')
        end
    end
end

do-- hypersonic_lo
    local bgmTransBegin,bgmTransFinish=100,300
    function progress.hypersonic_lo_afterSpawn(P)
        if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 then
            BGM.set(bgmList['secret8th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
        end
    end
    function progress.hypersonic_lo_afterClear(P,clear)
        if not P.isMain then return true end
        if clear.line>=4 then
            P.modeData.hypersonic_lo_techrash=(P.modeData.hypersonic_lo_techrash or 0)+math.floor(clear.line/4)
            if P.modeData.hypersonic_lo_techrash==36 then
                PROGRESS.setMinoModeUnlocked('techrash_hard')
            end
        end
        if P.modeData.point>=500 then
            PROGRESS.setMinoModeUnlocked('hypersonic_hi')
            return true
        end
    end
end

do-- hypersonic_hi
    local bgmTransBegin,bgmTransFinish=100,500
    function progress.hypersonic_hi_afterSpawn(P)
        if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
        end
    end
    function progress.hypersonic_hi_afterClear(P,clear)
        if not P.isMain then return true end
        if clear.line>=4 then
            P.modeData.hypersonic_hi_techrash=(P.modeData.hypersonic_hi_techrash or 0)+math.floor(clear.line/4)
            if P.modeData.hypersonic_hi_techrash==42 then
                PROGRESS.setMinoModeUnlocked('hypersonic_hd')
            end
        end
        if P.modeData.point>=1000 then
            PROGRESS.setMinoModeUnlocked('hypersonic_ti')
            return true
        end
    end
end

return progress
