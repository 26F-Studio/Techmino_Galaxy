local gc=love.graphics
local kb=love.keyboard

local instList={'square_wave','triangle_wave','sine_wave'}
local keys={
    -- ['1']=57,['2']=59,['3']=61,['4']=62,['5']=64,['6']=66,['7']=68,['8']=69,['9']=71,['0']=73,['-']=74,['=']=76,['backspace']=78,
        ['2']=34,['3']=36,         ['5']=39,['6']=41,['7']=43,         ['9']=46,['0']=48,         ['=']=51,['backspace']=53,
    ['q']=33,['w']=35,['e']=37,['r']=38,['t']=40,['y']=42,['u']=44,['i']=45,['o']=47,['p']=49,['[']=50,[']']=52,['\\']=54,
    -- ['a']=33,['s']=35,['d']=37,['f']=38,['g']=40,['h']=42,['j']=44,['k']=45,['l']=47,[';']=49,["'"]=50,['return']=52,
        ['s']=22,['d']=24,         ['g']=27,['h']=29,['j']=31,         ['l']=34,[';']=36,
    ['z']=21,['x']=23,['c']=25,['v']=26,['b']=28,['n']=30,['m']=32,[',']=33,['.']=35,['/']=37,
}
local activeEventMap={}
local inst
local offset

---@type Zenitha.Scene
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
        activeEventMap[key]=FMOD.effect(inst,{
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
        inst=TABLE.next(instList,inst) or instList[1]
    elseif key=='lalt' then
        offset=math.max(offset-1,-12)
    elseif key=='ralt' then
        offset=math.min(offset+1,12)
    elseif key=='escape' then
        if sureCheck('back') then SCN.back() end
    end
    return true
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
