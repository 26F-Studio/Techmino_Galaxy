local gc=love.graphics
local gc_setColor=GC.setColor
local gc_rect=GC.rectangle
local gc_mStr=GC.mStr
local setFont=FONT.set

local ins,rem=table.insert,table.remove

local activeEventMap={} ---@type table<love.Scancode, FMOD.Studio.EventInstance>
local objPool={} ---@type Techmino.Piano.Object[]
local inst,offset,release

local instList={'organ_wave','square_wave','saw_wave','complex_wave','stairs_wave','spectral_wave'}
local presets={}

local scrollSpeed=620
local disappearDist=-800
presets.synthNote={}
---@return Techmino.Piano.Object
function presets.synthNote.newNote()
    return {
        len=0,
        free=false,
        _type='synthNote',
        _update=function(self,dt)
            local dSize=dt*scrollSpeed
            self.y=self.y-dSize
            if self.free then
                return self.y+self.len<disappearDist
            else
                self.len=self.len+dSize
            end
        end,
        _draw=function(self)
            gc_setColor(self.color)
            gc_rect('fill',self.x,self.y,self.w,self.len,8)
        end,
    }
end
function presets.synthNote.press(key)
    key.note=presets.synthNote.newNote()
    local centerX=key.x+key.w/2+(key.synthNotePos or 0)
    local width=key.synthNoteWidth or key.w
    TABLE.update(key.note,{y=key.y,x=centerX-width/2,w=width,color=key.synthNoteColor or key.fillC})
    ins(objPool,key.note)
end
function presets.synthNote.release(key)
    key.note.free=true
    key.note=nil
end

---@class Techmino.Piano.Object
---@field _type string
---@field _update fun(dt:number): any
---@field _draw function

---@class Techmino.Piano.Layout
---@field name string
---@field keyMap table<string,number>
---@field pos_x number Starting X position of the layout (0,0 for screen center)
---@field pos_y number Starting Y position
---@field size number Scale all things (based on the screen center)
---@field font number Font size, MUST BE MULTIPLE OF 5
---@field templates? Techmino.Piano.keyObj[]
---@field keyLayout Techmino.Piano.keyObj[]

---@class Techmino.Piano.keyObj
---@field [1]? number Template id (low priority)
---@field x? number X position of key's upper-left corner
---@field y? number Y position
---@field w? number Width
---@field h? number Height
---@field key? string | string[] Key code, use list for multiple inputs, leave blank for decorating only
---@field show? string Text to show on the key, leave blank for default
---@field fillC? Zenitha.Color | Zenitha.ColorStr Background color when NOT pressed
---@field lineC? Zenitha.Color | Zenitha.ColorStr Outline color when NOT pressed
---@field actvC? Zenitha.Color | Zenitha.ColorStr color when pressed
---@field textC? Zenitha.Color | Zenitha.ColorStr Text color
---@field _pressed? boolean
---@field _onPress? function
---@field _onRelease? function

