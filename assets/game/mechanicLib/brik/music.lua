---@type Map<Techmino.Event|Techmino.Mech.Brik>
local music={}

function music.sprint_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_200_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,150,P.modeData.stat.line))
end

function music.sprint_1000_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(750,900,P.modeData.stat.line))
end

function music.sprint_obstacle_20_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(5,15,P.modeData.stat.line))
end

function music.sprint_drought_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_flood_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_pento_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_sym_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_mph_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_lock_20_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(5,15,P.modeData.stat.line))
end

function music.sprint_fix_20_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(5,15,P.modeData.stat.line))
end

function music.sprint_wind_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_delay_20_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(5,15,P.modeData.stat.line))
end

function music.sprint_hide_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_invis_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_blind_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_big_80_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,60,P.modeData.stat.line))
end

function music.sprint_small_20_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(5,15,P.modeData.stat.line))
end

function music.sprint_low_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,60,P.modeData.stat.line))
end

function music.sprint_float_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,60,P.modeData.stat.line))
end

function music.sprint_randctrl_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_flip_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.sprint_dizzy_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.marathon_afterClear(P)
    if not P.isMain then return true end
    local md=P.modeData
    FMOD.music.setParam('level_marathon_exterior',(md.level or 1)+(md.ascend or 0))
end

function music.hypersonic_lo_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,300,P.modeData.point))
end

function music.techrash_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(4,10,P.modeData.techrash))
end

function music.hypersonic_hi_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,500,P.modeData.point))
end

function music.hypersonic_hd_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,500,P.modeData.point))
    FMOD.music.setParam('level_hypersonic_exterior',P.modeData.level)
end

function music.hypersonic_ti_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(200,600,P.modeData.point))
end

function music.combo_practice_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(50,100,P.modeData.comboCount))
end

function music.dig_shale_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end

function music.dig_volcanics_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(0,10,P.modeData.lineDig))
end

function music.dig_40_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end

function music.dig_100_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(50,75,P.modeData.lineDig))
end

function music.dig_400_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(200,300,P.modeData.lineDig))
end

function music.survivor_power_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(20,50,P.modeData.wave))
end

function music.survivor_cheese_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(30,80,P.modeData.wave))
end

function music.survivor_spike_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.wave))
end

function music.backfire_100_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,75,P.modeData.stat.line))
end

function music.backfire_amplify_100_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,75,P.modeData.stat.line))
end

function music.backfire_cheese_100_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,75,P.modeData.stat.line))
end

for k,v in next,music do
    ---@cast v fun(P:Techmino.Player.Brik):any
    music[k]={1e62,v}
end

return music
