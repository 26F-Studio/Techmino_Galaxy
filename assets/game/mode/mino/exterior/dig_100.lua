local gc=love.graphics
local lineTarget,lineStay=100,10
local bgmTransBegin,bgmTransFinish=50,75

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                for _=1,lineStay do P:riseGarbage() end
                P.fieldDived=0
                P.modeData.lineCleared=0
                P.modeData.lineExist=lineStay
            end,
            afterClear=function(P,movement)
                local cleared=P.modeData.lineExist+1-movement.clear[#movement.clear]
                if cleared>0 then
                    P.modeData.lineCleared=P.modeData.lineCleared+cleared
                    P.modeData.lineExist=P.modeData.lineExist-cleared
                    local stay=math.min(lineTarget-P.modeData.lineCleared,lineStay)
                    if P.modeData.lineExist<stay then
                        local add=stay-P.modeData.lineExist
                        for _=1,add do P:riseGarbage() end
                        P.modeData.lineExist=P.modeData.lineExist+add
                    end
                    if P.modeData.lineCleared==lineTarget then
                        P:finish('AC')
                    end
                    if P.modeData.lineCleared>bgmTransBegin and P.modeData.lineCleared<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((P.modeData.lineCleared-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(lineTarget-P.modeData.lineCleared,-300,-55)
            end,
        },
    }},
}
