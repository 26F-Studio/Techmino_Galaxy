-- Music Progress: set volume of music tracks
-- Game Progress: unlock new game mode, needs check P.isMain

--- @type Techmino.Mech.mino
local progress={}

do-- sprint_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        P.modeData.maxHeight=math.max(P.modeData.maxHeight or 0,P.field:getHeight())
        if P.finished then
            if P.gameTime<=86 then
                PROGRESS.setMinoModeUnlocked('sprint_hide_40')
            end
            if P.modeData.maxHeight<=8 then
                PROGRESS.setMinoModeUnlocked('sprint_10')
            end
            PROGRESS.setMinoModeUnlocked('sprint_big_80')
        end
    end
end

do-- sprint_10
    function progress.sprint_10_afterClear(P,clear)
        if not P.isMain then return true end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_obstacle_20')
        end
    end
end

do-- sprint_200
    local bgmTransBegin,bgmTransFinish=100,150
    function progress.sprint_200_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_1000')
        end
    end
end

do-- sprint_1000
    local bgmTransBegin,bgmTransFinish=750,900
    function progress.sprint_1000_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_obstacle_20
    local bgmTransBegin,bgmTransFinish=5,15
    function progress.sprint_obstacle_20_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_drought_40')
        end
    end
end

do-- sprint_drought_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_drought_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_flood_40')
            PROGRESS.setMinoModeUnlocked('sprint_mph_40')
        end
    end
end

do-- sprint_flood_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_flood_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_pento_40')
        end
    end
end

do-- sprint_mph_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_mph_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_pento_40')
        end
    end
end

do-- sprint_hide_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_hide_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_invis_40')
        end
    end
end

do-- sprint_invis_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_invis_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_blind_40')
        end
    end
end

do-- sprint_blind_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_blind_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_big_80
    local bgmTransBegin,bgmTransFinish=40,60
    function progress.sprint_big_80_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_small_20')
            PROGRESS.setMinoModeUnlocked('sprint_low_40')
        end
    end
end

do-- sprint_low_40
    local bgmTransBegin,bgmTransFinish=40,60
    function progress.sprint_low_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_float_40')
        end
    end
end

do-- sprint_low_40
    local bgmTransBegin,bgmTransFinish=40,60
    function progress.sprint_float_40_afterClear(P,clear)
        if not P.isMain then return true end
        if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

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
