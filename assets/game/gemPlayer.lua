local gc=love.graphics

local max,min=math.max,math.min
local floor,ceil=math.floor,math.ceil
local abs,rnd=math.abs,math.random
local ins,rem=table.insert,table.remove

local sign,expApproach=MATH.sign,MATH.expApproach
local inst=SFX.playSample

local defaultSoundFunc={
    countDown=function(num)
        if num==0 then-- 6, 3+6+6
            inst('bass',.8,'A3')
            inst('lead',.9,'A4','E5','A5')
        elseif num==1 then-- 5, 3+7
            inst('bass',.9,'G3')
            inst('lead',.9,'B4','E5')
        elseif num==2 then-- 4, 6+2
            inst('bass','F3')
            inst('lead',.8,'A4','D5')
        elseif num==3 then-- 6+6
            inst('bass',.9,'A3','E4')
            inst('lead',.8,'A4')
        elseif num==4 then-- 5+7, 5
            inst('bass',.9,'G3','B3')
            inst('lead',.6,'G4')
        elseif num==5 then-- 4+6, 4
            inst('bass',.8,'F3','A3')
            inst('lead',.3,'F4')
        elseif num<=10 then
            inst('bass',2.2-num/5,'A2','E3')
        end
    end,
    move=           function() SFX.play('move')             end,
    move_failed=    function() SFX.play('move_failed')      end,
    touch=          function() SFX.play('touch',.5)         end,
    clear=function(lines)
        SFX.play(
            lines==1 and 'clear_1' or
            lines==2 and 'clear_2' or
            lines==3 and 'clear_3' or
            lines==4 and 'clear_4' or
            'clear_5'
        )
        if lines>=3 then
            BGM.set('all','highgain',.26+1/lines,0)
            BGM.set('all','highgain',1,min((lines)^1.5/5,2.6))
        end
    end,
    combo=       function() end,
    chain=       function() end,
    win=         function() SFX.play('win')         end,
    fail=        function() SFX.play('fail')        end,
}

local GP={}

--------------------------------------------------------------
-- Actions
local actions={}

function actions.swapLeft(P)
    if P.settings.swap then
        P:swap(P.swapX,P.swapY,-1,0)
    end
end
function actions.swapRight(P)
    if P.settings.swap then
        P:swap(P.swapX,P.swapY,1,0)
    end
end
function actions.swapUp(P)
    if P.settings.swap then
        P:swap(P.swapX,P.swapY,0,1)
    end
end
function actions.swapDown(P)
    if P.settings.swap then
        P:swap(P.swapX,P.swapY,0,-1)
    end
end
function actions.rotateCW(P)
    if P.settings.twistR then
        P:rotate(P.twistX,P.twistY,'R')
    end
end
function actions.rotateCCW(P)
    if P.settings.twistL then
        P:rotate(P.twistX,P.twistY,'L')
    end
end
function actions.rotate180(P)
    if P.settings.twistF then
        P:rotate(P.twistX,P.twistY,'F')
    end
end
actions.moveLeft={
    press=function(P)
        P.swapX=(P.swapX-2)%P.settings.fieldSize+1
        P.twistX=(P.twistX-2)%(P.settings.fieldSize-1)+1
    end,
    release=function(P)
    end
}
actions.moveRight={
    press=function(P)
        P.swapX=P.swapX%P.settings.fieldSize+1
        P.twistX=P.twistX%(P.settings.fieldSize-1)+1
    end,
    release=function(P)
    end
}
actions.moveUp={
    press=function(P)
        P.swapY=P.swapY%P.settings.fieldSize+1
        P.twistY=P.twistY%(P.settings.fieldSize-1)+1
    end,
    release=function(P)
    end
}
actions.moveDown={
    press=function(P)
        P.swapY=(P.swapY-2)%P.settings.fieldSize+1
        P.twistY=(P.twistY-2)%(P.settings.fieldSize-1)+1
    end,
    release=function(P)
    end
}

actions.func1=NULL
actions.func2=NULL
actions.func3=NULL
actions.func4=NULL
actions.func5=NULL
actions.func6=NULL


