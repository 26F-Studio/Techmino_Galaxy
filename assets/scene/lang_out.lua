local langList={
    zh="简体中文",
    zh_trad="繁體中文",
    en="English",
    fr="Français",
    es="　Español\n(Castellano)",
    pt="Português",
    id="Bahasa Indonesia",
    ja="日本語",
    vi="Tiếng Việt",
}
local languages={
    "Language  语言  Idioma",
    "Luḡa  Bahasa  Ngôn Ngữ",
    "言語  언어  Linguagem",
    "Langue  Язык  Spache",
}
local curLang=1
local changed

local rec
local dialMode,transTimer
local mode,instrument,octave_plus

---@type Zenitha.Scene
local scene={}

local dialModeData={
    normal={
        ['1']={text=langList.en},
        ['2']={text=langList.vi},
        ['3']={text=langList.zh},
        ['4']={text=''},
        ['5']={text=''},
        ['6']={text=''},
        ['7']={text=''},
        ['8']={text=''},
        ['9']={text=''},
        ['*']={text=''},
        ['0']={text=''},
        ['#']={text=''},
    },
    dial={
        ['1']={text='1',notes={{-697/220,1,160,62},{-1209/220,1,160,62}}},
        ['2']={text='2',notes={{-697/220,1,160,62},{-1336/220,1,160,62}}},
        ['3']={text='3',notes={{-697/220,1,160,62},{-1477/220,1,160,62}}},
        ['4']={text='4',notes={{-770/220,1,160,62},{-1209/220,1,160,62}}},
        ['5']={text='5',notes={{-770/220,1,160,62},{-1336/220,1,160,62}}},
        ['6']={text='6',notes={{-770/220,1,160,62},{-1477/220,1,160,62}}},
        ['7']={text='7',notes={{-850/220,1,160,62},{-1209/220,1,160,62}}},
        ['8']={text='8',notes={{-850/220,1,160,62},{-1336/220,1,160,62}}},
        ['9']={text='9',notes={{-850/220,1,160,62},{-1477/220,1,160,62}}},
        ['*']={text='*',notes={{-941/220,1,160,62},{-1209/220,1,160,62}}},
        ['0']={text='0',notes={{-941/220,1,160,62},{-1336/220,1,160,62}}},
        ['#']={text='#',notes={{-941/220,1,160,62},{-1477/220,1,160,62}}},
    },
    chord={
        ['1']={text='D' ,notes={{'F#4',1,355,2600},{'A4',1,355,2600},{'D5',1,355,2600}}},
        ['2']={text='C' ,notes={{'G4',1,355,2600},{'C5',1,355,2600},{'E5',1,355,2600}}},
        ['3']={text='A' ,notes={{'A4',1,355,2600},{'C#5',1,355,2600},{'E5',1,355,2600}}},
        ['4']={text='F' ,notes={{'F4',1,355,2600},{'A4',1,355,2600},{'C5',1,355,2600}}},
        ['5']={text='G' ,notes={{'G4',1,355,2600},{'B4',1,355,2600},{'D5',1,355,2600}}},
        ['6']={text='Am',notes={{'A4',1,355,2600},{'C5',1,355,2600},{'E5',1,355,2600}}},
        ['7']={text='Dm',notes={{'F4',1,355,2600},{'A4',1,355,2600},{'D5',1,355,2600}}},
        ['8']={text='Em',notes={{'G4',1,355,2600},{'B4',1,355,2600},{'E5',1,355,2600}}},
        ['9']={text='E' ,notes={{'G#4',1,355,2600},{'B4',1,355,2600},{'E5',1,355,2600}}},
        ['*']={text='Inst.'},
        ['0']={text='8va'},
        ['#']={text='Notes'},
    },
    simple={
        ['1']={text='F4',notes={{'F4',1,260,1260}}},
        ['2']={text='G4',notes={{'G4',1,260,1260}}},
        ['3']={text='A4',notes={{'A4',1,260,1260}}},
        ['4']={text='B4',notes={{'B4',1,260,1260}}},
        ['5']={text='C5',notes={{'C5',1,260,1260}}},
        ['6']={text='D5',notes={{'D5',1,260,1260}}},
        ['7']={text='E5',notes={{'E5',1,260,1260}}},
        ['8']={text='F5',notes={{'F5',1,260,1260}}},
        ['9']={text='G5',notes={{'G5',1,260,1260}}},
        ['*']={text='Inst.'},
        ['0']={text='8va'},
        ['#']={text='Chords'},
    },
}

local function freshTexts()
    for _,W in next,scene.widgetList do
        if W.name and W.name:sub(1,4)=='dial' and dialModeData[mode][W.name:sub(6)] then
            W.text=dialModeData[mode][W.name:sub(6)].text
            W:reset()
        end
    end
end

