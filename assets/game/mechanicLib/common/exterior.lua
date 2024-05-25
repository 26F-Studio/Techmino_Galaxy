---@type Map<Techmino.Event|Techmino.Mech.Brik>
local music={}

---@type Map<Techmino.Event|Techmino.Mech.Brik>
local exterior={}

function music.sprint_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end
function exterior.sprint_event_playerInit(P)
end

function music.sequence_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end
function music.sequence_pento_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
end
function exterior.sequence_event_playerInit(P)
end

function music.allclear_afterClear(P)
    if not P.isMain then return true end
    -- FMOD.music.setParam('intensity',MATH.icLerp(50,100,P.modeData.comboCount))
end
function exterior.allclear_event_playerInit(P)
end

function music.dig_afterClear(P)
    if not P.isMain then return true end
    -- FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end
function exterior.dig_event_playerInit(P)
end

function music.excavate_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end
function exterior.excavate_event_playerInit(P)
end

function music.drill_shale_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.lineDig))
end
function music.drill_volcanics_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(0,10,P.modeData.lineDig))
end
function exterior.drill_event_playerInit(P)
end

function music.survivor_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(20,50,P.modeData.wave))
end
function exterior.survivor_event_playerInit(P)
end

function music.backfire_afterClear(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(40,75,P.modeData.stat.line))
end
function exterior.backfire_event_playerInit(P)
end

for k,v in next,music do
    ---@cast v fun(P:Techmino.Player.Brik):any
    music[k]={1e62,v}
end

return exterior
