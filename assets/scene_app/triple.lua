local gc=love.graphics
local gc_setColor,gc_rectangle=gc.setColor,gc.rectangle

local floor,rnd=math.floor,math.random
local ins,rem=table.insert,table.remove

local setFont,mStr=FONT.set,GC.mStr

local tileTexts=setmetatable({
    [-9]=CHAR.icon.star,
    [-7]=CHAR.icon.upload,
    [-5]=CHAR.icon.bombBlock,
    [-3]=CHAR.icon.star,
    [-2]=CHAR.icon.moon,
    [-1]=CHAR.icon.sun_strong,
},{__index=function(t,k) t[k]=k return k end})
local colors=setmetatable({
    [-9]={COLOR.Y,COLOR.DY},         -- Star
    [-7]={COLOR.dL,COLOR.LD},        -- Shovel
    [-5]={COLOR.R,COLOR.dR},         -- Bomb
    [-3]={COLOR.DL,COLOR.lD},        -- Statue lv1
    [-2]={COLOR.DL,COLOR.lD},        -- Statue lv2
    [-1]={COLOR.DL,COLOR.lD},        -- Statue lv3
    {{.39, 1.0, .39},{.26, .66, .26}}, -- Tile 1
    {{.39, .39, 1.0},{.26, .26, .66}}, -- Tile 2
    {{1.0, .70, .31},{.66, .46, .20}}, -- Tile 3
    {{.94, .31, .31},{.62, .20, .20}}, -- Tile 4
    {{.00, .71, .12},{.00, .48, .08}}, -- Tile 5
    {{.90, .20, .90},{.60, .14, .60}}, -- Tile 6
    {{.94, .47, .39},{.62, .32, .26}}, -- Tile 7
    {{.90, .00, .00},{.60, .00, .00}}, -- Tile 8
    {{.86, .86, .31},{.58, .58, .20}}, -- Tile 9
    {{.78, .31, .00},{.52, .20, .00}}, -- Tile 10
},{
    __index=function(t,k)
        t[k]={COLOR.random(5),COLOR.random(4)}
        return t[k]
    end
})

local P={x=350,y=50,w=900,h=900}
P.c=P.w/6

function P:getHolyPoint()
    local holy=0
    for y=1,6 do for x=1,6 do
        local b=self.board[y][x]
        if b and b<0 then
            holy=holy+(b<=-2 and b+4 or 10)
        end
    end end
    return holy
end
function P:newTile()
    local r=rnd()
    -- do return -3 end
    -- do return -5 end
    -- do return -7 end
    -- do return -9 end
    -- Holy point will make value smaller, cause larger probability of special items
    r=r*(1-math.min(P:getHolyPoint(),26)*.026)
    if r<.005-P:getHolyPoint()*.0005 then -- 0.5% (→0%) chance of statue, each holy point make it 0.05% lower
        return -3
    elseif r<.010 then -- 0.5% (→1%) chance of star
        return -9
    elseif r<.015 then -- 0.5% chance of shovel
        return -7
    elseif r<.026 then -- 1.1% chance of bomb
        return -5
    else -- 97.4% chance of normal tile, max at 6
        local t=1
        if rnd()<.12 then t=t+1 end
        if rnd()<.26 then t=t+1 end
        if self.maxTile>=4  and rnd()<.26 then t=t+1 end
        if self.maxTile>=6  and rnd()<.26 then t=t+1 end
        if self.maxTile>=8  and rnd()<.42 then t=t+1 end
        if self.maxTile>=10 and rnd()<.62 then t=t+1 end
        return t
    end
end

function P:reset()
    self.progress={}
    self.state=0
    self.time=0
    self.startTime=false
    self.score=0
    self.maxTile=3

    self.board={}
    for y=1,6 do
        self.board[y]={}
        for x=1,6 do
            self.board[y][x]=0
        end
    end
    self.board[1][1]=false
    self.nexts,self.holdTile={self:newTile(),self:newTile(),self:newTile()},false
    self.selectX,self.selectY=false,false

    for _,n in next,{-3,-3,1,1,2,2,3,3} do
        local x,y
        repeat
            x,y=rnd(6),rnd(6)
        until not (x==1 and y==1) and self.board[y][x]==0
        self.board[y][x]=n
    end
end

local function merge(b,v,x,y,l)
    if b[y] and v==b[y][x] then
        ins(l,{x,y})
        b[y][x]=0
        merge(b,v,x,y-1,l)
        merge(b,v,x,y+1,l)
        merge(b,v,x-1,y,l)
        merge(b,v,x+1,y,l)
    end
end

function P:canPlaceAt(x,y)
    local old=self.board[y or self.selectY][x or self.selectX]
    local new=self.nexts[1]
    return
        new==-9 and old==0 or -- Star
        new==-7 and old~=0 or -- Shovel
        new==-5 and old~=0 or -- Bomb

        new==-3 and old==0 or -- Statue lv1
        new==-2 and old==0 or -- Statue lv2
        new==-1 and old==0 or -- Statue lv3

        new==0 and false or

        new>0 and old==0