---@type Techmino.Piano.Layout[]
local layoutList={
    {name="Classic-C",
        pos_x=-70,
        pos_y=-25,
        size=10,
        font=60,
        templates={
            {w=8,h=8,fillC='DS',actvC='dS',lineC='LD',textC='dL'}, -- Treble (black)
            {w=8,h=8,fillC='LS',actvC='S',lineC='LD',textC='D'},   -- Treble (white)
            {w=8,h=8,fillC='DR',actvC='dR',lineC='LD',textC='dL'}, -- Bass (black)
            {w=8,h=8,fillC='LR',actvC='R',lineC='LD',textC='D'},   -- Bass (white)
        },
        keyLayout={
            {x=0,y=0,w=140,h=50,fillC={1,1,1,.26},lineC='dL'}, -- Frame
            {1,x=010,y=05,key='2'}, -- Line 1
            {1,x=020,y=05,key='3'},
            {1,x=040,y=05,key='5'},
            {1,x=050,y=05,key='6'},
            {1,x=060,y=05,key='7'},
            {1,x=080,y=05,key='9'},
            {1,x=090,y=05,key='0'},
            {1,x=110,y=05,key='='},
            {1,x=120,y=05,w=13,key='backspace'},
            {2,x=005,y=15,key='q'}, -- Line 2
            {2,x=015,y=15,key='w'},
            {2,x=025,y=15,key='e'},
            {2,x=035,y=15,key='r'},
            {2,x=045,y=15,key='t'},
            {2,x=055,y=15,key='y'},
            {2,x=065,y=15,key='u'},
            {2,x=075,y=15,key='i'},
            {2,x=085,y=15,key='o'},
            {2,x=095,y=15,key='p'},
            {2,x=105,y=15,key='['},
            {2,x=115,y=15,key=']'},
            {2,x=125,y=15,key='\\'},
            {3,x=020,y=25,key='s'}, -- Line 3
            {3,x=030,y=25,key='d'},
            {3,x=050,y=25,key='g'},
            {3,x=060,y=25,key='h'},
            {3,x=070,y=25,key='j'},
            {3,x=090,y=25,key='l'},
            {3,x=100,y=25,key=';'},
            {4,x=015,y=35,key='z'}, -- Line 4
            {4,x=025,y=35,key='x'},
            {4,x=035,y=35,key='c'},
            {4,x=045,y=35,key='v'},
            {4,x=055,y=35,key='b'},
            {4,x=065,y=35,key='n'},
            {4,x=075,y=35,key='m'},
            {4,x=085,y=35,key=','},
            {4,x=095,y=35,key='.'},
            {4,x=105,y=35,key='/'},
        },
        keyMap={
            ['2']=37,['3']=39,         ['5']=42,['6']=44,['7']=46,         ['9']=49,['0']=51,         ['=']=54,['backspace']=56,
            ['q']=36,['w']=38,['e']=40,['r']=41,['t']=43,['y']=45,['u']=47,['i']=48,['o']=50,['p']=52,['[']=53,[']']=55,['\\']=57,
            ['s']=25,['d']=27,         ['g']=30,['h']=32,['j']=34,         ['l']=37,[';']=39,
            ['z']=24,['x']=26,['c']=28,['v']=29,['b']=31,['n']=33,['m']=35,[',']=36,['.']=38,['/']=40,
        },
    },
    {name="Simple-C",
        pos_x=-71.5,
        pos_y=-25,
        size=10,
        font=60,
        templates={
            {w=8,h=8,fillC='dL',lineC='DL',actvC='lG',textC='lD'}, -- Soprano
            {w=8,h=8,fillC='dL',lineC='DL',actvC='lY',textC='lD'}, -- Alto
            {w=8,h=8,fillC='dL',lineC='DL',actvC='lB',textC='lD'}, -- Tenor
            {w=8,h=8,fillC='dL',lineC='DL',actvC='lR',textC='lD'}, -- Bass
        },
        keyLayout={
            {1,x=0,y=0,w=143,h=50,fillC={1,1,1,.26},lineC='dL'}, -- Frame
            {1,x=005,y=05,key='1'}, -- Line 1
            {1,x=015,y=05,key='2'},
            {1,x=025,y=05,key='3'},
            {1,x=035,y=05,key='4'},
            {1,x=045,y=05,key='5'},
            {1,x=055,y=05,key='6'},
            {1,x=065,y=05,key='7'},
            {1,x=075,y=05,key='8'},
            {1,x=085,y=05,key='9'},
            {1,x=095,y=05,key='0'},
            {1,x=105,y=05,key='-'},
            {1,x=115,y=05,key='='},
            {1,x=125,y=05,w=13,key='backspace'},
            {2,x=010,y=15,key='q'}, -- Line 2
            {2,x=020,y=15,key='w'},
            {2,x=030,y=15,key='e'},
            {2,x=040,y=15,key='r'},
            {2,x=050,y=15,key='t'},
            {2,x=060,y=15,key='y'},
            {2,x=070,y=15,key='u'},
            {2,x=080,y=15,key='i'},
            {2,x=090,y=15,key='o'},
            {2,x=100,y=15,key='p'},
            {2,x=110,y=15,key='['},
            {2,x=120,y=15,key=']'},
            {2,x=130,y=15,key='\\'},
            {3,x=015,y=25,key='a'}, -- Line 3
            {3,x=025,y=25,key='s'},
            {3,x=035,y=25,key='d'},
            {3,x=045,y=25,key='f'},
            {3,x=055,y=25,key='g'},
            {3,x=065,y=25,key='h'},
            {3,x=075,y=25,key='j'},
            {3,x=085,y=25,key='k'},
            {3,x=095,y=25,key='l'},
            {3,x=105,y=25,key=';'},
            {3,x=115,y=25,key='\''},
            {3,x=125,y=25,w=13,key='return'},
            {4,x=020,y=35,key='z'}, -- Line 4
            {4,x=030,y=35,key='x'},
            {4,x=040,y=35,key='c'},
            {4,x=050,y=35,key='v'},
            {4,x=060,y=35,key='b'},
            {4,x=070,y=35,key='n'},
            {4,x=080,y=35,key='m'},
            {4,x=090,y=35,key=','},
            {4,x=100,y=35,key='.'},
            {4,x=110,y=35,key='/'},
        },
        keyMap={
            ['1']=60,['2']=62,['3']=64,['4']=65,['5']=67,['6']=69,['7']=71,['8']=72,['9']=74,['0']=76,['-']=77,['=']=79,['backspace']=81,
            ['q']=48,['w']=50,['e']=52,['r']=53,['t']=55,['y']=57,['u']=59,['i']=60,['o']=62,['p']=64,['[']=65,[']']=67,['\\']=69,
            ['a']=36,['s']=38,['d']=40,['f']=41,['g']=43,['h']=45,['j']=47,['k']=48,['l']=50,[';']=52,["'"]=50,['return']=55,
            ['z']=24,['x']=26,['c']=28,['v']=29,['b']=31,['n']=33,['m']=35,[',']=36,['.']=38,['/']=40,
        },
    },
    {name="Piano (Class-C)",
        pos_x=-80/2,
        pos_y=5,
        size=16,
        font=35,
        templates={
            {y=0,w=4,h=15,show='',fillC='L',lineC='LD',actvC='lI',_onPress=presets.synthNote.press,_onRelease=presets.synthNote.release,synthNoteWidth=30,synthNoteColor=COLOR.L}, -- White key
            {y=0,w=2.6,h=10,show='',fillC='lD',lineC='LD',actvC='LI',_onPress=presets.synthNote.press,_onRelease=presets.synthNote.release,synthNoteWidth=30,synthNoteColor=COLOR.DL}, -- Black key
            {y=11.5,w=3,h=3,fillC='X',lineC='X',textC='lD'}, -- Tag
        },
        keyLayout={
            {1,x=00*4,synthNotePos=-13,key='z'},{3,x=00*4+.5,show='Z'},
            {1,x=01*4,synthNotePos= 00,key='x'},
            {1,x=02*4,synthNotePos= 13,key='c'},
            {1,x=03*4,synthNotePos=-15,key='v'},
            {1,x=04*4,synthNotePos=-05,key='b'},{3,x=04*4+.5,show='B'},
            {1,x=05*4,synthNotePos= 05,key='n'},
            {1,x=06*4,synthNotePos= 15,key='m'},
            {1,x=07*4,synthNotePos=-13,key={',','q'}},{3,x=07*4+.5,show='Q'},
            {1,x=08*4,synthNotePos= 00,key={'.','w'}},
            {1,x=09*4,synthNotePos= 13,key={'/','e'}},
            {1,x=10*4,synthNotePos=-15,key='r'},
            {1,x=11*4,synthNotePos=-05,key='t'},{3,x=11*4+.5,show='T'},
            {1,x=12*4,synthNotePos= 05,key='y'},
            {1,x=13*4,synthNotePos= 15,key='u'},
            {1,x=14*4,synthNotePos=-13,key='i'},{3,x=14*4+.5,show='I'},
            {1,x=15*4,synthNotePos= 00,key='o'},
            {1,x=16*4,synthNotePos= 13,key='p'},
            {1,x=17*4,synthNotePos=-15,key='['},
            {1,x=18*4,synthNotePos=-05,key=']'},{3,x=18*4+.5,show=']'},
            {1,x=19*4,synthNotePos= 05,key='\\'},
            {2,x=2.7+00*4 -.3*1.5,key='s'},
            {2,x=2.7+01*4 +.3*1.5,key='d'},
            {2,x=2.7+03*4 -.4*1.5,key='g'},
            {2,x=2.7+04*4 +.0*1.5,key='h'},
            {2,x=2.7+05*4 +.4*1.5,key='j'},
            {2,x=2.7+07*4 -.3*1.5,key={'l','2'}},
            {2,x=2.7+08*4 +.3*1.5,key={';','3'}},
            {2,x=2.7+10*4 -.4*1.5,key='5'},
            {2,x=2.7+11*4 +.0*1.5,key='6'},
            {2,x=2.7+12*4 +.4*1.5,key='7'},
            {2,x=2.7+14*4 -.3*1.5,key='9'},
            {2,x=2.7+15*4 +.3*1.5,key='0'},
            {2,x=2.7+17*4 -.4*1.5,key='='},
            {2,x=2.7+18*4 +.0*1.5,key='backspace'},
            {2,x=2.7+19*4 +.4*1.5,w=.7,fillC='LD'},

        },
        keyMap={
            ['2']=37,['3']=39,         ['5']=42,['6']=44,['7']=46,         ['9']=49,['0']=51,         ['=']=54,['backspace']=56,
            ['q']=36,['w']=38,['e']=40,['r']=41,['t']=43,['y']=45,['u']=47,['i']=48,['o']=50,['p']=52,['[']=53,[']']=55,['\\']=57,
            ['s']=25,['d']=27,         ['g']=30,['h']=32,['j']=34,         ['l']=37,[';']=39,
            ['z']=24,['x']=26,['c']=28,['v']=29,['b']=31,['n']=33,['m']=35,[',']=36,['.']=38,['/']=40,
        },
    },
    {name="Piano (Full)",
        pos_x=-96/2-1,
        pos_y=5,
        size=16,
        font=35,
        templates={
            {y=0,w=4,h=15,show='',fillC='L',lineC='LD',actvC='lI',_onPress=presets.synthNote.press,_onRelease=presets.synthNote.release,synthNoteWidth=30,synthNoteColor=COLOR.L}, -- White key
            {y=0,w=2.6,h=10,show='',fillC='lD',lineC='LD',actvC='LI',_onPress=presets.synthNote.press,_onRelease=presets.synthNote.release,synthNoteWidth=30,synthNoteColor=COLOR.DL}, -- Black key
            {y=11.5,w=3,h=3,fillC='X',lineC='X',textC='lD'}, -- Tag
        },
        keyLayout={
            {1,x=.5*4,w=2,fillC='LD'},
            {1,x=01*4,synthNotePos=-05,key='z'},{3,x=01*4+.5,show='Z'},
            {1,x=02*4,synthNotePos= 05,key='x'},
            {1,x=03*4,synthNotePos= 15,key='c'},
            {1,x=04*4,synthNotePos=-13,key='v'},{3,x=04*4+.5,show='V'},
            {1,x=05*4,synthNotePos= 00,key='b'},
            {1,x=06*4,synthNotePos= 13,key='n'},
            {1,x=07*4,synthNotePos=-15,key='m'},
            {1,x=08*4,synthNotePos=-05,key=','},{3,x=08*4+.5,show='<'},
            {1,x=09*4,synthNotePos= 05,key='.'},
            {1,x=10*4,synthNotePos= 15,key={'/','1'}},
            {1,x=11*4,synthNotePos=-13,key={'q','\''}},{3,x=11*4+.5,show='Q'},
            {1,x=12*4,synthNotePos= 00,key='w'},
            {1,x=13*4,synthNotePos= 13,key='e'},
            {1,x=14*4,synthNotePos=-15,key='r'},
            {1,x=15*4,synthNotePos=-05,key='t'},{3,x=15*4+.5,show='T'},
            {1,x=16*4,synthNotePos= 05,key='y'},
            {1,x=17*4,synthNotePos= 15,key='u'},
            {1,x=18*4,synthNotePos=-13,key='i'},{3,x=18*4+.5,show='I'},
            {1,x=19*4,synthNotePos= 00,key='o'},
            {1,x=20*4,synthNotePos= 13,key='p'},
            {1,x=21*4,synthNotePos=-15,key='['},
            {1,x=22*4,synthNotePos=-05,key=']'},{3,x=22*4+.5,show=']'},
            {1,x=23*4,synthNotePos= 05,key='\\'},
            {2,x=2.7+01*4 +.0*1.5,key='s'},
            {2,x=2.7+00*4 -.4*1.5,key='a'},
            {2,x=2.7+02*4 +.4*1.5,key='d'},
            {2,x=2.7+04*4 -.3*1.5,key='g'},
            {2,x=2.7+05*4 +.3*1.5,key='h'},
            {2,x=2.7+07*4 -.4*1.5,key='k'},
            {2,x=2.7+08*4 +.0*1.5,key='l'},
            {2,x=2.7+09*4 +.4*1.5,key=';'},
            {2,x=2.7+11*4 -.3*1.5,key='2'},
            {2,x=2.7+12*4 +.3*1.5,key='3'},
            {2,x=2.7+14*4 -.4*1.5,key='5'},
            {2,x=2.7+15*4 +.0*1.5,key='6'},
            {2,x=2.7+16*4 +.4*1.5,key='7'},
            {2,x=2.7+18*4 -.3*1.5,key='9'},
            {2,x=2.7+19*4 +.3*1.5,key='0'},
            {2,x=2.7+21*4 -.4*1.5,key='='},
            {2,x=2.7+22*4 +.0*1.5,key='backspace'},
            {2,x=2.7+23*4 +.0*1.5,w=1.3,fillC='LD'},
        },
        keyMap={
            ['1']=35,['2']=37,['3']=39,         ['5']=42,['6']=44,['7']=46,         ['9']=49,['0']=51,         ['=']=54,['backspace']=56,
            ['q']=36,['w']=38,['e']=40,['r']=41,['t']=43,['y']=45,['u']=47,['i']=48,['o']=50,['p']=52,['[']=53,[']']=55,['\\']=57,
            ['a']=18,['s']=20,['d']=22,         ['g']=25,['h']=27,         ['k']=30,['l']=32,[';']=34,['\'']=36,
            ['z']=19,['x']=21,['c']=23,['v']=24,['b']=26,['n']=28,['m']=29,[',']=31,['.']=33,['/']=35,
        },
    },
    {name="Melodic Phone Keypad (on C)",
        pos_x=-28/2,
        pos_y=-38/2,
        size=18,
        font=100,
        templates={
            {w=8,h=8,fillC='dL',lineC='lD',actvC="LD",textC='D'},
        },
        keyLayout={
            {1,x=-2,y=-2,w=32,h=42,fillC={1,1,1,.26},lineC='dL'}, -- Frame
            {1,x=00,y=00,key='kp7'},
            {1,x=10,y=00,key='kp8'},
            {1,x=20,y=00,key='kp9'},
            {1,x=00,y=10,key='kp4'},
            {1,x=10,y=10,key='kp5'},
            {1,x=20,y=10,key='kp6'},
            {1,x=00,y=20,key='kp1'},
            {1,x=10,y=20,key='kp2'},
            {1,x=20,y=20,key='kp3'},
            {1,x=00,y=30,key='kp0'},
            {1,x=10,y=30,key='kp.'},
            {1,x=20,y=30,key='kpenter'},
        },
        keyMap={
            ['kp7']=48,['kp8']=50,['kp9']=52,
            ['kp4']=53,['kp5']=55,['kp6']=57,
            ['kp1']=59,['kp2']=60,['kp3']=62,
            ['kp0']=64,['kp.']=65,['kpenter']=67,
        },
    },
}
local defaultKeyName={
    ['=']='+',['backspace']=CHAR.key.backspace,
    ['\\']='|',
    ['\'']='"',['return']=CHAR.key.returnKey,
    [',']='<',['.']='>',['/']='?',
    ['kp0']='⓪',['kp.']='.',
    ['kp1']='①',['kp2']='②',['kp3']='③',
    ['kp4']='④',['kp5']='⑤',['kp6']='⑥',
    ['kp7']='⑦',['kp8']='⑧',['kp9']='⑨',
    ['kp/']='⊘',['kp*']='⊛',
    ['kp-']='⊖',['kp+']='⊕',
    ['kpenter']=CHAR.key.returnKey,
}
local function checkColor(input)
    if type(input)=='string' then input=COLOR[input] end
    assert(type(input)=='table',"input should be an exist 'color string' or {R,G,B}, but got "..tostring(input))
    return input
