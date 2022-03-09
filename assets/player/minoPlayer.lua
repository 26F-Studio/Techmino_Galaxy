local gc=love.graphics

local ins,rem=table.insert,table.remove

local MP={}
setmetatable(MP,{__index=require'assets.player.basePlayer'})

--------------------------------------------------------------
-- Actions
local function _defaultPressEvent(p,act)
    if p.keyState[act] then return end
    p.keyState[act]=true
    ins(p.actionHistory,{0,act})
    p.actions[act].press(p)
end
local function _defaultPeleaseEvent(p,act)
    if not p.keyState[act] then return end
    p.keyState[act]=false
    ins(p.actionHistory,{1,act})
    p.actions[act].release(p)
end
local actions={
    moveLeft=function(p)
        -- TODO
    end,
    moveRight=function(p)
        -- TODO
    end,
    rotateCW=function(p)
        -- TODO
    end,
    rotateCCW=function(p)
        -- TODO
    end,
    rotate180=function(p)
        -- TODO
    end,
    softDrop=function(p)
        -- TODO
    end,
    sonicDrop=function(p)
        -- TODO
    end,
    hardDrop=function(p)
        -- TODO
    end,
    holdPiece=function(p)
        -- TODO
    end,

    function1=NULL,
    function2=NULL,
    function3=NULL,
    function4=NULL,

    target1=NULL,
    target2=NULL,
    target3=NULL,
    target4=NULL,

    fastLeft=function(p)
        -- TODO
    end,
    fastRight=function(p)
        -- TODO
    end,
    dropLeft=function(p)
        -- TODO
    end,
    dropRight=function(p)
        -- TODO
    end,
    zangiLeft=function(p)
        -- TODO
    end,
    zangiRight=function(p)
        -- TODO
    end,
}
local function _getActionObj(a)
    if type(a)=='string' then
        return actions[a]
    elseif type(a)=='function' then
        return {
            press=a,
            release=NULL,
        }
    elseif type(a)=='table' then
        return {
            press=a.press,
            release=a.release,
        }
    else
        error("Invalid action: should be function or table contain 'press' and 'release' fields")
    end
end
for k,v in next,actions do actions[k]=_getActionObj(v) end
local actionPacks={
    classic={
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'softDrop',
    },
    modern={
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'rotate180',
        'softDrop',
        'sonicDrop',
        'hardDrop',
        'holdPiece',
    },
}
--------------------------------------------------------------
-- Updates
local updateFuncs={
    _=function(self,dt)
        -- TODO
    end
}
--------------------------------------------------------------
-- Draws
local drawEvents={}
function drawEvents.applyPos(self)
    gc.translate(self.pos.x,self.pos.y)
    gc.scale(self.pos.kx,self.pos.ky)
    gc.rotate(self.pos.angle)
end
function drawEvents.board(self)
    gc.setColor(1,1,1)
    gc.setLineWidth(2)
    gc.rectangle('line',-202,-402,404,804)
    local f=self.field
    for y=1,#f do
        for x=1,#f[y] do
            if f[y][x] then
                gc.rectangle('fill',-200+(x-1)*40,400-y*40,40,40)
            end
        end
    end
end
function drawEvents.field(self)
    --TODO
end
function drawEvents.ghost(self)
    --TODO
end
function drawEvents.block(self)
    --TODO
end
function drawEvents.hold(self)
    --TODO
end
function drawEvents.next(self)
    --TODO
end
--------------------------------------------------------------
-- Useful methods
function MP:setPosition(x,y,kx,ky,angle)
    self.pos.x=x or self.pos.x
    self.pos.y=y or self.pos.y
    self.pos.kx=kx or self.pos.kx
    self.pos.ky=ky or self.pos.ky
    self.pos.angle=angle or self.pos.angle
end
function MP:movePosition(dx,dy,kx,ky,da)
    self.pos.x=self.pos.x+(dx or 0)
    self.pos.y=self.pos.y+(dy or 0)
    self.pos.kx=self.pos.kx*(kx or 1)
    self.pos.ky=self.pos.ky*(ky or 1)
    self.pos.angle=self.pos.angle+(da or 0)
end
--------------------------------------------------------------
-- Builder
function MP.new(data)
    assert(type(data)=='table',"function PLAYER.new(data): data must be table")
    local p=require'assets.player.basePlayer'.new(data)

    p.pos={
        x=0,y=0,
        kx=1,ky=1,
        angle=0,
    }

    p.field=require'assets.player.minoField'.new(data.field or NONE)
    p.holdQueue={}
    p.nextQueue={}

    p.actionHistory={}

    do-- Generate available actions
        p.actions={}
        local pack=data.actionPack or 'modern'
        if type(pack)=='string' then
            pack=actionPacks[pack]
            assert(pack,STRING.repD("Invalid actionPack '$1'",pack))
            for i=1,#pack do
                p.actions[pack[i]]=_getActionObj(pack[i])
            end
        elseif type(pack)=='table' then
            for k,v in next,pack do
                if type(k)=='number' then
                    p.actions[v]=_getActionObj(v)
                elseif type(k)=='string' then
                    assert(actions[k],STRING.repD("function PLAYER.new(data): no action called '$1'",k))
                    p.actions[k]=_getActionObj(v)
                else
                    error(STRING.repD("Invalid actionPack table's key type ($1)",type(k)))
                end
            end
        else
            error("function PLAYER.new(data): data.actionPack must be string or table")
        end

        p.keyState={}
        for k in next,p.actions do
            p.keyState[k]=false
        end
    end

    ins(p.pressEventList,_defaultPressEvent)
    ins(p.releaseEventList,_defaultPeleaseEvent)

    -- ins(p.updateEventList,updateFuncs[?])
    ins(p.drawEventList,drawEvents.applyPos)
    ins(p.drawEventList,drawEvents.board)
    ins(p.drawEventList,drawEvents.field)
    ins(p.drawEventList,drawEvents.ghost)
    ins(p.drawEventList,drawEvents.block)
    ins(p.drawEventList,drawEvents.hold)
    ins(p.drawEventList,drawEvents.next)

    setmetatable(p,{__index=MP})
    return p
end
--------------------------------------------------------------

return MP
