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
        pieceVisTime=120,
        pieceFadeTime=120,
        event={
            playerInit=function(P)
                P.modeData.line=0
                P.modeData.coverAlpha=0
            end,
            always=function(P)
                if P.finished then
                    if P.modeData.coverAlpha>2000 then
                        P.modeData.coverAlpha=P.modeData.coverAlpha-1
                    end
                else
                    if P.modeData.coverAlpha<2600 then
                        P.modeData.coverAlpha=P.modeData.coverAlpha+1
                    end
                end
            end,
            afterClear=function(P,clear)
                P.modeData.line=math.min(P.modeData.line+clear.line,lineTarget)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
                if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            gameOver=function(P)
                P:showInvis()
            end,
            drawInField=function(P)
                gc.setColor(.26,.26,.26,P.modeData.coverAlpha/2600)
                gc.setColor(.26,.26,.26)
                gc.setColor(.26,.26,.26,P.modeData.coverAlpha/2600)
                gc.rectangle('fill',0,0,P.settings.fieldW*40,-P.settings.spawnH*40)
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
