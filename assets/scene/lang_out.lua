local langList={
    zh="简体中文",
    zh_trad="繁體中文",
    en="English",
    fr="Français",
    es="　Español\n(Castellano)",
    pt="Português",
    id="Bahasa Indonesia",
    ja="日本語",
}
local languages={
    "Language  语言  Idioma",
    "Luḡa  Bahasa  Ngôn Ngữ",
    "言語  언어  Linguagem",
    "Langue  Язык  Spache",
}
local curLang=1
local changed

---@type Zenitha.Scene
local scene={}

function scene.load()
    BG.set('none')
    changed=false
end
function scene.unload()
    if changed then
        saveSettings()
    end
end

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
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy_u)
    FONT.set(60)
    GC.setColor(1,1,1,1-curLang%1*2)
    GC.mStr(languages[curLang-curLang%1],0,20)
    GC.setColor(1,1,1,curLang%1*2)
    GC.mStr(languages[curLang-curLang%1+1] or languages[1],0,20)
end

local function _setLang(lid)
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
    {type='text',           x=800,y=900,fontSize=30, text=LANG'lang_note'},

    {type='button',         x=350,y=310,w=390,h=100,cornerR=26,fontSize=40, text=langList.en, color='LY', sound_trigger='check_on',code=function() _setLang('en') end},
    {type='button_fill',    x=350,y=460,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LI'},
    {type='button_fill',    x=350,y=610,w=390,h=100,cornerR=26,fontSize=35, text='',          color='LB'},
    {type='button_fill',    x=350,y=760,w=390,h=100,cornerR=26,fontSize=35, text='',          color='LV'},

    {type='button_fill',    x=800,y=310,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LO'},
    {type='button_fill',    x=800,y=460,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LA'},
    {type='button_fill',    x=800,y=610,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LJ'},
    {type='button_fill',    x=800,y=760,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LP'},

    {type='button',         x=1250,y=310,w=390,h=100,cornerR=26,fontSize=40,text=langList.zh, color='LR', sound_trigger='check_on',code=function() _setLang('zh') end},
    {type='button_fill',    x=1250,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',          color='LF'},
    {type='button_fill',    x=1250,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',          color='LK'},
    {type='button_fill',    x=1250,y=760,w=390,h=100,cornerR=26,fontSize=40,text='',          color='LG'},
}

return scene
