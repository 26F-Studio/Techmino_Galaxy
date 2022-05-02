local gc=love.graphics

local touches={}

local button={}
button.__index=button
function button:new(data)
    if not data then data=NONE end
    return setmetatable({
        type='button',
        x=data.x or SCR.w0/2,
        y=data.y or SCR.h0/2,
        r=data.r or 70,
        shape=data.shape or 'circle',
        lastPressTime=-1e99,
        key=data.key or 'X',
    },self)
end
function button:reset()
    self.pressed=false
    self.touchID=false
    self.lastPressTime=-1e99
end
function button:getDistance(x,y)
    if self.shape=='circle' then
        return MATH.distance(x,y,self.x,self.y)/self.r
    elseif self.shape=='square' then
        return math.max(math.abs(x-self.x),math.abs(y-self.y))/self.r
    end
end
function button:press(_,_,id)
    self.touchID=id
    self.pressed=true
    self.lastPressTime=love.timer.getTime()
    love.keypressed(self.key)
end
function button:move()
    -- Do nothing
end
function button:drag(dx,dy)
    self.x,self.y=self.x+dx,self.y+dy
end
function button:release()
    self.pressed=false
    self.touchID=false
    love.keyreleased(self.key)
end
function button:draw(setting)
    gc.setLineWidth(4)
    FONT.set(50)
    if self.shape=='circle' then
        gc.setColor(1,1,1,self.pressed and .5 or .05)
        gc.circle('fill',self.x,self.y,self.r-4)

        gc.setColor(1,1,1)
        gc.circle('line',self.x,self.y,self.r-2)
    elseif self.shape=='square' then
        gc.setColor(1,1,1,self.pressed and .5 or .05)
        gc.rectangle('fill',self.x-self.r-4,self.y-self.r-4,self.r*2+8,self.r*2+8)

        gc.setColor(1,1,1)
        gc.rectangle('line',self.x-self.r-2,self.y-self.r-2,self.r*2+4,self.r*2+4)
    end
    if not setting then gc.setColor(1,1,1,.4) end
    GC.mStr(self.key,self.x,self.y-35)
end


local stick2way={}
stick2way.__index=stick2way
function stick2way:new(data)
    if not data then data=NONE end
    return setmetatable({
        type='stick2way',
        x=data.x or 300,
        y=data.y or 800,
        len=data.len or 320,-- Not include semicircle
        h=data.h or 160,
        touchID=false,
        state='wait',
        stickX=0,
    },self)
end
function stick2way:getDistance(x,y)
    return (
        (math.abs(x-self.x)<self.len/2 and math.abs(y-self.y)<self.h/2) or
        MATH.distance(x,y,self.x-self.len/2,self.y)<self.h/2 or
        MATH.distance(x,y,self.x+self.len/2,self.y)<self.h/2
    ) and 0 or 1e99
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
function stick2way:press(x,_,id)
    if not self.touchID then
        self.touchID=id
        self:updatePos(x)
    end
end
function stick2way:move(x,_,_)
    self:updatePos(x)
end
function stick2way:drag(dx,dy)
    self.x,self.y=self.x+dx,self.y+dy
end
function stick2way:release()
    if self.touchID then
        self.touchID=false
        self:updatePos()
    end
end
function stick2way:reset()
    self.touchID=false
    self.state='wait'
    self.stickX=0
end
function stick2way:draw(setting)
    gc.setLineWidth(4)
    gc.setColor(1,1,1)
    gc.rectangle('line',self.x-self.len/2-self.h/2,self.y-self.h/2,self.len+self.h,self.h,self.h/2)
    if setting then
        gc.circle('line',self.x,self.y,self.h/2-10)
        gc.setColor(1,1,1,self.touchID and .5 or .05)
        gc.rectangle('fill',self.x-self.len/2-self.h/2,self.y-self.h/2,self.len+self.h,self.h,self.h/2)
    else
        gc.circle('line',self.x+self.stickX*self.len/2,self.y,self.h/2-10)
        gc.setColor(1,1,1,self.touchID and .5 or .05)
        gc.circle('fill',self.x+self.stickX*self.len/2,self.y,self.h/2-12)
    end
end

local VCTRL={
    stick2way:new{x=300,y=800},
    button:new{x=1150,y=800,r=70,shape='circle',key='vk_1'},
    button:new{x=1300,y=800,r=70,shape='circle',key='vk_2'},
    button:new{x=1450,y=800,r=70,shape='circle',key='vk_3'},
    button:new{x=1300,y=650,r=70,shape='circle',key='vk_4'},
    button:new{x=1450,y=650,r=70,shape='circle',key='vk_5'},
    button:new{x=1450,y=500,r=70,shape='circle',key='vk_6'},
}
VCTRL.focus=false

function VCTRL.reset()
    touches={}
    VCTRL.focus=false
    for i=1,#VCTRL do
        VCTRL[i]:reset()
    end
end

function VCTRL.press(x,y,id)
    local obj,closestDist=false,1e99
    for i=1,#VCTRL do
        local d=VCTRL[i]:getDistance(x,y)
        if d<=1 and d<closestDist then
            obj,closestDist=VCTRL[i],d
        end
    end
    if obj then
        touches[id]=obj
        obj:press(x,y,id)
        VCTRL.focus=obj
    end
end

function VCTRL.move(x,y,id)
    if touches[id] then
        touches[id]:move(x,y)
    end
end

function VCTRL.drag(dx,dy,id)
    if touches[id] then
        touches[id]:drag(dx,dy)
    end
end

function VCTRL.release(id)
    if touches[id] then
        touches[id]:release()
    end
    touches[id]=nil
end

function VCTRL.draw(setting)
    for i=1,#VCTRL do
        VCTRL[i]:draw(setting)
    end
end

function VCTRL.addButton()
    local k=1
    repeat
        local flag
        for i=1,#VCTRL do
            if VCTRL[i].type=='button' and VCTRL[i].key=='vk_'..k then
                k=k+1
                flag=true
            end
        end
    until not flag
    table.insert(VCTRL,button:new{x=SCR.w0/2,y=SCR.h0/2,r=70,shape='circle',key='vk_'..k})
end

function VCTRL.removeButton()
    if VCTRL.focus and VCTRL.focus.type=='button' then
        table.remove(VCTRL,TABLE.find(VCTRL,VCTRL.focus))
    else
        for i=#VCTRL,1,-1 do
            if VCTRL[i].type=='button' then
                table.remove(VCTRL,i)
                return
            end
        end
    end
end

function VCTRL.importSettings(data)
    -- TODO
end

function VCTRL.exportSettings()
    -- TODO
end

return VCTRL