local gc=love.graphics
local gc_translate=gc.translate
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_rectangle=gc.rectangle
local gc_print=gc.print

local max,min=math.max,math.min
local ins,rem=table.insert,table.remove

local deck0={}
for i=1,9 do
    for _=1,4 do
        ins(deck0,'m'..i)
        ins(deck0,'p'..i)
        ins(deck0,'s'..i)
        if i<=7 then ins(deck0,'z'..i) end
    end
end
-- deck0[TABLE.find(deck0,'m5')]='m0'
-- deck0[TABLE.find(deck0,'p5')]='p0'
-- deck0[TABLE.find(deck0,'s5')]='s0'
-- cardText['5m+']={COLOR.R,'五'}
-- cardText['5p+']={COLOR.R,'⑤'}
-- cardText['5s+']={COLOR.R,'5'}

local cardText={
    m1={COLOR.dR,CHAR.mahjong.m1},
    m2={COLOR.dR,CHAR.mahjong.m2},
    m3={COLOR.dR,CHAR.mahjong.m3},
    m4={COLOR.dR,CHAR.mahjong.m4},
    m5={COLOR.dR,CHAR.mahjong.m5},
    m6={COLOR.dR,CHAR.mahjong.m6},
    m7={COLOR.dR,CHAR.mahjong.m7},
    m8={COLOR.dR,CHAR.mahjong.m8},
    m9={COLOR.dR,CHAR.mahjong.m9},
    p1={COLOR.D,CHAR.mahjong.p1},
    p2={COLOR.D,CHAR.mahjong.p2},
    p3={COLOR.D,CHAR.mahjong.p3},
    p4={COLOR.D,CHAR.mahjong.p4},
    p5={COLOR.D,CHAR.mahjong.p5},
    p6={COLOR.D,CHAR.mahjong.p6},
    p7={COLOR.D,CHAR.mahjong.p7},
    p8={COLOR.D,CHAR.mahjong.p8},
    p9={COLOR.D,CHAR.mahjong.p9},
    s1={COLOR.dG,CHAR.mahjong.s1},
    s2={COLOR.dG,CHAR.mahjong.s2},
    s3={COLOR.dG,CHAR.mahjong.s3},
    s4={COLOR.dG,CHAR.mahjong.s4},
    s5={COLOR.dG,CHAR.mahjong.s5},
    s6={COLOR.dG,CHAR.mahjong.s6},
    s7={COLOR.dG,CHAR.mahjong.s7},
    s8={COLOR.dG,CHAR.mahjong.s8},
    s9={COLOR.dG,CHAR.mahjong.s9},
    z1={COLOR.D,CHAR.mahjong.z1},
    z2={COLOR.D,CHAR.mahjong.z2},
    z3={COLOR.D,CHAR.mahjong.z3},
    z4={COLOR.D,CHAR.mahjong.z4},
    z5={COLOR.D,CHAR.mahjong.z5},
    z6={COLOR.G,CHAR.mahjong.z6},
    z7={COLOR.R,CHAR.mahjong.z7},
}

local deck,hand,pool
local selected

local function _getPoolCardArea(i)
    local row=math.floor((i-1)/10)
    local col=i-row*10
    return
    240+70*col,45+95*row,
    60,84
end

local function _getHandCardArea(i)
    return
    20+70*i+(i==14 and 30 or 0),480,
    60,84
end

local function _newGame()
    deck=TABLE.shift(deck0)
    hand={}
    pool={}
    for _=1,14 do ins(hand,(TABLE.popRandom(deck))) end
    table.sort(hand)
end

local function _checkWin()
    if #hand==14 then
        MSG.new('info',"Coming soon!")
    end
end

local function _throwCard()
    if hand[selected] and #pool<40 then
        ins(pool,rem(hand,selected))
        table.sort(hand)
        FMOD.effect('hold')
        FMOD.effect('lock')
        if #pool<40 then
            ins(hand,(TABLE.popRandom(deck)))
        end
    end
end

---@type Zenitha.Scene
local scene={}

function scene.enter()
    BG.set('fixColor')
    BG.send('fixColor',.26,.62,.26)
    _newGame()
    selected=false
end

function scene.mouseMove(x,y)
    selected=false
    for i=1,#hand do
        local cx,cy,cw,ch=_getHandCardArea(i)
        if x>cx and x<cx+cw and y>cy and y<cy+ch then
            selected=i
            return
        end
    end
end
function scene.mouseDown()
    _throwCard()
end
function scene.touchMove(x,y)scene.mouseMove(x,y) end
function scene.touchDown(x,y)scene.mouseMove(x,y) end
function scene.touchClick(x,y)scene.mouseDown(x,y) end
function scene.keyDown(key)
    if key=='left' then
        if selected then
            selected=max(selected-1,1)
        else
            selected=1
        end
    elseif key=='right' then
        if selected then
            selected=min(selected+1,#hand)
        else
            selected=#hand
        end
    elseif key=='space' then
        _throwCard()
    elseif key=='r' then
        _newGame()
    elseif key=='return' then
        _checkWin()
    elseif key=='escape' then
        SCN.back()
    end
end

function scene.draw()
    FONT.set(35)
    gc_setColor(COLOR.D)
    gc_print('余 '..#deck,1060,30)

    gc_setLineWidth(4)
    FONT.set(100)
    for i=1,#hand do
        local c=hand[i]
        local x,y,w,h=_getHandCardArea(i)
        if i==selected then
            gc_translate(0,-10)
        end
        gc_setColor(COLOR.L)
        gc_rectangle('fill',x,y,w,h,6)
        if i==selected then
            gc_setColor(1,1,1,.4)
            gc_rectangle('fill',x,y,w,h,6)
        end
        gc_setColor(1,1,1)
        GC.mStr(cardText[c],x+w/2,y-24)
        if i==selected then gc_translate(0,10) end
    end
    for i=1,#pool do
        local c=pool[i]
        local x,y,w,h=_getPoolCardArea(i)
        gc_setColor(COLOR.L)
        gc_rectangle('fill',x,y,w,h,6)
        if selected and hand[selected]==c then
            gc_setColor(1,.2,.2,.3)
            gc_rectangle('fill',x,y,w,h,6)
        end
        gc_setColor(1,1,1)
        GC.mStr(cardText[c],x+w/2,y-17)
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},x=160, y=100,w=180,h=100,color='lR',fontSize=60,text=CHAR.icon.retry,code=WIDGET.c_pressKey'r'},
    WIDGET.new{type='button',          x=1150,y=370,w=140,h=80,fontSize=45,sound_trigger=false,text='自摸',code=WIDGET.c_pressKey'return'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
