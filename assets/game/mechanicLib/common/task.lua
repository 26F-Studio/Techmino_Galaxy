local pIndex=TABLE.pathIndex

local task={}

---@class Techmino.PlayerModeData.TaskObj
---@field id string
---@field title string
---@field desc string?
---@field progress string? progress text, like "1/10"
---@field value number 0-1
---@field valueShow number 0-1
---@field changing boolean
---@field achieved boolean
---@field achievedTimer integer

---@type Techmino.Event
function task.install(P)
    P.modeData.task={}
    P:addEvent('always',task.event_always)
    P:addEvent('drawOnPlayer',task.event_drawOnPlayer)
end

---@param P Techmino.Player
---@param id string
---@param title string
---@param desc string
---@param progress? string
---@param value? number|true
function task.add(P,id,title,desc,progress,value)
    table.insert(P.modeData.task,{
        id=id,
        title=title,
        desc=desc,
        value=value or 0,
        valueShow=value or 0,
        progress=progress,
        changing=false,
        achieved=value==true,
        achievedTimer=0,
    })
end

---@param P Techmino.Player
---@param id string
---@param value number|true
---@param progress? string
function task.set(P,id,value,progress)
    ---@type Techmino.PlayerModeData.TaskObj
    local opt
    for _,o in next,P.modeData.task do
        if o.id==id then
            opt=o
            break
        end
    end
    if not opt then return end
    if value==true then
        opt.value=1
        opt.valueShow=1
        opt.changing=false
        opt.achieved=true
        opt.achievedTimer=0
        -- for _,o in next,P.modeData.task do
        --     if o~=opt then
        --         task.set(P,o.id,0)
        --     end
        -- end
    else
        opt.value=MATH.clamp(value,0,1)
        opt.changing=opt.valueShow~=opt.value
    end
    if progress then
        opt.progress=progress
    end
end

---@type Techmino.Event
function task.event_always(P)
    local L=P.modeData.task
    for i=1,#L do
        local opt=L[i]
        if opt.changing then
            opt.valueShow=MATH.expApproach(opt.valueShow,opt.value,0.0626)
            if math.abs(opt.valueShow-opt.value)<.001 then
                opt.valueShow=opt.value
                opt.changing=false
            end
        end
        if opt.achieved then
            opt.achievedTimer=opt.achievedTimer%100+1
        end
    end
end

local w,dh,r=355,60,15
local gc=love.graphics
---@type Techmino.Event
function task.event_drawOnPlayer(P)
    ---@type Techmino.PlayerModeData.TaskObj[]
    local L=P.modeData.task
    local h=#L*dh
    local y=-h/2
    gc.push('transform')
    gc.translate(-760,y)
    GC.stc_reset()
    GC.stc_rect(0,0,w,h,r)
    gc.setColor(0,0,0,.42)
    gc.rectangle('fill',0,0,w,h)
    for i=1,#L do
        local opt=L[i]
        if opt.achieved and opt.achievedTimer<=50 then
            gc.setColor(.26,.62,.7023,.7023)
        else
            gc.setColor(.26,.62,.7023,.872)
        end
        gc.rectangle('fill',0,0,w*opt.valueShow,dh)

        gc.setColor(COLOR.L)
        FONT.set(25,'bold')
        gc.print(Text[opt.title] or opt.title,20,12)

        FONT.set(20)
        gc.printf(Text[opt.desc] or opt.title,10,5,w-20,'right')

        if opt.progress then
            FONT.set(15)
            gc.printf(opt.progress,10,dh-30,w-20,'right')
        end

        gc.translate(0,dh)
    end

    gc.setColor(COLOR.L)
    for i=1,#L-1 do
        gc.line(0,-dh*i,w,-dh*i)
    end

    GC.stc_stop()
    gc.setColor(COLOR.L)
    gc.rectangle('line',0,-h,w,h,r)
    gc.pop()
end

return task
