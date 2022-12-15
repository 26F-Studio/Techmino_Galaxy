-- #   ______          __              _                     ______      __                 #
-- #  /_  __/__  _____/ /_  ____ ___  (_)___  ____     _    / ____/___ _/ /___ __  ____  __ #
-- #   / / / _ \/ ___/ __ \/ __ `__ \/ / __ \/ __ \   (_)  / / __/ __ `/ / __ `/ |/_/ / / / #
-- #  / / /  __/ /__/ / / / / / / / / / / / / /_/ /  _    / /_/ / /_/ / / /_/ />  </ /_/ /  #
-- # /_/  \___/\___/_/ /_/_/ /_/ /_/_/_/ /_/\____/  (_)   \____/\__,_/_/\__,_/_/|_|\__, /   #
-- #                                                                              /____/    #
-- Techmino: Galaxy is an improved version of Techmino.
-- Creating issues on GitHub is welcomed if you also love tetromino stacking game

-- Some coding styles:
-- 1. I made a framework called Zenitha, *most* codes in Zenitha are not directly relevant to the game;
-- 2. "xxx" are texts for reading by the player, 'xxx' are string values just used in the program;
-- 3. Some goto statements are used for better performance. All goto-labels have detailed names so don't be afraid;
-- 4. Except "gcinfo" function of Lua itself, other "gc"s are short for "graphics";

