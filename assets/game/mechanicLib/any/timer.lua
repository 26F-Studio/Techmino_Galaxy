local ins,rem=table.insert,table.remove
local gc=love.graphics

local floatMixList={.15,.35,.45,.35,.3,.25,.21,.18,.15}-- Alpha curve of 'float' timer text, right-to-left

--- @alias mechLib.any.timer.style 'info'|'float'
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
        local alpha=MATH.listMix(floatMixList,time/time0)
        gc.setColor(0,0,0,alpha/2)
        GC.mStr(text,-2,-69,'center')
        GC.mStr(text,-1,-68,'center')
        gc.setColor(1,1,1,alpha)
        GC.mStr(text,0,-70,'center')
    end,
}

local timer={}

--- @param time number @milliseconds
--- @param timeUp function @function(P) called when time is up
--- @param draw? mechLib.any.timer.style|function @name of style or function(P,time,time0)
--- @param cancel? function @function(P,time,time0), manually control when to disappear (return true)
function timer.new(P,time,timeUp,draw,cancel)
    if not P.modeData.timerList then
        P.modeData.timerList={}
        P:addEvent('always',timer.event_always)
        P:addEvent('drawOnPlayer',timer.event_drawOnPlayer)
    end
    if type(draw)=='string' then
        draw=timer_drawFunc[draw]
    end
    ins(P.modeData.timerList,{
        time=time,
        time0=time,
        timeUpFunc=timeUp,
        drawFunc=draw,
        cancelFunc=cancel,
    })
end

function timer.event_always(P)
    if not P.timing then return end
    local list=P.modeData.timerList
    if not list then return end
    local i=1
    while list[i] do
        local willRemove
        local t=list[i]
        if t.cancelFunc then
            if t.cancelFunc(P,t.time,t.time0) then
                willRemove=true
            else
                t.time=t.time-1
                if t.time<=0 then
                    t.timeUpFunc(P)
                end
            end
        else
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
