local subject={
    {-- Puyo
        trigger=function()
            SCN.go('mode_puyo','fade')
        end,
        draw=function()
            GC.setColor(COLOR.R)
            GC.setLineWidth(8)
            GC.circle('line',-35,-60,70)
            GC.circle('line',35,60,70)
        end,
    },
    {-- Mino
        trigger=function()
            SCN.go('mode_mino','fade')
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
    {-- Gem
        trigger=function()
            SCN.go('mode_gem','fade')
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

---@type integer
---| false
local subjectFocused=false

local scene={}

function scene.enter()
    for _,s in next,subject do
        s.valid=false
        s.active=0
        s.x,s.y=nil
        s.size=nil
        s.trigTimer=false
    end
    subject[1].valid=PROGRESS.getPuyoUnlocked()
    subject[2].valid=PROGRESS.getMinoUnlocked()
    subject[3].valid=PROGRESS.getGemUnlocked()
    scene.update(0)
    PROGRESS.playExteriorBGM()
end

local function onSubject(x,y)
    for i,s in next,subject do
        if s.valid and x>s.x and y>s.y and x<s.x+s.size and y<s.y+s.size then
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
    if key=='left' or key=='right' then
        if not subjectFocused then
            for i,s in next,subject do
                if s.valid then
                    subjectFocused=i
                    break
                end
            end
        else
            repeat
                subjectFocused=(subjectFocused-1+(key=='left' and -1 or 1))%3+1
            until subject[subjectFocused].valid
        end
    elseif key=='up' or key=='return' then
        if subjectFocused then
            subject[subjectFocused].trigTimer=subject[subjectFocused].trigTimer or 0
            SFX.play('position_selected')
        end
    elseif key=='escape' then
        SCN.back('fadeHeader')
    end
end

function scene.update(dt)
    for i,s in next,subject do
        if s.valid then
            s.active=MATH.expApproach(s.active,i==subjectFocused and 1 or 0,dt*26)
            s.size=390+120*s.active
            if s.trigTimer then
                s.trigTimer=s.trigTimer+dt
                if s.trigTimer>.62 then
                    s.trigger()
                end
            end
        end
    end
    local x=0
    for _,s in next,subject do
        if s.valid then
            s.x,s.y=x,550-s.size/2
            x=x+s.size
        end
    end
    for _,s in next,subject do
        if s.valid then
            s.x=s.x-x/2+800
        end
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
    GC.replaceTransform(SCR.xOy)
    for _,s in next,subject do
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
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={.5,0},x=0,y=60,alignX='center',fontType='bold',fontSize=60,text=LANG'title_positioning'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
