local gc=love.graphics

---@type Map<Techmino.Event.Brik>
local chargeLimit={}

do -- tspin
    function chargeLimit.tspin_event_playerInit(P)
        P.modeData.tsd=0
        P.modeData.tsdInfo={}
    end

    local tsdPower=3
    local maxCharge=5

    function chargeLimit.tspin_event_always(P)
        for _,v in next,P.modeData.tsdInfo do
            if v._charge~=v.charge then
                if v._charge<v.charge then
                    v._charge=MATH.expApproach(v._charge,v.charge,.00626)
                else
                    v._charge=math.max(v._charge-.00626,v.charge)
                end
                if math.abs(v._charge-v.charge)<.01 then
                    v._charge=v.charge
                end
            end
        end
    end
    function chargeLimit.tspin_death_event_always(P)
        P.modeData.overChargedTimer=P.modeData.overChargedTimer+1
        if P.modeData.overChargedTimer>=620 then
            if P.modeData.superpositionProtect then
                P:delEvent('drawBelowMarks',chargeLimit.tspin_event_drawBelowMarks)
                P:playSound('beep_drop')
            else
                P:finish('PE')
            end
            return true
        end
    end
    function chargeLimit.tspin_event_afterClear(P,clear)
        local movement=P.lastMovement
        if P.hand.name=='T' and movement.action=='rotate' and (movement.corners or movement.immobile) then
            if P.modeData.tsd and clear.line==2 then
                P.modeData.tsd=P.modeData.tsd+1
                if P.modeData.tsd>1 then
                    local n=P.modeData.tsd
                    P:playSound('charge',
                        n<=3 and 1 or
                        n<=5 and 2 or
                        n<=7 and 3 or
                        n<=9 and 4 or
                        n<=11 and 5 or
                        n<=13 and 6 or
                        n<=15 and 7 or
                        n<=17 and 8 or
                        n<=19 and 9 or
                        n<=22 and 10 or
                        11
                    )
                end

                if not P.modeData.overChargedTimer then
                    local list=P.modeData.tsdInfo
                    local settings=P.settings
                    local RS=brikRotSys[settings.rotSys]
                    local brikData=RS[P.hand.shape]
                    local state=brikData[P.hand.direction]
                    local centerPos=state and state.center or type(brikData.center)=='function' and brikData.center(P)

                    if centerPos then
                        local x=P.handX+centerPos[1]-.5
                        if not list[x] then list[x]={charge=0,_charge=0} end
                        if list[x].charge>=maxCharge then
                            list[x].dead=true
                            P.modeData.overChargedTimer=0
                            P:addEvent('always',chargeLimit.tspin_death_event_always)
                            if P.modeData.superpositionProtect then
                                P:playSound('beep_drop')
                            end
                        else
                            for k,v in next,list do
                                if k~=x then
                                    v.charge=math.max(v.charge-1,0)
                                end
                            end
                        end
                        list[x].charge=list[x].charge+tsdPower
                    end
                end
            elseif P.modeData.superpositionProtect then
                -- Degrade to tspin
                if not P.modeData.tspin then
                    P.modeData.tspin=P.modeData.tsd
                    P.modeData.tsd=nil
                    P:playSound('beep_drop')
                end
                P.modeData.tspin=P.modeData.tspin+1
            else
                P:finish('PE')
            end
        else
            P:finish('PE')
        end
    end
    function chargeLimit.tspin_event_drawBelowMarks(P)
        local t=love.timer.getTime()
        for k,v in next,P.modeData.tsdInfo do
            if v._charge>0 or v.dead then
                local x=40*k-20
                local chargeRate=v._charge/maxCharge
                local barHeight=chargeRate*P.settings.fieldW*80
                if v.dead then
                    if t%.2<.1 then
                        gc.setColor(.6,.4,.8,.626)
                    else
                        gc.setColor(.6,.6,.6,.42)
                    end
                    gc.rectangle('fill',x-15,0,30,-barHeight)
                else
                    if chargeRate<1 then
                        gc.setColor(.8,0,0,.3+.06*math.sin(t*2+k))
                    elseif t%.2<.1 then
                        gc.setColor(.8,.4,.4,.626)
                    else
                        gc.setColor(.6,.6,.6,.42)
                    end
                    gc.rectangle('fill',x-15,0,30,-barHeight)
                    gc.setColor(1,1,1,.42)
                    gc.rectangle('fill',x-15,-barHeight,30,2)
                end
            end
        end
    end
    function chargeLimit.tspin_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(P.modeData.tsd,-300,-70)
        FONT.set(30) GC.mStr(Text.target_tsd,-300,15)
    end