end
function P:newMergeFX(x,y,tile)
    local r,g,b
    if tile==-5 then
        -- Bomb
        r,g,b=1,.6,.26
    elseif tile==-7 then
        -- Shovel
        r,g,b=.42,.42,.42
    elseif tile==-9 then
        -- Star
        r,g,b=1,1,.26
    end
    SYSFX.rect(.26,self.x+self.c*(x-1),self.y+self.c*(y-1),self.c,self.c,r,g,b)
end
function P:select(x,y)
    if self:canPlaceAt(x,y) then
        self.selectX,self.selectY=x,y
    else
        self.selectX,self.selectY=false,false
    end
end
function P:hold()
    self.nexts[1],self.holdTile=self.holdTile,self.nexts[1]
    FMOD.effect('hold')
    if not self.nexts[1] then
        rem(self.nexts,1)
        ins(self.nexts,self:newTile())
    end
end
function P:legalTile(x,y)
    local b=self.board
    local n=b[y] and b[y][x]
    return n and n~=0
end
function P:calculateStar(x,y) -- Star will choose the best tile around
    local b=self.board
    local choice={}
    if self:legalTile(x-1,y) then ins(choice,b[y][x-1]) end
    if self:legalTile(x+1,y) then ins(choice,b[y][x+1]) end
    if self:legalTile(x,y-1) then ins(choice,b[y-1][x]) end
    if self:legalTile(x,y+1) then ins(choice,b[y+1][x]) end
    if #choice==0 then
        return -3
    else
        for i=1,#choice do
            local c={tile=choice[i],score=choice[i]}
            choice[i]=c

            -- Simulate merging
            local b1,mergedTiles=TABLE.copy(self.board),{}
            b1[y][x]=c.tile
            merge(b1,c.tile,x,y,mergedTiles)

            -- Change to statue 1 if no merging
            if #mergedTiles<3 then
                c.tile=-3
                c.score=-1e99
            end
        end
        table.sort(choice,function(c1,c2) return c1.score>c2.score end)
        return choice[1].tile
    end
end
function P:click(x,y)
    if x==1 and y==1 then
        -- Hold
        self:hold()
    elseif not (x==self.selectX and y==self.selectY) then
        -- Select
        self:select(x,y)
    else
        -- Confirm
        if not self:canPlaceAt() then return end
        if self.state==0 then
            self.state=1
            self.startTime=love.timer.getTime()
        end

        if self.nexts[1]==-5 then
            -- Bomb
            self.board[y][x]=0
            FMOD.effect('clear_2')
            rem(self.nexts,1)
            ins(self.nexts,self:newTile())
            self:newMergeFX(x,y,-2)
        elseif self.nexts[1]==-7 then
            -- Shovel
            self.nexts[1]=self.board[y][x]
            self.board[y][x]=0
            self:newMergeFX(x,y,-3)
            FMOD.effect('hold_init')
        else
            -- Normal tile
            if self.nexts[1]==-9 then
                self.nexts[1]=self:calculateStar(x,y)
                print(self.nexts[1])
                FMOD.effect('rotate_special')
            end
            self.board[y][x]=rem(self.nexts,1)
            FMOD.effect('move')

            local cur,merged
            local textDY=.42
            repeat
                cur=self.board[y][x]
                if cur==0 then -- Possible when merging Statue lv3
                    TEXT:add{text=CHAR.zchan.mrz,x=P.x+(self.selectX-.5)*self.c,y=P.y+(self.selectY-.4)*self.c,fontSize=50,k=2,style='score',duration=6.26}
                    break
                end
                local b1,mergedTiles=TABLE.copy(self.board),{}
                merge(b1,cur,x,y,mergedTiles)
                local count=#mergedTiles
                if count>=3 then
                    merged=true
                    self.board=b1
                    b1[y][x]=cur+1

                    if cur+1>self.maxTile then
                        self.maxTile=cur+1
                        if self.maxTile>=6 then
                            ins(self.progress,("%s - %.3fs"):format(self.maxTile,love.timer.getTime()-P.startTime))
                        end
                        FMOD.effect('beep_rise')
                    end

                    local getScore=4^(cur>0 and cur or cur+10)*count
                    self.score=self.score+getScore
                    TEXT:add{text=getScore,x=P.x+(self.selectX-.5)*self.c,y=P.y+(self.selectY-.5-textDY)*self.c,fontSize=60,style='score',duration=math.log(getScore,3)/1.626}
                    textDY=textDY+.26
                    for i=1,#mergedTiles do
                        self:newMergeFX(mergedTiles[i][1],mergedTiles[i][2],cur+1)
                    end
                end
            until count<=2

            ins(self.nexts,self:newTile())

            self.selectX,self.selectY=false,false

            if merged then
                FMOD.effect('touch')
                if cur>=4 then
                    FMOD.effect(
                        cur>=8 and 'spin_4' or
                        cur>=7 and 'spin_3' or
                        cur>=6 and 'spin_2' or
                        cur>=5 and 'spin_1' or
                        'spin_0'
                    )
                end
            else -- Alive checking
                -- Having bomb?
                if self.nexts[1]==-5 or self.holdTile==-5 then return end

                -- Any space?
                for i=1,6 do if TABLE.find(self.board[i],0) then return end end

                self.state=2
                FMOD.effect('finish_suffocate')
            end
        end
    end
