local gc=love.graphics

---@type Map<Techmino.Mech.Brik|Map<Techmino.Mech.Brik>>
local sprint={}

sprint.event_afterClear=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        if P.modeData.stat.line>=lineCount then
            P:finish('AC')
        end
    end
    return self[lineCount]
end)

sprint.event_drawInField=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        gc.setColor(1,1,1,.26)
        gc.rectangle('fill',0,(P.modeData.stat.line-lineCount)*40-2,P.settings.fieldW*40,4)
    end
    return self[lineCount]
end)

sprint.event_drawOnPlayer=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(lineCount-P.modeData.stat.line,-300,-70)
        FONT.set(30) GC.mStr(Text.target_line,-300,15)
    end
    return self[lineCount]
end)

return sprint
