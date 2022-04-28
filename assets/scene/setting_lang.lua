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

function scene.update(dt)
    curLang=curLang+dt*1.26
    if curLang>=#languages+1 then
        curLang=1
    end
end

function scene.draw()
    FONT.set(80)
    love.graphics.setColor(1,1,1,1-curLang%1*2)
    GC.mStr(languages[curLang-curLang%1],800,60)
    love.graphics.setColor(1,1,1,curLang%1*2)
    GC.mStr(languages[curLang-curLang%1+1] or languages[1],800,60)
end

local function _setLang(lid)
    SETTINGS.system.locale=lid
    TEXT:clear()
    TEXT:add{
        text=langList[lid],
        x=800,
        y=500,
        fontSize=100,
        style='appear',
        duration=1.6,
    }
    collectgarbage()
    WIDGET.resize()
end

scene.widgetList={
    WIDGET.new{type='button_fill',x=350,y=310,w=390,h=100,fontSize=40, text=langList.en, color='R', sound='check',code=function() _setLang('en') end},
    WIDGET.new{type='button'     ,x=350,y=460,w=390,h=100,fontSize=40, text='',          color='F', sound='check'},
    WIDGET.new{type='button'     ,x=350,y=610,w=390,h=100,fontSize=35, text='',          color='O', sound='check'},
    WIDGET.new{type='button'     ,x=350,y=760,w=390,h=100,fontSize=35, text='',          color='Y', sound='check'},

    WIDGET.new{type='button'     ,x=800,y=310,w=390,h=100,fontSize=40, text='',          color='A', sound='check'},
    WIDGET.new{type='button'     ,x=800,y=460,w=390,h=100,fontSize=40, text='',          color='K', sound='check'},
    WIDGET.new{type='button'     ,x=800,y=610,w=390,h=100,fontSize=40, text='',          color='G', sound='check'},
    WIDGET.new{type='button'     ,x=800,y=760,w=390,h=100,fontSize=40, text='',          color='J', sound='check'},

    WIDGET.new{type='button_fill',x=1250,y=310,w=390,h=100,fontSize=40,text=langList.zh, color='I', sound='check',code=function() _setLang('zh') end},
    WIDGET.new{type='button'     ,x=1250,y=460,w=390,h=100,fontSize=40,text='',          color='B', sound='check'},
    WIDGET.new{type='button'     ,x=1250,y=610,w=390,h=100,fontSize=40,text='',          color='P', sound='check'},

    WIDGET.new{type='button_fill',x=1250,y=760,w=390,h=100,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}

return scene
