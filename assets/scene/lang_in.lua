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

local scene={}

function scene.leave()
    saveSettings()
end

function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
    else
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

local function _setLang(lid)
    SETTINGS.system.locale=lid
    TEXT:clear()
    TEXT:add{
        text=langList[lid],
        x=800,y=500,
        fontSize=100,
        style='appear',
        duration=1,inPoint=0,outPoint=0,
    }
    WIDGET._reset()
end

scene.widgetList={
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    {type='button',         x=350,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.en, color='R', sound_trigger='check_on',code=function() _setLang('en') end},
    {type='button_fill',    x=350,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='F'},
    {type='button_fill',    x=350,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          color='K'},
    {type='button_fill',    x=350,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          color='G'},

    {type='button_fill',    x=800,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='O'},
    {type='button_fill',    x=800,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='A'},
    {type='button_fill',    x=800,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='J'},
    {type='button_fill',    x=800,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='P'},

    {type='button',         x=1250,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text=langList.zh, color='Y', sound_trigger='check_on',code=function() _setLang('zh') end},
    {type='button_fill',    x=1250,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='I'},
    {type='button_fill',    x=1250,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='B'},
    {type='button_fill',    x=1250,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='V'},
}

return scene