end

function P:drawTile(x,y,val,size)
    if val and val~=0 then
        gc.push('transform')
        gc.translate((x-.5)*self.c,(y-.5)*self.c)
        gc.scale(size)
        gc_setColor(colors[val][1])
        gc_rectangle('fill',-self.c/2,-self.c/2,self.c,self.c)
        gc_setColor(colors[val][2])
        mStr(tileTexts[val],0,-50)
        gc.pop()
    end
end
function P:draw()
    gc.push('transform')
        gc.translate(self.x,self.y)

        -- Board background
        gc_setColor(COLOR.dT)
        gc_rectangle('fill',0,0,self.w,self.h)

        -- Hold slot
        gc_setColor(COLOR.lC)
        gc_rectangle('fill',0,0,self.c,self.c)
        gc_setColor(COLOR.C)
        gc_rectangle('fill',10,10,self.c-20,self.c-20)

        setFont(75)

        -- Hold tile
        self:drawTile(1,1,self.holdTile,.7)

        -- Board tiles
        local b=self.board
        for y=1,6 do for x=1,6 do
            self:drawTile(x,y,b[y][x],1)
        end end

        -- Board lines
        gc_setColor(COLOR.L)
        gc.setLineWidth(2)
        for x=0,6 do gc.line(x*self.c,0,x*self.c,P.w) end
        for y=0,6 do gc.line(0,y*self.c,P.w,y*self.c) end

        -- Cursor
        if self.selectX then
            local c=colors[self.nexts[1]][1]
            gc.setLineWidth(10)
            gc_setColor(c[1],c[2],c[3],.6+.3*math.sin(love.timer.getTime()*9.29))
            gc_rectangle('line',(self.selectX-1)*self.c+10,(self.selectY-1)*self.c+10,self.c-20,self.c-20)
        end

        -- Previews
        self:drawTile(-0.62,2.6,P.nexts[1],.8)
        self:drawTile(-0.72,3.4,P.nexts[2],.6)
        self:drawTile(-0.82,4.0,P.nexts[3],.4)

        setFont(25,'bold')
        gc_setColor(COLOR.L)
        mStr("Current",-166,220)

    gc.pop()
end

---@type Zenitha.Scene
local scene={}

function scene.load()
    P:reset()
end

function scene.mouseMove(x,y)
    x,y=floor((x-P.x)/P.c)+1,floor((y-P.y)/P.c)+1
    if MATH.between(x,1,6) and MATH.between(y,1,6) then
        P:select(x,y)
    end
end
function scene.mouseDown(x,y,k)
    if k==1 then
        x,y=floor((x-P.x)/P.c)+1,floor((y-P.y)/P.c)+1
        if MATH.between(x,1,6) and MATH.between(y,1,6) then
            P:click(x,y)
        end
    else
        P:hold()
    end
end
function scene.touchClick(x,y)
    x,y=floor((x-P.x)/P.c)+1,floor((y-P.y)/P.c)+1
    if MATH.between(x,1,6) and MATH.between(y,1,6) then
        P:click(x,y)
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='up' or key=='down' or key=='left' or key=='right' then
        if not P.selectX then
            P.selectX,P.selectY=3,3
        else
            if key=='up' then P.selectY=math.max(P.selectY-1,1)
            elseif key=='down' then P.selectY=math.min(P.selectY+1,6)
            elseif key=='left' then P.selectX=math.max(P.selectX-1,1)
            elseif key=='right' then P.selectX=math.min(P.selectX+1,6)
            end
        end
    elseif key=='z' then
        P:hold()
    elseif key=='space' then
        if P.selectX then
            local y,x=P.selectY,P.selectX
            P:click(P.selectX,P.selectY)
            P.selectY,P.selectX=y,x
        end
    elseif key=='r' then
        if P.state~=1 or SureCheck('reset') then
            P:reset()
        end
    elseif key=='escape' then
        if SureCheck('back') then SCN.back() end
    end
    return true
end

function scene.update()
    if P.state==1 then
        P.time=love.timer.getTime()-P.startTime
    end
end

function scene.draw()
    setFont(40)
    gc_setColor(1,1,1)
    gc.print(STRING.time(P.time),1326,50)
    gc.print(P.score,1326,100)

    -- Progress time list
    setFont(25)
    gc_setColor(.7,.7,.7)
    for i=1,#P.progress do
        gc.print(P.progress[i],1326,140+30*i)
    end

    P:draw()
end

scene.widgetList={
    WIDGET.new{type='button',x=160,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,onClick=WIDGET.c_pressKey'r'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_release='button_back',fontSize=60,text=CHAR.icon.back,onClick=WIDGET.c_backScn()},
}
return scene
