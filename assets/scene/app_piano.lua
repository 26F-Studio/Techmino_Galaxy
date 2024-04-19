local gc=love.graphics
local kb=love.keyboard

local instList={'square_wave','triangle_wave','sine_wave'}
local keys={
    ['1']=57,['2']=59,['3']=61,['4']=62,['5']=64,['6']=66,['7']=68,['8']=69,['9']=71,['0']=73,['-']=74,['=']=76,['backspace']=78,
    ['q']=45,['w']=47,['e']=49,['r']=50,['t']=52,['y']=54,['u']=56,['i']=57,['o']=59,['p']=61,['[']=62,[']']=64,['\\']=66,
    ['a']=33,['s']=35,['d']=37,['f']=38,['g']=40,['h']=42,['j']=44,['k']=45,['l']=47,[';']=49,["'"]=50,['return']=52,
    ['z']=21,['x']=23,['c']=25,['v']=26,['b']=28,['n']=30,['m']=32,[',']=33,['.']=35,['/']=37,
}
local activeEventMap={}
local inst
local offset

local scene={}

function scene.enter()
    inst='square_wave'
    offset=0
end

function scene.touchDown(x,y,k)
    -- TODO
end
scene.mouseDown=scene.touchDown

function scene.keyDown(key,isRep)
    if not isRep and keys[key] then
        local note=keys[key]+offset
        if kb.isDown('lshift','rshift') then note=note+1 end
        if kb.isDown('lctrl','rctrl') then note=note-1 end
        activeEventMap[key]=FMOD.effect.play(inst,{
            tune=note-21,
            volume=1,
            param={'release',1000*1.0594630943592953^(note-21)},
        })
        TEXT:add{
            text=SFX.getNoteName(note),
            x=math.random(150,1130),
            y=math.random(140,500),
            fontSize=60,
            style='score',
            duration=.8,
        }
    elseif key=='tab' then
        inst=TABLE.next(instList,inst)
    elseif key=='lalt' then
        offset=math.max(offset-1,-12)
    elseif key=='ralt' then
        offset=math.min(offset+1,12)
    elseif key=='escape' then
        SCN.back()
    end
end
function scene.keyUp(key)
    if keys[key] and activeEventMap[key] then
        activeEventMap[key]:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT)
        activeEventMap[key]=false
    end
end

function scene.draw()
    FONT.set(30)
    gc.print(inst,40,60)
    gc.print(offset,40,100)
end

scene.widgetList={
    WIDGET.new{type='button', pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
