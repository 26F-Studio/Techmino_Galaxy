local abs=math.abs

local gc=love.graphics

local touches={}

local buttons={
    {x=1150,y=800,r=70,lastPressTime=-1e99},
    {x=1300,y=800,r=70,lastPressTime=-1e99},
    {x=1450,y=800,r=70,lastPressTime=-1e99},
    {x=1300,y=650,r=70,lastPressTime=-1e99},
    {x=1450,y=650,r=70,lastPressTime=-1e99},
    {x=1450,y=500,r=70,lastPressTime=-1e99},
}
function buttons:reset()
    for i=1,#self do
        local v=self[i]
        v.pressed=false
        v.touchID=false
        v.lastPressTime=-1e99
    end
end
function buttons:draw()
    gc.setLineWidth(4)
    local t=love.timer.getTime()
    for i=1,#self do
        local b=self[i]
        gc.setColor(1,1,1,.6)
        gc.circle('line',b.x,b.y,b.r-2)
        if t-b.lastPressTime<.26 then
            gc.setColor(1,1,1,1-(t-b.lastPressTime)/.26)
            gc.circle('line',b.x,b.y,b.r+(t-b.lastPressTime)*62)
        end

        gc.setColor(1,1,1,b.pressed and .2 or .05)
        gc.circle('fill',b.x,b.y,b.r-4)
    end
end

local stick2way={
    x=300,y=800,
    len=320,-- Not include semicircle
    h=160,
    touchID=false,
    state='wait',
    stickX=0,
}
function stick2way:isAbove(x,y)
    return
        (abs(x-stick2way.x)<stick2way.len/2 and abs(y-stick2way.y)<stick2way.h/2) or
        MATH.distance(x,y,stick2way.x-stick2way.len/2,stick2way.y)<stick2way.h/2 or
        MATH.distance(x,y,stick2way.x+stick2way.len/2,stick2way.y)<stick2way.h/2
end
function stick2way:reset()
    self.touchID=false
    self.state='wait'
    self.stickX=0
end
function stick2way:updatePos(x)
    self.stickX=x and MATH.clamp((x-self.x)/(self.len/2),-1,1) or 0
    if self.state=='wait' then
        if self.stickX>.26 then
            love.keypressed('right')
            self.state='right'
        elseif self.stickX<-.26 then
            love.keypressed('left')
            self.state='left'
        end
    elseif self.state=='right' then
        if self.stickX<.26 then
            love.keyreleased('right')
            self.state='wait'
        end
    elseif self.state=='left' then
        if self.stickX>.26 then
            love.keyreleased('left')
            self.state='wait'
        end
    end
end
function stick2way:draw()
    gc.setLineWidth(4)
    gc.setColor(1,1,1,.8)
    gc.rectangle('line',self.x-self.len/2-self.h/2,self.y-self.h/2,self.len+self.h,self.h,self.h/2)

    gc.setColor(1,1,1,.6)
    gc.circle('line',self.x+self.stickX*self.len/2,self.y,self.h/2-10)
    gc.setColor(1,1,1,self.touchID and .2 or .05)
    gc.circle('fill',self.x+self.stickX*self.len/2,self.y,self.h/2-12)
end

local VCTRL={}

function VCTRL.reset()
    TABLE.cut(touches)
    buttons:reset()
    stick2way:reset()
end

function VCTRL.press(x,y,id)
    if stick2way:isAbove(x,y) then
        if not stick2way.touchID then
            touches[id]='stick2way'
            stick2way.touchID=id
            stick2way:updatePos(x)
        end
        return true
    else
        local closestID,closestDist=false,1e99
        for i=1,#buttons do
            local b=buttons[i]
            local d=MATH.distance(x,y,b.x,b.y)
            if d<b.r and d<closestDist then
                closestID,closestDist=i,d/b.r
            end
        end
        if closestID then
            local b=buttons[closestID]
            if not b.pressed then
                touches[id]=closestID
                b.touchID=id
                b.pressed=true
                b.lastPressTime=love.timer.getTime()
                love.keypressed('vk_'..closestID)
            end
            return true
        end
    end
end

function VCTRL.move(x,y,id)
    if touches[id]=='stick2way' then
        stick2way:updatePos(x)
    end
end

function VCTRL.release(id)
    if type(touches[id])=='number' then
        local b=buttons[touches[id]]
        if b.pressed then
            b.pressed=false
            b.touchID=false
            love.keyreleased('vk_'..touches[id])
        end
    elseif touches[id]=='stick2way' then
        stick2way.touchID=false
        stick2way:updatePos()
    else
        -- ?
    end
    touches[id]=nil
end

function VCTRL.draw()
    buttons:draw()
    stick2way:draw()
end

function VCTRL.importSettings(data)
    -- TODO
end

function VCTRL.iexportSettings()
    -- TODO
end

return VCTRL