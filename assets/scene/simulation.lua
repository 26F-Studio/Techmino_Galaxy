-- Game mode selecting for exterior menu

--- @class Techmino.simulation
--- @field trigger function
--- @field draw function
--- @field valid boolean
--- @field active number
--- @field x number
--- @field y number
--- @field size number
--- @field trigTimer number|false

--- @type Techmino.simulation[]
local sims={
    { -- Mino
        trigger=function()
            DEBUG.yieldUntilNextScene()
            if SCN.cur=='simulation' then
                SCN.go('mode_mino_stdMap','fadeHeader')
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
    { -- Puyo
        trigger=function()
            DEBUG.yieldUntilNextScene()
            if SCN.cur=='simulation' then
                SCN.go('mode_puyo','fadeHeader')
            end
        end,
        draw=function()
            GC.setColor(COLOR.R)
            GC.setLineWidth(8)
            GC.circle('line',-35,-60,70)
            GC.circle('line',35,60,70)
        end,
    },
    { -- Gem
        trigger=function()
            DEBUG.yieldUntilNextScene()
            if SCN.cur=='simulation' then
                SCN.go('mode_gem','fadeHeader')
            end
        end,
        draw=function()
            GC.setColor(COLOR.B)
            GC.setLineWidth(10)
            GC.polygon('line',
                0,112,
                108,-32,
                50,-100,
                -50,-100,
                -108 ,-32
            )
        end,
    },
}

--- @type integer|false
local subjectFocused=false

local scene={}

function scene.enter()
    for _,s in next,sims do
        s.valid=false
        s.active=0
        s.x,s.y=nil
        s.size=nil
        s.trigTimer=false
    end
    subjectFocused=false
    sims[1].valid=PROGRESS.getModeUnlocked('mino_stdMap')
    sims[2].valid=PROGRESS.getModeUnlocked('puyo_wip')
    sims[3].valid=PROGRESS.getModeUnlocked('gem_wip')
    scene.update(0)
    PROGRESS.setExteriorBG()
    PROGRESS.playExteriorBGM()
    if SCN.prev=='main_out' and sims[1].valid and not (sims[2].valid or sims[3].valid) then
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
    end
end

scene.touchDown=scene.mouseMove
scene.touchMove=scene.mouseMove
function scene.touchClick(x,y)
    scene.mouseDown(x,y,1)
end

function scene.keyDown(key,isRep)
    if isRep then return end
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
                SFX.play('simulation_select')
            end
        end
    elseif KEYMAP.sys:getAction(key)=='back' then
        for _,s in next,sims do
            TASK.removeTask_code(s.trigger)
        end
        SCN.back('fadeHeader')
    end
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
            GC.rectangle('fill',-190,-190,380,380,26)
            if s.trigTimer then
                GC.setColor(1,1,1,(s.trigTimer%.12<.06 or s.trigTimer>.36) and math.max(1-s.trigTimer,.626) or .26)
                GC.setLineWidth(20)
                GC.rectangle('line',-190+10,-190+10,380-20,380-20,16)
                end
            s.draw()
            GC.pop()
        end
    end
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'simulation_title'},
}
return scene
