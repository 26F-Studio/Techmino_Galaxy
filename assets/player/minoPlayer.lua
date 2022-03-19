local gc=love.graphics

local max,min=math.max,math.min
local int,abs=math.floor,math.abs
local sin,cos=math.sin,math.cos

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
-- Events
function MP:gameover(reason)
    error(reason)
    if reason=='AC' then-- Win
        -- TODO
    elseif reason=='WA' then-- Block out
        -- TODO
    elseif reason=='CE' then-- Lock out
        -- TODO
    elseif reason=='MLE' then-- Top out
        -- TODO
    elseif reason=='TLE' then-- Time out
        -- TODO
    elseif reason=='OLE' then-- Finesse fault
        -- TODO
    elseif reason=='ILE' then-- Ran out pieces
        -- TODO
    elseif reason=='PE' then-- Mission failed
        -- TODO
    elseif reason=='RE' then-- Other reason
        -- TODO
    end
end
function MP:popNext()
    if self.nextQueue[1]then-- Most cases there is pieces in next queue
        self.hand=rem(self.nextQueue,1)
    elseif self.holdQueue[1]then-- If no nexts, force using hold
        self:hold(true,true)
    else-- If no piece to use, Next queue is empty, game over...?
        self:gameover('ILE')
    end
end
function MP:lock()
    local M=self.hand.matrix
    local F=self.field.array
    for y=1,#M do
        for x=1,#M[1] do
            F[self.handY+y-1][self.handX+x-1]=M[y][x]
        end
    end
end
function MP:checkField()
    local lineClear={}
    local w=self.width
    local F=self.field.array
    for y=#F,1,-1 do
        local hasHole
        for x=1,w do
            if not F[y][x] then
                hasHole=true
                break
            end
        end
        if not hasHole then
            rem(F,y)
            ins(lineClear,y)
        end
    end
    if #lineClear>0 then
        ins(self.clearHistory,{
            lines=lineClear,
        })
    end
end
function MP:minoDropped()
    self.spawnTimer=self.settings.spawnDelay
end
--------------------------------------------------------------
-- Updates
function MP:update(dt)
    local df=int(self.curTime+dt*1000)-int(self.curTime)
    self.curTime=self.curTime+dt*1000

    local l=self.task
    while df>0 do
        -- local closestTime=1e99
        -- for i=1,#l do
        --     closestTime=min(l[i].wait(self),closestTime)
        --     if closestTime<=0 then
        --         error(('Invalid counter in task "$1"'):repD(l[i].name))
        --     end
        -- end
        -- if closestTime<=df then
        --     self.timer=self.timer+closestTime-1
        --     for i=1,#l do l[i].func(self,closestTime-1) end
        --     self.timer=self.timer+1
        --     for i=1,#l do l[i].func(self,1) end
        --     df=df-closestTime
        -- else
        --     self.timer=self.timer+dt
        --     for i=1,#l do l[i].func(self,df) end
        --     break-- df=0
        -- end
        for i=1,#l do l[i].func(self,1) end
        df=df-1
    end
end
local updTasks={}
updTasks.dropTimer={
    name='dropTimer',
    wait=function(self)
        -- TODO
    end,
    func=function(self,df)
        if self.spawnTimer>0 then
            self.spawnTimer=self.spawnTimer-df
            if self.spawnTimer==0 then
                self:popNext()
                self.genNext()
                return
            end
        end
        if self.handY==self.ghostY then
            self.lockTimer=self.lockTimer-1
            if self.lockTimer==0 then
                self:lock()
                self:minoDropped()
                self:checkField()
                print('lock')
            end
            return
        else
            self.dropTimer=self.dropTimer-1
            if self.dropTimer==0 then
                self.handY=self.handY-1
                self.dropTimer=self.settings.dropDelay
                print('drop')
            end
        end
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
    local f=self.field.array
    for y=1,#f do
        for x=1,#f[y] do
            if f[y][x] then
                gc.rectangle('fill',-200+(x-1)*40,400-y*40,40,40)
            end
        end
    end
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

    p.settings={-- Generate from template in future
        nextCount=6,
        holdCount=1,
        dropDelay=1000,
        lockDelay=1000,
        spawnDelay=1000,
        clearDelay=1000,
        das=70,
        arr=0,
        seqData={},
    }

    p.pos={
        x=0,y=0,
        kx=1,ky=1,
        angle=0,
    }

    p.field=require'assets.player.minoField'.new(data.field or NONE)
    p.holdQueue={}
    p.nextQueue={}
    p.genNext=coroutine.wrap(function()
        while true do
            coroutine.yield(1)
        end
    end)

    p.dropTimer=1000
    p.lockTimer=1000
    p.spawnTimer=1000

    p.hand={}
    p.handX=false
    p.handY=false
    p.ghostY=false
    p.handDir=false

    p.moveCharge=0

    p.curTime=0-- Real time, [double] ms
    p.timer=0-- Inside timer for player, [int] ms
    p.timing=false-- Are we timing?
    p.playing=false-- Did we start?

    p.clearHistory={}
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

    ins(p.drawEventList,drawEvents.applyPos)
    ins(p.drawEventList,drawEvents.board)
    ins(p.drawEventList,drawEvents.field)
    ins(p.drawEventList,drawEvents.ghost)
    ins(p.drawEventList,drawEvents.block)
    ins(p.drawEventList,drawEvents.hold)
    ins(p.drawEventList,drawEvents.next)

    p.task={}
    ins(p.task,updTasks.dropTimer)

    setmetatable(p,{__index=MP})
    return p
end
--------------------------------------------------------------

return MP
