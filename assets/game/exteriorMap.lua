local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_replaceTransform=gc.replaceTransform
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_draw,gc_line=gc.draw,gc.line
local gc_circle,gc_polygon=gc.circle,gc.polygon

local linear=MATH.interpolate
local expAppr=MATH.expApproach
local dist=MATH.distance
local tau=MATH.tau

---@alias Techmino.ModeName
---| 'sprint'
---| 'sequence'
---| 'hidden'
---| 'tspin'
---| 'marathon'
---| 'allclear'
---| 'combo'
---| 'hypersonic'
---| 'dig'
---| 'excavate'
---| 'drill'
---| 'survivor'
---| 'backfire'
---| 'chain'
---| 'action'

-- Y   X
--   *
--   Z
local modes={
    {pos={25,35,00},name='sprint'},
    {pos={25,50,00},name='sequence'},
    {pos={25,65,15},name='hidden'},
    {pos={25,50,15},name='tspin'},

    {pos={45,45,00},name='marathon'},
    {pos={45,60,00},name='allclear'},
    {pos={60,60,00},name='combo'},
    {pos={60,45,00},name='hypersonic'},

    {pos={35,25,00},name='dig'},
    {pos={50,25,00},name='excavate'},
    {pos={35,10,00},name='drill'},
    {pos={65,25,00},name='survivor'},
    {pos={50,10,00},name='backfire'},

    {pos={00,35,10},name='chain'},

    {pos={35,00,10},name='action'},
}
-- Initialize modes' graphic values
for _,m in next,modes do
    m.enable=false
    m.state=-1
    m.active=0
    m.x=30*(m.pos[1]-m.pos[2])*(3^.5/2)
    m.y=30*(m.pos[3]-(m.pos[1]+m.pos[2])*.5)
    m.r=100
end

-- Generate name-mode pairs
local modes_str={} for i=1,#modes do modes_str[modes[i].name]=modes[i] end

local bridgeLinks={
    'marathon - dig - sprint - marathon',
    'sprint - tspin',
    'sprint - hidden',
    'sprint - sequence',
    'marathon - hypersonic',
    'marathon - combo',
    'marathon - allclear',
    'dig - excavate - survivor',
    'dig - drill - backfire',
    'tspin - chain',
    'drill - action',
}
local bridges={}
local function _newBridge(m1,m2)
    local x1,y1=m1.x,m1.y
    local x2,y2=m2.x,m2.y
    local d=dist(x1,y1,x2,y2)

    -- Cut in-mode parts
    local p1,p2=(m1.r*1.2)/d,1-(m2.r*1.2)/d
    x1,y1,x2,y2=
        x1*(1-p1)+x2*p1,
        y1*(1-p1)+y2*p1,
        x1*(1-p2)+x2*p2,
        y1*(1-p2)+y2*p2

    table.insert(bridges,{
        enable=false,
        m1=m1,m2=m2,
        timer=0,
        x1=x1,y1=y1,
        x2=x2,y2=y2,
        q1x=x1*.25+x2*.75,q1y=y1*.25+y2*.75,
        q2x=x1*.50+x2*.50,q2y=y1*.50+y2*.50,
        q3x=x1*.75+x2*.25,q3y=y1*.75+y2*.25,
    })
end
for _,link in next,bridgeLinks do
    local b=STRING.split(link,' - ')
    for i=1,#b-1 do
        _newBridge(
            assert(modes_str[b[i]],"Mode "..b[i].." doesn't exist"),
            assert(modes_str[b[i+1]],"Mode "..b[i+1].." doesn't exist")
        )
    end
end

local animations={}

local pSys={} for i=1,3 do pSys[i]=require'assets.game.particleSystemTemplate'.exMapBack:clone() end
local mapPoly={
    0,0,
    6200,10738.715,
    12400,0,
    6200,-10738.715,
}
local modeStateColor={
    test=COLOR.B,
}
local enterFX={
    timer=false,
    x=false,
    y=false,
    r=false,
}
local mapCursor=false
local cam=GC.newCamera()
cam.y0,cam.y=950,620
cam.k0,cam.k=.9,2
cam.swing=.00626
cam.maxDist=2600
cam.minK,cam.maxK=.4--[[.2]],1.26

---@type table|false
local focused=false

---@type table|false
local selected=false

---@type boolean
local full=false

local map={}

-- Map methods
function map:freshUnlocked(modeList,init)
    assert(type(modeList)=='table',"WTF why modeList isn't table")

    local modeTime=.626

    -- Unlock modes
    for name,state in next,modeList do
        local mode=modes_str[name]
        if mode then
            if not (init or mode.enable) then
                animations[mode]={
                    type='mode',
                    wait=modeTime,
                    t=0,
                }
                modeTime=modeTime+.626
            end
            mode.enable=true
            mode.state=state
        end
    end

    -- Create bridges
    for _,b in next,bridges do
        if not b.enable and b.m1.enable and b.m2.enable then
            b.enable=true
            if animations[b.m2] then
                animations[b]={
                    type='bridge',
                    wait=animations[b.m2].wait-.355,
                    t=0,
                    x=(b.m1.x+b.m2.x)*.5,
                    y=(b.m1.y+b.m2.y)*.5,
                    sound=true,
                }
            end
        end
    end
