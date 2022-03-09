local gc=love.graphics

local function NI(method) error("basePlayer's method '"..method.."' not implemented!") end
local BP={}

--------------------------------------------------------------
-- System Event
function BP:press(act)
    for i=1,#self.pressEventList do
        self.pressEventList[i](self,act)
    end
end
function BP:release(act)
    for i=1,#self.releaseEventList do
        self.releaseEventList[i](self,act)
    end
end
function BP:update(dt)
    for i=1,#self.updateEventList do
        self.updateEventList[i](self,dt)
    end
end
function BP:draw()
    gc.push('transform')
    for i=1,#self.drawEventList do
        self.drawEventList[i](self)
    end
    gc.pop()
end
--------------------------------------------------------------
-- Builder
function BP.new(data)
    assert(type(data)=='table',"function PLAYER.new(data): data must be table")

    local p={}
    setmetatable(p,{__index=BP})

    assert(type(data.id)=='number',"function PLAYER.new(data): need data.id")
    p.id=data.id

    p.pressEventList={}
    p.releaseEventList={}
    p.updateEventList={}
    p.drawEventList={}

    return p
end
--------------------------------------------------------------

return BP
