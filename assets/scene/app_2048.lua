local gc=love.graphics
local gc_setColor,gc_rectangle=gc.setColor,gc.rectangle

local floor,abs=math.floor,math.abs
local rnd,min=math.random,math.min

---@type Zenitha.Scene
local scene={}

local invis,tapControl

local field={
    x=340,y=40,
    w=920,
}
field.mx=field.x+field.w/2
field.my=field.y+field.w/2
field.r=field.w/4

local startTime,time
local state,progress
local score,move

local autoPressing
local nextTile,nextCD
local nextPos,prevPos
local prevSpawnTime=0
local maxTile

local skipper={
    used=false,
    cd=0,
}
local repeater={
    focus=false,
    seq={"",""},last={"X","X"},
}

--[[ Tiles' value:
    -1: black tile, cannot move
    0: X tile, cannot merge
    1/2/3/...: 2/4/8/... tile
]]
local tileColor={
    [-1]=COLOR.D,
    [0]={.5,.3,.3},
    {.93,.89,.85},
    {.93,.88,.78},
    {.95,.69,.47},
    {.96,.58,.39},
    {.96,.49,.37},
    {.96,.37,.23},
    {.93,.81,.45},
    {.93,.80,.38},
    {.93,.78,.31},
    {.93,.77,.25},
    {.93,.76,.18},
    {.40,.37,.33},
    {.22,.19,.17},
}
local tileName={[0]="X"}
for i=1,19 do tileName[i]=tostring(2^i) end
tileName[20]="2^20"
local tileText={}
local function airExist()
    for i=1,16 do
        if not field[i] then
            return true
        end
    end
end
local function newTile()
    -- Select position & generate number
    nextPos=(nextPos+6)%16+1
    while field[nextPos] do
        nextPos=(nextPos-4)%16+1
    end
    field[nextPos]=nextTile
    prevPos=nextPos
    prevSpawnTime=0

    -- Fresh score
    score=score+2^nextTile
    TEXT:add{
        text="+"..2^nextTile,
        x=field.x+field.w+180+rnd(-90,90),
        y=770+rnd(-40,40),
        fontSize=40,
        style='score',
        duration=.626,
    }

    -- Generate next number
    nextCD=nextCD-1
    if nextCD>0 then
        nextTile=1
    else
        nextTile=MATH.roll(.9) and 2 or MATH.roll(.9) and 3 or 4
        nextCD=rnd(8,12)
    end

    -- Check if board is full
    if airExist() then return end

    -- Check if board is locked in all-directions
    for i=1,12 do
        if field[i]==field[i+4] then
            return
        end
    end
    for i=1,13,4 do
        if
            field[i+0]==field[i+1] or
            field[i+1]==field[i+2] or
            field[i+2]==field[i+3]
        then
            return
        end
    end

    -- Die.
    state=2
    FMOD.effect(maxTile>=10 and 'win' or 'fail')
end
local function freshMaxTile()
    maxTile=maxTile+1
    if maxTile==12 then
        skipper.cd=0
    end
    FMOD.effect('beep_notice')
    table.insert(progress,("%s - %.3fs"):format(tileName[maxTile],love.timer.getTime()-startTime))
end
local function squash(L)
    local p1,p2=1
    local moved=false
    while true do
        p2=p1+1
        while not L[p2] and p2<5 do
            p2=p2+1
        end
        if p2==5 then
            if p1==4 then
                return L[1],L[2],L[3],L[4],moved
            else
                p1=p1+1
            end
        else
            if not L[p1] then -- air←2
                L[p1],L[p2]=L[p2],false
                moved=true
            elseif L[p1]==L[p2] then -- 2←2
                L[p1],L[p2]=L[p1]+1,false
                if L[p1]>maxTile then
                    freshMaxTile()
                end
                L[p2]=false
                p1=p1+1
                moved=true
            elseif p1+1~=p2 then -- 2←4
                L[p1+1],L[p2]=L[p2],false
                p1=p1+1
                moved=true
            else -- 2,4
                p1=p1+1
            end
        end
    end
end
local function reset()
    for i=1,16 do field[i]=false end
    state,progress=0,{}
    score,move=0,0
    time=0
    maxTile=6
    nextTile,nextPos=1,rnd(16)
    nextCD=32
    skipper.cd,skipper.used=false,false
    repeater.seq[1],repeater.seq[2]="",""
    repeater.last[1],repeater.last[2]="X","X"
    newTile()
