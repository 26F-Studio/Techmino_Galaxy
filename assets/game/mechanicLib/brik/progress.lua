---@type Techmino.Mech.brik
local progress={}

do -- sprint_40
    function progress.sprint_40_afterClear(P)
        if not P.isMain then return true end
        P.modeData.maxHeight=math.max(P.modeData.maxHeight or 0,P.field:getHeight())
    end
    function progress.sprint_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.gameTime<=86e3 then
                PROGRESS.setModeState('brik_stdMap','sprint_hide_40')
            end
            if P.modeData.maxHeight<=8 then
                PROGRESS.setModeState('brik_stdMap','sprint_10')
            end
            if P.modeData.stat.piece<110 then
                PROGRESS.setModeState('brik_stdMap','sprint_big_80')
            end
            PROGRESS.setModeState('brik_stdMap','sprint_40',1)
        end
    end
end

do -- sprint_10
    function progress.sprint_10_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.modeData.stat.piece<30 then
                PROGRESS.setModeState('brik_stdMap','sprint_obstacle_20')
            end
            PROGRESS.setModeState('brik_stdMap','sprint_200')
            PROGRESS.setModeState('brik_stdMap','sprint_10',1)
        end
    end
end

do -- sprint_200
    function progress.sprint_200_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_1000')
            PROGRESS.setModeState('brik_stdMap','sprint_200',1)
        end
    end
end

do -- sprint_1000
    function progress.sprint_1000_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_1000',1)
        end
    end
end

do -- sprint_obstacle_20
    function progress.sprint_obstacle_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_drought_40')
            PROGRESS.setModeState('brik_stdMap','sprint_obstacle_20',1)
        end
    end
end

do -- sprint_drought_40
    function progress.sprint_drought_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_flood_40')
            PROGRESS.setModeState('brik_stdMap','sprint_mph_40')
            PROGRESS.setModeState('brik_stdMap','sprint_drought_40',1)
        end
    end
end

do -- sprint_flood_40
    function progress.sprint_flood_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_pento_40')
            PROGRESS.setModeState('brik_stdMap','sprint_flood_40',1)
        end
    end
end

do -- sprint_pento_40
    function progress.sprint_pento_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_pento_40',1)
        end
    end
end

do -- sprint_sym_40
    function progress.sprint_sym_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_sym_40',1)
        end
    end
end

do -- sprint_mph_40
    function progress.sprint_mph_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_lock_20')
            PROGRESS.setModeState('brik_stdMap','sprint_mph_40',1)
        end
    end
end

do -- sprint_lock_20
    function progress.sprint_lock_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_fix_20')
            PROGRESS.setModeState('brik_stdMap','sprint_lock_20',1)
        end
    end
end

do -- sprint_fix_20
    function progress.sprint_fix_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_fix_20',1)
        end
    end
end

do -- sprint_wind_40
    function progress.sprint_wind_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_wind_40',1)
        end
    end
end

do -- sprint_delay_20
    function progress.sprint_delay_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_delay_20',1)
        end
    end
end

do -- sprint_hide_40
    function progress.sprint_hide_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.modeData.stat.piece<110 then
                PROGRESS.setModeState('brik_stdMap','sprint_invis_40')
            end
            PROGRESS.setModeState('brik_stdMap','sprint_hide_40',1)
        end
    end
end

do -- sprint_invis_40
    function progress.sprint_invis_40_afterClear(P)
        if P.modeData.stat.clears[4]==10 then
            PROGRESS.setModeState('brik_stdMap','sprint_blind_40')
        end
    end
    function progress.sprint_invis_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_invis_40',1)
        end
    end
end

do -- sprint_blind_40
    function progress.sprint_blind_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_blind_40',1)
        end
    end
end

do -- sprint_big_80
    function progress.sprint_big_80_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_small_20')
            PROGRESS.setModeState('brik_stdMap','sprint_low_40')
            PROGRESS.setModeState('brik_stdMap','sprint_big_80',1)
        end
    end
end

do -- sprint_small_20
    function progress.sprint_small_20_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_small_20',1)
        end
    end
end

do -- sprint_low_40
    function progress.sprint_low_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_float_40')
            PROGRESS.setModeState('brik_stdMap','sprint_low_40',1)
        end
    end
end

do -- sprint_float_40
    function progress.sprint_float_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_float_40',1)
        end
    end
end

do -- sprint_randctrl_40
    function progress.sprint_randctrl_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_randctrl_40',1)
        end
    end
end

do -- sprint_flip_40
    function progress.sprint_flip_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            if P.gameTime<=60e3 then
                PROGRESS.setModeState('brik_stdMap','sprint_dizzy_40')
            end
            PROGRESS.setModeState('brik_stdMap','sprint_flip_40',1)
        end
    end
end

do -- sprint_dizzy_40
    function progress.sprint_dizzy_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','sprint_dizzy_40',1)
        end
    end
end

do -- marathon
    function progress.marathon_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]==16 then
            PROGRESS.setModeState('brik_stdMap','techrash_easy')
        end
    end
    function progress.marathon_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','marathon',1)
        end
    end
