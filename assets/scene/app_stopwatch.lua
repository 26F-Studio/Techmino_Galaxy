local state
local pressTime
local releaseTime
local time1,time2

local function press()
    if state==0 then
        state=1
        pressTime=love.timer.getTime()
        releaseTime=false
        time2=STRING.time(0)
    elseif state==2 then
        state=0
    end
end

local function release()
    if state==1 then
        state=2
        releaseTime=love.timer.getTime()
    end
end

---@type Zenitha.Scene
local scene={}

function scene.enter()
    state=0
    time1=STRING.time(0)
    time2=STRING.time(0)
end

function scene.mouseDown()
    press()
end
function scene.mouseUp()
    release()
end
function scene.touchDown()
    press()
end
function scene.touchUp()
    if #getTouches()==0 then
        release()
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='escape' then
        if sureCheck('back') then SCN.back() end
    else
        press()
    end
    return true
end
function scene.keyUp()
    release()
end

function scene.update()
    if state~=0 then
        time1=STRING.time(love.timer.getTime()-pressTime)
        if releaseTime then
            time2=STRING.time(love.timer.getTime()-releaseTime)
        end
    end
end

function scene.draw()
    FONT.set(60)
    GC.mStr(CHAR.icon.import,340,230)
    GC.mStr(CHAR.icon.export,940,230)
    GC.mStr(time1,340,300)
    GC.mStr(time2,940,300)
end

scene.widgetList={
    WIDGET.new{type='button',  name="back", pos={1,1},x=-120,y=-80,w=160,h=80,fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
