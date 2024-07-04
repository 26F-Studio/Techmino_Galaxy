local gc=love.graphics
local rnd,int=math.random,math.floor
local max,min=math.max,math.min
local setFont,mStr=FONT.set,GC.mStr

-- This mini-game is written for TI-nSpire CX CAS many years ago.
-- Deliberately, some grammar mistakes and typos in the 'great' list remained.
-- So no need to correct them.

local perfect={"Perfect!","Excellent!","Nice!","Good!","Great!","Just!","300"}
local great={"Pay attention!","Be carefully!","Teacher behind you!","Feel tired?","You are in danger!"," Do your homework!","A good game!","Minecraft!","y=ax^2+bx+c!","No music?","Internet unavailable.","It's raining!","Too hard!","Shorter?","Higher!","English messages!","Hi!","^_^","Drop!","Colorful!",":)","100$","~~~wave~~~","★★★","中文!","NOW!!!!!","Also try the TEN!","I'm a programer!","Also try minesweeperZ!","This si Dropper!","Hold your calculatoor!","Look! UFO!","Bonjour!","[string]","Author:MrZ","Boom!","PvZ!","China!","TI-nspire!","I love LUA!"}
local miss={"Oops!","Uh-oh","Ouch!","Oh no."}

---@type Zenitha.Scene
local scene={}

local highScore,highFloor=0,0
local move,base
local state,message
local moveDir
local score,floor,camY
local color1,color2

local moveSpeed=10
local dropSpeed=22
local shortenSpeed=6
local climbSpeed=4
local brickHeight=50

local overflowWidth=420
local brickStroke=5

local function restart()
    move={x=0,y=260,w=500}
    base={x=100,y=SCR.h0-brickHeight,w=1400}
    message="Welcome"
    moveDir=1
    score=0
    floor=0
    camY=0
    color1=COLOR.random(3)
    color2=COLOR.random(3)
end

function scene.load()
    restart()
    state='menu'
    BG.set('space')
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='space' or key=='return' then
        if state=='move' then
            if floor>0 and math.abs(move.x-base.x)<10 then
                move.x=base.x
            end
            FMOD.effect('hold')
            state='drop'
        elseif state=='dead' then
            move.x,move.y,move.w=1e99,0,0
            base.x,base.y,base.w=1e99,0,0
            state='scroll'
        elseif state=='menu' then
            restart()
            state='move'
        end
    elseif key=='escape' then
        if sureCheck('back') then SCN.back() end
    end
    return true
end
function scene.mouseDown(_,_,k)
    if k==1 then
        scene.keyDown('space')
    end
end
function scene.touchDown()
    scene.keyDown('space')
end

function scene.update(dt)
    dt=dt*60 -- Second to Frame
    if state=='move' then
        move.x=move.x+moveSpeed*moveDir*dt
        if moveDir<0 and move.x<=0 or moveDir>0 and move.x+move.w>=SCR.w0 then
            FMOD.effect('lock')
            moveDir=-moveDir
        end
    elseif state=='drop' then
        move.y=move.y+dropSpeed*dt
        if move.y>=SCR.h0-2*brickHeight then
            if move.x>base.x+base.w or move.x+move.w<base.x then
                message=miss[rnd(1,4)]
                state='die'
            else
                move.y=SCR.h0-2*brickHeight
                comboSound(math.floor(floor/2)+1)
                FMOD.effect(move.x==base.x and 'clear_3' or 'clear_2',{volume=.6})
                state='shorten'
            end
        end
    elseif state=='shorten' then
        if move.x>base.x+base.w or move.x+move.w<base.x then
            state='die'
        elseif move.x<base.x then
            local d=min(shortenSpeed*dt,base.x-move.x)
            move.x=move.x+d
            move.w=move.w-d
        elseif move.x+move.w>base.x+base.w then
            local d=min(shortenSpeed*dt,(move.x+move.w)-(base.x+base.w))
            move.w=move.w-d
        else
            state='climb'
        end
    elseif state=='climb' then
        if base.y<SCR.h0 then
            local d=min(climbSpeed*dt,SCR.h0-base.y)
            move.y=move.y+d
            base.y=base.y+d
            camY=camY+d
        else
            if move.x==base.x and move.x+move.w==base.x+base.w and floor~=0 then
                score=score+2
                message=perfect[rnd(1,3)]
            else
                score=score+1
                message=great[rnd(1,table.maxn(great))]
            end
            color2=color1
            color1=COLOR.random(3)
            base.x=move.x
            base.y=SCR.h0-brickHeight
            base.w=move.w
            floor=floor+1
            if rnd()<.5 then
                move.x=-move.w
                moveDir=1
            else
                move.x=SCR.w0
                moveDir=-1
            end
            move.y=rnd(max(260-floor*4,60),max(420-floor*5,100))
            state='move'
        end
    elseif state=='die' then
        move.y=move.y+dropSpeed*dt
        if move.y>=SCR.h0 then
            move.y=SCR.h0
            highScore=max(score,highScore)
            highFloor=max(floor,floor)
            state='dead'
        end
    elseif state=='scroll' then
        camY=camY-(2.6+floor/6.2+camY/626)*dt
        if camY<=0 then
            restart()
            state='move'
        end
    end
