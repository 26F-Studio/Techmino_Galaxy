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

local jaClickCount

---@type Zenitha.Scene
local scene={}

function scene.load()
    changed=false
    jaClickCount=0
end

function scene.unload()
    if changed and SCN.stackChange<0 then
        SaveSettings()
    end
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('none') end end
function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
        return true
    end
end

function scene.update(dt)
    curLang=curLang+dt*1.26
    if curLang>=#languages+1 then
        curLang=1
    end
end

function scene.draw()
    FONT.set(80)
    GC.setColor(1,1,1)
    GC.mStr(languages[curLang-curLang%1],800,60)
end

function scene.overDraw()
    -- Glitch effect after III
    if PROGRESS.get('main')>=3 then
        DrawGlitch()
    end
end

local function _setLang(lid)
    if lid=='ja' then jaClickCount=jaClickCount+1 end
    if jaClickCount>=26 then
        PROGRESS.setSecret('language_japanese')
        SCN.go('goyin')
    else
        TEXT:clear()
        TEXT:add{
            text=langList[lid],
            x=800,y=500,k=2,
            fontSize=50,
            style='appear',
            duration=1,inPoint=0,outPoint=0,
        }
        if SETTINGS.system.locale~=lid then
            SETTINGS.system.locale=lid
            changed=true
            WIDGET._reset()
        end
    end
end

scene.widgetList={
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_release='button_back',fontSize=60,text=CHAR.icon.back,onClick=WIDGET.c_backScn('none')},

    {type='button_fill', x=350,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.en, fillColor='R', sound_release='check_on',onClick=function() _setLang('en') end},
    {type='button_fill', x=350,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.eo, fillColor='F', sound_release='check_on',onClick=function() _setLang('eo') end},
    {type='button',      x=350,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          fillColor='K'},
    {type='button',      x=350,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          fillColor='G'},

    {type='button_fill', x=800,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.it, fillColor='O', sound_release='check_on',onClick=function() _setLang('it') end},
    {type='button_fill', x=800,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.vi, fillColor='A', sound_release='check_on',onClick=function() _setLang('vi') end},
    {type='button',      x=800,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          fillColor='J'},
    {type='button',      x=800,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          fillColor='P'},

    {type='button_fill', x=1250,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text=langList.zh, fillColor='Y', sound_release='check_on',onClick=function() _setLang('zh') end},
    {type='button',      x=1250,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          fillColor='I'},
    {type='button',      x=1250,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          fillColor='B'},
    {type='button',      x=1250,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          fillColor='V'},
}

return scene