end
for _,layout in next,layoutList do
    for _,key in ipairs(layout.keyLayout) do
        if key[1] and layout.templates[key[1]] then
            TABLE.updateMissing(key,layout.templates[key[1]])
        end
        key.x=(key.x+layout.pos_x)*layout.size
        key.y=(key.y+layout.pos_y)*layout.size
        key.w=key.w*layout.size
        key.h=key.h*layout.size
        if not key.show then
            if key.key then
                key.show=defaultKeyName[key.key] or (key.key:upper():sub(1,2))
            else
                key.show=''
            end
        end
        key.fillC=checkColor(key.fillC or COLOR.M)
        key.lineC=checkColor(key.lineC or COLOR.M)
        key.actvC=checkColor(key.actvC or COLOR.M)
        key.textC=checkColor(key.textC or COLOR.M)

        key._pressed=false
        key._onPress=key._onPress or NULL
        key._onRelease=key._onRelease or NULL
    end
end
local layout=layoutList[1]

---@type Zenitha.Scene
local scene={}

function scene.load()
    for _,effect in next,activeEventMap do effect:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT) end
    TABLE.clearAll(activeEventMap)
    TABLE.clearAll(objPool)
    stopBgm()
    inst='square_wave'
    offset=0
    release=500
end

scene.unload=scene.load

