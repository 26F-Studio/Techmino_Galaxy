local gc=love.graphics

local max,min=math.max,math.min
local floor=math.floor
local rnd=math.random
local ins,rem=table.insert,table.remove

local inst=SFX.playSample

local PP=setmetatable({},{__index=require'assets.game.basePlayer'})

--------------------------------------------------------------
-- Function tables
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
    rotate=         function() SFX.play('rotate')           end,
    initrotate=     function() SFX.play('initrotate')       end,
    rotate_failed=  function() SFX.play('rotate_failed')    end,
    rotate_special= function() SFX.play('rotate_special')   end,
    touch=          function() SFX.play('touch',.5)         end,
    drop=           function() SFX.play('drop')             end,
    lock=           function() SFX.play('lock')             end,
    clear=function(lines)
        SFX.play(
            lines==1 and 'clear_1' or
            lines==2 and 'clear_2' or
            lines==3 and 'clear_3' or
            lines==4 and 'clear_4' or
            'clear_5'
        )
    end,
    chain=setmetatable({
        function() inst('bass',.70,'A2') end,-- 1 chain
        function() inst('bass',.75,'C3') end,-- 2 chain
        function() inst('bass',.80,'D3') end,-- 3 chain
        function() inst('bass',.85,'E3') end,-- 4 chain
        function() inst('bass',.90,'G3') end,-- 5 chain
        function() inst('bass',.90,'A3') inst('lead',.20,'A2') end,-- 6 chain
        function() inst('bass',.75,'C4') inst('lead',.40,'C3') end,-- 7 chain
        function() inst('bass',.60,'D4') inst('lead',.60,'D3') end,-- 8 chain
        function() inst('bass',.40,'E4') inst('lead',.75,'E3') end,-- 9 chain
        function() inst('bass',.20,'G4') inst('lead',.90,'G3') end,-- 10 chain
        function() inst('bass',.20,'A4') inst('lead',.85,'A3') end,-- 11 chain
        function() inst('bass',.40,'A4') inst('lead',.80,'C4') end,-- 12 chain
        function() inst('bass',.60,'A4') inst('lead',.75,'D4') end,-- 13 chain
        function() inst('bass',.75,'A4') inst('lead',.70,'E4') end,-- 14 chain
        function() inst('bass',.90,'A4') inst('lead',.65,'G4') end,-- 15 chain
        function() inst('bass',.90,'A4') inst('bass',.70,'E5') inst('lead','A4') end,-- 16 chain
        function() inst('bass',.85,'A4') inst('bass',.75,'E5') inst('lead','C5') end,-- 17 chain
        function() inst('bass',.80,'A4') inst('bass',.80,'E5') inst('lead','D5') end,-- 18 chain
        function() inst('bass',.75,'A4') inst('bass',.85,'E5') inst('lead','E5') end,-- 19 chain
        function() inst('bass',.70,'A4') inst('bass',.90,'E5') inst('lead','G5') end,-- 20 chain
    },{__call=function(self,chain)
        if self[chain] then
            self[chain]()
        else
            inst('bass',.626,'A4')
            local phase=(chain-21)%12
            inst('lead',1-((11-phase)/12)^2,41+phase)-- E4+
            inst('lead',1-((11-phase)/12)^2,46+phase)-- A4+
            inst('lead',1-(phase/12)^2,     53+phase)-- E5+
            inst('lead',1-(phase/12)^2,     58+phase)-- A5+
        end
    end,__metatable=true}),
    frenzy=      function() SFX.play('frenzy')      end,
    allClear=    function() SFX.play('all_clear')   end,
    suffocate=   function() SFX.play('suffocate')   end,
    desuffocate= function() SFX.play('desuffocate') end,
    reach=       function() SFX.play('beep_rise')      end,
    win=         function() SFX.play('win')         end,
    fail=        function() SFX.play('fail')        end,
}
PP.scriptCmd={
}
--------------------------------------------------------------
-- Actions
local actions={}
actions.moveLeft={
    press=function(P)
        P.moveDir=-1
        P.moveCharge=0
        if P.hand then
            if P:moveLeft() then
                P:playSound('move')
                if P.handY==P.ghostY then
                    P:playSound('touch')
                end
            else
                P:playSound('move_failed')
            end
        else
            P.keyBuffer.move='L'
        end
    end,
    release=function(P)
        if P.keyBuffer.move=='L' then P.keyBuffer.move=false end
        if P.deathTimer then P:moveRight() end
    end
}
actions.moveRight={
    press=function(P)
        P.moveDir=1
        P.moveCharge=0
        if P.hand then
            if P:moveRight() then
                P:playSound('move')
                if P.handY==P.ghostY then
                    P:playSound('touch')
                end
            else
                P:playSound('move_failed')
            end
        else
            P.keyBuffer.move='R'
        end
    end,
    release=function(P)
        if P.keyBuffer.move=='R' then P.keyBuffer.move=false end
        if P.deathTimer then P:moveLeft() end
    end
}
actions.rotateCW={
    press=function(P)
        if P.hand then
            P:rotate('R')
        else
            P.keyBuffer.rotate='R'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='R' then P.keyBuffer.rotate=false end
    end
}
actions.rotateCCW={
    press=function(P)
        if P.hand then
            P:rotate('L')
        else
            P.keyBuffer.rotate='L'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='L' then P.keyBuffer.rotate=false end
    end
}
actions.rotate180={
    press=function(P)
        if P.hand then
            P:rotate('F')
        else
            P.keyBuffer.rotate='F'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='F' then P.keyBuffer.rotate=false end
    end
}
function actions.softDrop(P)
    P.downCharge=0
    if not P.hand or P.deathTimer then return end
    if P.handY>P.ghostY then
        if P:moveDown() then
            P:playSound('move')
        end
    end
