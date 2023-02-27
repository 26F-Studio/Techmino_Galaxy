local gc=love.graphics
local lineTarget,lineStay=20,6
local bgmTransBegin,bgmTransFinish=0,10

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                for _=1,lineStay do
                    P:riseGarbage(P:calculateHolePos(
                        P.seqRND:random(3,4),-- count
                        .2,-- splitRate
                        -.1, -- copyRate
                        .1 -- sandwichRate
            ))
                end
                P.fieldDived=0
                P.modeData.lineCleared=0
                P.modeData.lineExist=lineStay
            end,
            afterClear=function(P,movement)
                local md=P.modeData
                local cleared=md.lineExist+1-movement.clear[#movement.clear]
                if cleared>0 then
                    md.lineCleared=md.lineCleared+cleared
                    md.lineExist=md.lineExist-cleared
                    local stay=math.min(lineTarget-md.lineCleared,lineStay)
                    if md.lineExist<stay then
                        local add=stay-md.lineExist
                        for _=1,add do
                            P:riseGarbage(P:calculateHolePos(
                                P.seqRND:random(3,4),-- count
                                .2,-- splitRate
                                -.1, -- copyRate
                                .1 -- sandwichRate
                            ))
                        end
                        md.lineExist=md.lineExist+add
                    end
                    if md.lineCleared==lineTarget then
                        P:finish('AC')
                    end
                    if md.lineCleared>bgmTransBegin and md.lineCleared<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['way'].add,'volume',math.min((md.lineCleared-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
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