local function _getActionObj(a)
    if type(a)=='string' then
        return actions[a]
    elseif type(a)=='function' then
        return setmetatable({
            press=a,
            release=NULL,
        },{__call=function(self,P)
            self.press(P)
        end})
    elseif type(a)=='table' then
        assert(type(a.press)=='function' and type(a.release)=='function',"wtf why action do not contain func press() & func release()")
        return setmetatable({
            press=a.press,
            release=a.release,
        },{__call=function(self,P)
            self.press(P)
            self.release(P)
        end})
    else
        error("Invalid action: should be function or table contain 'press' and 'release' fields")
    end
end
for k,v in next,actions do actions[k]=_getActionObj(v) end
--------------------------------------------------------------
-- Effects
function GP:shakeBoard(args,v)
    local shake=self.settings.shakeness
    if args:sArg('-drop') then
        self.pos.vy=self.pos.vy+.2*shake
    elseif args:sArg('-down') then
        self.pos.dy=self.pos.dy+.1*shake
    elseif args:sArg('-right') then
        self.pos.dx=self.pos.dx+.1*shake
    elseif args:sArg('-left') then
        self.pos.dx=self.pos.dx-.1*shake
    elseif args:sArg('-cw') then
        self.pos.va=self.pos.va+.002*shake
    elseif args:sArg('-ccw') then
        self.pos.va=self.pos.va-.002*shake
    elseif args:sArg('-180') then
        self.pos.vy=self.pos.vy+.1*shake
        self.pos.va=self.pos.va+((self.handX+#self.hand.matrix[1]/2-1)/self.settings.fieldSize-.5)*.0026*shake
    elseif args:sArg('-clear') then
        self.pos.dk=self.pos.dk*(1+shake)
        self.pos.vk=self.pos.vk+.0002*shake*min(v^1.6,26)
    end
end
function GP:playSound(event,...)
    if not self.sound then return end
    if self.time-self.soundTimeHistory[event]>=15 then
        self.soundTimeHistory[event]=self.time
        if self.soundEvent[event] then
            self.soundEvent[event](...)
        else
            MES.new('warn',"Unknown sound event: "..event)
        end
    end
end
function GP:setPosition(x,y,k,a)
    self.pos.x=x or self.pos.x
    self.pos.y=y or self.pos.y
    self.pos.k=k or self.pos.k
    self.pos.a=a or self.pos.a
end
function GP:movePosition(dx,dy,k,da)
    self.pos.x=self.pos.x+(dx or 0)
    self.pos.y=self.pos.y+(dy or 0)
    self.pos.k=self.pos.k*(k or 1)
    self.pos.a=self.pos.a+(da or 0)
end
--------------------------------------------------------------
-- Game methods
function GP:triggerEvent(name,...)
    local L=self.event[name]
    if L then for i=1,#L do L[i](self,...) end end
end
function GP:isMoveAble(x,y)
    if
        x>=1 and x<=self.settings.fieldSize and
        y>=1 and y<=self.settings.fieldSize and
        1
    then
        local F=self.field
        if F[y][x] then
            return not F[y][x].clearTimer
        else
            return true
        end
    else
        return false
    end
end
function GP:swap(x,y,dx,dy)
    local F=self.field
    if
        self:isMoveAble(x,y) and self:isMoveAble(x+dx,y+dy)
    then
        F[y][x],F[y+dy][x+dx]=F[y+dy][x+dx],F[y][x]
        self:checkPosition(x,y)
        self:checkPosition(x+dx,y+dy)
    end
end
function GP:rotate(x,y,dir)
    local F=self.field
    if
        self:isMoveAble(x,y) and self:isMoveAble(x,y+1) and
        self:isMoveAble(x+1,y+1) and self:isMoveAble(x+1,y)
    then
        if dir=='R' then
            F[y][x],F[y][x+1],F[y+1][x+1],F[y+1][x]=F[y][x+1],F[y+1][x+1],F[y+1][x],F[y][x]
        elseif dir=='L' then
            F[y][x],F[y][x+1],F[y+1][x+1],F[y+1][x]=F[y+1][x],F[y][x],F[y][x+1],F[y+1][x+1]
        elseif dir=='F' then
            F[y][x],F[y][x+1],F[y+1][x+1],F[y+1][x]=F[y+1][x+1],F[y+1][x],F[y][x],F[y][x+1]
        end
        self:checkPosition(x,y)
        self:checkPosition(x+1,y)
        self:checkPosition(x+1,y+1)
        self:checkPosition(x,y+1)
    end
end
local function linkLen(F,color,x,y,dx,dy)
    local cnt=0
    x,y=x+dx,y+dy
    while F[y] and F[y][x] and F[y][x].color==color do
        x,y=x+dx,y+dy
        cnt=cnt+1
    end
    return cnt
end
function GP:checkPosition(x,y)
    local F=self.field
    if not F[y][x] then return end

    local color=F[y][x].color

    if not F[y][x].lrCnt then
        local stepX,stepY=1,0
        local left=linkLen(F,color,x,y,-stepX,-stepY)
        local right=linkLen(F,color,x,y,stepX,stepY)
        local len=1+left+right
        if len>=self.settings.linkLen then
            for i=-left,right do
                local cx,cy=x+stepX*i,y+stepY*i
                local c=F[cy] and F[cy][cx]
                if c and not c.clearTimer then
                    c.clearTimer=self.settings.clearDelay
                    c.lrCnt=len
                end
            end
        end
    end
    if not F[y][x].udCnt then
        local stepX,stepY=0,1
        local left=linkLen(F,color,x,y,-stepX,-stepY)
        local right=linkLen(F,color,x,y,stepX,stepY)
        local len=1+left+right
        if len>=self.settings.linkLen then
            for i=-left,right do
                local cx,cy=x+stepX*i,y+stepY*i
                local c=F[cy] and F[cy][cx]
                if c and not c.clearTimer then
                    c.clearTimer=self.settings.clearDelay
                    c.lrCnt=len
                end
            end
        end
    end
    if self.settings.diagonalLinkLen then
        if not F[y][x].riseCnt then
            local stepX,stepY=1,1
            local left=linkLen(F,color,x,y,-stepX,-stepY)
            local right=linkLen(F,color,x,y,stepX,stepY)
            local len=1+left+right
            if len>=self.settings.diagonalLinkLen then
                for i=-left,right do
                    local cx,cy=x+stepX*i,y+stepY*i
                    local c=F[cy] and F[cy][cx]
                    if c and not c.clearTimer then
                        c.clearTimer=self.settings.clearDelay
                        c.lrCnt=len
                    end
                end
            end
        end
        if not F[y][x].dropCnt then
            local stepX,stepY=1,-1
            local left=linkLen(F,color,x,y,-stepX,-stepY)
            local right=linkLen(F,color,x,y,stepX,stepY)
            local len=1+left+right
            if len>=self.settings.diagonalLinkLen then
                for i=-left,right do
                    local cx,cy=x+stepX*i,y+stepY*i
                    local c=F[cy] and F[cy][cx]
                    if c and not c.clearTimer then
                        c.clearTimer=self.settings.clearDelay
                        c.lrCnt=len
                    end
                end
            end
        end
    end
end
function GP:freshGems()
    local holes={}
    local F=self.field
    for y=1,self.settings.fieldSize do
        for x=1,self.settings.fieldSize do
            if not F[y][x] then
                local g={}
                F[y][x]=g
                ins(holes,g)
            end
        end
    end
    local freshTimes=0
    repeat
        for i=1,#holes do
            holes[i].color=self.seqRND:random(self.settings.colors)
        end
        freshTimes=freshTimes+1
    until freshTimes>=self.settings.refreshCount or self:hasMove()
end
function GP:hasMove()
    return true
end
function GP:changeFieldSize(w,h,origX,origY)
end
function GP:receive(data)
    local B={
        power=data.power,
        mode=data.mode,
        time0=math.floor(data.time*1000+.5),
        time=0,
        fatal=data.fatal,
        speed=data.speed,
    }
    ins(self.garbageBuffer,B)
end
function GP:finish(reason)
    --[[ Reason:
        AC:  Win
        WA:  No Moves
        CE:  /
        MLE: /
        TLE: Time out
        OLE: Invalid move
        ILE: /
        PE:  Mission failed
        RE:  Other reason
    ]]

    if self.finished then return end
    self.timing=false
    self.finished=true

    self:triggerEvent('gameOver',reason)
    GAME.checkFinish()

    -- <Temporarily>
    if self.isMain then
        MES.new(reason=='AC' and 'check' or 'error',reason,6.26)
        self:playSound(reason=='AC' and 'win' or 'fail')
    end
    -- </Temporarily>
end
--------------------------------------------------------------
-- Press & Release & Update & Render
function GP:press(act)
    self:triggerEvent('beforePress',act)

    if not self.actions[act] or self.keyState[act] then return end
    self.keyState[act]=true
    ins(self.actionHistory,{0,self.time,act})
    self.actions[act].press(self)

    self:triggerEvent('afterPress',act)
end
function GP:release(act)
    self:triggerEvent('beforeRelease',act)
    if not self.actions[act] or not self.keyState[act] then return end
    self.keyState[act]=false
    ins(self.actionHistory,{1,self.time,act})
    self.actions[act].release(self)
    self:triggerEvent('afterRelease',act)
end
function GP:update(dt)
    local df=floor((self.realTime+dt)*1000)-floor(self.realTime*1000)
    self.realTime=self.realTime+dt
    local SET=self.settings

    for _=1,df do
        -- Step game time
        if self.timing then self.gameTime=self.gameTime+1 end

        self:triggerEvent('always',1)

        -- Calculate board animation
        local O=self.pos
        --                     sticky           force          soft
        O.vx=expApproach(O.vx,0,.02)-sign(O.dx)*.0001*abs(O.dx)^1.2
        O.vy=expApproach(O.vy,0,.02)-sign(O.dy)*.0001*abs(O.dy)^1.1
        O.va=expApproach(O.va,0,.02)-sign(O.da)*.0001*abs(O.da)^1.0
        O.vk=expApproach(O.vk,0,.01)-sign(O.dk)*.0001*abs(O.dk)^1.0
        O.dx=O.dx+O.vx
        O.dy=O.dy+O.vy
        O.da=O.da+O.va
        O.dk=O.dk+O.vk

        -- Step main time & Starting counter
        if self.time<SET.readyDelay then
            self.time=self.time+1
            local d=SET.readyDelay-self.time
            if floor((d+1)/1000)~=floor(d/1000) then
                self:playSound('countDown',ceil(d/1000))
            end
            if d==0 then
                self:playSound('countDown',0)
                self:triggerEvent('gameStart')
                self.timing=true
            end
        else
            self.time=self.time+1
        end

        local F=self.field
        for y=1,self.settings.fieldSize do
            for x=1,self.settings.fieldSize do
                local g=F[y][x]
                if g then
                    if g.clearTimer then
                        g.clearTimer=g.clearTimer-1
                        if g.clearTimer==0 then
                            F[y][x]=false
                        end
                    end
                end
            end
        end

        -- Update garbage
        for i=1,#self.garbageBuffer do
            local g=self.garbageBuffer[i]
            if g.mode==0 and g.time<g.time0 then
                g.time=g.time+1
            end
        end
    end
    for _,v in next,self.particles do v:update(dt) end
    self.texts:update(dt)
end
function GP:render()
    local settings=self.settings
    local skin=SKIN.get(settings.skin)
    SKIN.time=self.time

    gc.push('transform')

    -- applyPlayerTransform
    gc.translate(self.pos.x,self.pos.y)
    gc.scale(self.pos.k*(1+self.pos.dk))
    gc.translate(self.pos.dx,self.pos.dy)
    gc.rotate(self.pos.a+self.pos.da)

    -- applyFieldTransform
    gc.push('transform')
    gc.translate(-360,360)

    -- startFieldStencil
    GC.stc_setComp()
    GC.stc_rect(0,0,720,-720)
    gc.scale(16/settings.fieldSize)


        self:triggerEvent('drawBelowField')


        -- Grid & Cells
        skin.drawFieldBackground(settings.fieldSize)
        skin.drawFieldCells(self.field)


        self:triggerEvent('drawInField')


    -- stopFieldStencil
    GC.stc_stop()

    -- Particles
    gc.setColor(1,1,1)
    gc.draw(self.particles.star)
    gc.draw(self.particles.trail)

    -- Cursor(s)
    if self.settings.swap then
        skin.drawSwapCursor(self.swapX,self.swapY)
    end
    if self.settings.twistR then
        skin.drawTwistCursor(self.twistX,self.twistY)
    end

    -- popFieldTransform
    gc.pop()

    -- Field border
    skin.drawFieldBorder()

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()


    self:triggerEvent('drawOnPlayer')


    -- Starting counter
    if self.time<settings.readyDelay then
        skin.drawStartingCounter(settings.readyDelay)
    end

    gc.pop()
end
--------------------------------------------------------------
-- Builder
local baseEnv={
    fieldSize=8,

    readyDelay=3000,
    swapDelay=1000,
    spinDelay=1000,
    clearDelay=200,
    fallDelay=100,

    atkSys='None',

    colors=7,
    linkLen=3,
    diagonalLinkLen=false,
    refreshCount=0,

    swap=true,
    swapForce=true,
    twistR=true,twistL=false,twistF=false,
    spinForce=false,

    skin='gem_default',

    shakeness=.26,
}
local modeDataMeta={
    __index=function(self,k) rawset(self,k,0) return 0 end,
    __newindex=function(self,k,v) rawset(self,k,v) end,
    __metatable=true,
}
local soundTimeMeta={
    __index=function(self,k) rawset(self,k,0) return -1e99 end,
    __metatable=true,
}
local soundEventMeta={
    __index=defaultSoundFunc,
    __metatable=true,
}
function GP.new()
    local self=setmetatable({},{__index=GP,__metatable=true})
    self.sound=false
    self.settings=TABLE.copy(baseEnv)
    self.event={
        -- Press & Release
        beforePress={},
        afterPress={},
        beforeRelease={},
        afterRelease={},

        -- Start & End
        playerInit={},
        gameStart={},
        gameOver={},

        -- Drop
        afterSpawn={},
        afterDrop={},
        afterLock={},
        afterClear={},

        -- Update
        always={},

        -- Graphics
        drawBelowField={},
        drawBelowBlock={},
        drawBelowMarks={},
        drawInField={},
        drawOnPlayer={},
    }

    return self
end
function GP:loadSettings(settings)
    -- Load data & events from mode settings
    for k,v in next,settings do
        if k=='event' then
            for name,E in next,v do
                assert(self.event[name],"Wrong event key: '"..tostring(name).."'")
                if type(E)=='table' then
                    for i=1,#E do
                        ins(self.event[name],E[i])
                    end
                elseif type(E)=='function' then
                    ins(self.event[name],E)
                end
            end
        elseif k=='soundEvent' then
            for name,E in next,v do
                if type(E)=='function' then
                    self.soundEvent[name]=E
                else
                    error("soundEvent must be function")
                end
            end
        else
            if type(v)=='table' then
                self.settings[k]=TABLE.copy(v)
            elseif v~=nil then
                self.settings[k]=v
            end
        end
    end
end
function GP:initialize()
    self.soundEvent=setmetatable({},soundEventMeta)
    self.modeData=setmetatable({},modeDataMeta)
    self.soundTimeHistory=setmetatable({},soundTimeMeta)

    self.rcvRND=love.math.newRandomGenerator(GAME.seed+434)
    self.seqRND=love.math.newRandomGenerator(GAME.seed+231)

    self.pos={
        x=0,y=0,k=1,a=0,

        dx=0,dy=0,dk=0,da=0,
        vx=0,vy=0,vk=0,va=0,
    }

    self.finished=false -- Did game finish
    self.realTime=0     -- Real time, [float] s
    self.time=0         -- Inside timer for player, [int] ms
    self.gameTime=0     -- Game time of player, [int] ms
    self.timing=false   -- Is gameTime running?

    self.field={}
    for y=1,self.settings.fieldSize do
        self.field[y]=TABLE.new(false,self.settings.fieldSize)
    end
    self:freshGems()

    self.swapX,self.swapY=1,1
    self.twistX,self.twistY=1,1

    self.garbageBuffer={}

    self.actionHistory={}
    self.keyBuffer={
        move=false,
        rotate=false,
        hardDrop=false,
    }
    self.texts=TEXT.new()

    -- Generate available actions
    do
        self.actions={}
        for k in next,actions do
            self.actions[k]=_getActionObj(k)
        end

        self.keyState={}
        for k in next,self.actions do
            self.keyState[k]=false
        end
    end

    self.particles={}
    for k,v in next,particleTemplate do
        self.particles[k]=v:clone()
    end
end
--------------------------------------------------------------

return GP
