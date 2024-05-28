---@type Map<Techmino.Mech.Basic>
local music={}

---Setup music-param-updating-event for FMOD music (Auto removing old event)
---
---Example: `mechLib.common.music.set(P,{path='.stat.line',s=10,e=30},'afterClear')`
---@param P Techmino.Player
---@param state Techmino.PlayerModeData.MusicTable
---@param eventName? Techmino.EventName Leave this empty to not add event automatically
function music.set(P,state,eventName)
    music.disable(P)
    assert(type(state.path)=='string',"data.path must be string")
    if state.path:sub(1,1)=='.' then
        state.path='modeData'..state.path
    end
    P.modeData.music={
        id=state.id,
        path=state.path,
        s=state.s,
        e=state.e,
    }
    if eventName then P:addEvent(eventName,{1e62,music.event}) end
end

---Remove old music event
function music.disable(P)
    for eventName,T in next,P.event do
        for i=1,#T do
            if T[i][2]==music.event then
                P:delEvent(eventName,1e62)
                return
            end
        end
    end
end

function music.event(P)
    if not P.isMain then return true end
    local m=P.modeData.music
    local v=TABLE.pathIndex(P,m.path)
    FMOD.music.setParam(m.id or 'intensity',m.s and MATH.icLerp(m.s,m.e,v) or v)
end

return music