end

function map:_unlockall()
    full=true
    for i=1,#modes do
        if not modes[i].enable then
            modes[i].enable=true
            modes[i].state=0
        end
    end
    for i=1,#bridges do
        bridges[i].enable=true
    end
end

function map:reset(f)
    for i=1,3 do
        pSys[i]:reset()
        pSys[i]:start()
    end
    mapCursor=false
    enterFX.timer=false
    focused=false
    selected=false
    full=f
end

function map:hideCursor() mapCursor=false end
function map:showCursor() mapCursor=true end

local function _onMode(x,y)
    x,y=SCR.xOy_m:inverseTransformPoint(x,y)
    x,y=cam.transform:inverseTransformPoint(x,y-100)
    for _,m in next,modes do
        if m.enable and dist(x,y,m.x,m.y)<m.r*1.26 then
            return m
        end
    end
    return false
end
local function _selectMode(m)
    selected=m
    if m then
        FMOD.effect('map_select')
    end
end
local function _enterMode(m)
    if m then
        if love.filesystem.getInfo('assets/game/mode/brik/exterior/'..m.name..'.lua') then
            enterFX.timer=0
            enterFX.x,enterFX.y,enterFX.r=m.x,m.y,m.r
            FMOD.effect('map_enter')
            SCN.go('game_out','fade','brik/exterior/'..m.name)
        else
            MSG.new('warn',"Mode file not exist")
        end
    end
end

function map:moveCam(dx,dy)
    if full then
        cam:move(dx,dy)
    end
end
function map:rotateCam(da)
    if full then
        cam:rotate(da)
    end
end
function map:scaleCam(dk)
    if full then
        cam:scale(dk)
    end
end

function map:mouseMove(x,y)
    focused=_onMode(x,y)
end
function map:mouseClick(x,y)
    local m=_onMode(x,y)
    if m and m==selected then
        _enterMode(m)
    else
        _selectMode(m)
        return m
    end
end
function map:keyboardMove(x,y)
    if mapCursor then
        focused=_onMode(x,y)
    end
end
function map:keyboardSelect()
    if focused and focused==selected then
        _enterMode(selected)
    else
        _selectMode(focused)
        return focused
    end
end

function map:update(dt)
    -- if selected then
    --     selected.pos={
    --         selected.pos[1]+.026*((love.keyboard.isDown('w') and 1 or 0)-(love.keyboard.isDown('s') and 1 or 0)),
    --         selected.pos[2]+.026*((love.keyboard.isDown('a') and 1 or 0)-(love.keyboard.isDown('d') and 1 or 0)),
    --         selected.pos[3]+.026*((love.keyboard.isDown('q') and 1 or 0)-(love.keyboard.isDown('e') and 1 or 0)),
    --     }
    --     selected.x=30*(selected.pos[1]-selected.pos[2])*(3^.5/2)
    --     selected.y=30*(selected.pos[3]-(selected.pos[1]+selected.pos[2])*.5)
    -- end
    for _,m in next,modes do
        if m.enable then
            m.active=expAppr(m.active,(m==focused) and 1 or 0,dt*6)
        end
    end
    for _,b in next,bridges do
        b.timer=b.timer+dt
    end
    for _,a in next,animations do
        if a.wait>0 then
            a.wait=a.wait-dt
            if a.wait<=0 and a.type=='bridge' then
                cam.x0,cam.y0=-a.x,-a.y
                cam.k0,cam.a0=1,0
                if TASK.lock('exMap_unlockSound',.26) then
                    FMOD.effect('map_unlock')
                end
            end
        else
            a.t=a.t+dt
            if a.t>2.6 then
                animations[_]=nil
            end
        end
    end
    if full then
        if love.keyboard.isDown('up','down','left','right') then
            self:showCursor()
            if isCtrlPressed() then
                if love.keyboard.isDown('up')    then cam:scale(2.6^dt) end
                if love.keyboard.isDown('down')  then cam:scale(1/2.6^dt) end
                if love.keyboard.isDown('right') then cam:rotate(dt*3.55) end
                if love.keyboard.isDown('left')  then cam:rotate(-dt*3.55) end
            else
                local dx,dy=0,0
                if love.keyboard.isDown('up')    then dy=dy+dt*1260 end
                if love.keyboard.isDown('down')  then dy=dy-dt*1260 end
                if love.keyboard.isDown('left')  then dx=dx+dt*1260 end
                if love.keyboard.isDown('right') then dx=dx-dt*1260 end
                cam:move(dx,dy)
            end
        end
        pSys[1]:update(dt)
        pSys[2]:update(dt)
        pSys[3]:update(dt)
    end
    cam:update(dt)
    if enterFX.timer then
        enterFX.timer=enterFX.timer+dt
    end
