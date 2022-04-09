local gc=love.graphics

return {
    settings={
        dropDelay=60,
        lockDelay=60,
        event={
            afterClear=function(P)
                P.modeData.line=P.modeData.line+P.clearHistory[#P.clearHistory].line
                if P.modeData.line>=40 then
                    P:gameover('AC')
                end
            end,
            drawInField=function(P)
                -- Countdown line
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-40)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(math.max(40-P.modeData.line,0),-300,-55)
            end,
        },
    },
    score=function(P)
        -- TODO
    end,
    record=function(P)
        -- TODO
    end,
    getRank=function(P)
        -- TODO
    end,
}