end

do -- techrash_easy
    function progress.techrash_easy_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]>=20 then
            PROGRESS.setModeState('brik_stdMap','techrash_easy',1)
        end
    end
end

do -- hypersonic_lo
    function progress.hypersonic_lo_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]==36 then
            PROGRESS.setModeState('brik_stdMap','techrash_hard')
        end
    end
    function progress.hypersonic_lo_gameOver(P,reason)
        if not P.isMain then return true end
        PROGRESS.setModeState('brik_stdMap','hypersonic_hi')
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','hypersonic_lo',1)
        end
    end
end

do -- techrash_hard
    function progress.techrash_hard_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]>=20 then
            PROGRESS.setModeState('brik_stdMap','techrash_easy',1)
        end
    end
end

do -- hypersonic_hi
    function progress.hypersonic_hi_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.stat.clears[4]==42 then
            PROGRESS.setModeState('brik_stdMap','hypersonic_hd')
        end
    end
    function progress.hypersonic_hi_gameOver(P)
        if not P.isMain then return true end
        if P.modeData.point>=1000 then
            PROGRESS.setModeState('brik_stdMap','hypersonic_ti')
            PROGRESS.setModeState('brik_stdMap','hypersonic_hi',1)
        end
    end
end

do -- hypersonic_hd
    function progress.hypersonic_hd_gameOver(P)
        if not P.isMain then return true end
        if P.modeData.point>=1000 then
            PROGRESS.setModeState('brik_stdMap','hypersonic_hd',1)
        end
    end
end

do -- hypersonic_ti
    function progress.hypersonic_ti_gameOver(P)
        if not P.isMain then return true end
        if P.modeData.point>=1000 then
            PROGRESS.setModeState('brik_stdMap','hypersonic_ti',1)
        end
    end
end

do -- combo_practice
    function progress.combo_practice_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.cleared==12 then
            PROGRESS.setModeState('brik_stdMap','tsd_easy')
        end
    end
    function progress.combo_practice_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','combo_practice',1)
        end
    end
end

do -- dig_practice
    function progress.dig_practice_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','dig_shale')
            if P.gameTime<30e3 then
                PROGRESS.setModeState('brik_stdMap','survivor_b2b')
            end
            if P.modeData.stat.piece<62 then
                PROGRESS.setModeState('brik_stdMap','dig_40')
            end
            PROGRESS.setModeState('brik_stdMap','dig_practice',1)
        end
    end
end

do -- dig_shale
    function progress.dig_shale_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','dig_volcanics')
            PROGRESS.setModeState('brik_stdMap','dig_shale',1)
        end
    end
end

do -- dig_volcanics
    function progress.dig_volcanics_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','dig_volcanics',1)
        end
    end
end

function progress.dig_checker_gameOver(P,reason)
    if not P.isMain then return true end
    if reason=='AC' then
        PROGRESS.setModeState('brik_stdMap','dig_checker',1)
    end
end

do -- dig_40
    function progress.dig_40_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','dig_100')
            PROGRESS.setModeState('brik_stdMap','dig_40',1)
        end
    end
end

do -- dig_100
    function progress.dig_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','dig_400')
            PROGRESS.setModeState('brik_stdMap','dig_100',1)
        end
    end
end

do -- dig_400
    function progress.dig_400_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','dig_400',1)
        end
    end
end

do -- survivor_b2b
    function progress.survivor_b2b_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.wave==42 then
            PROGRESS.setModeState('brik_stdMap','backfire_100')
            PROGRESS.setModeState('brik_stdMap','survivor_cheese')
            PROGRESS.setModeState('brik_stdMap','survivor_b2b',1)
        end
    end
end

do -- survivor_cheese
    function progress.survivor_cheese_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.wave==62 then
            PROGRESS.setModeState('brik_stdMap','survivor_spike')
            PROGRESS.setModeState('brik_stdMap','sprint_randctrl_40',1)
        end
    end
end

do -- survivor_spike
    function progress.survivor_spike_afterClear(P)
        if not P.isMain then return true end
        if P.modeData.wave==20 then
            PROGRESS.setModeState('brik_stdMap','survivor_spike',1)
        end
    end
end

do -- backfire_100
    function progress.backfire_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','backfire_amplify_100')
            PROGRESS.setModeState('brik_stdMap','backfire_100',1)
        end
    end
end

do -- backfire_amplify_100
    function progress.backfire_amplify_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','backfire_cheese_100')
            PROGRESS.setModeState('brik_stdMap','backfire_amplify_100',1)
        end
    end
end

do -- backfire_cheese_100
    function progress.backfire_cheese_100_gameOver(P,reason)
        if not P.isMain then return true end
        if reason=='AC' then
            PROGRESS.setModeState('brik_stdMap','backfire_cheese_100',1)
        end
    end
end

-- Lowest priority for all statistics events
for k,v in next,progress do progress[k]={1e99,v} end

return progress
