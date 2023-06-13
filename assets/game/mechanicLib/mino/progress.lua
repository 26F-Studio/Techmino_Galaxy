-- Music Progress: set volume of music tracks
-- Game Progress: unlock new game mode, needs check P.isMain

--- @type Techmino.Mech.mino
local progress={}

do-- sprint_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        P.modeData.maxHeight=math.max(P.modeData.maxHeight or 0,P.field:getHeight())
        if P.finished then
            if P.gameTime<=86e3 then
                PROGRESS.setMinoModeUnlocked('sprint_hide_40')
            end
            if P.modeData.maxHeight<=8 then
                PROGRESS.setMinoModeUnlocked('sprint_10')
            end
            if #P.dropHistory<110 then
                PROGRESS.setMinoModeUnlocked('sprint_big_80')
            end
        end
    end
end

do-- sprint_10
    function progress.sprint_10_afterClear(P,clear)
        if not P.isMain then return true end
        if P.finished and #P.dropHistory<30 then
            PROGRESS.setMinoModeUnlocked('sprint_obstacle_20')
        end
    end
end

do-- sprint_200
    local bgmTransP1,bgmTransP2=100,150
    function progress.sprint_200_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_1000')
        end
    end
end

do-- sprint_1000
    local bgmTransP1,bgmTransP2=750,900
    function progress.sprint_1000_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- sprint_obstacle_20
    local bgmTransP1,bgmTransP2=5,15
    function progress.sprint_obstacle_20_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_drought_40')
        end
    end
end

do-- sprint_drought_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_drought_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_flood_40')
            PROGRESS.setMinoModeUnlocked('sprint_mph_40')
        end
    end
end

do-- sprint_flood_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_flood_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_pento_40')
        end
    end
end

