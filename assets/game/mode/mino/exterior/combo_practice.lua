local lineTarget=200
local bgmTransBegin,bgmTransFinish=20,50

local function newMap(P)
    local F=P.field
    local w=P.settings.fieldW
    local difficulty=MATH.clamp(P.modeData.cleared+1+P:random(-1,1),1,10)
    local height=10+math.floor((difficulty+1)/2)+P:random(-2,2)
    local wellWidth=MATH.clamp(2+math.floor(difficulty/4),2,4)
    local widthExpandCounter=math.floor(15-difficulty)+P:random(-2,2)
    local wellL,wellR

    if wellWidth==3 then
        widthExpandCounter=widthExpandCounter+3-widthExpandCounter%3
    end

    wellL=P:random(1,w+1-wellWidth)
    wellR=wellL+wellWidth-1

    TABLE.cut(F._matrix)
    for y=1,height do
        F._matrix[y]=TABLE.new(false,w)
        for x=1,w do
            if not (x>=wellL and x<=wellR) then
                F._matrix[y][x]={color=0,conn={}}
            end
        end
        if wellR-wellL+1<4 then
            widthExpandCounter=widthExpandCounter-1
            if widthExpandCounter==0 then
                if P:random()<.5 then wellL=wellL-1 else wellR=wellR+1 end
                if wellL<1 then wellL,wellR=wellL+1,wellR+1 end
                if wellR>w then wellL,wellR=wellL-1,wellR-1 end
                wellL,wellR=MATH.clamp(wellL,1,10),MATH.clamp(wellR,1,10)
                widthExpandCounter=math.floor(12-difficulty)+P:random(-1,2)
            end
        end
    end

    -- 4w base
    if wellWidth==4 then
        if P:random()<.626 then-- 6-res
            for x=wellL,wellR do
                for y=1,2 do
                    F._matrix[y][x]={color=0,conn={}}
                end
            end
            F._matrix[1][P:random(wellL,wellR)]=false
            F._matrix[2][P:random(wellL,wellR)]=false
        else-- 3-res
            if P:random()<.626 then-- Hook pattern
                local L=P:random()<.5
                F._matrix[1][L and wellL   or wellR  ]={color=0,conn={}}
                F._matrix[2][L and wellL   or wellR  ]={color=0,conn={}}
                F._matrix[2][L and wellL+1 or wellR-1]={color=0,conn={}}
            else-- Flat
                for x=wellL,wellR do
                    F._matrix[1][x]={color=0,conn={}}
                end
                F._matrix[1][P:random(wellL,wellR)]=false
            end
        end
    end

    P.clearTimer=0
    P.modeData.levelRemain=height
    P.modeData.levelStarted=false
end

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('oxygen','base')
    end,
    settings={mino={
        spawnDelay=60,
        clearDelay=120,
        atkSys='modern',
        event={
            playerInit=function(P)
                P.settings.das=math.max(P.settings.das,120)
                P.settings.arr=math.max(P.settings.arr,12)
                P.settings.sdarr=math.max(P.settings.sdarr,6)

                P.modeData.totalCombo=0
                P.modeData.levelRemain=0
                P.modeData.cleared=0
                P.modeData._curHisLen=false
                newMap(P)
            end,
            afterDrop=function(P)
                if P.handY>P.modeData.levelRemain then
                    if P.modeData.levelStarted then
                        newMap(P)
                        P:playSound('b2b_break')
                        P.combo=0
                    end
                    P.hand=false
                end
            end,
            afterLock=function(P)
                P.modeData._curHisLen=#P.clearHistory
            end,
            afterClear=function(P,clear)
                P.modeData.levelRemain=P.modeData.levelRemain-clear.line
            end,
            beforeDiscard=function(P)
                if #P.clearHistory>P.modeData._curHisLen then
                    if not P.modeData.levelStarted then
                        P.modeData.levelStarted=true
                    else
                        P.modeData.totalCombo=P.modeData.totalCombo+1
                    end
                    if P.modeData.totalCombo>bgmTransBegin and P.modeData.totalCombo<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['oxygen'].add,'volume',math.min((P.modeData.totalCombo-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                    if P.modeData.totalCombo>=lineTarget then
                        P:finish('AC')
                    elseif P.modeData.levelRemain<=0 then
                        P.modeData.cleared=P.modeData.cleared+1
                        newMap(P)
                        P:playSound('reach')
                    end
                elseif P.modeData.levelStarted then
                    newMap(P)
                    P:playSound('b2b_break')
                end
            end,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80)
                GC.mStr(lineTarget-P.modeData.totalCombo,-300,-55)
            end,
        },
    }},
}
