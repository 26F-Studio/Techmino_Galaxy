local gc=love.graphics
local lineTarget=100
local bgmTransBegin,bgmTransFinish=50,75

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('echo','base')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        clearStuck=true,
        event={
            playerInit=function(P)
                P.modeData.line=0
            end,
            beforeCancel=function(_,atk)
                atk.power=atk.power*3
            end,
            beforeSend=function(P,atk)
                P:receive(atk)
            end,
            afterClear=function(P,movement)
                P.modeData.line=math.min(P.modeData.line+#movement.clear,lineTarget)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
                if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                    BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-lineTarget)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80) GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}