end

local function moveUp()
    local moved
    for i=1,4 do
        local m
        field[i],field[i+4],field[i+8],field[i+12],m=squash({field[i],field[i+4],field[i+8],field[i+12]})
        if m then moved=true end
    end
    return moved
end
local function moveDown()
    local moved
    for i=1,4 do
        local m
        field[i+12],field[i+8],field[i+4],field[i],m=squash({field[i+12],field[i+8],field[i+4],field[i]})
        if m then moved=true end
    end
    return moved
end
local function moveLeft()
    local moved
    for i=1,13,4 do
        local m
        field[i],field[i+1],field[i+2],field[i+3],m=squash({field[i],field[i+1],field[i+2],field[i+3]})
        if m then moved=true end
    end
    return moved
end
local function moveRight()
    local moved
    for i=1,13,4 do
        local m
        field[i+3],field[i+2],field[i+1],field[i],m=squash({field[i+3],field[i+2],field[i+1],field[i]})
        if m then moved=true end
    end
    return moved
end
local function skip()
    if state==1 and skipper.cd==0 then
        if airExist() then
            skipper.cd=1024
            skipper.used=true
            newTile()
            FMOD.effect('hold')
        else
            FMOD.effect('beep_drop')
        end
    end
end

function scene.enter()
    for i=1,#tileName do
        tileText[i]=gc.newText(FONT.get(80,'_norm'),tileName[i])
    end
    BG.set('space')

    invis=false
    tapControl=false
    startTime=0
    reset()
end

function scene.mouseDown(x,y,k)
    if tapControl then
        if k==2 then
            skip()
        else
            local dx,dy=x-(field.mx),y-(field.my)
            if abs(dx)<field.w/2 and abs(dy)<field.w/2 and (abs(dx)>field.w*.1 or abs(dy)>field.w*.1) then
                scene.keyDown(abs(dx)-abs(dy)>0 and
                    (dx>0 and 'right' or 'left') or
                    (dy>0 and 'down' or 'up')
                )
            end
        end
    end
end
scene.touchDown=scene.mouseDown

local moveFunc={
    up=moveUp,
    down=moveDown,
    left=moveLeft,
    right=moveRight,
}
local arrows={
    up='↑',down='↓',left='←',right='→',
    ['↑']='up',['↓']='down',['←']='left',['→']='right',
}
local function setFocus(n)
    if state~=2 then
        repeater.focus=n
        repeater.seq[n]=""
    end
end
local function playRep(n)
    if state~=2 and #repeater.seq[n]>0 then
        repeater.focus=false
        local move0=move
        for i=1,#repeater.seq[n],3 do
            autoPressing=true
            scene.keyDown(arrows[repeater.seq[n]:sub(i,i+2)])
            autoPressing=false
        end
        if move~=move0 then
            if repeater.seq[n]~=repeater.last[n] then
                repeater.last[n]=repeater.seq[n]
                move=move0+#repeater.seq[n]/3+1
            else
                move=move0+1
            end
        end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='up' or key=='down' or key=='left' or key=='right' then
        if repeater.focus then
            local f=repeater.focus
            if #repeater.seq[f]<24 then
                repeater.seq[f]=repeater.seq[f]..arrows[key]
            end
        else
            if moveFunc[key]() then
                if state==0 then
                    startTime=love.timer.getTime()
                    state=1
                end
                if skipper.cd and skipper.cd>0 then
                    skipper.cd=skipper.cd-1
                    if skipper.cd==0 then
                        FMOD.effect('spin_0')
                    end
                end
                newTile()
                TEXT:add{
                    text=arrows[key],
                    x=field.mx,y=field.my,
                    fontSize=100,
                    style='beat',
                    duration=.26,
                }
                move=move+1
                if not autoPressing then
                    FMOD.effect('touch')
                end
            end
        end
    elseif key=='space' then skip()
    elseif key=='r' then reset()
    elseif key=='q' then if state==0 then invis=not invis end
    elseif key=='w' then if state==0 then tapControl=not tapControl end
    elseif key=='1' or key=='2' then (isKeyDown('lshift','lctrl','lalt') and playRep or setFocus)(key=='1' and 1 or 2)
    elseif key=='c1' then playRep(1)
    elseif key=='c2' then playRep(2)
    elseif key=='return' then
        if repeater.focus then
            repeater.focus=false
        end
    elseif key=='escape' then
        if repeater.focus then
            repeater.focus=false
        else
            if sureCheck('back') then SCN.back() end
        end
    end
    return true
