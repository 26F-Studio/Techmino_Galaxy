local langList={
    zh="简体中文",
    zh_trad="繁體中文",
    en="English",
    eo="Esperanto",
    it="Italiano",
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

local rec,recTimer
local dialMode,transTimer
local mode,instrument,octave_plus

local jaClickCount
local hasMessage

---@type Zenitha.Scene
local scene={}

local dialModeData={
    normal={
        ['1']={text=langList.en},
        ['2']={text=langList.it},
        ['3']={text=langList.zh},
        ['4']={text=langList.eo},
        ['5']={text=langList.vi},
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
        ['1']={text='D' ,notes={{'F#3',1,355,2600},{'A3',1,355,2600},{'D4',1,355,2600}}},
        ['2']={text='C' ,notes={{'G3',1,355,2600},{'C4',1,355,2600},{'E4',1,355,2600}}},
        ['3']={text='A' ,notes={{'A3',1,355,2600},{'C#4',1,355,2600},{'E4',1,355,2600}}},
        ['4']={text='F' ,notes={{'F3',1,355,2600},{'A3',1,355,2600},{'C4',1,355,2600}}},
        ['5']={text='G' ,notes={{'G3',1,355,2600},{'B3',1,355,2600},{'D4',1,355,2600}}},
        ['6']={text='Am',notes={{'A3',1,355,2600},{'C4',1,355,2600},{'E4',1,355,2600}}},
        ['7']={text='Dm',notes={{'F3',1,355,2600},{'A3',1,355,2600},{'D4',1,355,2600}}},
        ['8']={text='Em',notes={{'G3',1,355,2600},{'B3',1,355,2600},{'E4',1,355,2600}}},
        ['9']={text='E' ,notes={{'G#3',1,355,2600},{'B3',1,355,2600},{'E4',1,355,2600}}},
        ['*']={text='Inst.'},
        ['0']={text='8va'},
        ['#']={text='Notes'},
    },
    simple={
        ['1']={text='F3',notes={{'F3',1,260,1260}}},
        ['2']={text='G3',notes={{'G3',1,260,1260}}},
        ['3']={text='A3',notes={{'A3',1,260,1260}}},
        ['4']={text='B3',notes={{'B3',1,260,1260}}},
        ['5']={text='C4',notes={{'C4',1,260,1260}}},
        ['6']={text='D4',notes={{'D4',1,260,1260}}},
        ['7']={text='E4',notes={{'E4',1,260,1260}}},
        ['8']={text='F4',notes={{'F4',1,260,1260}}},
        ['9']={text='G4',notes={{'G4',1,260,1260}}},
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
    '1379',
    '7126',
    '63232',
    '6323',
    '1155665',
    '1235789',
    '22884646',
}
local function dial(n)
    rec,recTimer=(rec..n):sub(-26),2.6
    if mode=='dial' then
        PlaySamp(instrument,unpack(dialModeData[mode][n].notes))
        for _,sequence in next,codes do
            if rec:find(sequence) then
                mode='chord'
                scene.widgetList.musicroom:setVisible(true)
                freshTexts()
                break
            end
        end
    else
        if n=='*' then
            instrument=TABLE.next(InstList,instrument) or InstList[1]
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
                PlaySamp(instrument,unpack(notes))
            else
                PlaySamp(instrument,unpack(dialModeData[mode][n].notes))
            end
        end
    end
end

function scene.load()
    rec,recTimer='',2.6
    if SCN.stackChange>0 then
        dialMode,transTimer=false,PROGRESS.getSecret('dial_enter') and 6.26 or 26
        mode,instrument,octave_plus='normal','complex',false
    end
    scene.widgetList.musicroom:setVisible(mode~='normal' and mode~='dial')
    BG.set('none')
    changed=false
    freshTexts()

    jaClickCount=0
    hasMessage=false
end
function scene.unload()
    if changed and SCN.stackChange<0 then
        SaveSettings()
    end
    if hasMessage then
        MSG.clear()
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
    if recTimer>0 then
        recTimer=recTimer-dt
        if recTimer<=0 then
            rec=''
        end
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    if IsCtrlDown() then
        FONT.set(100)
        GC.setColor(1,1,1,.626)
        GC.mStr(CHAR.icon.eye,love.mouse.getX(),love.mouse.getY()-64)
    end

    GC.replaceTransform(SCR.xOy_u)
    FONT.set(60)
    GC.setColor(1,1,1,1-curLang%1*2)
    GC.mStr(languages[curLang-curLang%1],0,20)
    GC.setColor(1,1,1,curLang%1*2)
    GC.mStr(languages[curLang-curLang%1+1] or languages[1],0,20)

    if recTimer>0 then
        FONT.set(50,'bold')
        GC.setColor(1,1,1,math.min(recTimer,1))
        GC.mStr(rec,0,155)
    end
    if octave_plus then
        GC.replaceTransform(SCR.xOy)
        GC.setColor(COLOR.LD)
        GC.setLineWidth(4)
        GC.mRect('fill',800,760,120,62,16)
    end
end

local function _setLang(lid)
    if lid=='ja' then jaClickCount=jaClickCount+1 end
    if jaClickCount>=26 then
        PROGRESS.setSecret('language_japanese')
        SCN.go('goyin')
    else
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
            if IsCtrlDown() then
                local oldText=TABLE.copyAll(Text)
                local oldLocale=SETTINGS.system.locale:upper()
                SETTINGS.system.locale=lid
                local newText=TABLE.copyAll(Text)
                local newLocale=SETTINGS.system.locale:upper()
                TABLE.flatten(oldText,6.26)
                TABLE.flatten(newText,6.26)
                local anyMissing
                for entry in next,newText do
                    if not oldText[entry] then
                        MSG.log('info',("[$1] missing '$2'"):repD(oldLocale,entry),26)
                        anyMissing=true
                    end
                end
                for entry in next,oldText do
                    if not newText[entry] then
                        MSG.log('info',("[$1] missing '$2'"):repD(newLocale,entry),26)
                        anyMissing=true
                    end
                end
                if anyMissing then
                    MSG.log('warn',"Some i18n strings missing",26)
                    hasMessage=true
                end
            else
                SETTINGS.system.locale=lid
            end
            changed=true
            WIDGET._reset()
        end
    end
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,fillColor='B',cornerR=15,sound_release='button_back',fontSize=40,text=BackText,onClick=WIDGET.c_backScn'fadeHeader'},
    {type='text',x=800,y=900,text=LANG'lang_note'},

    {type='button',name='dial_1',x=350 ,y=310,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LV',sound_release=false,onClick=function() if dialMode then dial('1') else _setLang('en') end end},
    {type='button',name='dial_2',x=800 ,y=310,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LP',sound_release=false,onClick=function() if dialMode then dial('2') else _setLang('it') end end},
    {type='button',name='dial_3',x=1250,y=310,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LG',sound_release=false,onClick=function() if dialMode then dial('3') else _setLang('zh') end end},
    {type='button',name='dial_4',x=350 ,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LB',sound_release=false,onClick=function() if dialMode then dial('4') else _setLang('eo') end end},
    {type='button',name='dial_5',x=800 ,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LJ',sound_release=false,onClick=function() if dialMode then dial('5') else _setLang('vi') end end},
    {type='button',name='dial_6',x=1250,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LK',sound_release=false,onClick=function() if dialMode then dial('6') else end end},
    {type='button',name='dial_7',x=350 ,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LI',sound_release=false,onClick=function() if dialMode then dial('7') else end end},
    {type='button',name='dial_8',x=800 ,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LA',sound_release=false,onClick=function() if dialMode then dial('8') else end end},
    {type='button',name='dial_9',x=1250,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LF',sound_release=false,onClick=function() if dialMode then dial('9') else end end},
    {type='button',name='dial_*',x=350, y=760,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LR',sound_release=false,onClick=function() if dialMode then dial('*') else end end},
    {type='button',name='dial_0',x=800, y=760,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LO',sound_release=false,onClick=function() if dialMode then dial('0') else end end},
    {type='button',name='dial_#',x=1250,y=760,w=390,h=100,cornerR=26,fontSize=40,text='',fontType='bold',color='LY',sound_release=false,onClick=function() if dialMode then dial('#') else end end},

    {type='button_invis',name='musicroom',pos={1,0},x=-200,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.music,sound_release='button_soft',onClick=WIDGET.c_goScn('musicroom','fadeHeader'),visibleFunc=NULL},
}

return scene
