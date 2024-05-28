local gc=love.graphics

---@type Map<Techmino.Mech.Brik>
local sprint={}

function sprint.event_afterClear(P)
    if P.modeData.stat.line>=P.modeData.target.line then
        P:finish('AC')
    end
end

function sprint.event_drawInField(P)
    gc.setColor(1,1,1,.26)
    gc.rectangle('fill',0,(P.modeData.stat.line-P.modeData.target.line)*40-2,P.settings.fieldW*40,4)
end

function sprint.event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.target.line-P.modeData.stat.line,-300,-70)
    FONT.set(30) GC.mStr(Text.target_line,-300,15)
end

return sprint
