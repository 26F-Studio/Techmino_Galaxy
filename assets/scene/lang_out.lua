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

function scene.enter()
    BG.set('none')
end
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
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy_u)
    FONT.set(60)
    love.graphics.setColor(1,1,1,1-curLang%1*2)
    GC.mStr(languages[curLang-curLang%1],0,20)
    love.graphics.setColor(1,1,1,curLang%1*2)
    GC.mStr(languages[curLang-curLang%1+1] or languages[1],0,20)
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
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},

    WIDGET.new{type='button',         x=350,y=310,w=390,h=100,cornerR=26,fontSize=40, text=langList.en, color='LR', sound='check',code=function() _setLang('en') end},
    WIDGET.new{type='button_fill',    x=350,y=460,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LF'},
    WIDGET.new{type='button_fill',    x=350,y=610,w=390,h=100,cornerR=26,fontSize=35, text='',          color='LO'},
    WIDGET.new{type='button_fill',    x=350,y=760,w=390,h=100,cornerR=26,fontSize=35, text='',          color='LY'},

    WIDGET.new{type='button_fill',    x=800,y=310,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LA'},
    WIDGET.new{type='button_fill',    x=800,y=460,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LK'},
    WIDGET.new{type='button_fill',    x=800,y=610,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LG'},
    WIDGET.new{type='button_fill',    x=800,y=760,w=390,h=100,cornerR=26,fontSize=40, text='',          color='LJ'},

    WIDGET.new{type='button',         x=1250,y=310,w=390,h=100,cornerR=26,fontSize=40,text=langList.zh, color='LI', sound='check',code=function() _setLang('zh') end},
    WIDGET.new{type='button_fill',    x=1250,y=460,w=390,h=100,cornerR=26,fontSize=40,text='',          color='LB'},
    WIDGET.new{type='button_fill',    x=1250,y=610,w=390,h=100,cornerR=26,fontSize=40,text='',          color='LP'},
    WIDGET.new{type='button_fill',    x=1250,y=760,w=390,h=100,cornerR=26,fontSize=40,text='',          color='LV'},
}

return scene
