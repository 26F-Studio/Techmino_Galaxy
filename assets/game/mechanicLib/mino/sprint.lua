local gc=love.graphics

--- @type Techmino.Mech.mino
local sprint={}

sprint.event_afterClear=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        P.modeData.line=math.min(P.modeData.line,lineCount)
        if P.modeData.line>=lineCount then
            P:finish('AC')
        end
    end
    return self[lineCount]
end)

sprint.event_drawInField=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        gc.setColor(1,1,1,.26)
        gc.rectangle('fill',0,(P.modeData.line-lineCount)*40-2,P.settings.fieldW*40,4)
    end
    return self[lineCount]
end)

sprint.event_drawOnPlayer=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(lineCount-P.modeData.line,-300,-55)
    end
    return self[lineCount]
end)

return sprint
