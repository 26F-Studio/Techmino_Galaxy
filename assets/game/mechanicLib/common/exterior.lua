local music={}

function music.sprint_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end

function music.allclear_afterClear(P)
    if not P.isMain then return true end
    -- FMOD.music.setParam('intensity',MATH.icLerp(50,100,P.modeData.comboCount))
end

function music.dig_afterClear(P)
    if not P.isMain then return true end
    -- FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end

function music.excavate_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end

function music.drill_shale_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end
function music.drill_volcanics_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(0,10,P.modeData.lineDig))
end

function music.survivor_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(20,50,P.modeData.wave))
end

function music.backfire_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,75,P.modeData.stat.line))
end

return music
