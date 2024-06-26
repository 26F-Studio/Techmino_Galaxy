--  .       ,   +       -                   `                 ,         .             `         _      ^  +  *        .       . --
--      `                 .    *    ,            `.      *                        *         , .                -        `       --
-- -         *     -    ______     .    __     .      * _     `     .      *  +          *          `      z     ^  ,       *   --
--   .                 /_  __/__  _____/ /_  ____ ___  (_)___  ____         `   .           *            `           *          --
--        +         .   / / / _ \/ ___/ __ \/ __ `__ \/ / __ \/ __ \    _     ______  .   __     .         .                _   --
--             `       / / /  __/ /__/ / / / / / / / / / / / / /_/ / * (_)   / ____/___ _/ /___ __  ____  __     `     .        --
-- +   ,     .   ,  . /_/  \___/\___/_/ /_/_/ /_/ /_/_/_/ /_/\____/   _     / / __/ __ `/ / __ `/ |/_/ / / /   *     *          --
--              +                       ^     *                      (_) ` / /_/ / /_/ / / /_/ />  </ /_/ /                *    --
--      *            ^   `      `                      `         `         \____/\__,_/_/\__,_/_/|_|\__, /  `                   --
--   ^         ,  *                   `  .    `  +          *          *              .   .        /____/      .    ,        *  --
--        *  .        +    .   * `  t                 *  ,        .    .          ^           `                   ^    `        --
--  .      _    `                -       ,     ^     *          `              `     +    *         -       .       +      .    --

-- Techmino: Galaxy is an ultra-improved version of Techmino.
-- Creating issues on GitHub is welcomed if you also love stacking/matching game

