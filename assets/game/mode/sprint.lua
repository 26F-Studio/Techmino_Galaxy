local gc=love.graphics

return {
    settings={
        dropDelay=1000,
        lockDelay=1000,
        event={
            playerInit=function(P)
                if P.isMain then
                    playBgm('race','-base')
                end
            end,
            afterClear=function(P)
                P.modeData.line=P.modeData.line+P.clearHistory[#P.clearHistory].line
                if P.modeData.line>=40 then P:gameover('AC') end
                if P.isMain and P.modeData.line>10 then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-10)/20,1),2.6)
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-40)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(math.max(40-P.modeData.line,0),-300,-55)
            end,
            gameOver=function(P)
                -- TODO
            end,
        },
    },
    result=function(P)
        -- TODO
    end,
    scorePage=function(data)
        -- TODO
    end,
}
