local gc=love.graphics
local max=math.max
local ins=table.insert
local setFont,mStr=FONT.set,GC.mStr

local scene={}

local lastKey,keyTime
local speed,maxSpeed=0,260

function scene.enter()
    lastKey=nil
    speed=0
    keyTime={} for i=1,40 do keyTime[i]=-1e99 end
    BG.set('fixColor')
    BG.send('fixColor',.26,.26,.26)
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        SCN.back()
    else
        if lastKey~=key then
            lastKey=key
        else
            ins(keyTime,1,love.timer.getTime())
            keyTime[41]=nil
            SFX.play('lock')
        end
    end
end

function scene.update(dt)
    local t=love.timer.getTime()
    local v=0
    for i=2,40 do v=v+i*(i-1)*.075/(t-keyTime[i]) end
    speed=MATH.expApproach(speed,v,dt)
    if speed>maxSpeed then
        maxSpeed=speed
    end
end

function scene.draw()
    setFont(70)gc.setColor(1,.6,.6)
    mStr(("%.2f"):format(maxSpeed),800,20)

    setFont(100)gc.setColor(COLOR.L)
    mStr(("%.2f"):format(speed),800,150)

    setFont(35)
    gc.setColor(.6,.6,.9)
    mStr(("%.2f"):format(maxSpeed/60),800,95)
    gc.setColor(.8,.8,.8)
    mStr(("%.2f"):format(speed/60),800,255)

    setFont(60)gc.setColor(.7,.7,.7)
    mStr("/min",800,310)


    gc.setLineWidth(4)
    if speed==maxSpeed then
        local t=love.timer.getTime()%.1>.05 and 1 or 0
        gc.setColor(1,t,t)
    else
        gc.setColor(max(speed/maxSpeed*10-9,0),1-max(speed/maxSpeed*8-7,0),1-max(speed/maxSpeed*4-3,0))
    end
    gc.rectangle('fill',960,360,30,-320*max(speed/maxSpeed*4-3,0))
    gc.setColor(COLOR.L)
    gc.rectangle('line',960,360,30,-320)
end

scene.widgetList={
    WIDGET.new{type='button',x=640,y=540,w=626,h=260,sound='touch',text="TAP",color='L',fontSize=100,code=function(i) love.keypressed('b'..i) end},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
