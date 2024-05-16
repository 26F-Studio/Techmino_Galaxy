local gc=love.graphics
local gc_setColor,gc_rectangle,gc_draw=gc.setColor,gc.rectangle,gc.draw
local setFont,mStr=FONT.set,GC.mStr

local floor,rnd,abs=math.floor,math.random,math.abs
local max,min=math.max,math.min
local ins,rem=table.insert,table.remove

local levels={
    {c=6,r=3,color=3},
    {c=6,r=4,color=3},
    {c=6,r=4,color=4},
    {c=8,r=5,color=4},
    {c=8,r=6,color=5},
    {c=9,r=6,color=5},
    {c=10,r=6,color=6},
    {c=12,r=7,color=6},
    {c=14,r=8,color=7},
    {c=14,r=9,color=7},
    {c=15,r=10,color=7},
    {c=17,r=10,color=8},
    {c=18,r=11,color=8},
    {c=20,r=12,color=9},
    {c=22,r=13,color=9},
    {c=24,r=14,color=9},
}
local colorList={
    COLOR.lR,
    COLOR.lB,
    COLOR.lY,
    COLOR.lG,
    COLOR.lM,
    COLOR.lC,
    COLOR.DL,
    COLOR.L,
    COLOR.lF,
}
gc.setDefaultFilter('nearest','nearest')
local iconList={
    GC.load{10,10,{'fRect',2,2,6,6}},
    GC.load{10,10,{'dRect',2.5,2.5,5,5}},
    GC.load{10,10,{'fCirc',5,5,2}},
    GC.load{10,10,{'fRect',2,2,2,6},{'fRect',6.5,2,2,6}},
    GC.load{10,10,{'fRect',2,2,1,1},{'fRect',3,3,1,1},{'fRect',4,4,1,1},{'fRect',5,5,1,1},{'fRect',6,6,1,1},{'fRect',7,7,1,1}},
    GC.load{10,10,{'fRect',2,2,2,2},{'fRect',2,6,2,2},{'fRect',6,2,2,2},{'fRect',6,6,2,2}},
    GC.load{1,1},
    GC.load{10,10,{'fRect',2,2,1,6},{'fRect',3,2,1,5},{'fRect',4,2,1,4},{'fRect',5,2,1,3},{'fRect',6,2,1,2},{'fRect',7,2,1,1}},
    GC.load{10,10,{'fRect',2,5,3,3},{'fRect',5,2,3,3}},
}
gc.setDefaultFilter('linear','linear')

local invis
local state
local startTime,time
local progress,level
local score,score1
local combo,comboTime,maxCombo,noComboBreak
local field={
    x=200,y=100,
    w=1200,h=800,
    c=16,r=10,
    remain=0,
}
local lines={}
local selX,selY

local function resetBoard()
    selX,selY=false,false

    local colors=levels[level].color
    field.c,field.r=levels[level].c,levels[level].r

    local total=field.r*field.c/2-- Total cell count
    local pool=TABLE.new(floor(total/colors),colors)
    for i=1,total%colors do pool[i]=pool[i]+1 end
    for i=1,#pool do pool[i]=pool[i]*2 end
    field.remain=total
    field.full=true
    total=total*2

    TABLE.clear(field)
    for y=1,field.r do
        field[y]={}
        for x=1,field.c do
            local ri=0
            local rn=rnd(total)
            while rn>0 do
                ri=ri+1
                rn=rn-pool[ri]
            end
            total=total-1
            pool[ri]=pool[ri]-1
            field[y][x]=ri
        end
    end

    noComboBreak=true
    comboTime=comboTime+2
    SYSFX.rect(.5,field.x,field.y,field.w,field.h,.8,.8,.8)
end
local function newGame()
    state=0
    level=1
    progress={}
    time=0
    startTime=love.timer.getTime()
    score,score1,combo,comboTime,maxCombo=0,0,0,0,0
    resetBoard()
end
local function addPoint(list,x,y)
    local l=#list
    if x~=list[l-1] or y~=list[l] then
        list[l+1]=x
        list[l+2]=y
    end