function scene.touchDown(x,y,k)
    -- TODO
end
scene.mouseDown=scene.touchDown

local _param={
    tune=1,
    volume=1,
    param={'release',1},
}
function scene.keyDown(key,isRep,keyCode)
    if not isRep and layout.keyMap[keyCode] then
        local note=layout.keyMap[keyCode]+offset
        if isShiftDown() then note=note+1 end
        if isCtrlDown() then note=note-1 end
        _param.tune=note-26
        _param.volume=1
        _param.param[2]=release*1.0594630943592953^(note-26)
        activeEventMap[keyCode]=FMOD.effect(inst,_param)
    elseif key=='tab' then
        inst=TABLE.next(instList,inst) or instList[1]
    elseif key=='lalt' then
        local d=0
        if isShiftDown() then d=d+12 end
        if isCtrlDown() then d=d-12 end
        if d==0 then
            offset=MATH.clamp(offset-1,-12,24)
        else
            offset=MATH.clamp(offset+d,-12,24)
        end
    elseif key=='ralt' then
        local d=0
        if isShiftDown() then d=d+12 end
        if isCtrlDown() then d=d-12 end
        if d==0 then
            offset=MATH.clamp(offset+1,-12,24)
        else
            offset=MATH.clamp(offset+d,-12,24)
        end
    elseif key=='f1' then
        layout=layoutList[(TABLE.find(layoutList,layout)-2)%#layoutList+1]
    elseif key=='f2' then
        layout=layoutList[TABLE.find(layoutList,layout)%#layoutList+1]
    elseif key=='f3' then
        release=math.max(release-100,0)
    elseif key=='f4' then
        release=math.min(release+100,2600)
    elseif key=='escape' then
        if sureCheck('back') then SCN.back() end
    end
    return true
end
function scene.keyUp(_,keyCode)
    if layout.keyMap[keyCode] and activeEventMap[keyCode] then
        activeEventMap[keyCode]:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT)
        activeEventMap[keyCode]=nil
    end
end

local isSCDown=isSCDown
function scene.update(dt)
    local L=layout.keyLayout
    for i=1,#L do
        local key=L[i]
        local keyList=key.key
        local keyPressed=false
        if keyList then
            if type(keyList)=='string' then
                keyPressed=isSCDown(keyList)
            else
                keyPressed=isSCDown(unpack(keyList))
            end
        end
        if key._pressed~=keyPressed then
            key._pressed=keyPressed
            key[keyPressed and '_onPress' or '_onRelease'](key)
        end
    end
    for i=#objPool,1,-1 do
        if objPool[i]:_update(dt) then
            rem(objPool,i)
        end
    end
end

function scene.draw()
    setFont(30)
    gc.print(layout.name,40,40)
    gc.print(inst,40,80)
    gc.print(offset,40,120)
    gc.print(release,40,160)
    gc.replaceTransform(SCR.xOy_m)

    for i=1,#objPool do
        objPool[i]:_draw()
    end

    gc.setLineWidth(4)
    local L=layout.keyLayout
    for i=1,#L do
        local key=L[i]
        if key._pressed then
            gc_setColor(key.actvC)
            gc_rect('fill',key.x,key.y,key.w,key.h)
        else
            gc_setColor(key.fillC)
            gc_rect('fill',key.x,key.y,key.w,key.h)
            gc_setColor(key.lineC)
            gc_rect('line',key.x+2,key.y+2,key.w-4,key.h-4)
        end
    end
    setFont(layout.font)
    for i=1,#L do
        local key=L[i]
        gc_setColor(key.textC)
        gc_mStr(key.show,key.x+key.w/2,key.y)
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
