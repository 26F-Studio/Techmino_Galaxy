local state ---@type 'stop' | 'press' | 'release'
local pressTime,releaseTime
local time1,time2
local history={}

local function press()
    if state=='stop' then
        if love.timer.getTime()-pressTime<0.26 then return end
        state='press'
        pressTime=love.timer.getTime()
        releaseTime=false
        table.insert(history,1,{time1,time2})
        history[7]=nil
        time2=""
    elseif state=='release' then
        state='stop'
    end
end

local function release()
    if state=='press' then
        state='release'
        releaseTime=love.timer.getTime()
    end
end

---@type Zenitha.Scene
local scene={}

function scene.load()
    pressTime,releaseTime=0,0
    state='stop'
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
    if #GetTouches()==0 then
        release()
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='escape' then
        if SureCheck('back') then SCN.back() end
    else
        press()
    end
    return true
end
function scene.keyUp()
    release()
end

function scene.update()
    if state~='stop' then
        time1=STRING.time(love.timer.getTime()-pressTime)
        if releaseTime then
            time2=STRING.time(love.timer.getTime()-releaseTime)
        end
    end
end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.translate(0,-126)
    FONT.set(90)
    GC.mStr(CHAR.icon.download,-300,-120); GC.mStr(time1,-300,0)
    GC.mStr(CHAR.icon.upload,   300,-120); GC.mStr(time2, 300,0)
    FONT.set(60)
    GC.setColor(.26,.26,.26)
    for i=1,#history do
        GC.mStr(history[i][1],-300,62+62*i)
        GC.mStr(history[i][2], 300,62+62*i)
    end
end

scene.widgetList={
    WIDGET.new{type='button',  name="back", pos={1,1},x=-120,y=-80,w=160,h=80,fontSize=60,text=CHAR.icon.back,onPress=WIDGET.c_backScn()},
}
return scene
