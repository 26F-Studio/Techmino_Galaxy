local gc=love.graphics

---@type Techmino.Mech.mino
local techrash={}

function techrash.easy_seqType(P)
    P.modeData.bagLoop=0
    local l1={}
    local l2={}
    while true do
        -- Fill list1 (bag7 + 0~4)
        if not l1[1] then
            P.modeData.bagLoop=P.modeData.bagLoop+1
            for i=1,7 do table.insert(l1,i) end
            for _=1,
                P.modeData.bagLoop<=10 and 0 or
                P.modeData.bagLoop<=20 and 1 or
                P.modeData.bagLoop<=30 and 2 or
                P.modeData.bagLoop<=40 and 3 or
                4
            do
                -- Fill list2 (bag6)
                if not l2[1] then for i=1,6 do table.insert(l2,i) end end
                table.insert(l1,table.remove(l2,P:random(#l2)))
            end
        end
        coroutine.yield(table.remove(l1,P:random(#l1)))
    end
end
function techrash.easy_event_playerInit(P)
    P.modeData.techrash=0
    P.modeData.minH=0
end
function techrash.easy_event_afterLock(P)
    local minH=P.field:getHeight()
    for x=1,P.settings.fieldW do
        for y=P.field:getHeight(),0,-1 do
            if P.field:getCell(x,y) then
                if y<minH then minH=y end
                break
            end
        end
    end
    P.modeData.minH=minH
end
function techrash.easy_event_afterClear(P,clear)
    P:triggerEvent('afterLock') -- Force refresh
    if P.hand.name=='I' and clear.line>=4 then
        P.modeData.techrash=P.modeData.techrash+1
        local HC=P.field:getHeight()==0
        if not HC then
            HC=true
            for x=1,P.settings.fieldW do
                if #P:getConnectedCells(x,1)%4~=0 then
                    HC=false
                    break
                end
            end
        end
        if HC then P:playSound('frenzy') end
        P.modeData.bagLoop=math.max(P.modeData.bagLoop-(P.lastMovement.combo-1)*2-(HC and 2 or 0),0)
    else
        P:finish('PE')
    end
end
function techrash.easy_event_drawInField(P)
    gc.setColor(1,1,1,.26)
    for y=P.modeData.minH+4,19,4 do
        gc.rectangle('fill',0,-y*40-2,P.settings.fieldW*40,4)
    end
end
function techrash.easy_event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.techrash,-300,-70)
    FONT.set(30) GC.mStr(Text.target_techrash,-300,15)
end

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
function techrash.hard_event_playerInit(P)
    P.modeData.techrash=0
    P.modeData.chargePower=initPower
    P.modeData.sidePower=initSidePower
    P.modeData.techrashInfo=setmetatable({},infoMeta)
end
function techrash.hard_event_always(P)
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
function techrash.hard_event_afterClear(P,clear)
    if P.hand.name=='I' and clear.line==4 then
        local list=P.modeData.techrashInfo
        local x=P.handX
        if list[x].charge>=maxCharge then
            list[x].dead=true
            P:finish('PE')
        else
            for k,v in next,list do
                if k~=x then
                    v.charge=math.max(v.charge-1,0)
                end
            end
            P.modeData.techrash=P.modeData.techrash+1
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
function techrash.hard_event_drawBelowMarks(P)
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
techrash.hard_event_drawOnPlayer=techrash.easy_event_drawOnPlayer

return techrash
