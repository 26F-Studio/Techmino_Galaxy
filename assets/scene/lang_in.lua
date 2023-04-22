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
    "Language  Langue  Lingua",
    "语言  言語  언어",
    "Idioma  Línguas  Sprache",
    "Язык  Γλώσσα  Bahasa",
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
    collectgarbage()
    WIDGET._reset()
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    WIDGET.new{type='button',         x=350,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.en, color='R', sound='check_on',code=function() _setLang('en') end},
    WIDGET.new{type='button_fill',    x=350,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='F'},
    WIDGET.new{type='button_fill',    x=350,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          color='K'},
    WIDGET.new{type='button_fill',    x=350,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          color='G'},

    WIDGET.new{type='button_fill',    x=800,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='O'},
    WIDGET.new{type='button_fill',    x=800,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='A'},
    WIDGET.new{type='button_fill',    x=800,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='J'},
    WIDGET.new{type='button_fill',    x=800,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='P'},

    WIDGET.new{type='button',         x=1250,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text=langList.zh, color='Y', sound='check_on',code=function() _setLang('zh') end},
    WIDGET.new{type='button_fill',    x=1250,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='I'},
    WIDGET.new{type='button_fill',    x=1250,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='B'},
    WIDGET.new{type='button_fill',    x=1250,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='V'},
}

return scene
