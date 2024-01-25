---@type Techmino.Mech.mino
local music={}

do -- sprint_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_200
    local bgmTransP1,bgmTransP2=100,150
    function music.sprint_200_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_1000
    local bgmTransP1,bgmTransP2=750,900
    function music.sprint_1000_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_obstacle_20
    local bgmTransP1,bgmTransP2=5,15
    function music.sprint_obstacle_20_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_drought_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_drought_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_flood_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_flood_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_pento_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_pento_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['beat5th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_sym_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_sym_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_mph_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_mph_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_lock_20
    local bgmTransP1,bgmTransP2=5,15
    function music.sprint_lock_20_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_fix_20
    local bgmTransP1,bgmTransP2=5,15
    function music.sprint_fix_20_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_wind_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_wind_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_delay_20
    local bgmTransP1,bgmTransP2=5,15
    function music.sprint_delay_20_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_hide_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_hide_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_invis_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_invis_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_blind_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_blind_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_big_80
    local bgmTransP1,bgmTransP2=40,60
    function music.sprint_big_80_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_small_20
    local bgmTransP1,bgmTransP2=5,15
    function music.sprint_small_20_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_low_40
    local bgmTransP1,bgmTransP2=40,60
    function music.sprint_low_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_float_40
    local bgmTransP1,bgmTransP2=40,60
    function music.sprint_float_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_randctrl_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_randctrl_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_flip_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_flip_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- sprint_dizzy_40
    local bgmTransP1,bgmTransP2=10,30
    function music.sprint_dizzy_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['race'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- marathon
    function music.marathon_afterClear(P)
        if not P.isMain then return true end
        local md=P.modeData
        if not md.marathon_lastLevel then md.marathon_lastLevel=1 end
        if md.level>md.marathon_lastLevel then
            if md.marathon_lastLevel<15 then
                BGM.set(bgmPack('propel','a1','a3','b3'),'volume',math.min(md.level/15,1)^2)
            end
            if md.level>=22 then
                BGM.set(bgmPack('propel','p'),'volume',math.min(.2+(md.level-20)*.8,1),6.26)
                PROGRESS.setModeState('mino_stdMap','hypersonic_lo')
            end
            if md.level>=25 and md.marathon_lastLevel<25 then
                BGM.set(bgmPack('propel','a1','a3'),'volume',0,26)
            end
            md.marathon_lastLevel=md.level
        else
            if not md.marathon_lastAscend then md.marathon_lastAscend=0 end
            if md.ascend>md.marathon_lastAscend then
                print(md.ascend)
                if md.ascend==1 then
                    BGM.set('all','volume',0,.26)
                    BGM.set(bgmPack('propel','m','b2','b3','p'),'volume',1,.26)
                elseif md.ascend==2 then
                    BGM.set('all','volume',0,.26)
                    BGM.set(bgmPack('propel','b1','b2','p'),'volume',1,.26)
                elseif md.ascend==3 then
                    BGM.set('all','volume',0,.26)
                    BGM.set(bgmPack('propel','a1','a2','a3'),'volume',1,.26)
                    BGM.set(bgmPack('propel','p'),'volume',.42,.26)
                elseif md.ascend==4 then
                    BGM.set('all','volume',0,.26)
                    BGM.set('all','pitch',1.5,.26)
                    BGM.set(bgmPack('propel','p'),'volume',.626,.26)
                else
                    BGM.set('all','volume',1,.26)
                    BGM.set(bgmPack('propel','p'),'volume',0,.26)
                    BGM.set('all','pitch',math.min(md.ascend/2-.5,32),.26)
                end
            end
        end
    end
end

do -- techrash_easy
    local bgmTransP1,bgmTransP2=4,10
    function music.techrash_easy_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.techrash
        if pt>bgmTransP1 and pt<=bgmTransP2 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- hypersonic_lo
    local bgmTransP1,bgmTransP2=100,300
    function music.hypersonic_lo_afterSpawn(P)
        if not P.isMain then return true end
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret8th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
    end
end

do -- techrash_hard
    local bgmTransP1,bgmTransP2=4,10
    function music.techrash_hard_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.techrash
        if pt>bgmTransP1 and pt<=bgmTransP2 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- hypersonic_hi
    local bgmTransP1,bgmTransP2=100,500
    function music.hypersonic_hi_afterSpawn(P)
        if not P.isMain then return true end
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
    end
end

do -- hypersonic_hd
    local bgmTransP1,bgmTransP2=100,500
    function music.hypersonic_hd_afterSpawn(P)
        if not P.isMain then return true end
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['secret7th'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
        if not P.modeData.hypersonic_bgmTransition1 then
            if P.modeData.level>=2 then
                BGM.set(bgmPack('secret7th','m1'),'volume',1,26)
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

do -- hypersonic_ti
    local bgmTransP1,bgmTransP2=200,600
    function music.hypersonic_ti_afterSpawn(P)
        if not P.isMain then return true end
        local pt=P.modeData.point
        if pt>bgmTransP1 and pt<bgmTransP2+10 then
            BGM.set(bgmList['distortion'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),1)
        end
    end
end

do -- combo_practice
    local bgmTransP1,bgmTransP2=50,100
    function music.combo_practice_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.comboCount
        if pt>bgmTransP1 and pt<=bgmTransP2 then
            BGM.set(bgmList['oxygen'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- dig_shale
    local bgmTransP1,bgmTransP2=10,30
    function music.dig_shale_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- dig_volcanics
    local bgmTransP1,bgmTransP2=0,10
    function music.dig_volcanics_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- dig_40
    local bgmTransP1,bgmTransP2=10,30
    function music.dig_40_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- dig_100
    local bgmTransP1,bgmTransP2=50,75
    function music.dig_100_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- dig_400
    local bgmTransP1,bgmTransP2=200,300
    function music.dig_400_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.lineDig
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['way'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- survivor_b2b
    local bgmTransP1,bgmTransP2=20,50
    function music.survivor_b2b_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.wave
        if pt>bgmTransP1 and pt<=bgmTransP2 then
            BGM.set(bgmList['here'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- survivor_cheese
    local bgmTransP1,bgmTransP2=30,80
    function music.survivor_cheese_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.wave
        if pt>bgmTransP1 and pt<=bgmTransP2 then
            BGM.set(bgmList['here'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- survivor_spike
    local bgmTransP1,bgmTransP2=10,30
    function music.survivor_spike_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.wave
        if pt>bgmTransP1 and pt<=bgmTransP2 then
            BGM.set(bgmList['here'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- backfire_100
    local bgmTransP1,bgmTransP2=40,75
    function music.backfire_100_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['echo'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- backfire_amplify_100
    local bgmTransP1,bgmTransP2=40,75
    function music.backfire_amplify_100_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['echo'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

do -- backfire_cheese_100
    local bgmTransP1,bgmTransP2=40,75
    function music.backfire_cheese_100_afterClear(P)
        if not P.isMain then return true end
        local pt=P.modeData.stat.line
        if pt>bgmTransP1 and pt<bgmTransP2+4 then
            BGM.set(bgmList['echo'].add,'volume',math.min((pt-bgmTransP1)/(bgmTransP2-bgmTransP1),1),2.6)
        end
    end
end

for k,v in next,music do music[k]={1e62,v} end

return music
