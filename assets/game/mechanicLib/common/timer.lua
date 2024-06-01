local ins,rem=table.insert,table.remove
local gc=love.graphics

local floatMixList={.3,.7,.9,.7,.6,.5,.42,.36,.3} -- Alpha curve of 'float' timer text, right-to-left

---@alias mechLib.common.timer.style 'info'|'float'
local timer_drawFunc={
    info=function(P,time,time0)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(75)
        local text=("%.1f"):format(time/1000)
        gc.setColor(COLOR.lD)
        GC.mStr(text,-298,-33)
        local t=time/time0
        gc.setColor(1.7-1.7*t,3+2*t,.3)
        GC.mStr(text,-300,-35)
    end,
    float=function(_,time,time0)
        FONT.set(100,'bold')
        local text=("%.1f"):format(time/1000)
        local alpha=MATH.listLerp(floatMixList,time/time0)
        gc.setColor(0,0,0,alpha)
        GC.mStr(text,-2,-69,'center')
        GC.mStr(text,-1,-68,'center')
        gc.setColor(1,1,1,alpha)
        GC.mStr(text,0,-70,'center')
    end,
}

---@type Map<Techmino.Event>
local timer={}

---@param time number milliseconds
---@param prop {timeUp:function, draw?:mechLib.common.timer.style|function, cancel?:(fun():boolean), alwaysTiming:boolean}
function timer.new(P,time,prop)
    if not P.modeData.timerList then
        P.modeData.timerList={}
        P:addEvent('always',timer.event_always)
        P:addEvent('drawOnPlayer',timer.event_drawOnPlayer)
    end
    if type(prop.draw)=='string' then
        prop.draw=timer_drawFunc[prop.draw]
    end
    ins(P.modeData.timerList,{
        time=time,
        time0=time,
        timeUpFunc=prop.timeUp,
        drawFunc=prop.draw,
        cancelFunc=prop.cancel,
        alwaysTiming=prop.alwaysTiming,
    })
end

function timer.event_always(P)
    local list=P.modeData.timerList
    if not list then return end
    local i=1
    while list[i] do
        local t=list[i]
        local willRemove
        if t.cancelFunc then
            if t.cancelFunc(P,t.time,t.time0) then
                willRemove=true
            elseif t.alwaysTiming or P.timing then
                t.time=t.time-1
                if t.time<=0 then
                    t.timeUpFunc(P)
                end
            end
        elseif t.alwaysTiming or P.timing then
            t.time=t.time-1
            if t.time<=0 then
                t.timeUpFunc(P)
                willRemove=true
            end
        end
        if willRemove then
            rem(list,i)
            if #list==0 then
                P.modeData.timerList=nil
                P:delEvent('always',timer.event_always)
                P:delEvent('drawOnPlayer',timer.event_drawOnPlayer)
                return
            end
        else
            i=i+1
        end
    end
end

function timer.event_drawOnPlayer(P)
    local l=P.modeData.timerList
    if not l then return end
    local i=1
    while l[i] do
        local t=l[i]
        if t.drawFunc then t.drawFunc(P,t.time,t.time0) end
        i=i+1
    end
end

return timer