do-- sprint_pento_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_pento_40_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['beat5th'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_sym_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_sym_40_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_mph_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_mph_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_fix_20')
            PROGRESS.setMinoModeUnlocked('sprint_lock_20')
        end
    end
end

do-- sprint_wind_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_wind_40_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_fix_20
    local bgmTransBegin,bgmTransFinish=5,15
    function progress.sprint_fix_20_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_lock_20
    local bgmTransBegin,bgmTransFinish=5,15
    function progress.sprint_lock_20_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_hide_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_hide_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished and #P.dropHistory<110 then
            PROGRESS.setMinoModeUnlocked('sprint_invis_40')
        end
    end
end

do-- sprint_invis_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_invis_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        -- if P.finished and #P.dropHistory<110 then
        --     PROGRESS.setMinoModeUnlocked('sprint_blind_40')
        -- end
    end
end

do-- sprint_blind_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_blind_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- sprint_big_80
    local bgmTransP1,bgmTransP2=40,60
    function progress.sprint_big_80_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_small_20')
            PROGRESS.setMinoModeUnlocked('sprint_low_40')
        end
    end
end

do-- sprint_small_20
    local bgmTransBegin,bgmTransFinish=5,15
    function progress.sprint_small_20_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_low_40
    local bgmTransP1,bgmTransP2=40,60
    function progress.sprint_low_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.finished then
            PROGRESS.setMinoModeUnlocked('sprint_float_40')
        end
    end
end

do-- sprint_float_40
    local bgmTransP1,bgmTransP2=40,60
    function progress.sprint_float_40_afterClear(P,clear)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- sprint_randctrl_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_randctrl_40_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_flip_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_flip_40_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- sprint_dizzy_40
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.sprint_dizzy_40_afterClear(P)
        if P.modeData.stat.line>bgmTransBegin and P.modeData.stat.line<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

function progress.marathon_afterClear(P,clear)
    local md=P.modeData
    if not md.marathon_lastLevel then md.marathon_lastLevel=1 end
    if md.level>md.marathon_lastLevel then
        if md.marathon_lastLevel<15 then
            BGM.set(bgmPack('propel','a1','a3','b3'),'volume',math.min(md.level/15,1)^2)
        end
        if md.level>=22 then
            BGM.set('propel/drum','volume',math.min(.2+(md.level-20)*.8,1),6.26)
            if P.isMain then
                PROGRESS.setMinoModeUnlocked('hypersonic_lo')
            end
        end
        if md.level>=25 and md.marathon_lastLevel<25 then
            BGM.set(bgmPack('propel','a1','a3'),'volume',0,26)
        end
        md.marathon_lastLevel=md.level
    end
    if P.isMain and clear.line>=4 then
        md.marathon_techrash=(md.marathon_techrash or 0)+math.floor(clear.line/4)
        if md.marathon_techrash==16 then
            PROGRESS.setMinoModeUnlocked('techrash_easy')
        end
    end
end

do-- techrash_easy
    local bgmTransBegin,bgmTransFinish=4,10
    function progress.techrash_easy_afterClear(P)
        if P.modeData.techrash>bgmTransBegin and P.modeData.techrash<=bgmTransFinish and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.techrash-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- techrash_hard
    local bgmTransBegin,bgmTransFinish=4,10
    function progress.techrash_hard_afterClear(P)
        if P.modeData.techrash>bgmTransBegin and P.modeData.techrash<=bgmTransFinish and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.techrash-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- hypersonic_lo
    local bgmTransP1,bgmTransP2=100,300
    function progress.hypersonic_lo_afterSpawn(P)
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret8th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
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
    local bgmTransP1,bgmTransP2=100,500
    function progress.hypersonic_hi_afterSpawn(P)
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
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

do-- hypersonic_hd
    local bgmTransBegin,bgmTransFinish=100,500
    function progress.hypersonic_hd_afterSpawn(P)
        if not P.isMain then return end
        if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
        end
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
end

do-- combo_practice
    local bgmTransBegin,bgmTransFinish=50,100
    function progress.combo_practice_beforeDiscard(P)
        if P.modeData.comboCount>bgmTransBegin and P.modeData.comboCount<=bgmTransFinish and P.isMain then
            BGM.set(bgmList['oxygen'].add,'volume',math.min((P.modeData.comboCount-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- dig_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.dig_40_afterClear(P)
        local pt=P.modeData.stat.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- dig_100
    local bgmTransP1,bgmTransP2=50,75
    function progress.dig_100_afterClear(P)
        local pt=P.modeData.stat.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- dig_400
    local bgmTransP1,bgmTransP2=200,300
    function progress.dig_400_afterClear(P)
        local pt=P.modeData.stat.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- dig_shale
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.dig_shale_afterClear(P)
        if P.modeData.stat.lineDig>bgmTransBegin and P.modeData.stat.lineDig<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.stat.lineDig-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- dig_vocanics
    local bgmTransBegin,bgmTransFinish=0,10
    function progress.dig_vocanics_afterClear(P)
        if P.modeData.stat.lineDig>bgmTransBegin and P.modeData.stat.lineDig<bgmTransFinish+4 and P.isMain then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.stat.lineDig-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- survivor_b2b
    local bgmTransBegin,bgmTransFinish=20,50
    function progress.survivor_b2b_afterClear(P)
        if P.modeData.wave>bgmTransBegin and P.modeData.wave<=bgmTransFinish and P.isMain then
            BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- survivor_cheese
    local bgmTransBegin,bgmTransFinish=30,80
    function progress.survivor_cheese_afterClear(P)
        if P.modeData.wave>bgmTransBegin and P.modeData.wave<=bgmTransFinish and P.isMain then
            BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- survivor_spike
    local bgmTransBegin,bgmTransFinish=10,30
    function progress.survivor_spike_afterClear(P)
        if P.modeData.wave>bgmTransBegin and P.modeData.wave<=bgmTransFinish and P.isMain then
            BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
        end
    end
end

do-- backfire_100
    local bgmTransP1,bgmTransP2=40,75
    function progress.backfire_100_afterClear(P)
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- backfire_amplify_100
    local bgmTransP1,bgmTransP2=40,75
    function progress.backfire_amplify_100_afterClear(P)
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do-- backfire_cheese_100
    local bgmTransP1,bgmTransP2=40,75
    function progress.backfire_cheese_100_afterClear(P)
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 and P.isMain then
            BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

return progress