local codes={
    '7126',
    '63232',
    '1155665',
    '1235789',
}
local function dial(n)
    rec=(rec..n):sub(-26)
    if mode=='dial' then
        playSample(instrument,unpack(dialModeData[mode][n].notes))
        for _,sequence in next,codes do
            if rec:find(sequence) then
                PROGRESS.setSecret('dial_password')
                mode='chord'
                scene.widgetList.musicroom:setVisible(true)
                freshTexts()
                break
            end
        end
    else
        if n=='*' then
            instrument=TABLE.next({'square','sine','triangle'},instrument) or 'square'
        elseif n=='0' then
            octave_plus=not octave_plus
        elseif n=='#' then
            mode=TABLE.next({'chord','simple'},mode) or 'chord'
            freshTexts()
        else
            if octave_plus then
                local notes=TABLE.copy(dialModeData[mode][n].notes)
                for i=1,#notes do
                    notes[i][1]=notes[i][1]:sub(1,-2)..(notes[i][1]:sub(-1)+1)
                end
                playSample(instrument,unpack(notes))
            else
                playSample(instrument,unpack(dialModeData[mode][n].notes))
            end
        end
    end
end

function scene.load()
    rec=''
    if SCN.stackChange>0 then
        dialMode,transTimer=false,PROGRESS.getSecret('dial_enter') and 6.26 or 26
        mode,instrument,octave_plus='normal','square',false
    end
    scene.widgetList.musicroom:setVisible(mode~='normal' and mode~='dial')
    BG.set('none')
    changed=false
    freshTexts()
end
function scene.unload()
    if changed and SCN.stackChange<0 then
        saveSettings()
    end
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('fadeHeader') end end
function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back()
        return true
    end
end

function scene.update(dt)
    curLang=curLang+dt*1.26
    if curLang>=#languages+1 then
        curLang=1
    end
    if transTimer then
        transTimer=transTimer-dt
        if transTimer<=0 then
            dialMode,transTimer=true,false
            mode='dial'
            freshTexts()
            PROGRESS.setSecret('dial_enter')
        end
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy_u)
    FONT.set(60)
    GC.setColor(1,1,1,1-curLang%1*2)
    GC.mStr(languages[curLang-curLang%1],0,20)
    GC.setColor(1,1,1,curLang%1*2)
    GC.mStr(languages[curLang-curLang%1+1] or languages[1],0,20)

    if octave_plus then
        GC.replaceTransform(SCR.xOy)
        GC.setColor(COLOR.LD)
        GC.setLineWidth(4)
        GC.mRect('fill',800,760,120,62,16)
    end
end

local function _setLang(lid)
    if transTimer then transTimer=26 end
    SFX.play('check_on')
    TEXT:clear()
    TEXT:add{
        text=langList[lid],
        x=800,y=500,a=.626,k=2,
        fontSize=50,
        style='zoomout',
        duration=1.26,
    }
    if SETTINGS.system.locale~=lid then
        SETTINGS.system.locale=lid
        changed=true
        WIDGET._reset()
    end
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    {type='text',x=800,y=900,fontSize=30,text=LANG'lang_note'},

    {type='button',    name='dial_1',x=350 ,y=310,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LV',sound_trigger=false,code=function() if dialMode then dial('1') else _setLang('en') end end},
    {type='button',    name='dial_2',x=800 ,y=310,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LP',sound_trigger=false,code=function() if dialMode then dial('2') else _setLang('vi') end end},
    {type='button',    name='dial_3',x=1250,y=310,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LG',sound_trigger=false,code=function() if dialMode then dial('3') else _setLang('zh') end end},
    {type='button',    name='dial_4',x=350 ,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LB',sound_trigger=false,code=function() if dialMode then dial('4') else end end},
    {type='button',    name='dial_5',x=800 ,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LJ',sound_trigger=false,code=function() if dialMode then dial('5') else end end},
    {type='button',    name='dial_6',x=1250,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LK',sound_trigger=false,code=function() if dialMode then dial('6') else end end},
    {type='button',    name='dial_7',x=350 ,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LI',sound_trigger=false,code=function() if dialMode then dial('7') else end end},
    {type='button',    name='dial_8',x=800 ,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LA',sound_trigger=false,code=function() if dialMode then dial('8') else end end},
    {type='button',    name='dial_9',x=1250,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LF',sound_trigger=false,code=function() if dialMode then dial('9') else end end},
    {type='button',    name='dial_*',x=350, y=760,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LR',sound_trigger=false,code=function() if dialMode then dial('*') else end end},
    {type='button',    name='dial_0',x=800, y=760,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LO',sound_trigger=false,code=function() if dialMode then dial('0') else end end},
    {type='button',    name='dial_#',x=1250,y=760,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LY',sound_trigger=false,code=function() if dialMode then dial('#') else end end},

    {type='button_invis',name='musicroom',pos={1,0},x=-200,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.music,sound_trigger='button_soft',code=WIDGET.c_goScn('musicroom','fadeHeader'),visibleFunc=NULL},
}

return scene
