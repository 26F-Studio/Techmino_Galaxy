local gc=love.graphics
local lineTarget=100

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        fieldW=5,
        spawnH=10,
        dropDelay=1000,
        lockDelay=1000,
        event={
            playerInit=function(P)
                P.modeData.line=0
            end,
            afterClear=function(P,movement)
                P.modeData.line=math.min(P.modeData.line+#movement.clear,lineTarget)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
                if P.modeData.line>50 and P.modeData.line<84 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-50)/40,1),2.6)
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-lineTarget)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}
