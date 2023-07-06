-- Music Progress: set volume of music tracks
-- Game Progress: unlock new game mode

--- @type Techmino.Mech.mino
local progress={}

do-- sprint_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        P.modeData.maxHeight=math.max(P.modeData.maxHeight or 0,P.field:getHeight())
    end
    function progress.sprint_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.gameTime<=86e3 then
                PROGRESS.setMinoModeState('sprint_hide_40')
            end
            if P.modeData.maxHeight<=8 then
                PROGRESS.setMinoModeState('sprint_10')
            end
            if P.modeData.stat.piece<110 then
                PROGRESS.setMinoModeState('sprint_big_80')
            end
            PROGRESS.setMinoModeState('sprint_40',1)
        end
    end
end

do-- sprint_10
    function progress.sprint_10_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.modeData.stat.piece<30 then
                PROGRESS.setMinoModeState('sprint_obstacle_20')
            end
            PROGRESS.setMinoModeState('sprint_200')
            PROGRESS.setMinoModeState('sprint_10',1)
        end
    end
end

do-- sprint_200
    local bgmTransP1,bgmTransP2=100,150
    function progress.sprint_200_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_200_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_1000')
            PROGRESS.setMinoModeState('sprint_200',1)
        end
    end
end

do-- sprint_1000
    local bgmTransP1,bgmTransP2=750,900
    function progress.sprint_1000_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_1000_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_1000',1)
        end
    end
end

do-- sprint_obstacle_20
    local bgmTransP1,bgmTransP2=5,15
    function progress.sprint_obstacle_20_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_obstacle_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_drought_40')
            PROGRESS.setMinoModeState('sprint_obstacle_20',1)
        end
    end
end

do-- sprint_drought_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_drought_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_drought_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_flood_40')
            PROGRESS.setMinoModeState('sprint_mph_40')
            PROGRESS.setMinoModeState('sprint_drought_40',1)
        end
    end
end

do-- sprint_flood_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_flood_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_flood_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_pento_40')
            PROGRESS.setMinoModeState('sprint_flood_40',1)
        end
    end
end

