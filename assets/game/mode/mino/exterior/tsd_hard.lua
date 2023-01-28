local gc=love.graphics
local tsdCharge=3
local maxCharge=5

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        spin_immobile=true,
        spin_corners=3,
        event={
            playerInit=function(P)
                P.modeData.tsd=0
                P.modeData.tsdInfo={}
            end,
            always=function(P)
                for _,v in next,P.modeData.tsdInfo do
                    if v.charge1~=v.charge then
                        if v.charge1<v.charge then
                            v.charge1=MATH.expApproach(v.charge1,v.charge,.00626)
                        else
                            v.charge1=math.max(v.charge1-.00626,v.charge)
                        end
                        if math.abs(v.charge1-v.charge)<.01 then
                            v.charge1=v.charge
                        end
                    end
                end
            end,
            afterClear=function(P,movement)
                if P.hand.name=='T' and #movement.clear==2 and movement.action=='rotate' and (movement.corners or movement.immobile) then
                    local list=P.modeData.tsdInfo
                    local settings=P.settings
                    local RS=minoRotSys[settings.rotSys]
                    local minoData=RS[P.hand.shape]
                    local state=minoData[P.hand.direction]
                    local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(P)
                    if centerPos then
                        local x=P.handX+centerPos[1]-.5
                        if not list[x] then list[x]={charge=0,charge1=0} end
                        if list[x].charge>=maxCharge then
                            list[x].dead=true
                            P:finish('PE')
                        else
                            for k,v in next,list do
                                if k~=x then
                                    v.charge=math.max(v.charge-1,0)
                                end
                            end
                            P.modeData.tsd=P.modeData.tsd+1
                        end
                        list[x].charge=list[x].charge+tsdCharge
                    end
                else
                    P:finish('PE')
                end
            end,
            drawBelowMarks=function(P)
                local t=love.timer.getTime()
                for k,v in next,P.modeData.tsdInfo do
                    if v.charge1>0 or v.dead then
                        local x=40*k-20
                        local chargeRate=v.charge1/maxCharge
                        local barHeight=chargeRate*P.settings.fieldW*80
                        if v.dead then
                            if t%.2<.1 then
                                GC.setColor(.6,.4,.8,.626)
                            else
                                GC.setColor(.6,.6,.6,.42)
                            end
                            GC.rectangle('fill',x-15,0,30,-barHeight)
                        else
                            if chargeRate<1 then
                                GC.setColor(.8,0,0,.3+.06*math.sin(t*2+k))
                            elseif t%.2<.1 then
                                GC.setColor(.8,.4,.4,.626)
                            else
                                GC.setColor(.6,.6,.6,.42)
                            end
                            GC.rectangle('fill',x-15,0,30,-barHeight)
                            GC.setColor(1,1,1,.42)
                            GC.rectangle('fill',x-15,-barHeight,30,2)
                        end
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(P.modeData.tsd,-300,-55)
                FONT.set(30)
                GC.mStr("TSD",-300,30)
            end,
        },
    }},
}
