local require=simpRequire('assets.game.')

local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setBlendMode,gc_setColorMask=gc.setBlendMode,gc.setColorMask
local gc_setColor=gc.setColor
local gc_draw,gc_rectangle=gc.draw,gc.rectangle


local max,min=math.max,math.min
local floor=math.floor
local ins,rem=table.insert,table.remove

---@class Techmino.Player.Gela: Techmino.Player
---@field field Techmino.RectField
local GP=setmetatable({},{__index=require'basePlayer',__metatable=true})

--------------------------------------------------------------
-- Function tables

local defaultSoundFunc={
    countDown=      countDownSound,
    move=           function() FMOD.effect('move')           end,
    move_down=      function() FMOD.effect('move_down')      end,
    move_failed=    function() FMOD.effect('move_failed')    end,
    rotate=         function() FMOD.effect('rotate')         end,
    rotate_init=    function() FMOD.effect('rotate_init')    end,
    rotate_failed=  function() FMOD.effect('rotate_failed')  end,
    rotate_special= function() FMOD.effect('rotate_special') end,
    touch=          function() FMOD.effect('touch')          end,
    drop=           function() FMOD.effect('drop')           end,
    lock=           function() FMOD.effect('lock')           end,
    clear=function(lines)
        FMOD.effect(
            lines==1 and 'clear_1' or
            lines==2 and 'clear_2' or
            lines==3 and 'clear_3' or
            lines==4 and 'clear_4' or
            'clear_5'
        )
    end,
    chain=       comboSound,
    frenzy=      function() FMOD.effect('frenzy')      end,
    allClear=    function() FMOD.effect('clear_all')   end,
    suffocate=   function() FMOD.effect('suffocate')   end,
    desuffocate= function() FMOD.effect('desuffocate') end,
    reach=       function() FMOD.effect('beep_rise')   end,
    notice=      function() FMOD.effect('beep_notice') end,
    win=         function() FMOD.effect('win')         end,
    fail=        function() FMOD.effect('fail')        end,
}
---@type Map<fun(P:Techmino.Player.Gela):any>
GP.scriptCmd={
}

--------------------------------------------------------------
-- Actions

GP._actions={}
for k,v in next,mechLib.gela.actions do GP._actions[k]=GP:_getActionObj(v) end

--------------------------------------------------------------
-- Effects

function GP:createMoveEffect(x1,y1,x2,y2)
    local p=self.particles.rectShade
    local dx,dy=self:getSmoothPos()
    for x=x1,x2,x2>x1 and 1 or -1 do for y=y1,y2,y2>y1 and 1 or -1 do
        p:setPosition((x-.5)*40+dx,-(y-.5)*40+dy)
        p:emit(1)
    end end
end
function GP:createHandEffect(r,g,b,a)
    local CB,bx,by=self.hand.matrix,self.handX,self.handY
    local dx,dy=self:getSmoothPos()
    local p=self.particles.tiltRect
    p:setColors(r,g,b,a or 1,r,g,b,0)
    for y=1,#CB do for x=1,#CB[1] do
        local c=CB[y][x]
        if c then
            p:setPosition(
                (bx+x-1.5)*40+dx,
                -(by+y-1.5)*40+dy
            )
            p:emit(1)
        end
    end end
