local scene={}

local modules={
    {"Zenitha framework","MrZ"},
    {"json.lua","rxi"},
    {"profile.lua","itraykov"},
    {"sha2.lua","Egor Skriptunoff"},
}
local toolchain={
    "VS Code",
    "BeepBox",
    "FL Mobile",
    "GoldWave",
    "GFIE",
}

local timer,score
local patron=require'assets.patron'
local function setName(o)
    local p=patron[math.random(#patron)]
    o.name=p.name
    o.text=GC.newText(FONT.get(30),p.name)
    o.score=p.score
    o.r=o.r*1.62
end

local obj={}

function scene.enter()
    TABLE.cut(obj)
    timer,score=12.6,0
end

function scene.mouseDown(x,y)
    x,y=SCR.xOy:transformPoint(x,y)
    x,y=SCR.xOy_d:inverseTransformPoint(x,y)
    for i=1,#obj do
        local o=obj[i]
        if math.abs(x-o.x)<=o.r and math.abs(y+o.y)<=o.r then
            if not o.name then
                setName(o)
            end
            o.vx=(o.vx+(o.x-x)*6.26)*.626
            o.vy=math.min((o.vy+math.random(620,1260))*.8,600)
            o.va=o.va+(o.x-x)/26*(.8+.4*math.random())
            score=score+o.score+(60-o.r/1.62)+math.random(2,6)
            break
        end
    end
end

function scene.update(dt)
    timer=timer-dt
    if timer<=0 then
        timer=timer+1000/(score+100)+math.random()*1.26
        local o={
            x=math.random(-500,500),y=-20,
            vx=math.random(-200,200),vy=math.random(926,1260),
            r=math.random(25,45),
            a=math.random()*MATH.tau,va=10*math.random()-5,
            mino=CHAR.mino[Minoes[math.random(#Minoes)].name],
            minoColor=math.random()*MATH.tau,
        }
        if MATH.roll(.026) then
            setName(o)
        end
        table.insert(obj,o)
    end
    for i=#obj,1,-1 do
        local o=obj[i]
        o.x=o.x+o.vx*dt
        o.y=o.y+o.vy*dt
        o.a=o.a+o.va*dt
        o.vy=math.max(o.vy-1e3*dt,-620)
        if o.y<-260 then
            if o.name then
                if score>=2600 then
                    score=math.max(score*.9,2600)
                    MSG.new('warn',Text.about_peopleLost:repD(o.name),2)
                end
            end
            table.remove(obj,i)
        end
    end
end

function scene.draw()
    local t=love.timer.getTime()

    if score>2600 then
        GC.replaceTransform(SCR.xOy_m)
        GC.scale(math.min(math.log10(score),4.2))
        FONT.set(80)
        GC.setColor(1,1,1,math.min((score-2600)/1260,1)^2*.126)
        GC.mStr(math.floor(score),0,-30)
    end
    GC.replaceTransform(SCR.xOy_d)
    GC.setLineWidth(4)
    for i=1,#obj do
        local o=obj[i]
        if o.name then
            GC.setColor(
                o.score<=25 and COLOR.DL or
                o.score<=80 and COLOR.L or
                COLOR.lG
            )
            GC.mDraw(o.text,o.x,-o.y,o.a,o.r/42)
        else
            -- GC.setColor(.6,.6,.6,.26)
            -- GC.rectangle('line',o.x-o.r,-o.y-o.r,2*o.r,2*o.r)
            GC.setColor(COLOR.rainbow(o.minoColor))
            FONT.set(60)
            GC.printf(o.mino,o.x,-o.y,100,'center',o.a,o.r/16,nil,50,41)
        end
    end

    PROGRESS.drawExteriorHeader()
    GC.replaceTransform(SCR.xOy)

    -- Powered by Love2D
    GC.push('transform')
        GC.translate(330,220)
        GC.setColor(COLOR.L)
        FONT.set(60)
        GC.shadedPrint(Text.about_love,45,-35,nil,2,4)

        GC.rotate(-.785398+t*4.2-math.sin(t*4.2))
        GC.setLineWidth(4)
        GC.setColor(COLOR.D) GC.circle('fill',0,0,32)
        GC.setColor(COLOR.lW) GC.circle('fill',0,0,30)
        GC.setColor(COLOR.lS) GC.arc('fill','closed',0,0,30,0,3.141593)
        GC.translate(-2,2)
        GC.setColor(COLOR.L)
        GC.rectangle('fill',-10,-10,20,20)
        GC.circle('fill',0,-10,10)
        GC.circle('fill',10,0,10)
    GC.pop()

    FONT.set(35)
    GC.shadedPrint(Text.about_module,200,350,nil,2,4)
    GC.shadedPrint(Text.about_toolchain,1000,350,nil,2,4)
    FONT.set(50)
    local m=modules[math.floor(t)%#modules+1]
    GC.shadedPrint(m[1],200,390,nil,2,4)
    GC.shadedPrint(toolchain[math.floor(t)%#toolchain+1],1000,390,nil,2,4)
    FONT.set(30)
    GC.shadedPrint(m[2],200,450,nil,2,4)
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'about_title'},
}
return scene
