local gc=love.graphics

local instList={'organ_wave','square_wave','saw_wave','complex_wave','stairs_wave','spectral_wave'}
local layoutList={
    {
            ['2']=37,['3']=39,         ['5']=42,['6']=44,['7']=46,         ['9']=49,['0']=51,         ['=']=54,['backspace']=56,
        ['q']=36,['w']=38,['e']=40,['r']=41,['t']=43,['y']=45,['u']=47,['i']=48,['o']=50,['p']=52,['[']=53,[']']=55,['\\']=57,
            ['s']=25,['d']=27,         ['g']=30,['h']=32,['j']=34,         ['l']=37,[';']=39,
        ['z']=24,['x']=26,['c']=28,['v']=29,['b']=31,['n']=33,['m']=35,[',']=36,['.']=38,['/']=40,

        pos={scale=10,x=-65,y=-20},
        {x=-5,y=-5,w=140,h=50}, -- Outline, just for look

        {x=005,y=00,w=8,h=8,key='2'},
        {x=015,y=00,w=8,h=8,key='3'},
        {x=035,y=00,w=8,h=8,key='5'},
        {x=045,y=00,w=8,h=8,key='6'},
        {x=055,y=00,w=8,h=8,key='7'},
        {x=075,y=00,w=8,h=8,key='9'},
        {x=085,y=00,w=8,h=8,key='0'},
        {x=105,y=00,w=8,h=8,key='='},
        {x=115,y=00,w=13,h=8,key='backspace'},

        {x=000,y=10,w=8,h=8,key='q'},
        {x=010,y=10,w=8,h=8,key='w'},
        {x=020,y=10,w=8,h=8,key='e'},
        {x=030,y=10,w=8,h=8,key='r'},
        {x=040,y=10,w=8,h=8,key='t'},
        {x=050,y=10,w=8,h=8,key='y'},
        {x=060,y=10,w=8,h=8,key='u'},
        {x=070,y=10,w=8,h=8,key='i'},
        {x=080,y=10,w=8,h=8,key='o'},
        {x=090,y=10,w=8,h=8,key='p'},
        {x=100,y=10,w=8,h=8,key='['},
        {x=110,y=10,w=8,h=8,key=']'},
        {x=120,y=10,w=8,h=8,key='\\'},

        {x=015,y=20,w=8,h=8,key='s'},
        {x=025,y=20,w=8,h=8,key='d'},
        {x=045,y=20,w=8,h=8,key='g'},
        {x=055,y=20,w=8,h=8,key='h'},
        {x=065,y=20,w=8,h=8,key='j'},
        {x=085,y=20,w=8,h=8,key='l'},
        {x=095,y=20,w=8,h=8,key=';'},

        {x=010,y=30,w=8,h=8,key='z'},
        {x=020,y=30,w=8,h=8,key='x'},
        {x=030,y=30,w=8,h=8,key='c'},
        {x=040,y=30,w=8,h=8,key='v'},
        {x=050,y=30,w=8,h=8,key='b'},
        {x=060,y=30,w=8,h=8,key='n'},
        {x=070,y=30,w=8,h=8,key='m'},
        {x=080,y=30,w=8,h=8,key=','},
        {x=090,y=30,w=8,h=8,key='.'},
        {x=100,y=30,w=8,h=8,key='/'},
    }
}
local layout=layoutList[1]
local activeEventMap={}
local inst
local offset
local release

---@type Zenitha.Scene
local scene={}

function scene.load()
    stopBgm()
    inst='square_wave'
    offset=0
    release=500
end

function scene.touchDown(x,y,k)
    -- TODO: cool piano
end
scene.mouseDown=scene.touchDown

local _param={
    tune=1,
    volume=1,
    param={'release',1},
}
function scene.keyDown(key,isRep,keyCode)
    if not isRep and layout[keyCode] then
        local note=layout[keyCode]+offset
        if isShiftPressed() then note=note+1 end
        if isCtrlPressed() then note=note-1 end
        _param.tune=note-26
        _param.volume=1
        _param.param[2]=release*1.0594630943592953^(note-26)
        activeEventMap[keyCode]=FMOD.effect(inst,_param)
    elseif key=='tab' then
        inst=TABLE.next(instList,inst) or instList[1]
    elseif key=='lalt' then
        local d=0
        if isShiftPressed() then d=d+12 end
        if isCtrlPressed() then d=d-12 end
        if d==0 then
            offset=MATH.clamp(offset-1,-12,24)
        else
            offset=MATH.clamp(offset+d,-12,24)
        end
    elseif key=='ralt' then
        local d=0
        if isShiftPressed() then d=d+12 end
        if isCtrlPressed() then d=d-12 end
        if d==0 then
            offset=MATH.clamp(offset+1,-12,24)
        else
            offset=MATH.clamp(offset+d,-12,24)
        end
    elseif key=='f1' then
        release=math.max(release-100,0)
    elseif key=='f2' then
        release=math.min(release+100,2600)
    elseif key=='escape' then
        if sureCheck('back') then SCN.back() end
    elseif key=='`' then
        layout=TABLE.next(layoutList,layout) or layoutList[1]
    end
    return true
end
function scene.keyUp(_,keyCode)
    if layout[keyCode] and activeEventMap[keyCode] then
        activeEventMap[keyCode]:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT)
        activeEventMap[keyCode]=false
    end
end

local rect=gc.rectangle
local isSCDown=isSCDown
function scene.draw()
    FONT.set(30)
    gc.print(inst,40,60)
    gc.print(offset,40,100)
    gc.print(release,40,140)
    gc.replaceTransform(SCR.xOy_m)
    gc.scale(layout.pos.scale)
    gc.translate(layout.pos.x,layout.pos.y)
    gc.setLineWidth(5/layout.pos.scale)
    for i=1,#layout do
        local key=layout[i]
        rect(key.key and isSCDown(key.key) and 'fill' or 'line',key.x,key.y,key.w,key.h)
    end
end

scene.widgetList={
    WIDGET.new{type='button', pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