end
local function checkLink(x1,y1,x2,y2)-- Most important function!
    -- Y-X-Y Check
    local bestLen,bestLine=1e99,false
    do
        if x1>x2 then x1,y1,x2,y2=x2,y2,x1,y1 end
        local luy,ldy,ruy,rdy=y1,y1,y2,y2
        while luy>1       and not field[luy-1][x1] do luy=luy-1 end
        while ldy<field.r and not field[ldy+1][x1] do ldy=ldy+1 end
        while ruy>1       and not field[ruy-1][x2] do ruy=ruy-1 end
        while rdy<field.r and not field[rdy+1][x2] do rdy=rdy+1 end
        for y=max(luy,ruy),min(ldy,rdy) do
            local nextRow
            for x=x1+1,x2-1 do if field[y][x] then nextRow=true break end end
            if not nextRow then
                local len=abs(x1-x2)+abs(y-y1)+abs(y-y2)
                if len<bestLen then
                    bestLen=len
                    bestLine={x1,y1}
                    addPoint(bestLine,x1,y)
                    addPoint(bestLine,x2,y)
                    addPoint(bestLine,x2,y2)
                end
            end
        end
    end
    -- X-Y-X Check
    do
        if y1>y2 then x1,y1,x2,y2=x2,y2,x1,y1 end
        local ulx,urx,dlx,drx=x1,x1,x2,x2
        while ulx>1       and not field[y1][ulx-1] do ulx=ulx-1 end
        while urx<field.c and not field[y1][urx+1] do urx=urx+1 end
        while dlx>1       and not field[y2][dlx-1] do dlx=dlx-1 end
        while drx<field.c and not field[y2][drx+1] do drx=drx+1 end
        for x=max(ulx,dlx),min(urx,drx) do
            local nextCol
            for y=y1+1,y2-1 do if field[y][x] then nextCol=true break end end
            if not nextCol then
                local len=abs(y1-y2)+abs(x-x1)+abs(x-x2)
                if len<bestLen then
                    bestLen=len
                    bestLine={x1,y1}
                    addPoint(bestLine,x,y1)
                    addPoint(bestLine,x,y2)
                    addPoint(bestLine,x2,y2)
                end
            end
        end
    end
    return bestLine
end
local function tap(x,y)
    if x<1 or x>field.c or y<1 or y>field.r then return end
    if state==0 then
        state=1
        startTime=love.timer.getTime()
    elseif state==1 then
        if selX and (x~=selX or y~=selY) and field[y][x]==field[selY][selX] then
            local line=checkLink(x,y,selX,selY)
            if line then
                ins(lines,{time=0,line=line})

                -- Clear
                field[y][x]=false
                field[selY][selX]=false
                field.remain=field.remain-1
                field.full=false

                -- Score
                local s=1000+floor(combo^.9)
                score=score+s
                TEXT:add{text="+"..s,x=1500,y=600,fontSize=20,style='score'}

                -- Combo
                if comboTime==0 then
                    combo=0
                    noComboBreak=false
                end
                comboTime=comboTime*max(1-combo*.001,.95)+max(1-combo*.01,.8)
                combo=combo+1
                if combo>maxCombo then maxCombo=combo end

                -- Check win
                if field.remain==0 then
                    FMOD.effect('frenzy',{volume=.8})
                    if noComboBreak then
                        TEXT:add{text="FULL COMBO",x=800,y=500,fontSize=100,style='beat',styleArg=.626}
                        comboTime=comboTime+3
                        score=floor(score*1.1)
                        FMOD.effect(
                            level==1 and 'clear_2' or
                            level==2 and 'clear_3' or
                            level==3 and 'clear_4' or
                            level==4 and 'clear_5' or
                            level==5 and 'clear_6' or
                            level==6 and 'clear_8' or
                            level==7 and 'clear_10' or
                            level==8 and 'clear_12' or
                            level==9 and 'clear_14' or
                            level==10 and 'clear_16' or
                            level==11 and 'clear_18' or
                            level==12 and 'clear_20' or
                            level==13 and 'clear_21' or
                            level==14 and 'clear_22' or
                            level==15 and 'clear_24' or
                            'clear_26'
                        )
                    end
                    ins(progress,
                        noComboBreak and
                        ("%s [FC] %.2fs"):format(level,love.timer.getTime()-startTime) or
                        ("%s - %.2fs"):format(level,love.timer.getTime()-startTime)
                    )
                    level=level+1
                    if levels[level] then
                        resetBoard()
                        FMOD.effect('beep_rise')
                    else
                        state=2
                        FMOD.effect('win')
                    end
                else
                    FMOD.effect(
                        combo<50 and 'touch' or
                        combo<100 and 'lock' or
                        'drop'
                    )
                end
                selX,selY=false,false
            else
                selX,selY=x,y
                FMOD.effect('move',{volume=.9})
            end
        else
            if field[y][x] and (x~=selX or y~=selY) then
                selX,selY=x,y
                FMOD.effect('move',{volume=.8})
            end
        end
    end
end

---@type Zenitha.Scene
local scene={}

function scene.enter()
    invis=false
    newGame()
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='r' then
        if state~=1 or sureCheck('reset') then
            newGame()
        end
    elseif key=='z' or key=='x' then
        love.mousepressed(love.mouse.getPosition())
    elseif key=='escape' then
        if state~=1 then
            if sureCheck('back') then SCN.back() end
        end
    elseif state==0 then
        if key=='q' then
            invis=not invis
        end
    end
    return true