end

do -- techrash
    local initPower=3
    local initSidePower=0
    local maxPower=6
    local maxSidePower=4
    local sidePowerRate=0.5
    local maxCharge=6

    function chargeLimit.techrash_event_playerInit(P)
        P.modeData.techrash=0
        P.modeData.chargePower=initPower
        P.modeData.sidePower=initSidePower
        P.modeData.techrashInfo={}
    end
    function chargeLimit.techrash_event_always(P)
        for _,v in next,P.modeData.techrashInfo do
            if v._charge~=v.charge then
                if v._charge<v.charge then
                    v._charge=MATH.expApproach(v._charge,v.charge,.00626)
                else
                    v._charge=math.max(v._charge-.00626,v.charge)
                end
                if math.abs(v._charge-v.charge)<.01 then
                    v._charge=v.charge
                end
            end
        end
    end
    function chargeLimit.techrash_event_afterClear(P,clear)
        if P.hand.name=='I' and clear.line==4 then
            local list=P.modeData.techrashInfo
            local x=P.handX
            P.modeData.techrash=P.modeData.techrash+1
            if P.modeData.techrash>1 then
                local n=P.modeData.techrash
                P:playSound('charge',
                    n<=2 and 1 or
                    n<=4 and 2 or
                    n<=6 and 3 or
                    n<=8 and 4 or
                    n<=10 and 5 or
                    n<=13 and 6 or
                    n<=16 and 7 or
                    n<=19 and 8 or
                    n<=22 and 9 or
                    n<=25 and 10 or
                    11
                )
            end
            if not list[x] then list[x]={charge=0,_charge=0} end
            if list[x].charge>=maxCharge then
                list[x].dead=true
                P:finish('PE')
            else
                for k,v in next,list do
                    if k~=x then
                        v.charge=math.max(v.charge-1,0)
                    end
                end
            end
            list[x].charge=list[x].charge+P.modeData.chargePower
            if not list[x-1] then list[x-1]={charge=0,_charge=0} end
            list[x-1].charge=list[x-1].charge+math.floor(P.modeData.sidePower/2)
            if not list[x+1] then list[x+1]={charge=0,_charge=0} end
            list[x+1].charge=list[x+1].charge+math.floor(P.modeData.sidePower/2)

            local r1,r2=P.modeData.chargePower,P.modeData.sidePower/sidePowerRate
            if P.modeData.chargePower>=maxPower then r1=0 end
            if P.modeData.sidePower>=maxSidePower then r2=0 end
            if r1*r2>0 then r1,r2=r1>=r2 and 1 or 0,r2>=r1 and 1 or 0 end
            if r1>0 then
                P.modeData.sidePower=P.modeData.sidePower+1
            elseif r2>0 then
                P.modeData.chargePower=P.modeData.chargePower+1
            end
        else
            P:finish('PE')
        end
    end
    function chargeLimit.techrash_event_drawBelowMarks(P)
        local t=love.timer.getTime()
        for k,v in next,P.modeData.techrashInfo do
            if v._charge>0 or v.dead then
                local x=40*k-20
                local chargeRate=v._charge/maxCharge
                local barHeight=chargeRate*P.settings.fieldW*80
                if v.dead then
                    if t%.2<.1 then
                        gc.setColor(.6,.4,.8,.626)
                    else
                        gc.setColor(.6,.6,.6,.42)
                    end
                    gc.rectangle('fill',x-15,0,30,-barHeight)
                else
                    if chargeRate<1 then
                        gc.setColor(.8,0,0,.3+.06*math.sin(t*2+k))
                    elseif t%.2<.1 then
                        gc.setColor(.8,.4,.4,.626)
                    else
                        gc.setColor(.6,.6,.6,.42)
                    end
                    gc.rectangle('fill',x-15,0,30,-barHeight)
                    gc.setColor(1,1,1,.42)
                    gc.rectangle('fill',x-15,-barHeight,30,2)
                end
            end
        end
    end
    function chargeLimit.techrash_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(P.modeData.techrash,-300,-70)
        FONT.set(30) GC.mStr(Text.target_techrash,-300,15)
    end
end

return chargeLimit
