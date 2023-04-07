local gc=love.graphics
local lineTarget=40
local bgmTransBegin,bgmTransFinish=10,30

local function flipFunc(P)
    if P.modeData.flip then
        P.keyState.rotateCW,P.keyState.rotateCCW=P.keyState.rotateCCW,P.keyState.rotateCW
        P.keyState.moveLeft,P.keyState.moveRight=P.keyState.moveRight,P.keyState.moveLeft
    end
end

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
                P.modeData.flip=false
            end,
            afterLock=function(P)
                P.modeData.flip=not P.modeData.flip
                P.actions.rotateCW,P.actions.rotateCCW=P.actions.rotateCCW,P.actions.rotateCW
                P.actions.moveLeft,P.actions.moveRight=P.actions.moveRight,P.actions.moveLeft
            end,
            beforePress=   flipFunc,
            afterPress=    flipFunc,
            beforeRelease= flipFunc,
            afterRelease=  flipFunc,
            afterClear=function(P,clear)
                P.modeData.line=math.min(P.modeData.line+clear.line,lineTarget)
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
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80) GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}