end

function scene.update(dt)
    if state==1 then
        time=love.timer.getTime()-startTime
    end
    if prevSpawnTime<1 then
        prevSpawnTime=min(prevSpawnTime+3*dt,1)
    end
end

function scene.draw()
    -- Field
    gc.setLineWidth(10)
    if state==2 then
        gc_setColor(.9,.9,0)-- win
    elseif state==1 then
        gc_setColor(.9,.9,.9)-- game
    elseif state==0 then
        gc_setColor(.2,.8,.2)-- ready
    end
    gc_rectangle('line',field.x-10,field.y-10,field.w+20,field.w+20,25)

    for i=1,16 do
        if field[i] then
            local r=field.r
            local x,y=field.x+r*((i-1)%4)+3,field.y+r*(floor((i-1)/4))+3
            local N=field[i]
            local textScale=min(field.r/tileText[N]:getWidth(),field.r/tileText[N]:getHeight())/1.26
            if i~=prevPos or prevSpawnTime==1 then
                if not invis or i==prevPos then
                    gc_setColor(tileColor[N] or COLOR.D)
                    gc_rectangle('fill',x,y,r-6,r-6,15)
                    if N>=0 then
                        gc_setColor(N<3 and COLOR.D or COLOR.L)
                        GC.mDraw(tileText[N],x+r/2,y+r/2,nil,textScale)
                    end
                else
                    gc_setColor(COLOR.DL)
                    gc_rectangle('fill',x,y,r-6,r-6,15)
                end
            else
                local c=tileColor[N]
                gc_setColor(c[1],c[2],c[3],prevSpawnTime)
                gc_rectangle('fill',x,y,r-6,r-6,15)
                c=N<3 and 0 or 1
                gc_setColor(c,c,c,prevSpawnTime)
                GC.mDraw(tileText[N],x+r/2,y+r/2,nil,textScale)
            end
        end
    end

    -- New tile position
    local x,y=1+(prevPos-1)%4,floor((prevPos+3)/4)
    gc.setLineWidth(8)
    gc_setColor(.2,.8,0,prevSpawnTime)
    local d=25-prevSpawnTime*25
    gc_rectangle('line',field.x+field.r*(x-1)+3-d,field.y+field.r*(y-1)+3-d,field.r-6+2*d,field.r-6+2*d,15)

    -- Time and moves
    FONT.set(50)
    gc_setColor(COLOR.L)
    gc.print(("%.3f"):format(time),1300,10)
    gc.print(move,1300,60)

    -- Progress time list
    FONT.set(20)
    gc_setColor(.6,.6,.6)
    for i=1,#progress do
        gc.print(progress[i],1300,120+20*i)
    end

    -- Score
    FONT.set(40)
    gc_setColor(1,.7,.7)
    GC.mStr(score,field.x+field.w+180,700)

    -- Touch control border line
    if tapControl then
        gc.setLineWidth(6)
        gc_setColor(1,1,1,.2)
        local r=field.w*.4
        gc.line(field.x,field.y,field.x+r,field.y+r)
        gc.line(field.x+field.w,field.y,field.x+field.w-r,field.y+r)
        gc.line(field.x,field.y+field.w,field.x+r,field.y+field.w-r)
        gc.line(field.x+field.w,field.y+field.w,field.x+field.w-r,field.y+field.w-r)
        gc_rectangle('line',field.x+r,field.y+r,field.w*.2,field.w*.2,10)
    end

    -- Skip mark
    if skipper.used then
        gc.circle('fill',field.x-35,field.y+field.w-20,10)
    end

    -- Skip cooldown
    gc.replaceTransform(SCR.xOy_dl)
    gc_setColor(1,1,.5)
    if skipper.cd and skipper.cd>0 then
        FONT.set(50)
        GC.mStr(skipper.cd,180,-420)
    end

    -- Repeater
    gc.replaceTransform(SCR.xOy_r)
    gc.setLineWidth(6)
    FONT.set(30)
    for i=1,2 do
        gc_setColor(
            repeater.focus==i and (
                love.timer.getTime()%.5>.25 and
                COLOR.R or COLOR.Y
            ) or (
                repeater.seq[i]==repeater.last[i] and
                COLOR.DL or COLOR.L
            )
        )
        gc_rectangle('line',-265,-115+60*i,250,50,5)
        gc.print(repeater.seq[i],-260,-150+100*i)
    end

    -- Next & Next indicator
    gc.replaceTransform(SCR.xOy_l)
    FONT.set(60)
    gc_setColor(COLOR.L)
    gc.print("Next",50,-35)
    if nextTile>1 then gc_setColor(1,.5,.4) end
    FONT.set(100)
    GC.mStr(tileName[nextTile],270,-65)

    if nextCD<=12 then
        gc_setColor(COLOR.L)
        for i=1,nextCD do
            gc_rectangle('fill',130+i*20-nextCD*8,-70,16,16)
        end
    end

    -- Draw no-setting area
    gc.replaceTransform(SCR.xOy_ul)
    if state==2 then
        gc_setColor(1,0,0,.3)
        gc_rectangle('fill',30,190,300,140)
    end
