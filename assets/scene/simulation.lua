-- Game mode selecting for exterior menu

---@class Techmino.simulation
---@field trigger function
---@field draw function
---@field valid boolean
---@field active number
---@field x number
---@field y number
---@field size number
---@field trigTimer number | false

---@type Techmino.simulation[]
local sims={
    { -- Exterior 1
        unlock=function()
            return PROGRESS.get('styles').brik
        end,
        trigger=function()
            TASK.yieldUntilNextScene()
            if SCN.cur=='simulation' then
                SCN.go('mode_exterior','fadeHeader')
            end
        end,
        draw=function()
            GC.setColor(COLOR.P)
            GC.setLineWidth(10)
            GC.translate(-150,-100)
            GC.polygon('line',
                0,0,
                300,0,
                300,100,
                200,100,
                200,200,
                100,200,
                100,100,
                0,100
            )
        end,
    },
    { -- TTGM
        unlock=function()
            return PROGRESS.get('TTGM').stage>0
        end,
        trigger=function()
            TASK.yieldUntilNextScene()
            if SCN.cur=='simulation' then
                -- SCN.go('tetra_galaxy_machine','flash')
                MSG('warn',"Coming soon?")
            end
        end,
        draw=function()
            GC.setColor(COLOR.DL)
            GC.translate(-150,-100)
            GC.rectangle('fill',0,0,300,100)
            GC.rectangle('fill',100,100,100,100)
        end,
    },
}
--[[
    -- Gela
    GC.setColor(COLOR.R)
    GC.setLineWidth(8)
    GC.circle('line',-35,-60,70)
    GC.circle('line',35,60,70)

    -- Acry
    GC.setColor(COLOR.B)
    GC.setLineWidth(10)
    GC.polygon('line',
        0,112,
        108,-32,
        50,-100,
        -50,-100,
        -108 ,-32
    )
]]

---@type integer | false
local subjectFocused=false

---@type Zenitha.Scene
local scene={}

function scene.load(prev)
    for _,s in next,sims do
        s.valid=false
        if type(s.unlock)=='function' then
            s.valid=s.unlock() or s.valid
        end
        s.active=0
        s.x,s.y=nil
        s.size=nil
        s.trigTimer=false
    end
    subjectFocused=false
    scene.update(0)
    PROGRESS.applyExteriorBG()
    PROGRESS.applyExteriorBGM()
    if prev=='main_out' then
        for i=2,#sims do
            if sims[i].valid then
                return
            end
        end
        subjectFocused=1
        scene.keyDown('return')
    end
end
local function onSubject(x,y)
    for i,s in next,sims do
        if s.valid and x>s.x and y>s.y and x<s.x+s.size and y<s.y+s.size then
            return i
        end
    end
    return false
end

function scene.mouseMove(x,y)
    subjectFocused=onSubject(x,y)
end
function scene.mouseDown(x,y,k)
    if k==1 then
        local s=onSubject(x,y)
        if s then
            if s==subjectFocused then
                scene.keyDown('return')
            else
                subjectFocused=s
            end
        end
    elseif k==2 then
        SCN.back('fadeHeader')
    end
end

scene.touchDown=scene.mouseMove
scene.touchMove=scene.mouseMove
function scene.touchClick(x,y)
    scene.mouseDown(x,y,1)
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='left' or key=='right' then
        if not subjectFocused then
            for i,s in next,sims do
                if s.valid then
                    subjectFocused=i
                    break
                end
            end
        else
            repeat
                subjectFocused=(subjectFocused-1+(key=='left' and -1 or 1))%3+1
            until sims[subjectFocused].valid
        end
    elseif key=='up' or key=='return' then
        if subjectFocused then
            if not sims[subjectFocused].trigTimer then
                sims[subjectFocused].trigTimer=0
                FMOD.effect('simulation_select')
            end
        end
    elseif KEYMAP.sys:getAction(key)=='back' then
        for _,s in next,sims do
            TASK.removeTask_code(s.trigger)
        end
        SCN.back('fadeHeader')
    end
    return true
end

function scene.update(dt)
    for i,s in next,sims do
        if s.valid then
            s.active=MATH.expApproach(s.active,(s.trigTimer or i==subjectFocused) and 1 or 0,dt*26)
            s.size=390+120*s.active
            if s.trigTimer then
                if s.trigTimer<.62 and s.trigTimer+dt>.62 then
                    TASK.new(s.trigger)
                end
                s.trigTimer=s.trigTimer+dt
            end
        end
    end
    local x=0
    for _,s in next,sims do
        if s.valid then
            s.x,s.y=x,550-s.size/2
            x=x+s.size
        end
    end
    for _,s in next,sims do
        if s.valid then
            s.x=s.x-x/2+800
        end
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
    GC.replaceTransform(SCR.xOy)
    for _,s in next,sims do
        if s.valid then
            GC.push('transform')
            GC.translate(s.x+s.size/2,s.y+s.size/2)
            GC.scale(1+120/390*s.active)
            GC.setColor(.26,.26,.26,.26)
            GC.mRect('fill',0,0,380,380,26)
            if s.trigTimer then
                GC.setColor(1,1,1,(s.trigTimer%.12<.06 or s.trigTimer>.36) and math.max(1-s.trigTimer,.626) or .26)
                GC.setLineWidth(20)
                GC.mRect('line',0,0,380-20,380-20,16)
                end
            s.draw()
            GC.pop()
        end
    end
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,fillColor='B',cornerR=15,sound_release='button_back',fontSize=40,text=BackText,onClick=WIDGET.c_backScn'fadeHeader'},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'simulation_title'},
}
return scene