end

function map:draw()
    gc_replaceTransform(SCR.xOy_m)
    gc_translate(0,100)
    cam:apply()

    -- Bridges
    for _,b in next,bridges do
        if b.enable then
            local x1,y1,x2,y2=b.x1,b.y1,b.x2,b.y2
            if animations[b] then
                local t=expAppr(0,1,animations[b].t*2.6)
                x2,y2=linear(0,x1,1,x2,t),linear(0,y1,1,y2,t)
            end
            if x1~=x2 or y1~=y2 then
                gc_setColor(1,1,1,.8)
                gc_setLineWidth(30)
                gc_line(x1,y1,x2,y2)
                gc_setColor(0,0,0,.6)
                gc_setLineWidth(20)
                gc_line(x1,y1,x2,y2)
                for i=0,.75,.25 do
                    local t=(b.timer/2.6+i)%1
                    gc_setColor(1,1,1,-t*(t-1)*4)
                    gc_circle('fill',linear(0,x1,1,x2,t),linear(0,y1,1,y2,t),6,6)
                end
            end
        end
    end

    -- Modes
    for _,m in next,modes do
        if m.enable then
            gc_push('transform')
            gc_translate(m.x,m.y)
            gc_scale(1+m.active*.1)
            if animations[m] then
                gc_scale(expAppr(0,1,animations[m].t*6.26))
            end
            gc_rotate(-cam.a)

            -- Outframe
            gc_setColor(1,1,1,.626)
            gc_setLineWidth(2)
            GC.regPolygon('line',0,0,m.r-11,6,tau/12)
            GC.regPolygon('line',0,0,m.r+5,6,tau/12)
            gc_setLineWidth(10)
            gc_setColor(modeStateColor[m.rank] or COLOR.lD)
            GC.regPolygon('line',0,0,m.r-3,6,tau/12)

            -- Name
            FONT.set(30)
            gc_setColor(COLOR.L)
            local modeInfo=Text.exteriorModeInfo[m.name]
            GC.shadedPrint(modeInfo and modeInfo[1] or m.name,0,-21,'center',2,4)

            -- Selecting frame
            if m==selected or m.active>.001 then
                local rb=m==selected and .42 or 1
                gc_setLineWidth(8)
                gc_setColor(rb,1,rb,m==selected and 1 or m.active*.26)
                GC.regPolygon('line',0,0,m.r+16,6,tau/12)
            end
            gc_pop()
        end
    end

    -- enterFX
    if enterFX.timer then
        gc_setColor(1,1,1,math.min(enterFX.timer*62,1))
        gc_setLineWidth(4+enterFX.timer*260)
        GC.regPolygon('line',enterFX.x,enterFX.y,(enterFX.r)*260^enterFX.timer,6,tau/12-cam.a)
    end

    -- Back and particles
    gc_rotate(-tau/4) gc_setColor(.6,0.,1.,.02) gc_polygon('fill',mapPoly) gc_scale(.5) gc_setColor(0,0,0,.0626) gc_polygon('fill',mapPoly) gc_scale(2)
    gc_rotate(tau/3)  gc_setColor(.1,.1,1.,.02) gc_polygon('fill',mapPoly) gc_scale(.5) gc_setColor(0,0,0,.0626) gc_polygon('fill',mapPoly) gc_scale(2)
    gc_rotate(tau/3)  gc_setColor(1.,0.,0.,.02) gc_polygon('fill',mapPoly) gc_scale(.5) gc_setColor(0,0,0,.0626) gc_polygon('fill',mapPoly) gc_scale(2)
    if full then
        gc_rotate(tau/3) if PROGRESS.getStyleUnlock('brik') then gc_setColor(.62,.26,1) gc_draw(pSys[1]) end
        gc_rotate(tau/3) if PROGRESS.getStyleUnlock('acry') then gc_setColor(.42,.42,1) gc_draw(pSys[2]) end
        gc_rotate(tau/3) if PROGRESS.getStyleUnlock('gela') then gc_setColor(1,.26,.26) gc_draw(pSys[3]) end
    end

    -- Keyboard cursor
    gc_replaceTransform(SCR.xOy_m)
    if mapCursor then
        gc_push('transform')
        gc_translate(0,100)
        gc_rotate(-cam.a)
        gc_setColor(COLOR.L)
        gc_setLineWidth(4)
        gc_line(0,-10,0,-30)
        gc_line(8.62,5,26,15)
        gc_line(-8.62,5,-26,15)
        gc_pop()
    end
end

function map:_printModePos()
    for _,m in next,modes do
        print(("pos={%d,%d,%d}, name='%s',"):format(m.pos[1],m.pos[2],m.pos[3],m.name))
    end
end

return map