-- Developer's note
-- 1. I made a framework called Zenitha, the code in Zenitha are not directly relevant to the game;
-- 2. This project use Emmylua for better IDE support, recommend to use it if you can;
-- 3. Check file ".editorconfig" for detailed formatting rule (but not exactly, don't change large amount of code with it);
-- 4. "xxx" are texts for reading by the player/developer, 'xxx' are string values used only in code;
-- 5. Most codes are focusing on efficiency, then maintainability and readability, excuse me for some mess;
-- 6. 26

-------------------------------------------------------------
-- Load Zenitha

require'Zenitha'
DEBUG.checkLoadTime("Load Zenitha")
-- DEBUG.runVarMonitor()
-- DEBUG.setCollectGarvageVisible()
-- if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

--------------------------------------------------------------
-- System setting

STRING.install()
math.randomseed(os.time()*626)
love.setDeprecationOutput(false)
love.keyboard.setTextInput(false)
VERSION=require'version'

--------------------------------------------------------------
-- Create directories

for _,v in next,{'conf','progress','replay','cache','lib','soundbank'} do
    local info=love.filesystem.getInfo(v)
    if not info then
        love.filesystem.createDirectory(v)
    elseif info.type~='directory' and info.type~='symlink' then
        love.filesystem.remove(v)
        love.filesystem.createDirectory(v)
    end
end

--------------------------------------------------------------
-- Misc modules

require'assets.gamefunc'
GAME=require'assets.game'
AI=require'assets.ai'
PROGRESS=require'assets.progress'
VCTRL=require'assets.vctrl'
KEYMAP=require'assets.keymap'
SKIN=require'assets.skin'
CHAR=require'assets.char'
SETTINGS=require'assets.settings'
SONGBOOK=require'assets.songbook'
FMOD=require'assets.fmod20221'
DEBUG.checkLoadTime("Load game modules")

--------------------------------------------------------------
-- Config Zenitha and Fmod

ZENITHA.setAppName('Techmino')
ZENITHA.setVersionText(VERSION.appVer)
ZENITHA.setFirstScene('hello')
ZENITHA.setMaxFPS(260)
ZENITHA.setDebugInfo{
    {"Cache", gcinfo},
    {"Tasks", TASK.getCount},
    {"Mouse", function() return ("%d, %d"):format(SCR.xOy:inverseTransformPoint(love.mouse.getPosition())) end},
    -- {"FMOD", function() local a,b,c=FMOD.studio:getMemoryUsage() return a..","..b..","..c end}, -- Only available in logging builds Fmod
}
ZENITHA.addConsoleCommand('regurl',{
    code=function(bool)
        if bool~="on" and bool~="off" then
            _CL{COLOR.I,"Usage: regurl <on|off>"}
        elseif not love.filesystem.isFused() then
            _CL{COLOR.Y,"Only available when running in fused mode"}
        elseif SYSTEM=='Windows' then
            if bool=="on" then
                local f

                f=io.popen('dir /b *.exe')
                if not f then
                    _CL{COLOR.R,"Error: Failed to get .exe file in working directory"}
                    return
                end
                local exeN=f:read('*a'); f:close()

                exeN=exeN:gsub('\r','')
                exeN=STRING.split(exeN,'\n')
                if #exeN==0 then
                    _CL{COLOR.R,"Error: No .exe file found in working directory"}
                    return
                elseif #exeN>=2 then
                    _CL{COLOR.R,"Error: Multiple .exe files found in working directory:"}
                    for i=1,#exeN do _CL{COLOR.R,exeN[i]} end
                    return
                end

                f=io.popen('cd')
                if not f then
                    _CL{COLOR.R,"Error: Failed to get working directory"}
                    return
                end
                local path=f:read('*l'); f:close()

                path=(path..'\\'..exeN[1]):gsub('\\','\\\\')
                local regCode=STRING.trimIndent[=[
                    Windows Registry Editor Version 5.00,
                    [HKEY_CLASSES_ROOT\techmino],
                    @="Techmino: Block Stacking Protocol",
                    "URL Protocol"="",
                    [HKEY_CLASSES_ROOT\techmino\shell],
                    [HKEY_CLASSES_ROOT\techmino\shell\open],
                    [HKEY_CLASSES_ROOT\techmino\shell\open\command],
                    @="\"EXEPATH\" %1",
                ]=]
                regCode=regCode:gsub('EXEPATH',path)
                love.filesystem.write('RegisterURL.reg',regCode)
                love.system.openURL(love.filesystem.getSaveDirectory())
            elseif bool=="off" then
                love.filesystem.write('UnregisterURL.reg',[=[Windows Registry Editor Version 5.00\n[-HKEY_CLASSES_ROOT\techmino]]=])
                love.system.openURL(love.filesystem.getSaveDirectory())
            end
        else
            _CL{COLOR.lR,"Only",COLOR.lS,"available",COLOR.lY,"on",COLOR.lG,"Windows"}
        end
    end,
    description="Register/Unregister \"Techmino://...\" link",
    details={
        "Register/Unregister \"Techmino://...\" link for your system.",
        "Windows: will generate a .reg file, run it manually",
        "Other systems: not supported yet",
        "",
        "Usage: regurl <on|off>",
    },
})
ZENITHA.addConsoleCommand('supernova',{
    code=function()
        if not PROGRESS.getStyleUnlock('acry') then
            PROGRESS.setStyleUnlock('acry')
            PROGRESS.setExteriorUnlock('action')
            _CL("Extraordinary!")
        end
    end,
},true)
ZENITHA.addConsoleCommand('chain',{
    code=function()
        if not PROGRESS.getStyleUnlock('gela') then
            PROGRESS.setStyleUnlock('gela')
            PROGRESS.setExteriorUnlock('chain')
            _CL("Ice storm!")
        end
    end,
},true)

local _keyDown_orig=ZENITHA.globalEvent.keyDown
function ZENITHA.globalEvent.keyDown(key,isRep)
    if _keyDown_orig(key,isRep) then return true end
    if key=='f11' then
        SETTINGS.system.fullscreen=not SETTINGS.system.fullscreen
        saveSettings()
        return true
    end
end
function ZENITHA.globalEvent.focus(f)
    if SETTINGS.system.autoMute then
        if f then
            FMOD.setMainVolume(SETTINGS.system.mainVol)
        elseif SCN.cur~='musicroom' then
            FMOD.setMainVolume(0)
        end
    end
end
local autoGCcount=0
function ZENITHA.globalEvent.lowMemory()
    collectgarbage()
    if autoGCcount<6 then
        autoGCcount=autoGCcount+1
        MSG.new('check',Text.autoGC..('.'):rep(4-autoGCcount))
    end
end
function ZENITHA.globalEvent.quit()
    PROGRESS.save('save')
end

FONT.setDefaultFallback('symbols')
FONT.setDefaultFont('norm')
FONT.load{
    norm='assets/fonts/RHDisplayGalaxy-Medium.otf',
    bold='assets/fonts/RHDisplayGalaxy-ExtraBold.otf',

    number='assets/fonts/RHTextInktrap-Regular.otf',
    symbols='assets/fonts/symbols.otf',

    galaxy_bold="assets/fonts/26FGalaxySans-Bold.otf",
    galaxy_norm="assets/fonts/26FGalaxySans-Regular.otf",
    galaxy_thin="assets/fonts/26FGalaxySans-Thin.otf",
}
SCR.setSize(1600,1000)
WIDGET.setDefaultOption{
    base={
        lineWidth=2,
    },
    button_fill={
        textColor='L',
    },
    button={
        sound_trigger='button_norm',
    },
    slider={
        sound_drag='slider_drag',
        soundInterval=.042,
        soundPitchRange=7.02,
    },
    slider_fill={
        sound_drag='slider_fill_drag',
        soundInterval=.042,
        soundPitchRange=7.02,
    },
    checkBox={
        w=40,
        sound_on='check_on',
        sound_off='check_off',
    },
    selector={
        sound_press='selector',
    },
    listBox={
        sound_select='listbox_select',
        sound_click='listbox_click',
    },
    inputBox={
        sound_input='inputbox_input',
        sound_bksp='inputbox_bksp',
        sound_clear='inputbox_clear',
    },
}
MSG.addCategory('collect',
    {COLOR.HEX'90FFC7'},
    {COLOR.HEX'262626'},
    GC.load{40,40,
        {'setCL',COLOR.HEX'262626'},
        {'setLW',3},
        {'fRect',17,6,6,28},
        {'fRect',6,17,28,6},
    }
)
MSG.addCategory('achievement',
    {COLOR.HEX'FFF0C2'},
    {COLOR.HEX'262626'},
    GC.load{40,40,
        {'setCL',COLOR.HEX'262626'},
        {'setLW',3},
        {'dRect',1,1,38,38},
        {'fRect',17,6,6,28},
        {'fRect',6,17,28,6},
    }
)

IMG.init{
    actionIcons={
        texture='assets/image/action_icon.png',
        brik=(function()
            local t={}
            local w=180
            for i,name in next,{
                'moveLeft','moveRight','','softDrop','hardDrop',
                'rotateCW','rotateCCW','rotate180','holdPiece','skip',
                '','','','','',
                'func1','func2','func3','func4','func5',
            } do if #name>0 then t[name]=GC.newQuad((i-1)%5*w,math.floor((i-1)/5)*w,w,w,5*w,7*w) end end
            return t
        end)(),
        gela=(function()
            local t={}
            local w=180
            for i,name in next,{
                'moveLeft','moveRight','','softDrop','hardDrop',
                'rotateCW','rotateCCW','rotate180','holdPiece','skip',
                '','','','','',
                'func1','func2','func3','func4','func5',
            } do if #name>0 then t[name]=GC.newQuad((i-1)%5*w,math.floor((i-1)/5)*w,w,w,5*w,7*w) end end
            return t
        end)(),
        acry=(function()
            local t={}
            local w=180
            for i,name in next,{
                'swapLeft','swapRight','swapUp','swapDown','',
                'twistCW','twistCCW','twist180','','skip',
                'moveLeft','moveRight','moveUp','moveDown','',
                'func1','func2','func3','func4','func5',
            } do if #name>0 then t[name]=GC.newQuad((i-1)%5*w,math.floor((i-1)/5)*w,w,w,5*w,7*w) end end
            return t
        end)(),
        sys=(function()
            local t={}
            local w=180
            for i,name in next,{
                '','','','','',
                '','','','','',
                '','','','','',
                '','','','','',
                'view','restart','back','quit','',
                'setting','help','chat','','',
                'left','right','up','down','select',
            } do if #name>0 then t[name]=GC.newQuad((i-1)%5*w,math.floor((i-1)/5)*w,w,w,5*w,7*w) end end
            return t
        end)(),
    },
    title_techmino='assets/image/title_techmino.png',
    logo_fmod='assets/image/logo_fmod.png',
    -- touhou=(function()
    --     local path='assets/image/touhou/'
    --     local L={}
    --     for _,v in next,love.filesystem.getDirectoryItems(path) do
    --         if FILE.isSafe(path..v) then
    --             L[tonumber(v:match("%d+"))]=path..v
    --         end
    --     end
    --     return L
    -- end)(),
    touhou={
        orb='assets/image/touhou/orb.png',
    },
}

Text=nil---@type Techmino.I18N
LANG.add{
    en='assets/language/lang_en.lua',
    zh='assets/language/lang_zh.lua',
}
LANG.setDefault('en')

function FMODLoadFunc() -- Will be called again when applying advanced options
    if not (FMOD.C and FMOD.C2) then
        MSG.new('error',"FMOD Studio initialization failed")
        return
    end

    FMOD.init{
        maxChannel=math.min(SETTINGS.system.fmod_maxChannel,256),
        DSPBufferCount=math.min(SETTINGS.system.fmod_DSPBufferCount,16),
        DSPBufferLength=math.min(SETTINGS.system.fmod_DSPBufferLength,65536),
        studioFlag=bit.bxor(FMOD.FMOD_STUDIO_INIT_SYNCHRONOUS_UPDATE,FMOD.FMOD_INIT_STREAM_FROM_UPDATE,FMOD.FMOD_INIT_MIX_FROM_UPDATE),
        coreFlag=FMOD.FMOD_INIT_NORMAL,
    }
    if not FMOD.loadBank2('soundbank/Master.strings.bank') then
        MSG.new('warn',"Strings bank file load failed")
    end
    if not FMOD.loadBank2('soundbank/Master.bank') then
        MSG.new('warn',"Master bank file load failed")
    end
    FMOD.registerMusic((function()
        if not love.filesystem.getInfo('soundbank/Master.bank') then
            MSG.new('warn',"Music bank not found")
            return {}
        end
        local L={}
        for _,bankName in next,{'Music_Beepbox','Music_FL','Music_Community','Music_Extra'} do
            if not love.filesystem.getInfo('soundbank/'..bankName..'.bank') then
                MSG.new('warn',bankName.." bank file not found")
            else
                local bankMusic=FMOD.loadBank2('soundbank/'..bankName..'.bank')
                if not bankMusic then
                    MSG.new('warn',"bank "..bankName.." load failed")
                else
                    local l,c=bankMusic:getEventList()
                    for i=1,c do
                        local path=l[i-1]:getPath()
                        if path then
                            local name=path:match('/([^/]+)$'):lower()
                            L[name]=path
                            if not SONGBOOK[name] then SONGBOOK(name) end
                            -- print(name,path)
                        end
                    end
                end
            end
        end
        -- print("--------------------------")
        -- print("Musics")
        -- for k,v in next,L do print(k,v)end
        return L
    end)())
    FMOD.registerEffect((function()
        if not love.filesystem.getInfo('soundbank/Effect.bank') then
            MSG.new('warn',"Effect bank not found")
            return {}
        end
        local bankEffect=FMOD.loadBank2('soundbank/Effect.bank')
        if not bankEffect then
            MSG.new('warn',"Effect bank file load failed")
            return {}
        end
        local L={}
        local l,c=bankEffect:getEventList()
        for i=1,c do
            local path=l[i-1]:getPath()
            if path then
                local name=path:match('/([^/]+)$'):lower()
                L[name]=path
                -- print(name,path)
            end
        end
        -- print("--------------------------")
        -- print("Effects")
        -- for k,v in next,L do print(k,v)end
        return L
    end)())
end
-- Hijack the original SFX module, use FMOD instead
SFX[('play')]=function(name,vol,pos,tune)
    FMOD.effect(name,{
        volume=vol,
        tune=tune,
    })
end
DEBUG.checkLoadTime("Config Zenitha and Fmod")

--------------------------------------------------------------
-- Load saving data

TABLE.update(SETTINGS,FILE.load('conf/settings','-json -canskip') or {})
for k,v in next,SETTINGS._system do
    -- Gurantee triggering all setting-triggers
    SETTINGS._system[k]=nil
    SETTINGS.system[k]=v
end
if SETTINGS.system.portrait then -- Brute fullscreen config for mobile device
    SCR.setSize(1600,2560)
    SCR._resize(love.graphics.getWidth(),love.graphics.getHeight())
end
PROGRESS.load()
PROGRESS.fix()
VCTRL.importSettings(FILE.load('conf/touch','-json -canskip'))
KEYMAP.brik=KEYMAP.new{
    {act='moveLeft', keys={'left'}},
    {act='moveRight',keys={'right'}},
    {act='rotateCW', keys={'up'}},
    {act='rotateCCW',keys={'down'}},
    {act='rotate180',keys={'c'}},
    {act='softDrop', keys={'x'}},
    {act='hardDrop', keys={'z'}},
    {act='holdPiece',keys={'space'}},
    {act='skip',     keys={'q'}},
    {act='func1',    keys={'a'}},
    {act='func2',    keys={'s'}},
    {act='func3',    keys={'d'}},
    {act='func4',    keys={'w'}},
    {act='func5',    keys={'e'}},
}
KEYMAP.gela=KEYMAP.new{
    {act='moveLeft', keys={'left'}},
    {act='moveRight',keys={'right'}},
    {act='rotateCW', keys={'up'}},
    {act='rotateCCW',keys={'down'}},
    {act='rotate180',keys={'c'}},
    {act='softDrop', keys={'x'}},
    {act='hardDrop', keys={'z'}},
    {act='skip',     keys={'q'}},
    {act='func1',    keys={'a'}},
    {act='func2',    keys={'s'}},
    {act='func3',    keys={'d'}},
    {act='func4',    keys={'w'}},
    {act='func5',    keys={'e'}},
}
KEYMAP.acry=KEYMAP.new{
    {act='swapLeft', keys={'left'}},
    {act='swapRight',keys={'right'}},
    {act='swapUp',   keys={'up'}},
    {act='swapDown', keys={'down'}},
    {act='twistCW',  keys={'e'}},
    {act='twistCCW', keys={'q'}},
    {act='twist180', keys={'z'}},
    {act='moveLeft', keys={'a'}},
    {act='moveRight',keys={'d'}},
    {act='moveUp',   keys={'w'}},
    {act='moveDown', keys={'s'}},
    {act='skip',     keys={'space'}},
    {act='func1',    keys={'r'}},
    {act='func2',    keys={'f'}},
    {act='func3',    keys={'c'}},
    {act='func4',    keys={'x'}},
    {act='func5',    keys={'v'}},
}
KEYMAP.sys=KEYMAP.new{
    {act='view',   keys={'lshift'}},
    {act='restart',keys={'r','`'}},
    {act='chat',   keys={'t'}},
    {act='back',   keys={'escape'}},
    {act='quit',   keys={'q'}},
    {act='setting',keys={'s'}},
    {act='help',   keys={'h'}},
    {act='left',   keys={'left'}},
    {act='right',  keys={'right'}},
    {act='up',     keys={'up'}},
    {act='down',   keys={'down'}},
    {act='select', keys={'return'}},
}
local keys=FILE.load('conf/keymap','-json -canskip')
if keys then
    KEYMAP.brik:import(keys['brik'])
    KEYMAP.gela:import(keys['gela'])
    KEYMAP.acry:import(keys['acry'])
    KEYMAP.sys:import(keys['sys'])
end
DEBUG.checkLoadTime("Load settings & data")

--------------------------------------------------------------
-- Load SOURCE ONLY resources

---@type table<string, love.Shader>
SHADER={}
for _,v in next,love.filesystem.getDirectoryItems('assets/shader') do
    if FILE.isSafe('assets/shader/'..v) then
        local name=v:sub(1,-6)
        local suc,res=pcall(love.graphics.newShader,'assets/shader/'..name..'.hlsl')
        SHADER[name]=suc and res or error("Error in Shader '"..name.."': "..res)
    end
end
-- Initialize shader parameters
for k,v in next,{
    aura={{'alpha',1.0}},
    gaussianBlur={
        {'smpCount',10}, -- min(400 * radius, 40)
        {'radius',0.026},
    },
    gaussianSharp={
        {'smpCount',10}, -- min(400 * radius, 40)
        {'radius',0.026},
        {'intensity',1},
    },
    pixelize={{'size',{100,100}}},
    rgb={{'alpha',1.0}},
    ripple={
        {'wave',{0.01,0.01}},
        {'freq',{12,16}},
        {'phase',{0,0}},
    },
    slowPixelize={{'tileSize',0.01}},
} do for i=1,#v do SHADER[k]:send(unpack(v[i])) end end

for _,v in next,love.filesystem.getDirectoryItems('assets/background') do
    if FILE.isSafe('assets/background/'..v) and v:sub(-3)=='lua' then
        local name=v:sub(1,-5)
        BG.add(name,require('assets/background/'..name))
    end
end

for _,v in next,love.filesystem.getDirectoryItems('assets/scene') do
    if FILE.isSafe('assets/scene/'..v) then
        local sceneName=v:sub(1,-5)
        SCN.add(sceneName,require('assets/scene/'..sceneName))
    end
end

for _,v in next,{
    'brik_template', -- Shouldn't be used
    'brik_plastic',
    'brik_interior',

    'gela_template', -- Shouldn't be used
    'gela_jelly',

    'acry_template',

    'touhou.brik_reimu',
} do
    if FILE.isSafe('assets/skin/'..v..'.lua') then
        SKIN.add(v,require('assets/skin/'..v))
    end
end

SCN.addSwapStyle('fadeHeader',{
    duration=.5,
    timeChange=.25,
    draw=function(t)
        local a=t>.25 and 2-t*4 or t*4
        local h=120*SCR.k
        GC.setColor(.26,.26,.26,a)
        GC.rectangle('fill',0,0,SCR.w,h)
        GC.setColor(1,1,1,a)
        GC.rectangle('fill',0,h,SCR.w,1)
        GC.setColor(.1,.1,.1,a)
        GC.rectangle('fill',0,h+1,SCR.w,SCR.h-h)
    end,
})
SCN.addSwapStyle('fastFadeHeader',{
    duration=.2,
    timeChange=.1,
    draw=function(t)
        local a=t>.1 and 2-t*10 or t*10
        local h=120*SCR.k
        GC.setColor(.26,.26,.26,a)
        GC.rectangle('fill',0,0,SCR.w,h)
        GC.setColor(1,1,1,a)
        GC.rectangle('fill',0,h,SCR.w,1)
        GC.setColor(.1,.1,.1,a)
        GC.rectangle('fill',0,h+1,SCR.w,SCR.h-h)
    end,
})

FMODLoadFunc()
if tostring(FMOD.studio):find('NULL') or TABLE.getSize(FMOD.banks)==0 then
    MSG.new('error',"FMOD Studio initialization failed")
else
    FMOD.setMainVolume(SETTINGS.system.mainVol,true)
    for name,data in next,SONGBOOK do
        if FMOD.music.getDesc(name) then
            data.intensity=FMOD.music.getParamDesc(name,'intensity')~=nil
            data.section=FMOD.music.getParamDesc(name,'section')~=nil
            if not FMOD.music.getParamDesc(name,'fade') then
                MSG.new('warn',"Missing 'fade' parameter in music '"..name.."'")
            end
        else
            data.notFound=true
            MSG.new('warn',"Music '"..name.."' not found in FMOD")
        end
    end
end

DEBUG.checkLoadTime("Load shaders/BGs/SCNs/skins")

--------------------------------------------------------------

DEBUG.logLoadTime()
