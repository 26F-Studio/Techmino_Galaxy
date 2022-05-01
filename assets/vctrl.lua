local abs=math.abs
local max=math.max

local gc=love.graphics

local touches={}

local buttons={
    {x=1150,y=800,r=70,shape='circle',lastPressTime=-1e99},
    {x=1300,y=800,r=70,shape='circle',lastPressTime=-1e99},
    {x=1450,y=800,r=70,shape='circle',lastPressTime=-1e99},
    {x=1300,y=650,r=70,shape='circle',lastPressTime=-1e99},
    {x=1450,y=650,r=70,shape='circle',lastPressTime=-1e99},
    {x=1450,y=500,r=70,shape='circle',lastPressTime=-1e99},
}
function buttons:new(data)
    if not data then data=NONE end
    return {
        x=data.x or SCR.w0/2,
        y=data.y or SCR.h0/2,
        r=data.r or 70,
        shape=data.shape or 'circle',
        lastPressTime=-1e99,
    }
end
function buttons:reset()
    for i=1,#self do
        local v=self[i]
        v.pressed=false
        v.touchID=false
        v.lastPressTime=-1e99
    end
end
function buttons:draw(setting)
    gc.setLineWidth(4)
    FONT.set(50)
    for i=1,#self do
        local b=self[i]
        if b.shape=='circle' then
            gc.setColor(1,1,1,b.pressed and .5 or .05)
            gc.circle('fill',b.x,b.y,b.r-4)

            gc.setColor(1,1,1)
            gc.circle('line',b.x,b.y,b.r-2)
        elseif b.shape=='rectangle' then
            gc.setColor(1,1,1,b.pressed and .5 or .05)
            gc.rectangle('fill',b.x-b.r-4,b.y-b.r-4,b.r*2+8,b.r*2+8)

            gc.setColor(1,1,1)
            gc.rectangle('line',b.x-b.r-2,b.y-b.r-2,b.r*2+4,b.r*2+4)
        end
        if not setting then gc.setColor(1,1,1,.4) end
        GC.mStr(i,b.x,b.y-35)
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
function stick2way:drag(dx,dy)
    self.x,self.y=self.x+dx,self.y+dy
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
function stick2way:draw(setting)
    gc.setLineWidth(4)
    if setting then
        gc.setColor(1,1,1)
        gc.rectangle('line',self.x-self.len/2-self.h/2,self.y-self.h/2,self.len+self.h,self.h,self.h/2)
        gc.circle('line',self.x,self.y,self.h/2-10)
        gc.setColor(1,1,1,self.touchID and .5 or .05)
        gc.rectangle('fill',self.x-self.len/2-self.h/2,self.y-self.h/2,self.len+self.h,self.h,self.h/2)
    else
        gc.setColor(1,1,1)
        gc.rectangle('line',self.x-self.len/2-self.h/2,self.y-self.h/2,self.len+self.h,self.h,self.h/2)
        gc.circle('line',self.x+self.stickX*self.len/2,self.y,self.h/2-10)
        gc.setColor(1,1,1,self.touchID and .5 or .05)
        gc.circle('fill',self.x+self.stickX*self.len/2,self.y,self.h/2-12)
    end
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
            local d
            if b.shape=='circle' then
                d=MATH.distance(x,y,b.x,b.y)/b.r
            elseif b.shape=='rectangle' then
                d=max(abs(x-b.x),abs(y-b.y))/b.r
            end
            if d<=1 and d<closestDist then
                closestID,closestDist=i,d
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

function VCTRL.drag(dx,dy,id)
    if type(touches[id])=='number' then
        local b=buttons[touches[id]]
        b.x,b.y=b.x+dx,b.y+dy
    elseif touches[id]=='stick2way' then
        stick2way:drag(dx,dy)
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

function VCTRL.draw(setting)
    if setting then
        buttons:draw(true)
        stick2way:draw(true)
    else
        buttons:draw()
        stick2way:draw()
    end
end

function VCTRL.set(method,args)
    if method=='button' then
        if args=='add' then
            if #buttons<26 then
                table.insert(buttons,buttons:new())
            end
        elseif args=='remove' then
            if #buttons>0 then
                table.remove(buttons)
            end
        end
    end
end

function VCTRL.importSettings(data)
    -- TODO
end

function VCTRL.iexportSettings()
    -- TODO
end

return VCTRL