end
local function touch(x,y)
    x=floor((x-field.x)/field.w*field.c+1)
    y=floor((y-field.y)/field.h*field.r+1)
    tap(x,y)
end
function scene.mouseDown(x,y,k) if k==1 or k==2 or not k then touch(x,y) end end
function scene.mouseMove(x,y) if (isMouseDown(1) or isKeyDown('z','x')) then touch(x,y) end end
function scene.touchDown(x,y) touch(x,y) end
function scene.touchMove(x,y) touch(x,y) end

function scene.update(dt)
    if state==1 then
        time=love.timer.getTime()-startTime
        comboTime=max(comboTime-dt,0)
        score1=score1+MATH.sign(score-score1)+floor((score-score1)*.1+.5)
    end

    for i=#lines,1,-1 do
        local L=lines[i]
        L.time=L.time+dt
        if L.time>=1 then
            rem(lines,i)
        end
    end
end

function scene.draw()
    gc.push('transform')
        -- Camera
        gc.translate(field.x,field.y)
        gc.scale(field.w/field.c,field.h/field.r)

        -- Background
        gc.setColor(COLOR.dX)
        gc.rectangle('fill',0,0,field.w,field.h)

        -- Matrix
        local mono=state==0 or invis and not field.full
        if mono then
            gc_setColor(COLOR.lD)
            for y=1,field.r do for x=1,field.c do
                if field[y][x] then
                    gc_rectangle('fill',x-1,y-1,1,1)
                end
            end end
        else
            for y=1,field.r do for x=1,field.c do
                local t=field[y][x]
                if t then
                    gc_setColor(colorList[t])
                    gc_rectangle('fill',x-1,y-1,1,1)
                    gc_setColor(0,0,0,.26)
                    gc_draw(iconList[t],x-1,y-1,nil,.1,.1)
                end
            end end
        end

        -- Selecting box
        gc.setLineWidth(.1)
        if selX then
            gc_setColor(COLOR.L)
            gc_rectangle('line',selX-1+.05,selY-1+.05,.9,.9)
        end

        -- Clearing lines
        gc.translate(-.5,-.5)
        for i=1,#lines do
            gc_setColor(1,1,1,1-lines[i].time)
            gc.line(lines[i].line)
        end
    gc.pop()

    -- Frame
    if state==2 then
        gc.setColor(.9,.9,0)-- win
    elseif state==1 then
        gc.setColor(.9,.9,.9)-- game
    elseif state==0 then
        gc.setColor(.2,.8,.2)-- ready
    end
    gc.setLineWidth(6)
    gc.rectangle('line',field.x-5,field.y-5,field.w+10,field.h+10)

    -- Draw no-setting area
    if state==2 then
        gc.setColor(1,0,0,.3)
        gc.rectangle('fill',0,100,155,80)
    end

    -- Maxcombo
    setFont(25) gc.setColor(COLOR.dF)
    gc.print(maxCombo,1432,40)

    -- Time
    setFont(35) gc.setColor(COLOR.L)
    gc.print(("%.3f"):format(time),1430,70)

    -- Section times
    setFont(20) gc.setColor(.6,.6,.6)
    for i=1,#progress do gc.print(progress[i],1430,90+20*i) end

    -- Combo Rectangle
    if comboTime>0 then
        local r=32*comboTime^.3
        gc.setColor(1,1,1,min(.6+comboTime,1)*.25)
        gc.rectangle('fill',1500-r,440-r,2*r,2*r,2)
        gc.setColor(1,1,1,min(.6+comboTime,1))
        gc.setLineWidth(2)
        gc.rectangle('line',1500-r,440-r,2*r,2*r,4)
    end

    -- Combo Text
    setFont(60)
    if combo>50 then
        gc.setColor(1,.2,.2,min(.3+comboTime*.5,1)*min(comboTime,1))
        mStr(combo,1500+(rnd()-.5)*combo^.5,398+(rnd()-.5)*combo^.5)
    end
    gc.setColor(1,1,max(1-combo*.001,.5),min(.4+comboTime,1))
    mStr(combo,1500,398)

    -- Score
    setFont(25) gc.setColor(COLOR.L)
    mStr(score1,1500,560)
end

scene.widgetList={
    WIDGET.new{type='button',x=80,y=60,w=110,h=60,color='lG',text=CHAR.icon.retry,code=WIDGET.c_pressKey'r',visibleTick=function() return state~=0 end},
    WIDGET.new{type='checkBox',x=100,y=140,widthLimit=80,disp=function() return invis end,code=WIDGET.c_pressKey'q',visibleTick=function() return state~=1 end},
    WIDGET.new{type='button',pos={1,1},x=-60,y=-60,w=80,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