end
actions.hardDrop={
    press=function(P)
        if P.hand and not P.deathTimer then
            P:puyoDropped()
        else
            P.keyBuffer.hardDrop=true
        end
    end,
    release=function(P)
        P.keyBuffer.hardDrop=false
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
function PP:createMoveParticle(x1,y1,x2,y2)
    local p=self.particles.star
    p:setParticleLifetime(.26,.5)
    p:setEmissionArea('none')
    for x=x1,x2,x2>x1 and 1 or -1 do for y=y1,y2,y2>y1 and 1 or -1 do
        p:setPosition(
            (x+rnd()*#self.hand.matrix[1]-1)*40,
            -(y+rnd()*#self.hand.matrix-1)*40
        )
        p:emit(1)
    end end
end
function PP:createClearParticle(x,y)
    local p=self.particles.star
    p:setParticleLifetime(.26,.626)
    p:setEmissionArea('ellipse',30,30,0,true)
    p:setPosition(40*x-20,-40*y+20)
    p:emit(6)
end
function PP:createLockParticle(x,y)
    local p=self.particles.trail
    p:setPosition(
        (x+#self.hand.matrix[1]/2-1)*40,
        -(y+#self.hand.matrix/2-1)*40
    )
    p:emit(1)
end
--------------------------------------------------------------
-- Game methods
function PP:moveHand(action,a,b,c)
    if action=='moveX' then
        self:createMoveParticle(self.handX,self.handY,self.handX+a,self.handY)
        self.handX=self.handX+a
    elseif action=='drop' or action=='moveY' then
        self:createMoveParticle(self.handX,self.handY,self.handX,self.handY+a)
        self.handY=self.handY+a
    elseif action=='rotate' or action=='reset' then
        self.handX,self.handY=a,b
    else
        error('wtf why action is '..tostring(action))
    end

    if self.handX%1~=0 or self.handY%1~=0 then error('EUREKA! Decimal position.') end

    if action=='rotate' then
        self:playSound(c and 'initrotate' or 'rotate')
        if self.handY==self.ghostY then
            self:playSound('touch')
        end
    end

    if self.deathTimer then
        local t=self.deathTimer
        self.deathTimer=false
        if self:ifoverlap(self.hand.matrix,self.handX,self.handY) then
            self.deathTimer=t
        else
            self:playSound('desuffocate')
        end
    end
end
function PP:restorePuyoState(puyo)-- Restore a puyo object's state (only inside, like shape, name, direction)
    if puyo._origin then
        for k,v in next,puyo._origin do
            puyo[k]=v
        end
    end
    return puyo
end
function PP:resetPos()-- Move hand piece to the normal spawn position
    self:moveHand('reset',floor(self.field:getWidth()/2-#self.hand.matrix[1]/2+1),self.settings.spawnH+1)
    self.minY=self.handY
    self.ghostY=self.handY
    self:resetPosCheck()
    self:triggerEvent('afterResetPos')
end
function PP:resetPosCheck()
    local suffocated-- Cancel deathTimer temporarily, or we cannot apply IMS when hold in suffcating
    if self.deathTimer then
        local bufferedDeathTimer=self.deathTimer
        self.deathTimer=false
        suffocated=self:ifoverlap(self.hand.matrix,self.handX,self.handY)
        self.deathTimer=bufferedDeathTimer
    else
        suffocated=self:ifoverlap(self.hand.matrix,self.handX,self.handY)
    end

    if suffocated then
        if self.settings.deathDelay>0 then
            self.deathTimer=self.settings.deathDelay
            self:playSound('suffocate')

            -- Suffocate IMS, trigger when key pressed, not buffered
            if self.keyState.moveLeft then self:moveLeft() end
            if self.keyState.moveRight then self:moveRight() end
        else
            self:lock()
            self:finish('WA')
            return
        end
    else
        if self.keyBuffer.move then-- IMS
            if self.keyBuffer.move=='L' then
                self:moveLeft()
            elseif self.keyBuffer.move=='R' then
                self:moveRight()
            end
            self.keyBuffer.move=false
        end

        self:freshGhost(true)
        self:freshDelay('spawn')
    end

    if self.keyBuffer.rotate then-- IRS
        self:rotate(self.keyBuffer.rotate,true)
        self.keyBuffer.rotate=false
    end

    if self.settings.dascut>0 then--DAS cut
        self.moveCharge=self.moveCharge-self.settings.dascut
    end
end
function PP:freshGhost(justFreshGhost)
    if self.hand then
        self.ghostY=min(self.field:getHeight()+1,self.handY)

        -- Move ghost to bottom
        while not self:ifoverlap(self.hand.matrix,self.handX,self.ghostY-1) do
            self.ghostY=self.ghostY-1
        end

        if not justFreshGhost then
            if (self.settings.dropDelay<=0 or self.downCharge and self.settings.sdarr==0) and self.ghostY<self.handY then-- if (temp) 20G on
                self:moveHand('drop',self.ghostY-self.handY)
                self:freshDelay('drop')
                self:shakeBoard('-drop')
            else
                self:freshDelay('move')
            end
        end
    end
end
function PP:freshDelay(reason)-- reason can be 'move' or 'drop' or 'spawn'
    local fell
    if self.handY<self.minY then
        self.minY=self.handY
        fell=true
    end
    local maxLockDelayAdded=min(self.settings.lockDelay-self.lockTimer,self.freshTimeRemain)
    if self.settings.freshCondition=='any' then
        if reason=='move' or reason=='rotate' then
            if self.lockTimer<self.settings.lockDelay and self.freshChance>0 then
                self.lockTimer=self.lockTimer+maxLockDelayAdded
                self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
                self.freshChance=self.freshChance-1
            end
        elseif reason=='drop' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.lockTimer+maxLockDelayAdded
            self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
            self.freshChance=self.settings.freshCount
            self.freshTimeRemain=self.settings.maxFreshTime
        end
    elseif self.settings.freshCondition=='fall' then
        if reason=='move' or reason=='rotate' then
            if fell and self.lockTimer<self.settings.lockDelay and self.freshChance>0 then
                self.lockTimer=self.lockTimer+maxLockDelayAdded
                self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
                self.freshChance=self.freshChance-1
            end
        elseif reason=='drop' then
            self.dropTimer=self.settings.dropDelay
            if self.lockTimer<self.settings.lockDelay and self.freshChance>0 then
                self.lockTimer=self.lockTimer+maxLockDelayAdded
                self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
                self.freshChance=self.freshChance-1
            end
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
            self.freshChance=self.settings.freshCount
            self.freshTimeRemain=self.settings.maxFreshTime
        end
    elseif self.settings.freshCondition=='never' then
        if reason=='move' or reason=='rotate' or reason=='drop' then
            -- Do nothing
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
            self.freshChance=self.settings.freshCount
            self.freshTimeRemain=self.settings.maxFreshTime
        end
    else
        error("wtf why settings.freshCondition is "..tostring(self.settings.freshCondition))
    end
end
function PP:freshNextQueue()
    while #self.nextQueue<max(self.settings.nextSlot,1) do
        local shape=self:seqGen()
        if shape then self:getPuyo(shape) end
    end
end
function PP:popNext()
    if self.nextQueue[1] then-- Most cases there is pieces in next queue
        self.hand=rem(self.nextQueue,1)
        self:freshNextQueue()
    else-- If no piece to use, Next queue are empty, game over
        self:finish('ILE')
        return
    end

    self:resetPos()

    self:triggerEvent('afterSpawn')

    if self.keyBuffer.hardDrop then-- IHdS
        self.keyBuffer.hardDrop=false
        if not self.deathTimer then
            self:puyoDropped()
        end
    end
end
function PP:getPuyo(mat)
    self.pieceCount=self.pieceCount+1
    mat=TABLE.shift(mat)

    -- Generate matrix
    for y=1,#mat do for x=1,#mat[1] do
        if mat[y][x] then
            mat[y][x]={
                puyoID=self.pieceCount,
                color=defaultPuyoColor[mat[y][x]],
                connClear=true,
            }
        end
    end end

    local puyo={
        id=self.pieceCount,
        shapeH=#mat[1],
        direction=0,
        matrix=mat,
    }
    puyo._origin=TABLE.copy(puyo,0)
    ins(self.nextQueue,puyo)
end
function PP:ifoverlap(CB,cx,cy)
    local F=self.field

    -- Must in wall
    if cx<=0 or cx+#CB[1]-1>F:getWidth() or cy<=0 then return true end

    -- Must in air
    if cy>F:getHeight() then return false end

    -- Check field
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] and self:isSolidCell(cx+x-1,cy+y-1) then
            return true
        end
    end end

    -- No collision
    return false
end
function PP:isSolidCell(x,y)
    return not self.deathTimer and self.field:getCell(x,y) and true or false
end
function PP:moveLeft()
    if not self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) then
        self:moveHand('moveX',-1)
        self:freshGhost()
        return true
    end
end
function PP:moveRight()
    if not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) then
        self:moveHand('moveX',1)
        self:freshGhost()
        return true
    end
end
function PP:moveDown()
    if not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) then
        self:moveHand('moveY',-1)
        self:freshDelay('drop')
        if self.handY==self.ghostY then
            self:playSound('touch')
        end
        return true
    end
end
local PRS={
    [1]={
        [0]={
            R={target=1,{0,0},{0,1},{-1,0},{-1,1}},
            L={target=3,{-1,0},{-1,1},{0,0},{0,1}},
            F={target=2,{0,-1},{0,0}},
        },
        [1]={
            R={target=2,{0,-1},{0,0},{1,-1},{1,0}},
            L={target=0,{0,0},{1,0},{0,-1},{1,-1}},
            F={target=3,{-1,0},{0,0}},
        },
        [2]={
            R={target=3,{-1,1},{0,1},{-1,0},{0,0}},
            L={target=1,{0,1},{-1,1},{0,0},{-1,0}},
            F={target=0,{0,1},{0,0}},
        },
        [3]={
            R={target=0,{1,0},{0,0},{1,-1},{0,-1}},
            L={target=2,{1,-1},{1,0},{0,-1},{0,0}},
            F={target=1,{1,0},{0,0}},
        },
    },
    [2]={
        [0]={R={target=1,{0,0}},L={target=3,{0,0}},F={target=2,{0,0}}},
        [1]={R={target=2,{0,0}},L={target=0,{0,0}},F={target=3,{0,0}}},
        [2]={R={target=3,{0,0}},L={target=1,{0,0}},F={target=0,{0,0}}},
        [3]={R={target=0,{0,0}},L={target=2,{0,0}},F={target=1,{0,0}}},
    },
}
function PP:rotate(dir,ifInit)
    if not self.hand then return end
    if dir~='R' and dir~='L' and dir~='F' then error("wtf why dir isn't R/L/F ("..tostring(dir)..")") end

    -- Rotate matrix
    local cb=self.hand.matrix
    local icb=TABLE.rotate(cb,dir)

    local kicks=PRS[self.hand.shapeH][self.hand.direction][dir]
    for n=1,#kicks do
        local ix,iy=self.handX+kicks[n][1],self.handY+kicks[n][2]
        if not self:ifoverlap(icb,ix,iy) then
            self.hand.matrix=icb
            self.hand.direction=kicks.target
            self:moveHand('rotate',ix,iy,ifInit)
            self:freshGhost()
            return
        end
    end
    self:freshDelay('rotate')
    self:playSound('rotate_failed')
end
function PP:puyoDropped()-- Drop & lock puyo, and trigger a lot of things
    if not self.hand then return end

    -- Move down
    if self.handY>self.ghostY then
        self:moveHand('drop',self.ghostY-self.handY)
        self:shakeBoard('-drop')
        self:playSound('drop')
    end
    self:createLockParticle(self.handX,self.handY)
    self:triggerEvent('afterDrop')

    -- Lock to field
    self.chain=0
    self:lock()
    self:playSound('lock')
    self:triggerEvent('afterLock')

    -- Lockout check
    if self.handY>self.settings.lockoutH then
        self:finish('CE')
    end

    -- Update & Release garbage
    local i=1
    while true do
        l=self.garbageBuffer[i]
        if not l then break end
        if l.time==l.time0 then
            self:dropGarbage(l.power*2)
            rem(self.garbageBuffer,i)
            i=i-1-- Avoid index error
        elseif l.mode==1 then
            l.time=l.time+1
        end
        i=i+1
    end

    if self:canFall() then
        if self.settings.fallDelay<=0 then
            repeat until not self:fieldFall()
        else
            self.fallTimer=self.settings.fallDelay
        end
    else
        self:checkClear()
    end

    -- Discard hand
    self.hand=false
    if self.finished then return end

    -- Fresh hand
    if self.settings.spawnDelay<=0 then
        if self.fallTimer<=0 and self.clearTimer<=0 then
            self:popNext()
        end
    else
        self.spawnTimer=self.settings.spawnDelay
    end
end
function PP:lock()-- Put puyo into field
    local CB=self.hand.matrix
    local F=self.field
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            F:setCell(CB[y][x],self.handX+x-1,self.handY+y-1)
        end
    end end

    ins(self.dropHistory,{
        id=self.hand.id,
        direction=self.hand.direction,
        x=self.handX,
        y=self.handY,
        time=self.time,
    })
end
function PP:getGroup(x,y,cell,set)
    local F=self.field
    local c
    local h=self.settings.connH
    if y-1<=h then
        c=F:getCell(x,y-1) if c and not set[c] and c.color==cell.color then set[c]={x,y-1} self:getGroup(x,y-1,cell,set) end
        if y<=h then
            c=F:getCell(x-1,y) if c and not set[c] and c.color==cell.color then set[c]={x-1,y} self:getGroup(x-1,y,cell,set) end
            c=F:getCell(x+1,y) if c and not set[c] and c.color==cell.color then set[c]={x+1,y} self:getGroup(x+1,y,cell,set) end
            if y+1<=h then
                c=F:getCell(x,y+1) if c and not set[c] and c.color==cell.color then set[c]={x,y+1} self:getGroup(x,y+1,cell,set) end
            end
        end
    end
end
function PP:checkDig(set)
    local F=self.field
    local h=self.settings.connH
    local tset={}
    for _,pos in next,set do
        local x,y=pos[1],pos[2]
        local c
        if y-1<=h then
            c=F:getCell(x,y-1) if c and c.diggable then tset[c]={x,y-1} end
            if y<=h then
                c=F:getCell(x-1,y) if c and c.diggable then tset[c]={x-1,y} end
                c=F:getCell(x+1,y) if c and c.diggable then tset[c]={x+1,y} end
                if y+1<=h then
                    c=F:getCell(x,y+1) if c and c.diggable then tset[c]={x,y+1} end
                end
            end
        end
    end
    TABLE.cover(tset,set)
end
function PP:checkPosition(x,y)
    local set={}
    local cell=self.field:getCell(x,y)

    -- Skip if this cell is being cleared
    for i=1,#self.clearingGroups do
        if self.clearingGroups[i][cell] then
            return
        end
    end

    -- Find all connected cells
    if y<=self.settings.connH then
        self:getGroup(x,y,cell,set)
    end

    -- Record the group, mark cells, trigger clearing (or later)
    if TABLE.getSize(set)>=self.settings.clearGroupSize then
        ins(self.clearingGroups,set)
        self:checkDig(set)
        for k in next,set do k.clearing=true end
        if self.settings.clearDelay<=0 then
            self:clearField()
        else
            self.clearTimer=self.settings.clearDelay
        end
    end
end
function PP:canFall()
    local F=self.field
    for y=1,F:getHeight() do for x=1,F:getWidth() do
        if self:isSolidCell(x,y) and not self:isSolidCell(x,y-1) then
            return true
        end
    end end
end
function PP:fieldFall()
    local F=self.field
    local fallen=false
    for x=1,F:getWidth() do
        local airHeight
        for y=1,F:getHeight() do
            if not F:getCell(x,y) then
                airHeight=y
                break
            end
        end
        if airHeight then
            for y=airHeight,F:getHeight() do
                local c=F:getCell(x,y+1)
                F:setCell(c,x,y)
                if c then
                    fallen=true
                end
            end
        end
    end
    return fallen
end
function PP:dropGarbage(count)
    local F=self.field
    local w=F:getWidth()
    for _=1,count do
        local x=self.rcvRND:random(w)
        local y=self.settings.spawnH+1
        while F:getCell(x,y) do y=y+1 end
        F:setCell({
            color=0,
            diggable=true,
        },x,y)
    end
end
function PP:checkClear()
    local F=self.field
    for y=1,F:getHeight() do for x=1,F:getWidth() do
        local c=F:getCell(x,y)
        if c and c.connClear then
            self:checkPosition(x,y)
        end
    end end
    if #self.clearingGroups>0 then
        self:playSound('desuffocate')
    end
end
function PP:clearField()
    self.chain=self.chain+1
    self:playSound('chain',self.chain)
    self:playSound('clear',#self.clearingGroups)

    local F=self.field
    for i=1,#self.clearingGroups do
        local set=self.clearingGroups[i]
        for k,pos in next,set do
            if k.shield then
                k.shield=k.shield>0 and k.shield-1 or nil
            else
                k=false
            end
            F:setCell(k,pos[1],pos[2])
            self:createClearParticle(pos[1],pos[2])
        end
    end
    self.clearingGroups={}

    if self:canFall() then
        if self.settings.fallDelay<=0 then
            repeat until not self:fieldFall()
            self:checkClear()
        else
            self.fallTimer=self.settings.fallDelay
        end
    else
        self:checkClear()
    end
end
function PP:changeFieldWidth(w,origPos)
    if w>0 and w%1==0 then
        if not origPos then origPos=1 end
        local w0=self.settings.fieldW
        for y=1,#self.field:getHeight() do
            local L=TABLE.new(false,w)
            for x=1,w0 do
                local newX=origPos+x-1
                if newX>=1 and newX<=w then
                    L[newX]=self.field._matrix[y][x]
                end
            end
        end
        self.settings.fieldW=w
        self.field._width=w
        self.field:fresh()
    end
end
function PP:receive(data)
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
function PP:getScriptValue(arg)
    return
        arg.d=='field_width' and self.field:getWidth() or
        arg.d=='field_height' and self.field:getHeight() or
        arg.d=='cell' and (self.field:getCell(arg.x,arg.y) and 1 or 0)
end
--------------------------------------------------------------
-- Press & Release & Update & Render
function PP:updateFrame()
    local SET=self.settings

    -- Controlling piece
    if not self.deathTimer then
        -- Auto shift
        if self.moveDir and (self.moveDir==-1 and self.keyState.moveLeft or self.moveDir==1 and self.keyState.moveRight) then
            if self.hand and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) then
                local c0=self.moveCharge
                local c1=c0+1
                self.moveCharge=c1
                local dist=0
                if c0>=SET.das then
                    c0=c0-SET.das
                    c1=c1-SET.das
                    if SET.arr==0 then
                        dist=1e99
                    else
                        dist=floor(c1/SET.arr)-floor(c0/SET.arr)
                    end
                elseif c1>=SET.das then
                    if SET.arr==0 then
                        dist=1e99
                    else
                        dist=1
                    end
                end
                if dist>0 then
                    local ox=self.handX
                    while dist>0 and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) do
                        self:moveHand('moveX',self.moveDir)
                        self:freshGhost()
                        dist=dist-1
                    end
                    if self.handX~=ox then
                        self:playSound('move')
                        if self.handY==self.ghostY then
                            self:playSound('touch')
                        end
                    end
                end
            else
                self.moveCharge=SET.das
                if self.hand then
                    self:shakeBoard(self.moveDir>0 and '-right' or '-left')
                end
            end
        else
            self.moveDir=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
            self.moveCharge=0
        end

        -- Auto drop
        if self.downCharge and self.keyState.softDrop then
            if self.hand and not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) then
                local c0=self.downCharge
                local c1=c0+1
                self.downCharge=c1
                local dist=SET.sdarr==0 and 1e99 or floor(c1/SET.sdarr)-floor(c0/SET.sdarr)
                local oy=self.handY
                if dist>0 then
                    while dist>0 do
                        dist=dist-1
                        if not self:moveDown() then break end
                    end
                    if oy~=self.handY then
                        self:freshDelay('drop')
                        self:playSound('move')
                        if self.handY==self.ghostY then
                            self:shakeBoard('-down')
                            self:playSound('touch')
                        end
                    end
                end
            else
                self.downCharge=SET.sdarr
                if self.hand then
                    self:shakeBoard('-down')
                end
            end
        else
            self.downCharge=false
        end

        repeat-- Update hand
            -- Wait falling & clearing animation
            if self.fallTimer>0 then
                self.fallTimer=self.fallTimer-1
                if self.fallTimer<=0 then
                    if self:canFall() then
                        if self:fieldFall() then
                            self.fallTimer=self.settings.fallDelay
                        end
                    else
                        self:checkClear()
                    end
                end
                break
            end
            if self.clearTimer>0 then
                self.clearTimer=self.clearTimer-1
                if self.clearTimer==0 then
                    self:clearField()
                    self:triggerEvent('afterClear')
                end
                break
            end

            -- Try spawn puyo if don't have one
            if self.spawnTimer>0 then
                self.spawnTimer=self.spawnTimer-1
                if self.spawnTimer<=0 then
                    self:popNext()
                end
                break
            elseif not self.hand then
                self:popNext()
            end

            -- Try lock/drop puyo
            if self.handY==self.ghostY then
                self.lockTimer=self.lockTimer-1
                if self.lockTimer<=0 then
                    self:puyoDropped()
                end
                break
            else
                if self.dropDelay~=0 then
                    self.dropTimer=self.dropTimer-1
                    if self.dropTimer<=0 then
                        self.dropTimer=SET.dropDelay
                        self:moveHand('drop',-1)
                        if self.handY==self.ghostY then
                            self:playSound('touch')
                        end
                    end
                elseif self.handY~=self.ghostY then-- If switch to 20G during game, puyo won't dropped to bottom instantly so we force fresh it
                    self:freshDelay('drop')
                end
            end
        until true
    else
        self.deathTimer=self.deathTimer-1
        if self.deathTimer<=0 then
            self.deathTimer=false
            self:lock()
            self:finish('WA')
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
function PP:render()
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
    gc.translate(-200,400)

    -- startFieldStencil
    GC.stc_setComp()
    GC.stc_rect(0,0,400,-920)
    gc.scale(10/settings.fieldW)


        self:triggerEvent('drawBelowField')


        -- Grid & Cells
        skin.drawFieldBackground(settings.fieldW)
        skin.drawFieldCells(self.field)


        self:triggerEvent('drawBelowBlock')


        if self.hand then
            local CB=self.hand.matrix

            -- Ghost
            if not self.deathTimer then
                skin.drawGhost(CB,self.handX,self.ghostY)
            end

            -- Puyo
            if not self.deathTimer or (2600/(self.deathTimer+260)-self.deathTimer/260)%1>.5 then
                -- Smooth
                local movingX,droppingY=0,0
                if self.moveDir and self.moveCharge<self.settings.das then
                    movingX=15*self.moveDir*(self.moveCharge/self.settings.das-.5)
                end
                if self.handY>self.ghostY then
                    droppingY=40*(max(1-self.dropTimer/settings.dropDelay*2.6,0))^2.6
                end
                gc.translate(movingX,droppingY)
                skin.drawHand(CB,self.handX,self.handY)
                gc.translate(-movingX,-droppingY)
            end
        end


        self:triggerEvent('drawBelowMarks')


        -- Height lines
        skin.drawHeightLines(-- All unit are pixel
            settings.fieldW*40,  -- Field Width
            settings.spawnH*40,  -- Spawning height
            settings.lockoutH*40,-- Lock-out height
            settings.deathH*40,  -- Death height
            settings.voidH*40    -- Void height
        )


        self:triggerEvent('drawInField')


    -- stopFieldStencil
    GC.stc_stop()

    -- Particles
    gc.setColor(1,1,1)
    gc.draw(self.particles.star)
    gc.draw(self.particles.trail)

    -- popFieldTransform
    gc.pop()

    -- Field border
    skin.drawFieldBorder()

    -- Delay indicator
    if not self.hand then-- Spawn
        skin.drawDelayIndicator(COLOR.lB,self.spawnTimer/settings.spawnDelay)
    elseif self.deathTimer then-- Death
        skin.drawDelayIndicator(COLOR.R,self.deathTimer/settings.deathDelay)
    else-- Lock
        skin.drawDelayIndicator(COLOR.lY,self.lockTimer/settings.lockDelay)
    end

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Lock delay indicator
    skin.drawLockDelayIndicator(settings.freshCondition,self.freshChance)

    -- Next
    gc.push('transform')
    gc.translate(200,-400)
    skin.drawNextBorder(settings.nextSlot)
    for n=1,min(#self.nextQueue,settings.nextSlot) do
        skin.drawNext(n,self.nextQueue[n].matrix)
    end
    gc.pop()

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()


    self:triggerEvent('drawOnPlayer')


    -- Starting counter
    if self.time<settings.readyDelay then
        skin.drawStartingCounter(settings.readyDelay)
    end

    -- Upside fade out
    gc.setBlendMode('multiply','premultiplied')
    gc.setColorMask(false,false,false,true)
    for i=0,99,2 do
        gc.setColor(0,0,0,(1-i/100)^2)
        gc.rectangle('fill',-200,-422-i,400,-2)
    end
    gc.setBlendMode('alpha')
    gc.setColorMask()

    gc.pop()
end
--------------------------------------------------------------
-- Other
function PP:decodeScript(line,errMsg)
    -- TODO
    -- error(errMsg.."No string command '"..cmd.."'")
end
function PP:checkScriptSyntax(cmd,arg,errMsg)
    -- TODO
end
--------------------------------------------------------------
-- Builder
local baseEnv={
    fieldW=6,-- [WARNING] This is not the real field width, just for generate field object. Change real field size with 'self:changeFieldWidth'
    spawnH=11,
    lockoutH=1e99,
    deathH=1e99,
    voidH=620,
    connH=12,-- Default to 12

    nextSlot=6,

    readyDelay=3000,
    dropDelay=1000,
    lockDelay=1000,
    spawnDelay=200,
    fallDelay=100,
    clearDelay=200,
    deathDelay=260,

    seqType='double4color',
    atkSys='none',

    clearGroupSize=4,
    freshCondition='fall',
    freshCount=15,
    maxFreshTime=6200,
    script=false,

    -- Will be overrode with user setting
    das=162,
    arr=26,
    sdarr=12,
    dascut=0,
    skin='puyo_jelly',

    shakeness=.26,
}
local seqGenerators={
    none=function() while true do coroutine.yield() end end,
    double3color=function(P)
        local l={}
        while true do
            if not l[1] then for i=1,3 do for j=1,3 do ins(l,{{i},{j}}) end end end
            coroutine.yield(rem(l,P.seqRND:random(#l)))
        end
    end,
    double4color=function(P)
        local l={}
        while true do
            if not l[1] then for i=1,4 do for j=1,4 do ins(l,{{i},{j}}) end end end
            coroutine.yield(rem(l,P.seqRND:random(#l)))
        end
    end,
    double5color=function(P)
        local l={}
        while true do
            if not l[1] then for i=1,5 do for j=1,5 do ins(l,{{i},{j}}) end end end
            coroutine.yield(rem(l,P.seqRND:random(#l)))
        end
    end,
}
local soundTimeMeta={
    __index=function(self,k) rawset(self,k,0) return -1e99 end,
    __metatable=true,
}
local soundEventMeta={
    __index=defaultSoundFunc,
    __metatable=true,
}
function PP.new()
    local self=setmetatable({},{__index=PP,__metatable=true})
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
        afterResetPos={},
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
function PP:initialize()
    self.soundEvent=setmetatable({},soundEventMeta)
    self.modeData={}
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

    self.field=require'assets.game.rectField'.new(self.settings.fieldW)

    self.pieceCount=0
    self.chain=0

    self.clearingGroups={}
    self.garbageBuffer={}

    self.nextQueue={}
    self.seqGen=coroutine.wrap(seqGenerators[self.settings.seqType])
    self:freshNextQueue()

    self.dropTimer=0
    self.lockTimer=0
    self.spawnTimer=self.settings.readyDelay
    self.fallTimer=0
    self.clearTimer=0
    self.deathTimer=false

    self.freshChance=self.settings.freshCount
    self.freshTimeRemain=0

    self.hand=false-- Controlling puyo object
    self.handX=false
    self.handY=false
    self.ghostY=false
    self.minY=false

    self.moveDir=false
    self.moveCharge=0
    self.downCharge=false

    self.actionHistory={}
    self.keyBuffer={
        move=false,
        rotate=false,
        hardDrop=false,
    }
    self.dropHistory={}
    self.clearHistory={}
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

    self:loadScript(self.settings.script)

    self.particles={}
    for k,v in next,particleSystemTemplate do
        self.particles[k]=v:clone()
    end
end
--------------------------------------------------------------
return PP
