---@type Map<Techmino.Mech.Brik>
local techrash={}

local initPower=3
local initSidePower=0
local maxPower=6
local maxSidePower=4
local sidePowerRate=0.5
local maxCharge=6

local infoMeta={__index=function(self,k)
    self[k]={charge=0,_charge=0}
    return self[k]
end}
function techrash.event_playerInit(P)
    P.modeData.techrash=0
    P.modeData.chargePower=initPower
    P.modeData.sidePower=initSidePower
    P.modeData.techrashInfo=setmetatable({},infoMeta)
end
function techrash.event_always(P)
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
function techrash.event_afterClear(P,clear)
    if P.hand.name=='I' and clear.line==4 then
        local list=P.modeData.techrashInfo
        local x=P.handX
        P.modeData.techrash=P.modeData.techrash+1
        if P.modeData.techrash>1 then
            P:playSound('charge',math.min(math.floor((P.modeData.techrash+2.6)^1.2/5.4),11))
        end
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
        list[x-1].charge=list[x-1].charge+math.floor(P.modeData.sidePower/2)
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
function techrash.event_drawBelowMarks(P)
    local t=love.timer.getTime()
    for k,v in next,P.modeData.techrashInfo do
        if v._charge>0 or v.dead then
            local x=40*k-20
            local chargeRate=v._charge/maxCharge
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
end
function techrash.event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.techrash,-300,-70)
    FONT.set(30) GC.mStr(Text.target_techrash,-300,15)
end

return techrash
