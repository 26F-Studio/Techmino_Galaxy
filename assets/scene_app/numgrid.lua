local gc=love.graphics

---@type Zenitha.Scene
local scene={}

local board,rank
local invis,disappear
local startTime,time
local state,progress=0
local tapFX,mistake

local area={
    x=350,y=50,
    w=900,h=900,
}
local fontSizes={
    [3]=100,
    [4]=100,
    [5]=90,
    [6]=80,
}

local function setState(v)
    state=v
    scene.widgetList.rank:setVisible(state==0)
    scene.widgetList.invis:setVisible(state~=1)
    scene.widgetList.disappear:setVisible(state~=1)
    scene.widgetList.tapFX:setVisible(state~=1)
end
function scene.load()
    BG.set('space')
    TABLE.clear(board)
    rank=3
    invis=false
    disappear=false
    tapFX=true

    startTime=0
    time=0
    mistake=0
    progress=0
    setState(0)
end

local function inBoard(x,y)
    return MATH.between(x,area.x,area.x+area.w) and MATH.between(y,area.y,area.y+area.h)
end
local function newBoard()
    local L={}
    for i=1,rank^2 do
        L[i]=i
    end
    for i=1,rank^2 do
        board[i]=table.remove(L,math.random(#L))
    end
end
local function tapBoard(x,y)
    if inBoard(x,y) and state==1 then
        local R=rank
        local X=math.floor((x-area.x)/area.w*R)
        local Y=math.floor((y-area.y)/area.h*R)
        x=R*Y+X+1
        if board[x]==progress+1 then
            progress=progress+1
            if progress<R^2 then
                FMOD.effect('touch')
            else
                time=love.timer.getTime()-startTime+mistake
                setState(2)
                FMOD.effect('beep_rise')
            end
            if tapFX then
                SYSFX.rect(.26,area.x+area.w/R*X,area.y+area.h/R*Y,area.w/R,area.h/R,.6,.8,1)
            end
        else
            mistake=mistake+1
            if tapFX then
                SYSFX.rect(.5,area.x+area.w/R*X,area.y+area.h/R*Y,area.w/R,area.h/R,1,.4,.5)
            end
            FMOD.effect('move_failed')
        end
    end
end

function scene.mouseDown(x,y)
    if state~=0 then tapBoard(x,y) end
end
function scene.touchDown(x,y)
    if state~=0 then tapBoard(x,y) end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='z' or key=='x' then
        local x,y=love.mouse.getPosition()
        love.mousepressed(x,y,1)
    elseif key=='space' then
        if state>0 then
            TABLE.clear(board)
            time=0
            mistake=0
            setState(0)
            progress=0
        end
    elseif key=='escape' then
        if SureCheck('back') then SCN.back() end
    elseif state==0 then
        if key=='q' then
                invis=not invis
        elseif key=='w' then
                disappear=not disappear
        elseif key=='e' then
                tapFX=not tapFX
        elseif key=='3' or key=='4' or key=='5' or key=='6' then
                rank=tonumber(key)
        end
    end
    return true
end
function scene.mouseUp(x,y)
    if inBoard(x,y) and state==0 then
        newBoard()
        setState(1)
        startTime=love.timer.getTime()
        progress=0
    end
end
scene.touchUp=scene.mouseUp
function scene.keyUp(key)
    if key=='z' or key=='x' then
        local x,y=love.mouse.getPosition()
        love.mousereleased(x,y,1)
    end
end

function scene.update()
    if state==1 then
        time=love.timer.getTime()-startTime+mistake
    end
end

function scene.draw()
    FONT.set(40)
    gc.setColor(COLOR.L)
    gc.print(("%.3f"):format(time),1350,80)
    gc.print(mistake,1350,150)

    FONT.set(70)
    GC.mStr(state==1 and progress or state==0 and "Ready" or "Win",1400,300)

    gc.setColor(COLOR.dT)
    gc.rectangle('fill',area.x-10,area.y-10,area.w+20,area.h+20)
    if state==2 then
        gc.setColor(.9,.9,0)-- win
    elseif state==1 then
        gc.setColor(.9,.9,.9)-- game
    elseif state==0 then
        gc.setColor(.2,.8,.2)-- ready
    end
    gc.setLineWidth(10)
    gc.rectangle('line',area.x-10,area.y-10,area.w+20,area.h+20)

    -- Draw no-setting area
    if state==2 then
        gc.setColor(1,0,0,.3)
        gc.rectangle('fill',35,295,285,250)
    end

    local width=area.w/rank
    local mono=state==0 or invis and state==1 and progress>0
    gc.setLineWidth(4)
    local f=fontSizes[rank]
    FONT.set(f)
    for i=1,rank do
        for j=1,rank do
            local N=board[rank*(i-1)+j]
            if not (state==1 and disappear and N<=progress) then
                gc.setColor(.4,.5,.6)
                gc.rectangle('fill',area.x+(j-1)*width,area.y+(i-1)*width,width,width)
                gc.setColor(COLOR.L)
                gc.rectangle('line',area.x+(j-1)*width,area.y+(i-1)*width,width,width)
                if not mono then
                    GC.strokePrint('full',3,COLOR.D,COLOR.L,N,area.x+(j-.5)*width,area.y+(i-.5)*width-f*.67,'center')
                end
            end
        end
    end
end

scene.widgetList={
    WIDGET.new{type='button',                                    x=180,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,code=WIDGET.c_pressKey'space',visibleTick=function() return state~=0 end},
    WIDGET.new{type='slider'  ,name='rank',     text="Rank",     x=150,y=250,widthLimit=105,w=150,axis={3,6,1},valueShow=false,fontSize=40,disp=function() return rank end,code=function(v) rank=v end},
    WIDGET.new{type='checkBox',name='invis',    text="Invisible",x=280,y=330,widthLimit=200,fontSize=40,disp=function() return invis     end,code=WIDGET.c_pressKey'q'},
    WIDGET.new{type='checkBox',name='disappear',text="Disappear",x=280,y=420,widthLimit=200,fontSize=40,disp=function() return disappear end,code=WIDGET.c_pressKey'w'},
    WIDGET.new{type='checkBox',name='tapFX',    text="TapEffect",x=280,y=510,widthLimit=200,fontSize=40,disp=function() return tapFX     end,code=WIDGET.c_pressKey'e'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
