local gc=love.graphics
local setFont,mStr=FONT.set,GC.mStr

local floor,rnd=math.floor,math.random
local ins,rem=table.insert,table.remove

local targets={
    [40]=true,
    [100]=true,
    [200]=true,
    [400]=true,
    [620]=true,
    [1000]=true,
    [2600]=true,
}

local B={x=400,y=20,w=800,h=960,cw=200,ch=160}

local state,progress
local startTime,time
local keyTime
local speed,maxSpeed
local arcade,rollSpeed,rollAcc

local reset=error -- function, defined later

local tileColor="D"
local mode="Normal"
local modeSelector=WIDGET.new{type='selector',x=200,y=240,w=290,
    list={
        "Normal",
        "Split",
        "Short",
        "Stairs",
        "Double",
        "Singlestream",
        "Light_Jumpstream",
        "Dense_Jumpstream",
        "Light_Handstream",
        "Dense_Handstream",
        "Light_Quadstream",
        "Quadstream",
    },disp=function() return mode end,code=function(m) mode=m reset() end
}
local colorSelector=WIDGET.new{type='selector',x=200,y=330,w=290,
    list={
        'D',
        'dR','R','lR',
        'dF','F','lF',
        'dO','O','lO',
        'dY','Y','lY',
        'dA','A','lA',
        'dK','K','lK',
        'dG','G','lG',
        'dJ','J','lJ',
        'dC','C','lC',
        'dI','I','lI',
        'dS','S','lS',
        'dB','B','lB',
        'dP','P','lP',
        'dV','V','lV',
        'dM','M','lM',
        'dW','W','lW'
    },
    disp=function() return tileColor end,code=function(m) tileColor=m end
}
local arcadeSwitch=WIDGET.new{type='checkBox',text="Arcade",x=300,y=430,widthLimit=200,fontSize=40,disp=function() return arcade end,code=WIDGET.c_pressKey'w'}
local function freshSelectors()
    local f=state==0
    modeSelector._visible=f
    colorSelector._visible=f
    arcadeSwitch._visible=f
end

local score
local pos,height
local diePos

local function get1(prev)
    if prev<10 or prev>999 then
        local r=rnd(3)
        return r>=prev and r+1 or r
    else
        while true do
            local r=rnd(4)
            if not string.find(prev,r) then return r end
        end
    end
end
local function get2(prev)
    while true do
        local i=rnd(4)
        local r=rnd(3)
        if r>=i then r=r+1 end
        if not (string.find(prev,r) or string.find(prev,i)) then
            return 10*i+r
        end
    end
end
local function get3(prev)
    if prev==0 then prev=rnd(4) end
    if prev==1 then return 234
    elseif prev==2 then return 134
    elseif prev==3 then return 124
    elseif prev==4 then return 123
    else error("wrong get3 usage: "..(prev or -1))
    end
end

