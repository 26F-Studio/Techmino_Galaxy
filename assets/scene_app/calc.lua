local gc=love.graphics

---@type Zenitha.Scene
local scene={}

local reg -- register
local val -- result value
local sym -- symbol

local function _autoReturn()
    if reg and sym then
        scene.keyDown('calculate')
    else
        reg=false
    end
end

function scene.load()
    BG.set('none')
    reg,val,sym=false,"0",false
end

scene.mouseDown=NULL
function scene.keyDown(key)
    if IsKeyDown('lshift','rshift') then
        if key=='=' then
            scene.keyDown('+')
            return true
        elseif IsKeyDown('lshift','rshift') and key=='8' then
            scene.keyDown('*')
            return true
        end
    elseif key:sub(1,2)=='kp' then
        scene.keyDown(key:sub(3))
        return true
    end
    if key=='.' then
        if sym=="=" then
            sym,reg=false,false
            val="0."
        elseif not (val:find(".",nil,true) or val:find("e")) then
            if sym and not reg then
                reg=val
                val="0."
            else
                val=val.."."
            end
        end
    elseif key=='e' then
        if sym=="=" then
            sym,reg=false
            val="0e"
        elseif not val:find("e") then
            val=val.."e"
        end
    elseif key=='backspace' then
        if sym=="=" then
            val=""
        elseif sym then
            sym=false
        else
            val=val:sub(1,-2)
        end
        if val=="" then
            val="0"
        end
    elseif key=='+' then
        _autoReturn()
        sym="+"
    elseif key=='*' then
        _autoReturn()
        sym="*"
    elseif key=='-' then
        _autoReturn()
        sym="-"
    elseif key=='/' then
        _autoReturn()
        sym="/"
    elseif key:byte()>=48 and key:byte()<=57 then
        if sym=="=" then
            val=key
            sym=false
        elseif sym and not reg then
            reg=val
            val=key
        else
            if #val<14 then
                if val=="0" then
                    val=""
                end
                val=val..key
            end
        end
    elseif key=='return' then
        scene.keyDown('calculate')
    elseif key=='calculate' then
        val=val:gsub("e$","")
        if sym and reg then
            reg=reg:gsub("e$","")
            val=
                sym=="+" and tostring((tonumber(reg) or 0)+tonumber(val)) or
                sym=="-" and tostring((tonumber(reg) or 0)-tonumber(val)) or
                sym=="*" and tostring((tonumber(reg) or 0)*tonumber(val)) or
                sym=="/" and tostring((tonumber(reg) or 0)/tonumber(val)) or
                "-1"
        end
        sym="="
        reg=false
    elseif key=='escape' then
        if val~="0" then
            reg,sym=false,false
            val="0"
        elseif SureCheck('back') then
            SCN.back()
        end
    elseif key=='delete' then
        val="0"
    end
    return true
end

function scene.draw()
    gc.translate(260,80)
    gc.setLineWidth(2)
    gc.setColor(COLOR.L)
    gc.rectangle('line',0,0,740,250,10)
    gc.setColor(COLOR.dT)
    gc.rectangle('fill',0,0,740,250,10)
    FONT.set(70)
    gc.setColor(COLOR.L)
    if reg then gc.printf(reg,0,30,700,'right') end
    if val then gc.printf(val,0,130,700,'right') end
    FONT.set(85)
    if sym then gc.printf(sym,26,125,260) end
end

scene.widgetList={
    WIDGET.new{type='button',x=330,y=420,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'1',                   text="1"},
    WIDGET.new{type='button',x=480,y=420,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'2',                   text="2"},
    WIDGET.new{type='button',x=630,y=420,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'3',                   text="3"},
    WIDGET.new{type='button',x=330,y=570,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'4',                   text="4"},
    WIDGET.new{type='button',x=480,y=570,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'5',                   text="5"},
    WIDGET.new{type='button',x=630,y=570,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'6',                   text="6"},
    WIDGET.new{type='button',x=330,y=720,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'7',                   text="7"},
    WIDGET.new{type='button',x=480,y=720,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'8',                   text="8"},
    WIDGET.new{type='button',x=630,y=720,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'9',                   text="9"},
    WIDGET.new{type='button',x=330,y=870,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'0',                   text="0"},
    WIDGET.new{type='button',x=480,y=870,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'.',        color='lM',text="."},
    WIDGET.new{type='button',x=630,y=870,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'e',        color='lM',text="e"},
    WIDGET.new{type='button',x=780,y=420,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'+',        color='lB',text="+"},
    WIDGET.new{type='button',x=780,y=570,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'-',        color='lB',text="-"},
    WIDGET.new{type='button',x=780,y=720,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'*',        color='lB',text="*"},
    WIDGET.new{type='button',x=780,y=870,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'/',        color='lB',text="/"},
    WIDGET.new{type='button',x=930,y=420,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'backspace',color='lR',text=CHAR.key.backspace},
    WIDGET.new{type='button',x=930,y=570,w=140,sound_trigger=false,fontSize=80,onPress=WIDGET.c_pressKey'return',   color='lY',text="="},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,onPress=WIDGET.c_backScn()},
}

return scene
