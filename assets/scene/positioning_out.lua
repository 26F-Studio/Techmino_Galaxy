local subject={
    {-- Puyo
        press=function()
            playExterior('mino/exterior/ultra')()
            -- SCN.go('mode_puyo','fade')
        end,
        draw=function()
            GC.setColor(COLOR.R)
            GC.setLineWidth(10)
            GC.circle('line',-35,-80,85)
            GC.circle('line',35,80,85)
        end,
    },
    {-- Mino
        press=function()
            playExterior('mino/exterior/sprint')()
        end,
        draw=function()
            GC.setColor(COLOR.P)
            GC.setLineWidth(10)
            GC.translate(-180,-120)
            GC.polygon('line',
                0,0,
                360,0,
                360,120,
                240,120,
                240,240,
                120,240,
                120,120,
                0,120
            )
        end,
    },
    {-- Gem
        press=function()
            playExterior('mino/exterior/marathon')()
            -- SCN.go('mode_gem','fade')
        end,
        draw=function()
            GC.setColor(COLOR.B)
            GC.setLineWidth(10)
            GC.polygon('line',
                0,140,
                136,-40,
                64,-128,
                -64,-128,
                -136 ,-40
            )
        end,
    },
}
for _,s in next,subject do
    s.active=0
    s.x,s.y,s.size=nil
end

---@type integer
---| false
local subjectFocused=false

local scene={}

function scene.enter()
    time=0
    scene.update(0)
end

local function onSubject(x,y)
    for i=1,3 do
        local s=subject[i]
        if x>s.x and y>s.y and x<s.x+s.size and y<s.y+s.size then
            return i
        end
    end
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
    if key=='left' then
        subjectFocused=subjectFocused and (subjectFocused-2)%3+1 or 1
    elseif key=='right' then
        subjectFocused=subjectFocused and subjectFocused%3+1 or 3
    elseif key=='down' then
        subjectFocused=2
    elseif key=='up' then
        scene.keyDown('return')
    elseif key=='return' then
        if subjectFocused then
            subject[subjectFocused].press()
        end
    elseif key=='escape' then
        SCN.back('fadeHeader')
    end
end

function scene.update(dt)
    for i=1,3 do
        subject[i].active=MATH.expApproach(subject[i].active,i==subjectFocused and 1 or 0,dt*26)
        subject[i].size=390+120*subject[i].active
    end
    local x=0
    for i=1,3 do
        local s=subject[i]
        s.x,s.y=x,550-s.size/2
        x=x+s.size
    end
    for i=1,3 do
        local s=subject[i]
        s.x=s.x-x/2+800
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
    GC.replaceTransform(SCR.xOy)
    GC.setLineWidth(4)
    GC.setColor(COLOR.L)
    for i=1,3 do
        local s=subject[i]
        GC.push('transform')
        GC.translate(s.x+s.size/2,s.y+s.size/2)
        GC.scale(1+120/390*s.active)
        GC.setColor(.26,.26,.26,.26)
        GC.rectangle('fill',-190,-190,380,380,26)
        s.draw()
        GC.pop()
    end
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={.5,0},x=0,y=60,alignX='center',fontType='bold',fontSize=60,text=LANG'title_positioning'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