local generator={
    Normal=function()
        ins(pos,rnd(4))
    end,
    Split=function()
        if #pos==0 then ins(pos,rnd(4)) end
        ins(pos,pos[#pos]<=2 and rnd(3,4) or rnd(2))
    end,
    Short=function()
        if #pos<2 then ins(pos,rnd(4)) ins(pos,rnd(4)) end
        local r
        if pos[#pos]==pos[#pos-1] then
            r=rnd(3)
            if r>=pos[#pos] then r=r+1 end
            ins(pos,r)
        else
            ins(pos,rnd(4))
        end
    end,
    Stairs=function()
        local r=get1(pos[#pos] or 0)
        local dir=r==1 and 1 or r==4 and -1 or rnd()<.5 and 1 or -1
        local count=rnd(3,5)
        while count>0 do
            ins(pos,r)
            r=r+dir
            if r==0 then
                r,dir=2,1
            elseif r==5 then
                r,dir=3,-1
            end
            count=count-1
        end
    end,
    Double=function()
        local i=rnd(4)
        local r=rnd(3)
        if r>=i then r=r+1 end
        r=10*i+r
        ins(pos,r)
    end,
    Singlestream=function()
        ins(pos,get1(pos[#pos] or 0))
    end,
    Light_Jumpstream=function() -- 2111
        ins(pos,get2(pos[#pos] or 0))
        ins(pos,get1(pos[#pos]))
        ins(pos,get1(pos[#pos]))
        ins(pos,get1(pos[#pos]))
    end,
    Dense_Jumpstream=function() -- 2121
        ins(pos,get2(pos[#pos] or 0))
        ins(pos,get1(pos[#pos]))
        ins(pos,get2(pos[#pos]))
        ins(pos,get1(pos[#pos]))
    end,
    Light_Handstream=function() -- 3111
        ins(pos,get3(pos[#pos] or 0))
        ins(pos,get1(pos[#pos]))
        ins(pos,get1(pos[#pos]))
        ins(pos,get1(pos[#pos]))
    end,
    Dense_Handstream=function() -- 3121
        ins(pos,get3(pos[#pos] or 0))
        ins(pos,get1(pos[#pos]))
        ins(pos,get2(pos[#pos]))
        ins(pos,get1(pos[#pos]))
    end,
    Light_Quadstream=function() -- 4111
        ins(pos,1234)
        ins(pos,get1(pos[#pos-1] or 0))
        ins(pos,get1(pos[#pos]))
        ins(pos,get1(pos[#pos]))
    end,
    Quadstream=function() -- 4121
        ins(pos,1234)
        ins(pos,get1(pos[#pos-1] or 0))
        ins(pos,get2(pos[#pos]))
        ins(pos,get1(pos[#pos]))
    end,
}

function reset()
    keyTime={} for i=1,40 do keyTime[i]=-1e99 end
    speed,maxSpeed=0,0
    progress={}
    state=0
    freshSelectors()
    time=0
    score=0

    -- Get speed from clipboard, format: s=
    local t=love.system.getClipboardText()
    if type(t)=='string' then
        rollSpeed,rollAcc=t:match("^s=(.+),(.+)")
        rollSpeed,rollAcc=tonumber(rollSpeed),tonumber(rollAcc)
    end
    rollSpeed=rollSpeed or 620
    rollAcc=rollAcc or 26

    pos={}
    while #pos<7 do generator[mode]() end
    height=0
    diePos=false
end

---@type Zenitha.Scene
local scene={}

function scene.enter()
    reset()
    BG.set('fixColor')
    BG.send('fixColor',.26,.26,.26)
end

local function touch(n)
    if state==0 then
        state=1
        freshSelectors()
        startTime=love.timer.getTime()
    end
    local t=tostring(pos[1])
    local p=string.find(t,n)
    if p then
        t=t:sub(1,p-1)..t:sub(p+1)
        if #t>0 then
            pos[1]=tonumber(t)
            FMOD.effect('lock')
        else
            rem(pos,1)
            while #pos<7 do generator[mode]() end
            ins(keyTime,1,love.timer.getTime())
            keyTime[21]=nil
            score=score+1
            if not arcade and targets[score] then
                ins(progress,("%s - %.3fs"):format(score,love.timer.getTime()-startTime))
                if score==2600 then
                    for i=1,#pos do
                        pos[i]=626
                    end
                    time=love.timer.getTime()-startTime
                    state=2
                    FMOD.effect('win')
                else
                    FMOD.effect('beep_notice',{volume=.5})
                end
            end
            height=height+B.ch
            FMOD.effect('lock')
        end
    else
        time=love.timer.getTime()-startTime
        state=2
        diePos=n
        FMOD.effect('clear_2')
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='r' or key=='space' then reset()
    elseif key=='escape' then SCN.back()
    elseif state~=2 then
        if     key=='d' or key=='c' then touch(1)
        elseif key=='f' or key=='v' then touch(2)
        elseif key=='j' or key=='n' then touch(3)
        elseif key=='k' or key=='m' then touch(4)
        elseif state==0 then
            if key=='tab' then
                local mode1=mode
                modeSelector:scroll(love.keyboard.isDown('lshift','rshift') and 1 or -1,0)
                if mode1~=mode then reset() end
            elseif key=='q' then
                colorSelector:scroll(love.keyboard.isDown('lshift','rshift') and 1 or -1,0)
            elseif key=='w' then
                arcade=not arcade
            end
        end
    end
    return true
end
function scene.mouseDown(x)
    scene.touchDown(x)
end
function scene.touchDown(x)
    if state==2 then return end
    x=floor((x-300)/170+1)
    if x>=1 and x<=4 then
        touch(x)
    end
end

function scene.update(dt)
    if state==1 then
        local t=love.timer.getTime()
        time=t-startTime
        local v=0
        for i=2,20 do v=v+i*(i-1)*.3/(t-keyTime[i]) end
        speed=MATH.expApproach(speed,v,dt)
        if speed>maxSpeed then maxSpeed=speed end

        if arcade then
            height=height-rollSpeed*dt
            rollSpeed=rollSpeed+rollAcc*dt
            if height<-120 then
                state=2
                FMOD.effect('clear_2')
            end
        else
            height=MATH.expApproach(height,0,dt*26)
        end
    end
end

function scene.draw()
    setFont(50)
    if arcade then
        -- Draw rolling speed
        mStr(("%.2f/s"):format(rollSpeed/B.ch),200,490)
    else
        -- Draw speed
        setFont(60)
        gc.setColor(1,.6,.6)
        mStr(("%.2f"):format(maxSpeed/60),200,500)
        gc.setColor(COLOR.L)
        mStr(("%.2f"):format(speed/60),200,600)

        -- Progress time list
        setFont(30)
        gc.setColor(.6,.6,.6)
        for i=1,#progress do
            gc.print(progress[i],1030,120+25*i)
        end

        -- Draw time
        gc.setColor(COLOR.L)
        setFont(45)
        gc.print(("%.3f"):format(time),1030,70)
    end

    -- Draw mode
    if state~=0 then
        gc.setColor(COLOR.L)
        setFont(30)
        mStr(mode,200,220)
    end

    gc.translate(B.x,B.y)
    GC.stc_reset()
    GC.stc_setComp()
    GC.stc_rect(0,0,B.w,B.h)
        -- Draw tiles
        gc.rectangle('fill',0,0,B.w,B.h)
        gc.setColor(COLOR[tileColor])
        gc.push('transform')
        gc.translate(0,B.h-height+8)
        for i=1,7 do
            local t=pos[i]
            while t>0 do
                gc.rectangle('fill',B.cw*(t%10-1)+8,-i*B.ch,B.cw-16,B.ch-16)
                t=(t-t%10)/10
            end
        end
        gc.pop()

        -- Draw red tile
        if diePos then
            gc.setColor(1,.2,.2)
            gc.rectangle('fill',B.cw*(diePos-1)+8,B.h-B.ch-height+8,B.cw-16,B.ch-16)
        end

        -- Draw track line
        gc.setColor(COLOR.D)
        gc.setLineWidth(2)
        for x=1,5 do
            x=B.cw*(x-1)
            gc.line(x,0,x,B.h)
        end
        for y=0,6 do
            y=B.h-B.ch*y-height%B.ch
            gc.line(0,y,B.w,y)
        end
    GC.stc_stop()
    gc.translate(-B.x,-B.y)


    -- Draw score
    setFont(80)
    gc.push('transform')
    gc.translate(800,40)
    gc.scale(2.6)
    gc.setColor(.5,.5,.5,.6)
    mStr(score,0,0)
    gc.pop()
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},x=200,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,code=WIDGET.c_pressKey'r'},
    modeSelector,
    colorSelector,
    arcadeSwitch,
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