end

local function visFunc1() return not tapControl end
scene.widgetList={
    WIDGET.new{type='button',  pos={0,0}, x=160, y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,code=WIDGET.c_pressKey'r'},
    WIDGET.new{type='checkBox',pos={0,0}, x=300, y=220,text="Invis",widthLimit=270,fontSize=40,disp=function() return invis end,     code=WIDGET.c_pressKey'q',visibleTick=function() return state~=1 end},
    WIDGET.new{type='checkBox',pos={0,0}, x=300, y=300,text="Tap",  widthLimit=270,fontSize=40,disp=function() return tapControl end,code=WIDGET.c_pressKey'w',visibleTick=function() return state~=1 end},

    WIDGET.new{type='button',  pos={0,1}, x=180, y=-280,w=100,     sound_trigger=false,text="↑",fontSize=50,color='Y', code=WIDGET.c_pressKey'up',   visibleTick=visFunc1},
    WIDGET.new{type='button',  pos={0,1}, x=180, y=-80, w=100,     sound_trigger=false,text="↓",fontSize=50,color='Y', code=WIDGET.c_pressKey'down', visibleTick=visFunc1},
    WIDGET.new{type='button',  pos={0,1}, x=80,  y=-180,w=100,     sound_trigger=false,text="←",fontSize=50,color='Y', code=WIDGET.c_pressKey'left', visibleTick=visFunc1},
    WIDGET.new{type='button',  pos={0,1}, x=280, y=-180,w=100,     sound_trigger=false,text="→",fontSize=50,color='Y', code=WIDGET.c_pressKey'right',visibleTick=visFunc1},
    WIDGET.new{type='button',  pos={0,1}, x=180, y=-390,w=100,     sound_trigger=false,text="S",fontSize=50,color='Y', code=WIDGET.c_pressKey'space',visibleTick=function() return state==1 and skipper.cd==0 end},
    WIDGET.new{type='button',  pos={1,.5},x=-140,y=-30, w=250,h=50,sound_trigger=false,                     color='lT',code=WIDGET.c_pressKey'1',    visibleTick=function() return state~=2 end},
    WIDGET.new{type='button',  pos={1,.5},x=-140,y=30,  w=250,h=50,sound_trigger=false,                     color='lT',code=WIDGET.c_pressKey'2',    visibleTick=function() return state~=2 end},
    WIDGET.new{type='button',  pos={1,.5},x=-300,y=-30, w=50,      sound_trigger=false,text=">",fontSize=50,color='R', code=WIDGET.c_pressKey'c1',   visibleTick=function() return state~=2 and #repeater.seq[1]~=0 end},
    WIDGET.new{type='button',  pos={1,.5},x=-300,y=30,  w=50,      sound_trigger=false,text=">",fontSize=50,color='R', code=WIDGET.c_pressKey'c2',   visibleTick=function() return state~=2 and #repeater.seq[2]~=0 end},
    WIDGET.new{type='button',  pos={1,1}, x=-120,y=-80, w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