end
function GP:createTuckEffect()
end
function GP:createLockEffect()
    local p=self.particles.trail
    p:setPosition(
        (self.handX+#self.hand.matrix[1]/2-1)*40,
        -(self.handY+#self.hand.matrix/2-1)*40
    )
    p:emit(1)
end
function GP:createClearEffect(x,y)
    local p=self.particles.star
    p:setParticleLifetime(.26,.626)
    p:setEmissionArea('ellipse',30,30,0,true)
    p:setPosition(40*(x-.5),-40*(y-.5))
    p:emit(6)
end
function GP:createSuffocateEffect()
end
function GP:createDesuffocateEffect()
end
function GP:setCellBias(x,y,bias)
    local c=self.field:getCell(x,y)
    if c then
        bias.x=40*(bias.x or 0)
        bias.y=-40*(bias.y or 0)
        if c.bias then
            bias.x=bias.x+c.bias.x
            bias.y=bias.y+c.bias.y
        end
        c.bias=bias
    end
end
function GP:showInvis(visStep,visMax)
    for y=1,self.field:getHeight() do
        for x=1,self.settings.fieldW do
            local c=self.field:getCell(x,y)
            if c then
                c.visTimer=c.visTimer or 0
                c.visStep=visStep or 1
                c.visMax=visMax
            end
        end
    end
end
function GP:getSmoothPos()
    if self.deathTimer then
        return 0,0
    else
        return
            self.moveDir and self.moveCharge<self.settings.asd and 15*self.moveDir*(max(self.moveCharge,0)/self.settings.asd-.5) or 0,
            self.ghostY and self.handY>self.ghostY and 40*(max(1-self.dropTimer/self.settings.dropDelay*2.6,0))^2.6 or 0
    end
end

--------------------------------------------------------------
-- Game methods

---@param action 'moveX'|'moveY'|'drop'|'rotate'|'reset'
function GP:moveHand(action,A,B,C)
    --[[
        moveX:  dx,noShade
        moveY:  dy,noShade
        drop:   dy,noShade
        rotate: x,y,ifInit
        reset:  x,y
    ]]
    if action=='moveX' then
        self.handX=self.handX+A
        self:checkLanding()
        if self.settings.particles then
            local hx,hy=self.handX,self.handY
            local mat=self.hand.matrix
            local w,h=#mat[1],#mat
            if not B then
                if A<0 then
                    for y=1,h do for x=w,1,-1 do
                        if mat[y][x] then
                            self:createMoveEffect(hx+x-1+1,hy+y-1,hx+x-1+1-A-1,hy+y-1)
                            break
                        end end
                    end
                elseif A>0 then
                    for y=1,h do for x=1,w do
                        if mat[y][x] then
                            self:createMoveEffect(hx+x-1-1,hy+y-1,hx+x-1-1-A+1,hy+y-1)
                            break
                        end end
                    end
                end
            end
        end
    elseif action=='moveY' or action=='drop' then
        self.handY=self.handY+A
        self.dropTimer=self.settings.dropDelay
        self:checkLanding(true)
        if self.settings.particles then
            local hx,hy=self.handX,self.handY
            local mat=self.hand.matrix
            local w,h=#mat[1],#mat
            if not B then
                if A<0 then
                    for x=1,w do for y=h,1,-1 do
                        if mat[y][x] then
                            self:createMoveEffect(hx+x-1,hy+y-1+1,hx+x-1,hy+y-1+1-A-1)
                            break
                        end end
                    end
                elseif A>0 then
                    for x=1,w do for y=1,h do
                        if mat[y][x] then
                            self:createMoveEffect(hx+x-1,hy+y-1-1,hx+x-1,hy+y-1-1-A+1)
                            break
                        end end
                    end
                end
            end
        end
    elseif action=='rotate' or action=='reset' then
        self.handX,self.handY=A,B
    else
        error("WTF why action is "..tostring(action))
    end

    if self.handX%1~=0 or self.handY%1~=0 then error("EUREKA! Decimal position") end

    if action=='rotate' then
        self:playSound(C and 'rotate_init' or 'rotate')
        self:checkLanding()
    end

    self:tryCancelSuffocate()
end
function GP:restoreGelaState(gela) -- Restore a gela object's state (only inside, like shape, name, direction)
    if gela._origin then
        for k,v in next,gela._origin do
            gela[k]=v
        end
    end
    return gela
end
function GP:resetPos() -- Move hand piece to the normal spawn position
    self:moveHand('reset',floor(self.settings.fieldW/2-#self.hand.matrix[1]/2+1),self.settings.spawnH+1)

    self.deathTimer=false
    self.ghostState=false

    self.minY=self.handY
    self.ghostY=self.handY
    self:resetPosCheck()

    self:triggerEvent('afterResetPos')

end
function GP:resetPosCheck()
    local suffocated -- Cancel deathTimer temporarily, or we cannot apply IMS when hold in suffcating
    if self.deathTimer then
        self.ghostState=false
        suffocated=self:isSuffocate()
        self.ghostState=true
    else
        suffocated=self:isSuffocate()
    end

    if suffocated then
        if self.settings.deathDelay>0 then
            self.deathTimer=self.settings.deathDelay
            self.ghostState=true

            -- Suffocate IMS, always trigger when held
            if self.keyState.softDrop then self:moveDown() end
            if self.keyState.moveRight~=self.keyState.moveLeft then
                if self.keyState.moveRight then self:moveRight() else self:moveLeft() end
            end

            -- Suffocate IRS
            if self.settings.initRotate then
                if self.settings.initRotate=='hold' then
                    if self.keyState.rotate180 then
                        self:rotate('F',true)
                    elseif self.keyState.rotateCW~=self.keyState.rotateCCW then
                        self:rotate(self.keyState.rotateCW and 'R' or 'L',true)
                    end
                elseif self.settings.initRotate=='buffer' then
                    if self.keyBuffer.rotate then
                        self:rotate(self.keyBuffer.rotate,true)
                        if not self.keyBuffer.hold then
                            self.keyBuffer.rotate=false
                        end
                    end
                end
            end
            self:tryCancelSuffocate()
            self:freshGhost()

            if self.deathTimer then
                self:playSound('suffocate')
                self:createSuffocateEffect()
            end
        else

            self:triggerEvent('whenSuffocate')
            self:freshGhost()

            if self:isSuffocate() then
                self:lock()
                self:finish('WA')
            end
            return
        end
    else
        -- IMS
        if self.settings.initMove then
            if self.settings.initMove=='hold' then
                if self.keyState.softDrop then self:moveDown() end
                if self.keyState.moveRight~=self.keyState.moveLeft then
                    local origY=self.handY -- For canceling 20G effect of IMS
                    if self.keyState.moveRight then self:moveRight() else self:moveLeft() end
                    self.handY=origY
                end
            elseif self.settings.initMove=='buffer' then
                if self.keyBuffer.move then
                    local origY=self.handY -- For canceling 20G effect of IMS
                    if self.keyBuffer.move=='L' then
                        self:moveLeft()
                    elseif self.keyBuffer.move=='R' then
                        self:moveRight()
                    end
                    self.keyBuffer.move=false
                    self.handY=origY
                end
            end
        end

        -- IRS
        if self.settings.initRotate then
            if self.settings.initRotate=='hold' then
                if self.keyState.rotate180 then
                    self:rotate('F',true)
                elseif self.keyState.rotateCW~=self.keyState.rotateCCW then
                    self:rotate(self.keyState.rotateCW and 'R' or 'L',true)
                end
            elseif self.settings.initRotate=='buffer' then
                if self.keyBuffer.rotate then
                    self:rotate(self.keyBuffer.rotate,true)
                    if not self.keyBuffer.hold then
                        self.keyBuffer.rotate=false
                    end
                end
            end
        end

        self:freshGhost()
        self:freshDelay('spawn')
    end

    if self.settings.stopMoveWhenSpawn then
        self.moveDir=false
        self.moveCharge=0
    elseif self.settings.ash>0 then
        self.moveCharge=min(self.moveCharge,self.settings.asd-self.settings.ash)
    end
end
function GP:freshGhost()
    if self.hand then
        self.ghostY=min(self.field:getHeight()+1,self.handY)

        -- Move ghost to bottom
        while not self:ifoverlap(self.hand.matrix,self.handX,self.ghostY-1) do
            self.ghostY=self.ghostY-1
        end

        -- 20G check
        if (self.settings.dropDelay<=0 or self.downCharge and self.settings.asp==0) and self.ghostY<self.handY then -- if (temp) 20G on
            local dY=self.ghostY-self.handY
            self:moveHand('drop',dY)
            self:freshDelay('drop')
            self:shakeBoard('-drop',-dY/self.settings.spawnH)
        else
            self:freshDelay('move')
        end
    end
end
function GP:tryCancelSuffocate()
    if self.deathTimer then
        self.ghostState=false
        if self:isSuffocate() then
            self.ghostState=true
        else
            self.deathTimer=false
            self:playSound('desuffocate')
            self:createDesuffocateEffect()
        end
    end
end
local freshRuleMap={
    move=  {any='N',fall='S',never='_'},
    rotate={any='N',fall='S',never='_'},
    moving={any='N',fall='S',never='_'},
    drop=  {any='F',fall='S',never='_'},
    spawn= {any='R',fall='R',never='R'},
}
---@param reason 'move'|'rotate'|'moving'|'drop'|'spawn'
function GP:freshDelay(reason)
    local fell=self.handY<self.minY
    if fell then self.minY=self.handY end

    local mode=freshRuleMap[reason][self.settings.freshCondition]

    if mode=='S' then mode=fell and 'N' or '_' end

    if mode=='N' or mode=='F' then
        local add=min(self.settings.lockDelay-self.lockTimer,self.freshTime)
        if self.freshChance>0 and self.lockTimer<self.settings.lockDelay and add>0 then
            self.lockTimer=self.lockTimer+add
            self.freshTime=self.freshTime-add
            self.freshChance=self.freshChance-(mode=='N' and 1 or 0)
        end
    elseif mode=='R' then
        self.dropTimer=self.settings.dropDelay
        self.lockTimer=self.settings.lockDelay
        self.freshChance=self.settings.maxFreshChance
        self.freshTime=self.settings.maxFreshTime
    elseif not mode then
        error("WTF why settings.freshCondition is "..tostring(self.settings.freshCondition))
    end
end
function GP:freshNextQueue()
    while #self.nextQueue<max(self.settings.nextSlot,1) do
        local shape=self:seqGen(self.seqData)
        if shape then self:getGela(shape) end
    end
end
function GP:decreaseNextColor(maxLength,maxColor)
    while true do
        -- Collect all cells in first N pieces
        local cells={}
        for n=1,min(maxLength,#self.nextQueue) do
            local mat=self.nextQueue[n].matrix
            for y=1,#mat do for x=1,#mat[1] do
                local c=mat[y][x]
                if c then
                    ins(cells,{n,y,x,c.color})
                end
            end end
        end

        -- Count colors
        local colors={}
        for i=1,#cells do
            local c=cells[i]
            local dictKey='mrz'..c[4]
            if not colors[dictKey] then
                colors[dictKey]={c[4],0}
                ins(colors,colors[dictKey])
            end
            colors[dictKey][2]=colors[dictKey][2]+1
        end

        -- Finish when color count is less enough
        if #colors<=1 or #colors<=maxColor then break end

        -- Merge the rarest two colors
        table.sort(colors,function(a,b) return a[2]<b[2] end)
        local orig,dest=colors[1][1],colors[2][1]
        for i=1,#cells do
            if cells[i][4]==orig then
                self.nextQueue[cells[i][1]].matrix[cells[i][2]][cells[i][3]].color=dest
            end
        end
        -- print('Merged color '..orig..' to '..dest)
    end
end
function GP:shuffleColor(n)
    local list=self.settings.colorSet
    for i=n,2,-1 do
        local r=self:random(i)
        list[i],list[r]=list[r],list[i]
    end
end
function GP:popNext()
    if self.nextQueue[1] then -- Most cases there is pieces in next queue
        self.hand=rem(self.nextQueue,1)
        self:freshNextQueue()
    else -- If no piece to use, Next queue are empty, game over
        self:finish('ILE')
        return
    end

    self:resetPos()

    self:triggerEvent('afterSpawn')

    if self.keyBuffer.hardDrop then -- IHdS
        self.keyBuffer.hardDrop=false
        self:gelaDropped()
    end
end
function GP:getGela(mat)
    self.pieceCount=self.pieceCount+1
    mat=TABLE.shift(mat)

    -- Generate cell matrix from bool matrix
    for y=1,#mat do for x=1,#mat[1] do
        mat[y][x]=mat[y][x] and {
            gelaID=self.pieceCount,
            color=self.settings.colorSet[mat[y][x]],
            connClear=true,
        }
    end end

    local gela={
        id=self.pieceCount,
        size=min(#mat,#mat[1]),
        direction=0,
        matrix=mat,
    }
    gela._origin=TABLE.copy(gela,0)
    ins(self.nextQueue,gela)
end
function GP:ifoverlap(CB,cx,cy)
    -- Must in wall
    if cx<=0 or cx+#CB[1]-1>self.settings.fieldW or cy<=0 then return true end

    -- Must in air
    if cy>self.field:getHeight() then return false end

    -- Check field
    if not self.ghostState then
        for y=1,#CB do for x=1,#CB[1] do
            if CB[y][x] and self.field:getCell(cx+x-1,cy+y-1) then
                return true
            end
        end end
    end

    -- No collision
    return false
end
function GP:checkLanding()
    if self.handY==self.ghostY then
        self:playSound('touch')
    end
end
function GP:isSuffocate()
    return self:ifoverlap(self.hand.matrix,self.handX,self.handY)
end
function GP:moveLeft()
    if not self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) then
        self:moveHand('moveX',-1,true)
        self:freshGhost()
        return true
    end
end
function GP:moveRight()
    if not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) then
        self:moveHand('moveX',1,true)
        self:freshGhost()
        return true
    end
end
function GP:moveDown()
    if not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) then
        self:moveHand('moveY',-1,true)
        self:freshDelay('drop')
        return true
    end
end
function GP:moveUp() -- ?
    if not self:ifoverlap(self.hand.matrix,self.handX,self.handY+1) then
        self:moveHand('moveY',1,true)
        return true
    end
end
local PRS={
    [1]={
        [0]={
            R={target=1,base={0,0},{0,0},{0,1},{-1,0},{-1,1}},
            L={target=3,base={-1,0},{0,0},{0,1},{1,0},{1,1}},
            F={target=2,base={0,-1},{0,0},{0,1}},
        },
        [1]={
            R={target=2,base={0,-1},{0,0},{0,1},{1,0},{1,1}},
            L={target=0,base={0,0},{0,0},{1,0},{0,-1},{1,-1}},
            F={target=3,base={-1,0},{0,0},{1,0}},
        },
        [2]={
            R={target=3,base={-1,1},{0,0},{1,0},{0,-1},{1,-1}},
            L={target=1,base={0,1},{0,0},{-1,0},{0,-1},{-1,-1}},
            F={target=0,base={0,1},{0,0},{0,-1}},
        },
        [3]={
            R={target=0,base={1,0},{0,0},{-1,0},{0,-1},{-1,-1}},
            L={target=2,base={1,-1},{0,0},{0,1},{-1,0},{-1,1}},
            F={target=1,base={1,0},{0,0},{-1,0}},
        },
    },
    [2]={
        [0]={R={target=1,{0,0}},L={target=3,{0,0}},F={target=2,{0,0}}},
        [1]={R={target=2,{0,0}},L={target=0,{0,0}},F={target=3,{0,0}}},
        [2]={R={target=3,{0,0}},L={target=1,{0,0}},F={target=0,{0,0}}},
        [3]={R={target=0,{0,0}},L={target=2,{0,0}},F={target=1,{0,0}}},
    },
}
for size=1,2 do
    for _,sizeData in next,PRS[size] do
        for _,rotData in next,sizeData do
            if rotData.base then
                for i=1,#rotData do
                    local kick=rotData[i]
                    kick[1]=kick[1]+rotData.base[1]
                    kick[2]=kick[2]+rotData.base[2]
                end
                rotData.base=nil
            end
        end
    end
end
function GP:rotate(dir,ifInit)
    if self.settings.stopMoveWhenRotate then
        self.moveDir=false
        self.moveCharge=0
    end

    if not self.hand then return end
    if dir~='R' and dir~='L' and dir~='F' then error("WTF why dir isn't R/L/F ("..tostring(dir)..")") end
    local origY=self.handY -- For IRS pushing up

    -- Rotate matrix
    local cb=self.hand.matrix
    local icb=TABLE.rotate(cb,dir)

    local kicks=PRS[self.hand.size][self.hand.direction][dir]
    for n=1,#kicks do
        local ix,iy=self.handX+kicks[n][1],self.handY+kicks[n][2]
        if not self:ifoverlap(icb,ix,iy) then
            self.hand.matrix=icb
            self.hand.direction=kicks.target
            self:moveHand('rotate',ix,iy,ifInit)
            self:freshGhost()
            if self.ghostState and self.settings.IRSpushUp then self:moveHand('moveY',origY-self.handY) end
            break
        end
    end
    self:freshDelay('rotate')
    self:playSound('rotate_failed')
end
function GP:gelaDropped() -- Drop & lock gela, and trigger a lot of things
    if not self.hand then return end

    -- Move down
    if self.handY>self.ghostY then
        self:moveHand('drop',self.ghostY-self.handY)
        self:shakeBoard('-drop',1)
        self:playSound('drop')
    end
    if self.settings.particles then
        self:createLockEffect()
    end

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

    -- Update field
    self:updField()

    -- Discard hand
    self.hand=false
    if self.finished then return end

    -- Fresh hand
    if self.settings.spawnDelay<=0 then
        -- TODO
        -- Trigger garbage
        if self.chain<=0 or not self.settings.clearStuck then
            self:checkGarbage()
        end
        if self.fallTimer<=0 and self.clearTimer<=0 then
            self:popNext()
        end
    else
        self.spawnTimer=self.settings.spawnDelay
    end
end
function GP:lock() -- Put gela into field
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
function GP:getGroup(x,y,cell,set)
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
function GP:checkDig(set)
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
function GP:checkPosition(x,y)
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

    -- Record the group, mark cells
    if TABLE.getSize(set)>=self.settings.clearGroupSize then
        ins(self.clearingGroups,set)
        self:checkDig(set)
        for k in next,set do k.clearing=true end
    end
end
---@param byTimer? boolean Only true when called by P:update, trigger falling, otherwise only start the falling timer but not do fall
function GP:updField(byTimer)
    if self:canFall() then
        if self.settings.fallDelay<=0 then
            while self:doFall() do end
            self:checkClear()
        else
            if byTimer then
                self:doFall()
            end
            self.fallTimer=self.settings.fallDelay
        end
    else
        self:checkClear()
    end
end
function GP:canFall()
    if not self.deathTimer then
        local F=self.field
        for y=1,F:getHeight() do for x=1,self.settings.fieldW do
            if F:getCell(x,y) and not F:getCell(x,y-1) then
                return true
            end
        end end
    end
end
function GP:doFall()
    local F=self.field
    local fallen=false
    for x=1,self.settings.fieldW do
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
function GP:checkClear()
    local F=self.field
    for y=1,F:getHeight() do for x=1,self.settings.fieldW do
        local c=F:getCell(x,y)
        if c and c.connClear then
            self:checkPosition(x,y)
        end
    end end
    if #self.clearingGroups>0 then
        self:playSound('desuffocate')
        if self.settings.clearDelay<=0 then
            self:doClear()
            self:updField()
        else
            self.clearTimer=self.settings.clearDelay
        end
    end
end
function GP:doClear()
    self.chain=self.chain+1
    self:playSound('chain',self.chain)
    self:playSound('clear',#self.clearingGroups)

    -- Attack
    local atk=GAME.initAtk(self:atkEvent('clear'))
    if atk then
        GAME.send(self,atk)
    end

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
            if self.settings.particles then
                self:createClearEffect(pos[1],pos[2])
            end
        end
    end
    self.clearingGroups={}
end
function GP:checkGarbage()
    local i=1
    while true do
        l=self.garbageBuffer[i]
        if not l then break end
        if l._time==l.time then
            self:dropGarbage(l.power*2)
            rem(self.garbageBuffer,i)
            i=i-1 -- Avoid index error
        elseif l.mode==1 then
            l._time=l._time+1
        end
        i=i+1
    end
end
function GP:dropGarbage(count)
    local F=self.field
    local w=self.settings.fieldW
    for _=1,count do
        local x=self:random(w)
        local y=self.settings.spawnH+1
        while F:getCell(x,y) do y=y+1 end
        F:setCell({
            color=555,
            diggable=true,
        },x,y)
    end
end
function GP:changeFieldWidth(w,origPos)
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
function GP:receive(data)
    local B={
        power=data.power,
        cancelRate=data.cancelRate,
        defendRate=data.defendRate,
        mode=data.mode,
        time=floor(data.time+.5),
        _time=0,
        fatal=data.fatal,
        speed=data.speed,
    }
    ins(self.garbageBuffer,B)
end
function GP:getScriptValue(arg)
    return
        arg.d=='field_width' and self.settings.fieldW or
        arg.d=='field_height' and self.field:getHeight() or
        arg.d=='cell' and (self.field:getCell(arg.x,arg.y) and 1 or 0)
end

--------------------------------------------------------------
-- Press & Release & Update & Render

function GP:updateFrame()
    local SET=self.settings

    -- Hard-drop lock
    if self.aHdLockTimer>0 then self.aHdLockTimer=self.aHdLockTimer-1 end
    if self.mHdLockTimer>0 then self.mHdLockTimer=self.mHdLockTimer-1 end

    -- Controlling piece
    if not self.deathTimer then
        -- Auto shift
        if self.moveDir and (self.moveDir==-1 and self.keyState.moveLeft or self.moveDir==1 and self.keyState.moveRight) then
            if self.hand and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) then
                local dist=0
                if self.moveCharge>=SET.asd then
                    if SET.asp==0 then
                        dist=1e99
                    elseif (self.moveCharge-SET.asd)%SET.asp==0 then
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
                    end
                end
                self.moveCharge=self.moveCharge+1
            else
                if not self.hand then
                    if SET.entryChrg=='full' then
                        self.moveCharge=SET.asd
                    elseif SET.entryChrg=='on' then
                        self.moveCharge=min(self.moveCharge+1,SET.asd)
                    elseif SET.entryChrg=='break' then
                        self.moveDir=false
                        self.moveCharge=0
                    end
                else
                    if SET.wallChrg=='full' then
                        self.moveCharge=SET.asd
                        self:shakeBoard(self.moveDir>0 and '-right' or '-left')
                    elseif SET.wallChrg=='on' then
                        self.moveCharge=min(self.moveCharge+1,SET.asd)
                        self:shakeBoard(self.moveDir>0 and '-right' or '-left')
                    elseif SET.wallChrg=='break' then
                        self.moveDir=false
                        self.moveCharge=0
                    end
                end
            end
        else
            self.moveDir=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
            self.moveCharge=0
        end

        -- Auto drop
        if self.downCharge and self.keyState.softDrop then
            local dropASD=SET.softdropSkipAsd and SET.asp or SET.asd
            if self.hand and not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) then
                local dist=0
                if self.downCharge>=dropASD then
                    if SET.asp==0 then
                        dist=1e99
                    elseif (self.downCharge-dropASD)%SET.asp==0 then
                        dist=1
                    end
                end
                if dist>0 then
                    local oy=self.handY
                    while dist>0 do
                        if not self:moveDown() then break end
                        dist=dist-1
                    end
                    if oy~=self.handY then
                        self:freshDelay('drop')
                        self:playSound('move_down')
                        if self.handY==self.ghostY then
                            self:shakeBoard('-down')
                        end
                    end
                end
                self.downCharge=self.downCharge+1
            else
                self.downCharge=dropASD
                if self.hand then
                    self:shakeBoard('-down')
                end
            end
        else
            self.downCharge=false
        end

        -- Update hand
        repeat
            -- Wait falling & clearing animation
            if self.fallTimer>0 then
                self.fallTimer=self.fallTimer-1
                if self.fallTimer<=0 then
                    self:updField(true)
                end
                break
            end
            if self.clearTimer>0 then
                self.clearTimer=self.clearTimer-1
                if self.clearTimer<=0 then
                    self:doClear()
                    self:updField()

                    self:triggerEvent('afterClear')

                end
                break
            end

            -- Try spawn gela if don't have one
            if self.spawnTimer>0 then
                self.spawnTimer=self.spawnTimer-1
                if self.spawnTimer<=0 then
                    self:popNext()
                end
                break
            elseif not self.hand then
                self:popNext()
            end

            -- Try lock/drop gela
            if self.handY==self.ghostY then
                self.lockTimer=self.lockTimer-1
                if self.lockTimer<=0 then
                    -- Yield LockDelay for moving
                    if self.moveDir and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) then
                        local inASD=self.moveCharge<SET.asd-SET.asp
                        if inASD and SET.freshLockInASD or not inASD and SET.freshLockInASP then
                            if self:freshDelay('move') then break end
                        end
                    end
                    self.aHdLockTimer=self.settings.aHdLock
                    self:gelaDropped()
                end
                break
            else
                if self.dropTimer>0 then
                    self.dropTimer=self.dropTimer-1
                    if self.dropTimer<=0 then
                        self:moveHand('drop',-1,true)
                    end
                elseif self.handY~=self.ghostY then -- If switch to 20G during game, gela won't dropped to bottom instantly so we force fresh it
                    self:freshDelay('drop')
                end
            end
        until true
    else
        self.deathTimer=self.deathTimer-1
        if self.deathTimer<=0 then
            self.deathTimer=false
            self.ghostState=false

            self:triggerEvent('whenSuffocate')
            self:freshGhost()

            if self:isSuffocate() then
                self:lock()
                self:finish('WA')
            end
            return
        end
    end

    -- Update garbage
    for i=1,#self.garbageBuffer do
        local g=self.garbageBuffer[i]
        if g.mode==0 and g._time<g.time then
            g._time=g._time+1
        end
    end
end
function GP:render()
    local SET=self.settings
    local skin=SKIN.get(SET.skin)
    SKIN.time=self.time

    gc_push('transform')

    -- Player's transform
    local pos=self.pos
    gc_translate(pos.x,pos.y)
    gc_scale(pos.k*(1+pos.dk))
    gc_translate(pos.dx,pos.dy)
    gc_rotate(pos.a+pos.da)

    -- Field's transform
    gc_push('transform')

        gc_translate(-200,400)

        -- Start field stencil
        GC.stc_setComp()
        GC.stc_rect(0,0,400,-920)
        gc_scale(10/SET.fieldW)

            self:triggerEvent('drawBelowField') -- From frame's bottom-left, 40px a cell

            -- Grid & Cells
            skin.drawFieldBackground(SET.fieldW)

            do -- Field
                local matrix=self.field._matrix
                gc_push('transform')
                gc_translate(0,-40) -- Move to up-left corner of first cell

                local width=SET.fieldW
                local connH=self.settings.connH
                for y=1,#matrix do
                    for x=1,width do
                        local C=matrix[y][x]
                        if C then
                            skin.drawFieldCell(C,matrix,x,y,connH)
                        end
                        gc_translate(40,0)
                    end
                    gc_translate(-40*width,-40) -- \r\n (Return + Newline)
                end
                gc_pop()
            end

            self:triggerEvent('drawBelowBlock') -- From frame's bottom-left, 40px a cell

            if self.hand then
                local CB=self.hand.matrix

                -- Ghost
                if not self.deathTimer and self.ghostY then
                    for y=1,#CB do for x=1,#CB[1] do
                        if CB[y][x] then
                            local dx,dy=(self.handX+x-2)*40,-(self.ghostY+y-1)*40
                            gc_translate(dx,dy)
                            skin.drawGhostCell(CB[y][x],CB,x,y)
                            gc_translate(-dx,-dy)
                        end
                    end end
                end

                -- Hand
                if not self.deathTimer or (2600/(self.deathTimer+260)-self.deathTimer/260)%1>.5 then
                    -- Smooth
                    local dx,dy=self:getSmoothPos()
                    gc_translate(dx,dy)
                    for y=1,#CB do for x=1,#CB[1] do
                        if CB[y][x] then
                            local dx_,dy_=(self.handX+x-2)*40,-(self.handY+y-1)*40
                            gc_translate(dx_,dy_)
                            skin.drawHandCellStroke(CB[y][x],CB,x,y)
                            gc_translate(-dx_,-dy_)
                        end
                    end end
                    for y=1,#CB do for x=1,#CB[1] do
                        if CB[y][x] then
                            local dx_,dy_=(self.handX+x-2)*40,-(self.handY+y-1)*40
                            gc_translate(dx_,dy_)
                            skin.drawHandCell(CB[y][x],CB,x,y)
                            gc_translate(-dx_,-dy_)
                        end
                    end end
                gc_translate(-dx,-dy)
                end
            end

            self:triggerEvent('drawBelowMarks') -- From frame's bottom-left, 40px a cell

            -- Height lines
            skin.drawHeightLines(     -- All unit are pixel
                SET.fieldW*40,   -- Field Width
                SET.spawnH*40,   -- Spawning height
                SET.spawnH*40,   -- Spawning height
                SET.lockoutH*40, -- Lock-out height
                SET.deathH*40,   -- Death height
                SET.voidH*40     -- Void height
            )

            self:triggerEvent('drawInField') -- From frame's bottom-left, 40px a cell

        -- Stop field stencil
        GC.stc_stop()

        -- Particles
        gc_setColor(1,1,1)
        gc_draw(self.particles.star)
        gc_draw(self.particles.trail)

    gc_pop()

    -- Field border
    skin.drawFieldBorder()

    -- ASD indicator
    skin.drawAsdIndicator(self.moveDir,self.moveCharge,self.settings.asd,self.settings.asp,self.settings.ash)

    -- Delay indicator
    if not self.hand then -- Spawn
        skin.drawDelayIndicator(COLOR.lB,self.spawnTimer/SET.spawnDelay)
    elseif self.deathTimer then -- Death
        skin.drawDelayIndicator(COLOR.R,self.deathTimer/SET.deathDelay)
    else -- Lock
        skin.drawDelayIndicator(COLOR.lY,self.lockTimer/SET.lockDelay)
    end

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Lock delay indicator
    skin.drawLockDelayIndicator(SET.freshCondition,self.freshChance,self.time<SET.readyDelay and (self.time/SET.readyDelay)^2.6 or self.freshTime/SET.maxFreshTime)

    -- Next
    gc_push('transform')
    gc_translate(200,-400)
    skin.drawNextBorder(SET.nextSlot)
    for n=1,min(#self.nextQueue,SET.nextSlot) do
        local B=self.nextQueue[n].matrix
        gc_push('transform')
            gc_translate(80+5*(-1)^n,100*n-50)
            -- gc_scale(min(2.3/#B,3/#B[1],.86))
            for y=1,#B do for x=1,#B[1] do
                if B[y][x] then
                    local dx,dy=(x-#B[1]/2-1)*40,(y-#B/2)*-40
                    gc_translate(dx,dy)
                    skin.drawNextCell(B[y][x],nil,B,x,y)
                    gc_translate(-dx,-dy)
                end
            end end
        gc_pop()
    end
    gc_pop()

    -- Timer
    skin.drawTime(self.gameTime)

    -- Debug
    -- gc.print("fallTimer "..self.fallTimer,-200,-400)
    -- gc.print("clearTimer "..self.clearTimer,-200,-370)

    -- Texts
    self.texts:draw()

    self:triggerEvent('drawOnPlayer') -- From player's center

    -- Starting counter
    if self.time<SET.readyDelay then
        skin.drawStartingCounter(SET.readyDelay)
    end

    -- Upside fade out
    gc_setBlendMode('multiply','premultiplied')
    gc_setColorMask(false,false,false,true)
    for i=0,99,2 do
        gc_setColor(0,0,0,(1-i/100)^2)
        gc_rectangle('fill',-200,-422-i,400,-2)
    end
    gc_setBlendMode('alpha')
    gc_setColorMask()

    gc_pop()
end

--------------------------------------------------------------
-- Other

function GP:decodeScript(line,errMsg)
    -- TODO
    -- error(errMsg.."No string command '"..cmd.."'")
end
function GP:checkScriptSyntax(cmd,arg,errMsg)
    -- TODO
end

--------------------------------------------------------------
-- Builder

---@class Techmino.Mode.Setting.Gela
local baseEnv={
    -- Size
    fieldW=6, -- [WARNING] This is not the real field width, just for generate field object. Change real field size with 'self:changeFieldWidth'
    spawnH=11,
    lockoutH=1e99,
    deathH=1e99,
    voidH=16,
    connH=12, -- Default to 12

    -- Color
    colorSet='classic', ---@type string|table
    colorShuffleRange=5,

    -- Clear
    clearGroupSize=4,

    -- Sequence
    seqType='twin_2S4C',
    maxOpeningLength=2,
    maxOpeningColor=3,
    nextSlot=6,

    -- Delay
    readyDelay=3000,
    dropDelay=1000,
    lockDelay=1000,
    spawnDelay=200,
    fallDelay=100,
    clearDelay=200,
    deathDelay=260,
    voidDelay=6200,

    -- Fresh
    freshCondition='fall',
    maxFreshChance=15,
    maxFreshTime=6200,

    -- Attack
    atkSys='classic',
    allowCancel=true,
    clearStuck=true,

    -- Control
    asd=122,
    asp=26,
    ash=26,
    softdropSkipAsd=true, -- *Skip asd when softdrop
    entryChrg='on',
    wallChrg='on',
    stopMoveWhenSpawn=false,
    stopMoveWhenRotate=false,
    dblMoveCover=true,
    dblMoveChrg='reset',
    dblMoveStep=true,
    dblMoveRelChrg='raw',
    dblMoveRelStep=false,
    dblMoveRelInvChrg='reset',
    dblMoveRelInvStep=true,
    dblMoveRelInvRedir=true,
    initMove='buffer',
    initRotate='buffer',
    aHdLock=60,
    mHdLock=40,
    freshLockInASD=true,
    freshLockInASP=true,

    -- Other
    script=false,
    IRSpushUp=true,
    skin='gela_jelly',
    particles=true,
    shakeness=.26,
    inputDelay=0,
}
local soundEventMeta={
    __index=defaultSoundFunc,
    __metatable=true,
}
function GP.new()
    local self=setmetatable(require'basePlayer'.new(),{__index=GP,__metatable=true})
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
        afterResetPos={},
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

        -- Other
        whenSuffocate={},
    }
    self.soundEvent=setmetatable({},soundEventMeta)

    mechLib.gela.statistics.event_playerInit[2](self)

    return self
end
function GP:initialize()
    require'basePlayer'.initialize(self)

    if self.settings.colorSet=='random' then
        self.settings.colorSet=mechLib.gela.colorSet.getRandom(self)
    elseif type(self.settings.colorSet)=='string' then
        self.settings.colorSet=mechLib.gela.colorSet[self.settings.colorSet]
    end
    assert(type(self.settings.colorSet)=='table',"Invalid P.settings.colorSet")
    self.settings.colorSet=TABLE.shift(self.settings.colorSet)
    self:shuffleColor(self.settings.colorShuffleRange)

    self.field=require'rectField'.new(self.settings.fieldW)
    self.clearingGroups={}

    self.pieceCount=0
    self.chain=0

    self.atkSysData={}
    self:atkEvent('init')
    self.garbageBuffer={}

    self.nextQueue={}
    self.seqData={}
    self.seqGen=mechLib.gela.sequence[self.settings.seqType] or self.settings.seqType
    assert(self:seqGen(self.seqData,true)==nil,"First call of sequence generator must return nil")
    self:freshNextQueue()
    self:decreaseNextColor(self.settings.maxOpeningLength,self.settings.maxOpeningColor)

    self.dropTimer=0
    self.lockTimer=0
    self.spawnTimer=self.settings.readyDelay
    self.fallTimer=0
    self.clearTimer=0
    self.deathTimer=false
    self.ghostState=false

    self.freshChance=self.settings.maxFreshChance
    self.freshTime=0

    self.hand=false -- Controlling gela object
    self.handX=false
    self.handY=false
    self.ghostY=false
    self.minY=false

    self.moveDir=false
    self.moveCharge=0
    self.downCharge=false

    self.aHdLockTimer=0
    self.mHdLockTimer=0

    self.keyBuffer={
        move=false,
        rotate=false,
        hardDrop=false,
    }
    self.dropHistory={}
    self.clearHistory={}

    self:loadScript(self.settings.script)
end
--------------------------------------------------------------

return GP