end

local backColor={
    {.71,1,.71},
    {.47,.86,1},
    {.63,.78,1},
    {.71,.71,.71},
    {.59,.55,.55},
    {.43,.43,.43,.9},
    {.34,.34,.34,.8},
    {.26,.26,.26,.7},
}
backColor.__index=function(t,lv)
    local a=backColor[#backColor][4]-.1
    t[lv]={.26,.26,.26,a}
    return t[lv]
end
setmetatable(backColor,backColor)
function scene.draw()
    -- Background
    local lv,height=int(camY/(SCR.h0-brickHeight)),camY%(SCR.h0-brickHeight)
    gc.setColor(backColor[lv+1] or COLOR.D)
    gc.rectangle('fill',-overflowWidth,SCR.h0,SCR.w0+overflowWidth*2,height-(SCR.h0-brickHeight))
    gc.setColor(backColor[lv+2] or COLOR.D)
    gc.rectangle('fill',-overflowWidth,height+brickHeight,SCR.w0+overflowWidth*2,-height-brickHeight)
    if height-680>0 then
        gc.setColor(backColor[lv+3] or COLOR.D)
        gc.rectangle('fill',0,height-680,SCR.w0,680-height)
    end

    if state=='menu' or state=='dead' then
        setFont(100)
        GC.shadedPrint("DROPPER",800,150,'center',4,8,COLOR.L,COLOR.L)
        gc.setColor(COLOR.rainbow_light(love.timer.getTime()*2.6))
        mStr("DROPPER",800,150)

        gc.setColor(COLOR.rainbow_gray(love.timer.getTime()*1.626))
        setFont(70)
        mStr("Score - "..score,800,400)
        mStr("High Score - "..highScore,800,500)
        mStr("High Floor - "..highFloor,800,600)

        gc.setColor(COLOR.D)
        setFont(50)
        mStr(MOBILE and "Touch to Start" or "Press space to Start",800,800)
        setFont(25)
        gc.print("Original CX-CAS version by MrZ",740,265)
        gc.print("Ported / Rewritten / Balanced by MrZ",740,290)
    end
    if state~='menu' then
        -- High floor
        gc.setColor(COLOR.L)
        gc.setLineWidth(3)
        local y=SCR.h0+camY-brickHeight*highFloor
        gc.line(-overflowWidth,y,SCR.w0+overflowWidth,y)

        setFont(60)
        GC.shadedPrint(floor+1,move.x+move.w+10,move.y-15,'left',3,8,COLOR.L,COLOR.D)
        GC.shadedPrint(floor,base.x+base.w+10,base.y-15,'left',3,8,COLOR.L,COLOR.D)

        GC.shadedPrint(message,800,0,'center',3,8,COLOR.L,COLOR.D)

        setFont(70)
        GC.shadedPrint(score,100,40,'center',3,8,COLOR.L,COLOR.D)

        gc.setColor(COLOR.L)
        gc.rectangle('fill',move.x-brickStroke,move.y-brickStroke,move.w+2*brickStroke,brickHeight+2*brickStroke)
        gc.rectangle('fill',base.x-brickStroke,base.y-brickStroke,base.w+2*brickStroke,brickHeight+2*brickStroke)
        gc.setColor(color1) gc.rectangle('fill',move.x,move.y,move.w,brickHeight)
        gc.setColor(color2) gc.rectangle('fill',base.x,base.y,base.w,brickHeight)
    end
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={1,0},x=-120,y=80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
