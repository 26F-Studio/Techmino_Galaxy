---@type Zenitha.Scene
local scene={}

local textOffset=6
local versionText=GC.newText(FONT.get(35,'bold'))
local terminalName=GC.newText(FONT.get(35))
versionText:set(VERSION.appVer)
terminalName:set(("TERM[%s]"):format(SYSTEM:sub(1,3):upper()))

local secretString="techmino"
local secretInput=0

function scene.load()
    PROGRESS.applyEnv('exterior')
    secretInput=0
end

local function sysAction(action)
    if action=='help' then
        CallDict('aboutDict')
        PROGRESS.setSecret('dict_shortcut')
    elseif action=='setting' then
        SCN.go('setting_out','fadeHeader')
    elseif action=='back' then
        if SureCheck('quit') then PROGRESS.quit() end
    end
end
function scene.keyDown(key,isRep)
    -- Debug
    if     key=='1' then
    elseif key=='2' then
    elseif key=='3' then
    elseif key=='b' then PlayExterior('brik/exterior/test')() return true
    elseif key=='g' then PlayExterior('gela/test')() return true
    elseif key=='a' then PlayExterior('acry/test')() return true
    end

    if isRep then return true end
    if secretInput==0 then
        if key==secretString:sub(1,1) then
            secretInput=1
        elseif KEYMAP.sys:getAction(key) then
            sysAction(KEYMAP.sys:getAction(key))
        end
    else
        if key==secretString:sub(secretInput+1,secretInput+1) then
            secretInput=secretInput+1
            if secretInput>=#secretString then
                PROGRESS.setSecret('menu_fastype')
                SCN.go('fastype')
            end
        else
            sysAction(KEYMAP.sys:getAction(key))
            secretInput=0
        end
    end
    return true
end

function scene.update(dt)
    textOffset=MATH.expApproach(textOffset,0,6.26*dt)
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy_m)
    GC.translate(-700,-290)

    -- System info
    GC.draw(versionText,40,190)
    GC.draw(terminalName,60+versionText:getWidth(),190)

    -- Title with animation
    GC.draw(TEX.title_techmino,-textOffset,0,nil,.55)
    FONT.set(190,'galaxy_thin')
    GC.setColor(.08,.08,.084)
    for a=0,MATH.tau,MATH.tau/20 do
        GC.print("GALAXY",455+7*math.cos(a)+textOffset,60+7*math.sin(a))
    end
    GC.setColor(1,1,1)
    GC.print("GALAXY",455+textOffset,60)
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=60,y=60,w=80,fillColor='R',cornerR=15,sound_release='button_back',fontSize=70,text=CHAR.icon.power,onClick=function() sysAction('back') end,visibleFunc=function() return SYSTEM~='iOS' end},

    {type='button_invis',pos={1,0},x=-200,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.ctrl_alt,  sound_release='button_soft',onClick=WIDGET.c_goScn('main_in','blackStun')},
    {type='button_invis',pos={1,0},x=-400,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.info_circ, sound_release='button_soft',onClick=WIDGET.c_goScn('about_out','fadeHeader')},
    {type='button_invis',pos={1,0},x=-600,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.music,     sound_release='button_soft',onClick=WIDGET.c_goScn('musicroom','fadeHeader')},
    {type='button_invis',pos={1,0},x=-800,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.language,  sound_release='button_soft',onClick=WIDGET.c_goScn('lang_out','fadeHeader')},

    {type='button',pos={.5,.5},x=-475,y=80, w=530,h=100,text=function() return CHAR.icon.person    ..' '..Text.main_out_single    end, fontSize=40,cornerR=26,onClick=WIDGET.c_goScn('simulation','fadeHeader')},
    {type='button',pos={.5,.5},x=95,  y=80, w=530,h=100,text=function() return CHAR.icon.people    ..' '..Text.main_out_multi     end, fontSize=40,cornerR=26,color='lD',sound_release=false},

    {type='button',pos={.5,.5},x=-570,y=220,w=340,h=100,text=function() return CHAR.icon.settings  ..' '..Text.main_out_settings  end, fontSize=40,cornerR=26,onClick=WIDGET.c_goScn('setting_out','fadeHeader')},
    {type='button',pos={.5,.5},x=-190,y=220,w=340,h=100,text=function() return CHAR.icon.statistics..' '..Text.main_out_stat      end, fontSize=40,cornerR=26,color='lD',sound_release=false},
    {type='button',pos={.5,.5},x=190, y=220,w=340,h=100,text=function() return CHAR.icon.zictionary..' '..Text.main_out_dict      end, fontSize=40,cornerR=26,onClick=function() CallDict('aboutDict') end},
}
return scene