-------------------------------------------------------------
-- Var leak check
-- setmetatable(_G,{__newindex=function(self,k,v)print('>>'..k..string.rep(" ",26-#k),debug.traceback():match("\n.-\n\t(.-): "))rawset(self,k,v)end})
-- Visible collectgarbage
-- local _gc=collectgarbage function collectgarbage()_gc()print(debug.traceback())end
-------------------------------------------------------------
-- Load Zenitha
require("Zenitha")
DEBUG.checkLoadTime("Load Zenitha")
--------------------------------------------------------------
-- Global Vars Declaration
VERSION=require"version"
--------------------------------------------------------------
-- System setting
math.randomseed(os.time()*626)
love.setDeprecationOutput(false)
love.keyboard.setTextInput(false)
if MOBILE then
    local w,h,f=love.window.getMode()
    f.resizable=false
    love.window.setMode(w,h,f)
end
--------------------------------------------------------------
-- Create directories
for _,v in next,{'conf','progress','replay','cache','lib'} do
    local info=love.filesystem.getInfo(v)
    if not info then
        love.filesystem.createDirectory(v)
    elseif info.type~='directory' then
        love.filesystem.remove(v)
        love.filesystem.createDirectory(v)
    end
end
--------------------------------------------------------------
-- Misc modules
GAME=require'assets.game'
AI=require'assets.ai'
PROGRESS=require'assets.progress'
VCTRL=require'assets.vctrl'
KEYMAP=require'assets.keymap'
SKIN=require'assets.skin'
CHAR=require'assets.char'
SETTINGS=require'assets.settings'
bgmList=require'assets.bgmlist'
defaultMinoColor=setmetatable({2,22,42,6,52,12,32},{__index=function() return math.random(64) end})
defaultPuyoColor=setmetatable({2,12,42,22,52},{__index=function() return math.random(64) end})
particleSystemTemplate=require'assets.game.particleSystemTemplate'
require'assets.gamefunc'
DEBUG.checkLoadTime("Load game modules")
--------------------------------------------------------------
-- Config Zenitha
STRING.install()
Zenitha.setAppName('Techmino')
Zenitha.setVersionText(VERSION.appVer)
Zenitha.setFirstScene('hello')
Zenitha.setMaxFPS(260)
Zenitha.setOnGlobalKey('f11',function()
    SETTINGS.system.fullscreen=not SETTINGS.system.fullscreen
    saveSettings()
end)
Zenitha.setOnFnKeys({
    function() MES.new('info',("System:%s[%s]\nLuaVer:%s\nJitVer:%s\nJitVerNum:%s"):format(SYSTEM,jit.arch,_VERSION,jit.version,jit.version_num)) end,
    function() MES.new('check',PROFILE.switch() and "Profile start!" or "Profile report copied!") end,
    function() if love['_openConsole'] then love['_openConsole']() end end,
    function() for k,v in next,_G do print(k,v) end end,
    function() local w=WIDGET.getSelected() print(w and w:getInfo() or "No widget selected") end,
    function() end,
    function() end,
})
Zenitha.setDebugInfo{
    {"Cache",gcinfo},
    {"Tasks",TASK.getCount},
    {"Voices",VOC.getQueueCount},
    {"Audios",love.audio.getSourceCount},
}
do-- Zenitha.setOnFocus
    local function task_autoSoundOff()
        repeat
            local v=math.max(love.audio.getVolume()-coroutine.yield()/.26,0)
            love.audio.setVolume(v*SETTINGS.system.mainVol)
        until v==0
    end
    local function task_autoSoundOn()
        repeat
            local v=math.min(love.audio.getVolume()+coroutine.yield()/.626,1)
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
    -- galaxy_black="assets/fonts/26FGalaxySans-Black.otf",
    -- galaxy_extrabold="assets/fonts/26FGalaxySans-ExtraBold.otf",
    -- galaxy_bold="assets/fonts/26FGalaxySans-Bold.otf",
    -- galaxy_medium="assets/fonts/26FGalaxySans-Medium.otf",
    -- galaxy_regular="assets/fonts/26FGalaxySans-Regular.otf",
    -- galaxy_light="assets/fonts/26FGalaxySans-Light.otf",
    -- galaxy_ultralight="assets/fonts/26FGalaxySans-UltraLight.otf",
    -- galaxy_thin="assets/fonts/26FGalaxySans-Thin.otf",
    -- galaxy_hairline="assets/fonts/26FGalaxySans-Hairline.otf",
    norm='assets/fonts/Inter-SemiBold.otf',
    thin='assets/fonts/Inter-Regular.otf',
    bold='assets/fonts/Inter-ExtraBold.otf',
    symbols='assets/fonts/symbols.otf',
}
SCR.setSize(1600,1000)
BGM.setMaxSources(16)
VOC.setDiversion(.62)
WIDGET._prototype.base.lineWidth=2
WIDGET._prototype.button.sound='button'
WIDGET._prototype.checkBox.sound_on='check'
WIDGET._prototype.checkBox.sound_off='uncheck'
WIDGET._prototype.selector.sound='selector'

--[Attention] Not loading IMG/SFX/BGM files here, just read file paths
IMG.init{
    lock='assets/image/mess/lock.png',
    dialCircle='assets/image/mess/dialCircle.png',
    dialNeedle='assets/image/mess/dialNeedle.png',
    lifeIcon='assets/image/mess/life.png',
    badgeIcon='assets/image/mess/badge.png',
    ctrlSpeedLimit='assets/image/mess/ctrlSpeedLimit.png',
    speedLimit='assets/image/mess/speedLimit.png',
    pay1='assets/image/mess/pay1.png',
    pay2='assets/image/mess/pay2.png',

    miya={
        miyaCH1='assets/image/characters/miya1.png',
        miyaCH2='assets/image/characters/miya2.png',
        miyaCH3='assets/image/characters/miya3.png',
        miyaCH4='assets/image/characters/miya4.png',
        heart='assets/image/characters/miya_heart.png',
        glow='assets/image/characters/miya_glow.png',
    },
    monoCH='assets/image/characters/mono.png',
    xiaoyaCH='assets/image/characters/xiaoya.png',
    xiaoyaOmino='assets/image/characters/xiaoya_Omino.png',
    mikuCH='assets/image/characters/miku.png',
    electric='assets/image/characters/electric.png',
    hbm='assets/image/characters/hbm.png',
    z={
        character='assets/image/characters/z_character.png',
        screen1='assets/image/characters/z_screen1.png',
        screen2='assets/image/characters/z_screen2.png',
        particle1='assets/image/characters/z_particle1.png',
        particle2='assets/image/characters/z_particle2.png',
        particle3='assets/image/characters/z_particle3.png',
        particle4='assets/image/characters/z_particle4.png',
    },

    lanterns={
        'assets/image/lanterns/1.png',
        'assets/image/lanterns/2.png',
        'assets/image/lanterns/3.png',
        'assets/image/lanterns/4.png',
        'assets/image/lanterns/5.png',
        'assets/image/lanterns/6.png',
    },

    cover='assets/image/db cover.png',
    title={
        techmino='assets/image/title_techmino.png',
        galaxy='assets/image/title_galaxy.png',
    }
}
SFX.init((function()
    local L={}
    for _,v in next,love.filesystem.getDirectoryItems('assets/sfx/') do
        if FILE.isSafe('assets/sfx/'..v) then
            table.insert(L,v:sub(1,-5))
        end
    end
    return L
end)())
SFX.loadSample{name='bass',path='assets/sample/bass',base='A2'}-- A2~A4
SFX.loadSample{name='lead',path='assets/sample/lead',base='A3'}-- A3~A5

SFX.load('assets/sfx/')
BGM.init((function()
    local path='assets/music/'
    local L={}
    for _,dir in next,love.filesystem.getDirectoryItems(path) do
        if love.filesystem.getInfo(path..dir).type=='directory' then
            for _,file in next,love.filesystem.getDirectoryItems(path..dir) do
                local fullPath=path..dir..'/'..file
                if FILE.isSafe(fullPath) then
                    L[dir..'/'..file:sub(1,-5)]=fullPath
                end
            end
        elseif love.filesystem.getInfo(path..dir).type=='file' then
            local fullPath=path..dir
            if FILE.isSafe(fullPath) then
                L[dir:sub(1,-5)]=fullPath
            end
        end
    end
    return L
end)())
VOC.init{}
LANG.setDefault('en')
LANG.add{
    en='assets/language/lang_en.lua',
    zh='assets/language/lang_zh.lua',
}
DEBUG.checkLoadTime("Load Zenitha resources")
--------------------------------------------------------------
-- Load saving data
TABLE.coverR(FILE.load('conf/settings','-json -canskip') or {},SETTINGS)
for k,v in next,SETTINGS._system do SETTINGS._system[k]=nil SETTINGS.system[k]=v end
PROGRESS.load()
VCTRL.importSettings(FILE.load('conf/touch','-json -canskip'))
KEYMAP.mino=KEYMAP.new{
    {act='moveLeft',    keys={'left'}},
    {act='moveRight',   keys={'right'}},
    {act='rotateCW',    keys={'up'}},
    {act='rotateCCW',   keys={'down'}},
    {act='rotate180',   keys={'c'}},
    {act='softDrop',    keys={'x'}},
    {act='hardDrop',    keys={'z'}},
    {act='holdPiece',   keys={'space'}},
    {act='sonicDrop',   keys={}},
    {act='sonicLeft',   keys={}},
    {act='sonicRight',  keys={}},
    {act='func1',       keys={'a'}},
    {act='func2',       keys={'s'}},
    {act='func3',       keys={'d'}},
    {act='func4',       keys={'q'}},
    {act='func5',       keys={'w'}},
    {act='func6',       keys={'e'}},
}
KEYMAP.puyo=KEYMAP.new{
    {act='moveLeft',    keys={'left'}},
    {act='moveRight',   keys={'right'}},
    {act='rotateCW',    keys={'up'}},
    {act='rotateCCW',   keys={'down'}},
    {act='rotate180',   keys={'c'}},
    {act='softDrop',    keys={'x'}},
    {act='hardDrop',    keys={'z'}},
    {act='func1',       keys={'a'}},
    {act='func2',       keys={'s'}},
    {act='func3',       keys={'d'}},
    {act='func4',       keys={'q'}},
    {act='func5',       keys={'w'}},
    {act='func6',       keys={'e'}},
}
KEYMAP.gem=KEYMAP.new{
    {act='swapLeft',    keys={'left'}},
    {act='swapRight',   keys={'right'}},
    {act='swapUp',      keys={'up'}},
    {act='swapDown',    keys={'down'}},
    {act='twistCW',     keys={'e'}},
    {act='twistCCW',    keys={'q'}},
    {act='twist180',    keys={'z'}},
    {act='moveLeft',    keys={'a'}},
    {act='moveRight',   keys={'d'}},
    {act='moveUp',      keys={'w'}},
    {act='moveDown',    keys={'s'}},
    {act='func1',       keys={'a'}},
    {act='func2',       keys={'s'}},
    {act='func3',       keys={'d'}},
    {act='func4',       keys={'q'}},
    {act='func5',       keys={'w'}},
    {act='func6',       keys={'e'}},
}
KEYMAP.sys=KEYMAP.new{
    {act='restart',     keys={'r'}},
    {act='chat',        keys={'t'}},
    {act='up',          keys={'up'}},
    {act='down',        keys={'down'}},
    {act='left',        keys={'left'}},
    {act='right',       keys={'right'}},
    {act='select',      keys={'return'}},
    {act='back',        keys={'escape'}},
}
local keys=FILE.load('conf/keymap','-json -canskip')
if keys then
    KEYMAP.mino:import(keys['mino'])
    KEYMAP.puyo:import(keys['puyo'])
    KEYMAP.gem :import(keys['gem'])
    KEYMAP.sys :import(keys['sys'])
end
DEBUG.checkLoadTime("Load settings & data")
--------------------------------------------------------------
-- Load SOURCE ONLY resources
SHADER={}
for _,v in next,love.filesystem.getDirectoryItems('assets/shader') do
    if FILE.isSafe('assets/shader/'..v) then
        local name=v:sub(1,-6)
        SHADER[name]=love.graphics.newShader('assets/shader/'..name..'.glsl')
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
    'mino_template',-- Shouldn't be used
    'mino_plastic',
    'mino_simp',
    'mino_interior',

    'puyo_template',-- Shouldn't be used
    'puyo_jelly',

    'gem_template',
} do
    if FILE.isSafe('assets/skin/'..v..'.lua') then
        SKIN.add(v,require('assets.skin.'..v))
    end
end
SCN.addSwap('fadeHeader',{
    duration=.5,changeTime=.25,
    draw=function(t)
        GC.setColor(.1,.1,.1,t>.25 and 2-t*4 or t*4)
        GC.rectangle('fill',0,120*SCR.k,SCR.w,SCR.h-120*SCR.k)
        GC.setColor(.26,.26,.26,t>.25 and 2-t*4 or t*4)
        GC.rectangle('fill',0,0,SCR.w,120*SCR.k)
    end,
})
SCN.addSwap('fastFadeHeader',{
    duration=.2,changeTime=.1,
    draw=function(t)
        GC.setColor(.1,.1,.1,t>.1 and 2-t*10 or t*10)
        GC.rectangle('fill',0,120*SCR.k,SCR.w,SCR.h-120*SCR.k)
        GC.setColor(.26,.26,.26,t>.1 and 2-t*10 or t*10)
        GC.rectangle('fill',0,0,SCR.w,120*SCR.k)
    end,
})
DEBUG.checkLoadTime("Load shaders/BGs/SCNs/skins")
--------------------------------------------------------------
DEBUG.logLoadTime()