do-- sprint_pento_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_pento_40_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['beat5th'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_pento_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_pento_40',1)
        end
    end
end

do-- sprint_sym_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_sym_40_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_sym_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_sym_40',1)
        end
    end
end

do-- sprint_mph_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_mph_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_mph_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_lock_20')
            PROGRESS.setMinoModeState('sprint_mph_40',1)
        end
    end
end

do-- sprint_lock_20
    local bgmTransP1,bgmTransP2=5,15
    function progress.sprint_lock_20_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_lock_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_fix_20')
            PROGRESS.setMinoModeState('sprint_lock_20',1)
        end
    end
end

do-- sprint_fix_20
    local bgmTransP1,bgmTransP2=5,15
    function progress.sprint_fix_20_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_fix_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_fix_20',1)
        end
    end
end

do-- sprint_wind_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_wind_40_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_wind_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_wind_40',1)
        end
    end
end

do-- sprint_delay_20
    local bgmTransP1,bgmTransP2=5,15
    function progress.sprint_delay_20_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_delay_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_delay_20',1)
        end
    end
end

do-- sprint_hide_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_hide_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_hide_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.modeData.stat.piece<110 then
                PROGRESS.setMinoModeState('sprint_invis_40')
            end
            PROGRESS.setMinoModeState('sprint_hide_40',1)
        end
    end
end

do-- sprint_invis_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_invis_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.modeData.stat.clears[4]==10 then
            PROGRESS.setMinoModeState('sprint_blind_40')
        end
    end
    function progress.sprint_invis_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_invis_40',1)
        end
    end
end

do-- sprint_blind_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_blind_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_blind_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_blind_40',1)
        end
    end
end

do-- sprint_big_80
    local bgmTransP1,bgmTransP2=40,60
    function progress.sprint_big_80_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_big_80_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_small_20')
            PROGRESS.setMinoModeState('sprint_low_40')
            PROGRESS.setMinoModeState('sprint_big_80',1)
        end
    end
end

do-- sprint_small_20
    local bgmTransP1,bgmTransP2=5,15
    function progress.sprint_small_20_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_small_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_small_20',1)
        end
    end
end

do-- sprint_low_40
    local bgmTransP1,bgmTransP2=40,60
    function progress.sprint_low_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_low_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_float_40')
            PROGRESS.setMinoModeState('sprint_low_40',1)
        end
    end
end

do-- sprint_float_40
    local bgmTransP1,bgmTransP2=40,60
    function progress.sprint_float_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_float_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_float_40',1)
        end
    end
end

do-- sprint_randctrl_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_randctrl_40_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_randctrl_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_randctrl_40',1)
        end
    end
end

do-- sprint_flip_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_flip_40_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_flip_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.gameTime<=60e3 then
                PROGRESS.setMinoModeState('sprint_dizzy_40')
            end
            PROGRESS.setMinoModeState('sprint_flip_40',1)
        end
    end
end

do-- sprint_dizzy_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.sprint_dizzy_40_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.sprint_dizzy_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('sprint_dizzy_40',1)
        end
    end
end

do-- marathon
    function progress.marathon_afterClear(P)
        if not P.isMain then return true end
        local md=P.modeData
        if not md.marathon_lastLevel then md.marathon_lastLevel=1 end
        if md.level>md.marathon_lastLevel then
            if md.marathon_lastLevel<15 then
                BGM.set(bgmPack('propel','a1','a3','b3'),'volume',math.min(md.level/15,1)^2)
            end
            if md.level>=22 then
                BGM.set('propel/drum','volume',math.min(.2+(md.level-20)*.8,1),6.26)
                PROGRESS.setMinoModeState('hypersonic_lo')
            end
            if md.level>=25 and md.marathon_lastLevel<25 then
                BGM.set(bgmPack('propel','a1','a3'),'volume',0,26)
            end
            md.marathon_lastLevel=md.level
        end
        if md.stat.clears[4]==16 then
            PROGRESS.setMinoModeState('techrash_easy')
        end
    end
    function progress.marathon_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('marathon',1)
        end
    end
end

do-- techrash_easy
    local bgmTransP1,bgmTransP2=4,10
    function progress.techrash_easy_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.techrash>bgmTransP1 and P.modeData.techrash<=bgmTransP2 then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.techrash-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.modeData.stat.clears[4]>=20 then
            PROGRESS.setMinoModeState('techrash_easy',1)
        end
    end
end

do-- hypersonic_lo
    local bgmTransP1,bgmTransP2=100,300
    function progress.hypersonic_lo_afterSpawn(P)
        if not P.isMain then return true end
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret8th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
    end
    function progress.hypersonic_lo_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]==36 then
            PROGRESS.setMinoModeState('techrash_hard')
        end
    end
    function progress.hypersonic_lo_gameOver(P,reason)
        if not P.isMain then return true end
        PROGRESS.setMinoModeState('hypersonic_hi')
        if reason=='AC' then
            PROGRESS.setMinoModeState('hypersonic_lo',1)
        end
    end
end

do-- techrash_hard
    local bgmTransP1,bgmTransP2=4,10
    function progress.techrash_hard_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.techrash>bgmTransP1 and P.modeData.techrash<=bgmTransP2 then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.techrash-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.modeData.stat.clears[4]>=20 then
            PROGRESS.setMinoModeState('techrash_easy',1)
        end
    end
end

do-- hypersonic_hi
    local bgmTransP1,bgmTransP2=100,500
    function progress.hypersonic_hi_afterSpawn(P)
        if not P.isMain then return true end
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
    end
    function progress.hypersonic_hi_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]==42 then
            PROGRESS.setMinoModeState('hypersonic_hd')
        end
    end
    function progress.hypersonic_hi_gameOver(P)
        if not P.isMain then return true end
        if P.modeData.point>=1000 then
            PROGRESS.setMinoModeState('hypersonic_ti')
            PROGRESS.setMinoModeState('hypersonic_hi',1)
        end
    end
end

do-- hypersonic_hd
    local bgmTransP1,bgmTransP2=100,500
    function progress.hypersonic_hd_afterSpawn(P)
        if not P.isMain then return end
        if P.modeData.point>bgmTransP1 and P.modeData.point<bgmTransP2+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
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
    function progress.hypersonic_hd_gameOver(P)
        if P.modeData.point>=1000 then
            PROGRESS.setMinoModeState('hypersonic_hd',1)
        end
    end
end

