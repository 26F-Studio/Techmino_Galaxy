local gc=love.graphics
local rnd,sin,cos=math.random,math.sin,math.cos

local tau=math.pi*2

local state
local zooming
local ang,pos
local hit,dist
local side,count
local needReset

local function new()
    if needReset then
        side=math.max(side-2,6)
        needReset=false
    else
        side=side+1
    end
    count=0
    for c=1,side do
        hit[c]=0
        dist[c]=rnd(200,360)
    end
end

---@type Zenitha.Scene
local scene={}

function scene.load()
    state=0
    ang,pos=0,-tau/4
    zooming=50
    hit,dist={},{}
    side=rnd(3,6)*2
    needReset=true
    for c=1,side,2 do
        hit[c],hit[c+1]=rnd(2),rnd(2)
        dist[c],dist[c+1]=226,126
    end
    BG.set('none')
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='escape' then
        if SureCheck('back') then SCN.back() end
    elseif key=='space' then
        if state==0 then -- main
            if zooming<=0 then
                state=1
            end
        elseif state==3 then -- play
            local c=(math.floor((pos-ang)*side/tau)-1)%side+1
            if hit[c]==0 then
                hit[c]=1
                count=count+1
                GameSndFunc.combo(count+5)
                if count==side then
                    state=1
                    FMOD.effect('spin_0')
                else
                    FMOD.effect('touch')
                end
            else
                hit[c]=2
                FMOD.effect('finish_suffocate',.6)
                needReset=true
                state=1
            end
        end
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
    if state==0 then -- main
        ang=ang-.02
        if ang>0 then ang=ang-tau end
        if pos<ang then pos=pos+tau end
        if zooming>0 then zooming=math.max(zooming-dt*60,0) end
    elseif state==1 or state==2 then -- zoom
        ang=ang+.02*dt*60+zooming/260
        pos=pos-.016*dt*60
        if ang>0 then ang=ang-tau end
        if pos<ang then pos=pos+tau end
        if state==1 then
            zooming=math.min(zooming+dt*60,50)
            if zooming==50 then
                state=2
                new()
            end
        else
            zooming=math.max(zooming-dt*60,0)
            if zooming==0 then
                state=3
            end
        end
    elseif state==3 then -- play
        ang=ang+.02*dt*60
        pos=pos-.016*dt*60
        if ang>0 then ang=ang-tau end
        if pos<ang then pos=pos+tau end
    end
end

function scene.draw()
    gc.replaceTransform(SCR.xOy_m)
    gc.clear(.9,.9,.9)
    gc.setColor(0,0,0,1-zooming/50)
    FONT.set(80)
    GC.mStr(side,0,-55)
    gc.polygon('fill',
        400*cos(pos-.03),400*sin(pos-.03),
        380*cos(pos+.00),380*sin(pos+.00),
        400*cos(pos+.03),400*sin(pos+.03)
    )
    gc.setLineWidth(4)
    for i=1,side do
        local dx=cos(ang+tau*i/side)*dist[i]*(1+zooming/10)
        local dy=sin(ang+tau*i/side)*dist[i]*(1+zooming/10)
        local dX=cos(ang+tau*(i%side+1)/side)*dist[i%side+1]*(1+zooming/10)
        local dY=sin(ang+tau*(i%side+1)/side)*dist[i%side+1]*(1+zooming/10)
        gc.setColor(0,0,0,.12)
        gc.line(0,0,dx,dy)
        if hit[i]==0 then gc.setColor(0,0,0,.3)
        elseif hit[i]==1 then gc.setColor(.8,0,0)
        elseif hit[i]==2 then gc.setColor(.4,0,.8)
        end
        gc.line(dx,dy,dX,dY)
    end
    if state==0 then
        gc.setColor(0,0,0,1-zooming/50)
        FONT.set(40)
        GC.mStr(MOBILE and "Touch to Start" or "Press space to Start",0,300)
    else
        gc.setColor(0,0,0,zooming/50)
        gc.print("POLYFORGE",20,620)
        FONT.set(35)
        gc.printf("Idea by ImpactBlue Studios",0,380,760,'right')
        gc.printf("n-Spire ver. & ported & improved by MrZ",0,420,760,'right')
    end
end

scene.widgetList={
    WIDGET.new{type='button',x=1140,y=60,w=170,h=80,color='D',sound_release='button_back',fontSize=60,text=CHAR.icon.back,onClick=WIDGET.c_backScn()},
}

return scene
