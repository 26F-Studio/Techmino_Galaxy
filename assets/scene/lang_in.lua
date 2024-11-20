local langList={
    zh="简体中文",
    zh_trad="繁體中文",
    en="English",
    it="Italiano",
    fr="Français",
    es="　Español\n(Castellano)",
    pt="Português",
    id="Bahasa Indonesia",
    ja="日本語",
    eo="Esperanto"
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
        saveSettings()
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
        drawGlitch()
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
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    {type='button',         x=350,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.en, color='R', sound_trigger='check_on',code=function() _setLang('en') end},
    {type='button',         x=350,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.eo, color='F', sound_trigger='check_on',code=function() _setLang('eo') end},
    {type='button_fill',    x=350,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          color='K'},
    {type='button_fill',    x=350,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=35, text='',          color='G'},

    {type='button',         x=800,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text=langList.it, color='O', sound_trigger='check_on',code=function() _setLang('it') end},
    {type='button_fill',    x=800,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='A'},
    {type='button_fill',    x=800,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='J'},
    {type='button_fill',    x=800,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40, text='',          color='P'},

    {type='button',         x=1250,y=310,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text=langList.zh, color='Y', sound_trigger='check_on',code=function() _setLang('zh') end},
    {type='button_fill',    x=1250,y=460,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='I'},
    {type='button_fill',    x=1250,y=610,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='B'},
    {type='button_fill',    x=1250,y=760,w=390,h=100,lineWidth=4,cornerR=0,fontSize=40,text='',          color='V'},
}

return scene
