local gc=love.graphics
local lineTarget=200
local bgmTransBegin,bgmTransFinish=100,150

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

                P:setAction("func1",mechLib.mino.stack.switch)
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
            afterLock = mechLib.mino.stack.event_afterLock,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-lineTarget)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80) GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
            whenSuffocate=mechLib.mino.stack.event_whenSuffocate,
        },
    }},
}
