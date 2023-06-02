local gc=love.graphics

--- @type Techmino.Mech.mino
local tsd={}

function tsd.easy_event_playerInit(P)
    P.modeData.tsd=0
end
function tsd.easy_event_afterClear(P,clear)
    local movement=P.lastMovement
    if P.hand.name=='T' and clear.line==2 and movement.action=='rotate' and (movement.corners or movement.immobile) then
        P.modeData.tsd=P.modeData.tsd+1
    else
        P:finish('PE')
    end
end
function tsd.easy_event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.tsd,-300,-70)
    FONT.set(30) GC.mStr(Text.target_tsd,-300,15)
end

local tsdCharge=3
local maxCharge=5

local infoMeta={__index=function(self,k)
    self[k]={charge=0,_charge=0}
    return self[k]
end}
function tsd.hard_event_playerInit(P)
    P.modeData.tsd=0
    P.modeData.tsdInfo=setmetatable({},infoMeta)
end
function tsd.hard_event_always(P)
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
function tsd.hard_event_afterClear(P,clear)
    local movement=P.lastMovement
    if P.hand.name=='T' and clear.line==2 and movement.action=='rotate' and (movement.corners or movement.immobile) then
        local list=P.modeData.tsdInfo
        local settings=P.settings
        local RS=minoRotSys[settings.rotSys]
        local minoData=RS[P.hand.shape]
        local state=minoData[P.hand.direction]
        local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(P)
        if centerPos then
            local x=P.handX+centerPos[1]-.5
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
end
function tsd.hard_event_drawBelowMarks(P)
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
tsd.hard_event_drawOnPlayer=tsd.easy_event_drawOnPlayer

return tsd
