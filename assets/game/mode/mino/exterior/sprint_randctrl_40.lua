local gc=love.graphics
local lineTarget=40
local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                P.modeData.line=0
                P.modeData.randomPressTimer=2600
            end,
            beforePress=function(P)
                if P.modeData.randomPressTimer>260 then
                    P.modeData.randomPressTimer=P.modeData.randomPressTimer-120
                end
            end,
            always=function(P)
                if not P.timing then return end
                P.modeData.randomPressTimer=P.modeData.randomPressTimer-1
                if P.modeData.randomPressTimer==0 then
                    local r=P.seqRND:random(P.holdTime==0 and 5 or 4)
                    if r==1 then
                        P:moveLeft()
                    elseif r==2 then
                        P:moveRight()
                    elseif r==3 then
                        P:rotate('R')
                    elseif r==4 then
                        P:rotate('L')
                    elseif r==5 then
                        P:hold()
                    end
                    P.modeData.randomPressTimer=P.seqRND:random(1620,2600)
                end
            end,
            afterClear=function(P,movement)
                P.modeData.line=math.min(P.modeData.line+#movement.clear,lineTarget)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
                if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
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
