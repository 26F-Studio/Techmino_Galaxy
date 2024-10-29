local gc=love.graphics

local instList={'organ_wave','square_wave','saw_wave','complex_wave','stairs_wave','spectral_wave'}
local keys={
    -- ['1']=60,['2']=62,['3']=64,['4']=65,['5']=67,['6']=69,['7']=71,['8']=72,['9']=74,['0']=76,['-']=77,['=']=79,['backspace']=81,
        ['2']=37,['3']=39,         ['5']=42,['6']=44,['7']=46,         ['9']=49,['0']=51,         ['=']=54,['backspace']=56,
    ['q']=36,['w']=38,['e']=40,['r']=41,['t']=43,['y']=45,['u']=47,['i']=48,['o']=50,['p']=52,['[']=53,[']']=55,['\\']=57,
    -- ['a']=36,['s']=38,['d']=40,['f']=41,['g']=43,['h']=45,['j']=47,['k']=48,['l']=50,[';']=52,["'"]=50,['return']=55,
        ['s']=25,['d']=27,         ['g']=30,['h']=32,['j']=34,         ['l']=37,[';']=39,
    ['z']=24,['x']=26,['c']=28,['v']=29,['b']=31,['n']=33,['m']=35,[',']=36,['.']=38,['/']=40,
}
local activeEventMap={}
local inst
local offset
local release

---@type Zenitha.Scene
local scene={}

function scene.load()
    stopBgm()
    inst='square_wave'
    offset=-3
    release=500
end

function scene.touchDown(x,y,k)
    -- TODO: cool piano
end
scene.mouseDown=scene.touchDown

function scene.keyDown(key,isRep,keyCode)
    if not isRep and keys[keyCode] then
        local note=keys[keyCode]+offset
        if isShiftPressed() then note=note+1 end
        if isCtrlPressed() then note=note-1 end
        activeEventMap[keyCode]=FMOD.effect(inst,{
            tune=note-26,
            volume=1,
            param={'release',release*1.0594630943592953^(note-26)},
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
    end
    return true
end
function scene.keyUp(_,keyCode)
    if keys[keyCode] and activeEventMap[keyCode] then
        activeEventMap[keyCode]:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT)
        activeEventMap[keyCode]=false
    end
end

function scene.draw()
    FONT.set(30)
    gc.print(inst,40,60)
    gc.print(offset,40,100)
    gc.print(release,40,140)
end

scene.widgetList={
    WIDGET.new{type='button', pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