do-- hypersonic_ti
    local bgmTransP1,bgmTransP2=200,600
    function progress.hypersonic_ti_afterSpawn(P)
        if not P.isMain then return end
        if P.modeData.point>bgmTransP1 and P.modeData.point<bgmTransP2+10 then
            BGM.set(bgmList['distortion'].add,'volume',math.min((P.modeData.point-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
    end
    function progress.hypersonic_ti_gameOver(P)
        if P.modeData.point>=1000 then
            PROGRESS.setMinoModeState('hypersonic_ti',1)
        end
    end
end

do-- combo_practice
    local bgmTransP1,bgmTransP2=50,100
    function progress.combo_practice_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.cleared==12 then
            PROGRESS.setMinoModeState('tsd_easy')
        end
    end
    function progress.combo_practice_beforeDiscard(P)
        if not P.isMain then return true end
        if P.modeData.comboCount>bgmTransP1 and P.modeData.comboCount<=bgmTransP2 then
            BGM.set(bgmList['oxygen'].add,'volume',math.min((P.modeData.comboCount-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.combo_practice_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('combo_practice',1)
        end
    end
end

do-- dig_practice
    function progress.dig_practice_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('dig_shale')
            if P.gameTime<30e3 then
                PROGRESS.setMinoModeState('survivor_b2b')
            end
            if P.modeData.stat.piece<62 then
                PROGRESS.setMinoModeState('dig_40')
            end
            PROGRESS.setMinoModeState('dig_practice',1)
        end
    end
end

do-- dig_shale
    local bgmTransP1,bgmTransP2=10,30
    function progress.dig_shale_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.lineDig>bgmTransP1 and P.modeData.lineDig<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.lineDig-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.dig_shale_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('dig_volcanics')
            PROGRESS.setMinoModeState('dig_shale',1)
        end
    end
end

do-- dig_volcanics
    local bgmTransP1,bgmTransP2=0,10
    function progress.dig_volcanics_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.lineDig>bgmTransP1 and P.modeData.lineDig<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.lineDig-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.dig_volcanics_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('dig_volcanics',1)
        end
    end
end

function progress.dig_checkers_gameOver(P,reason)
    if not P.isMain then return true end
    if reason=='AC' then
        PROGRESS.setMinoModeState('dig_checkers',1)
    end
end

do-- dig_40
    local bgmTransP1,bgmTransP2=10,30
    function progress.dig_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.dig_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('dig_100')
            PROGRESS.setMinoModeState('dig_40',1)
        end
    end
end

do-- dig_100
    local bgmTransP1,bgmTransP2=50,75
    function progress.dig_100_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.dig_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('dig_400')
            PROGRESS.setMinoModeState('dig_100',1)
        end
    end
end

do-- dig_400
    local bgmTransP1,bgmTransP2=200,300
    function progress.dig_400_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.dig_400_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('dig_400',1)
        end
    end
end

do-- survivor_b2b
    local bgmTransP1,bgmTransP2=20,50
    function progress.survivor_b2b_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.wave>bgmTransP1 and P.modeData.wave<=bgmTransP2 then
            BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.modeData.wave==42 then
            PROGRESS.setMinoModeState('backfire_100')
            PROGRESS.setMinoModeState('survivor_cheese')
            PROGRESS.setMinoModeState('survivor_b2b',1)
        end
    end
end

do-- survivor_cheese
    local bgmTransP1,bgmTransP2=30,80
    function progress.survivor_cheese_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.wave>bgmTransP1 and P.modeData.wave<=bgmTransP2 then
            BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.modeData.wave==62 then
            PROGRESS.setMinoModeState('survivor_spike')
            PROGRESS.setMinoModeState('sprint_randctrl_40',1)
        end
    end
end

do-- survivor_spike
    local bgmTransP1,bgmTransP2=10,30
    function progress.survivor_spike_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.wave>bgmTransP1 and P.modeData.wave<=bgmTransP2 then
            BGM.set(bgmList['here'].add,'volume',math.min((P.modeData.wave-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
        if P.modeData.wave==20 then
            PROGRESS.setMinoModeState('survivor_spike',1)
        end
    end
end

do-- backfire_100
    local bgmTransP1,bgmTransP2=40,75
    function progress.backfire_100_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.backfire_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('backfire_amplify_100')
            PROGRESS.setMinoModeState('backfire_100',1)
        end
    end
end

do-- backfire_amplify_100
    local bgmTransP1,bgmTransP2=40,75
    function progress.backfire_amplify_100_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.backfire_amplify_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('backfire_cheese_100')
            PROGRESS.setMinoModeState('backfire_amplify_100',1)
        end
    end
end

do-- backfire_cheese_100
    local bgmTransP1,bgmTransP2=40,75
    function progress.backfire_cheese_100_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.line>bgmTransP1 and P.modeData.stat.line<bgmTransP2+4 then
            BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.stat.line-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
    function progress.backfire_cheese_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setMinoModeState('backfire_cheese_100',1)
        end
    end
end

return progress
