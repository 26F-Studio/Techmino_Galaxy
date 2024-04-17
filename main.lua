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
require("Zenitha")
DEBUG.checkLoadTime("Load Zenitha")
-- DEBUG.runVarMonitor()
-- DEBUG.setCollectGarvageVisible()
--------------------------------------------------------------
-- System setting
STRING.install()
math.randomseed(os.time()*626)
love.setDeprecationOutput(false)
love.keyboard.setTextInput(false)
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
VERSION=require"version"
GAME=require'assets.game'
AI=require'assets.ai'
PROGRESS=require'assets.progress'
VCTRL=require'assets.vctrl'
KEYMAP=require'assets.keymap'
SKIN=require'assets.skin'
CHAR=require'assets.char'
SETTINGS=require'assets.settings'
bgmList=require'assets.bgmlist'
FMOD=require("assets.fmod20221")
DEBUG.checkLoadTime("Load game modules")
--------------------------------------------------------------
-- Config Zenitha
Zenitha.setAppName('Techmino')
Zenitha.setVersionText(VERSION.appVer)
Zenitha.setFirstScene('hello')
Zenitha.setMaxFPS(260)
Zenitha.setOnGlobalKey('f11',function()
    SETTINGS.system.fullscreen=not SETTINGS.system.fullscreen
    saveSettings()
end)
Zenitha.setOnFnKeys({
    function() MSG.new('info',("System:%s[%s]\nLuaVer:%s\nJitVer:%s\nJitVerNum:%s"):format(SYSTEM,jit.arch,_VERSION,jit.version,jit.version_num)) end,
    function() MSG.new('check',PROFILE.switch() and "Profile start!" or "Profile report copied!") end,
    function() if love['_openConsole'] then love['_openConsole']() end end,
    function() for k,v in next,_G do print(k,v) end end,
    function() print(WIDGET.sel and WIDGET.sel:getInfo() or "No widget selected") end,
    function() end,
    function() end,
})
Zenitha.setDebugInfo{
    {"Cache", gcinfo},
    {"Tasks", TASK.getCount},
    {"Voices",VOC.getQueueCount},
    {"Audios",love.audio.getSourceCount},
    {"Mouse", function() local x,y=SCR.xOy:inverseTransformPoint(love.mouse.getPosition()) return math.floor(x+.5)..' '..math.floor(y+.5) end},
}
do -- Zenitha.setOnFocus
    local function task_autoSoundOff()
        repeat
            local v=math.max(love.audio.getVolume()/SETTINGS.system.mainVol-coroutine.yield()/.26,0)
            love.audio.setVolume(v*SETTINGS.system.mainVol)
        until v==0
    end
    local function task_autoSoundOn()
        repeat
            local v=math.min(love.audio.getVolume()/SETTINGS.system.mainVol+coroutine.yield()/.626,1)
            love.audio.setVolume(v*SETTINGS.system.mainVol)
        until v==1
    end
    Zenitha.setOnFocus(function(f)
        if SETTINGS.system.autoMute then
            if f then
                TASK.removeTask_code(task_autoSoundOff)
                TASK.new(task_autoSoundOn)
            elseif SCN.cur~='musicroom' then
                TASK.removeTask_code(task_autoSoundOn)
                TASK.new(task_autoSoundOff)
            end
        end
    end)
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
VOC.setDiversion(.62)
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
        sound_on='check_on',
        sound_off='check_off',
    },
    selector={
        sound_press='selector',
    },
    listBox={
        sound_select='listBox_select',
        sound_click='listBox_click',
    },
    inputBox={
        sound_input='inputBox_input',
        sound_bksp='inputBox_bksp',
        sound_clear='inputBox_clear',
    },
}

IMG.init{
    actionIcons={
        texture='assets/image/action_icon.png',
        mino=(function()
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
        puyo=(function()
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
        gem=(function()
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
}

LANG.add{
    en='assets/language/lang_en.lua',
    zh='assets/language/lang_zh.lua',
}
LANG.setDefault('en')
DEBUG.checkLoadTime("Load Zenitha resources")
--------------------------------------------------------------
-- Load saving data
TABLE.coverR(FILE.load('conf/settings','-json -canskip') or {},SETTINGS)
for k,v in next,SETTINGS._system do
    SETTINGS._system[k]=nil
    SETTINGS.system[k]=v
end                              -- Gurantee triggering all setting-triggers
if SETTINGS.system.portrait then -- Brute fullscreen config
    SCR.setSize(1600,2560)
    SCR.resize(love.graphics.getWidth(),love.graphics.getHeight())
end
PROGRESS.load()
VCTRL.importSettings(FILE.load('conf/touch','-json -canskip'))
KEYMAP.mino=KEYMAP.new{
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
KEYMAP.puyo=KEYMAP.new{
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
KEYMAP.gem=KEYMAP.new{
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
    {act='func1',    keys={'x'}},
    {act='func2',    keys={'c'}},
    {act='func3',    keys={'v'}},
    {act='func4',    keys={'f'}},
    {act='func5',    keys={'r'}},
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
    KEYMAP.mino:import(keys['mino'])
    KEYMAP.puyo:import(keys['puyo'])
    KEYMAP.gem:import(keys['gem'])
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
        local suc,res=pcall(love.graphics.newShader,'assets/shader/'..name..'.glsl')
        SHADER[name]=suc and res or error("Error in Shader '"..name.."': "..res)
    end
end
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
    'mino_template', -- Shouldn't be used
    'mino_plastic',
    'mino_interior',

    'puyo_template', -- Shouldn't be used
    'puyo_jelly',

    'gem_template',
} do
    if FILE.isSafe('assets/skin/'..v..'.lua') then
        SKIN.add(v,require('assets.skin.'..v))
    end
end
SCN.addSwap('fadeHeader',{
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
SCN.addSwap('fastFadeHeader',{
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
DEBUG.checkLoadTime("Load shaders/BGs/SCNs/skins")
--------------------------------------------------------------
FMOD.init{
    maxChannel=64,
    DSPBufferLength=8,
    DSPBufferCount=8,
    studioFlag=FMOD.FMOD_STUDIO_INIT_SYNCHRONOUS_UPDATE,
    coreFlag=FMOD.FMOD_INIT_NORMAL,
}
FMOD.registerMusic((function()
    local bankMusic=FMOD.loadBank(love.filesystem.getSaveDirectory().."/soundbank/Master.bank")
    assert(bankMusic,"bank load failed")
    local L={}
    local l,c=bankMusic:getEventList(bankMusic:getEventCount())
    for i=1,c do
        local path=assert(l[i-1]:getPath())
        local name=path:match("/([^/]+)$"):lower()
        L[name]=path
    end
    return L
end)())
FMOD.registerEffect((function()
    local bankEffect=FMOD.loadBank(love.filesystem.getSaveDirectory().."/soundbank/Effect.bank")
    assert(bankEffect,"bank load failed")
    local L={}
    local l,c=bankEffect:getEventList(bankEffect:getEventCount())
    for i=1,c do
        local path=assert(l[i-1]:getPath())
        local name=path:match("/([^/]+)$"):lower()
        L[name]=path
    end
    return L
end)())
-- Hijack the original SFX module, use FMOD instead
SFX[('play')]=function(name,vol,pos,tune)
    FMOD.playEffect(name,{
        volume=vol,
        tune=tune,
    })
end
DEBUG.checkLoadTime("Load FMod and Bank")
--------------------------------------------------------------
DEBUG.logLoadTime()
