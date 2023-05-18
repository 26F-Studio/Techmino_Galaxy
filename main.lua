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
-- Load Zenitha
require("Zenitha")
DEBUG.checkLoadTime("Load Zenitha")
-- DEBUG.runVarMonitor()
-- DEBUG.setCollectGarvageVisible()
--------------------------------------------------------------
-- System setting
math.randomseed(os.time()*626)
love.setDeprecationOutput(false)
love.keyboard.setTextInput(false)
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
VERSION=require"version"
GAME=require'assets.game'
AI=require'assets.ai'
PROGRESS=require'assets.progress'
MINOMAP=require'assets.game.minomap'
VCTRL=require'assets.vctrl'
KEYMAP=require'assets.keymap'
SKIN=require'assets.skin'
CHAR=require'assets.char'
SETTINGS=require'assets.settings'
bgmList=require'assets.bgmlist'
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
    function() MSG.new('info',("System:%s[%s]\nLuaVer:%s\nJitVer:%s\nJitVerNum:%s"):format(SYSTEM,jit.arch,_VERSION,jit.version,jit.version_num)) end,
    function() MSG.new('check',PROFILE.switch() and "Profile start!" or "Profile report copied!") end,
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
BGM.setMaxSources(16)
VOC.setDiversion(.62)
WIDGET._prototype.base.lineWidth=2
WIDGET._prototype.button.sound_trigger='button_norm'
WIDGET._prototype.checkBox.sound_on='check_on'
WIDGET._prototype.checkBox.sound_off='check_off'
WIDGET._prototype.selector.sound_trigger='selector'
WIDGET._prototype.listBox.sound_select='listBox_select'
WIDGET._prototype.listBox.sound_click='listBox_click'
WIDGET._prototype.inputBox.sound_input='inputBox_input'
WIDGET._prototype.inputBox.sound_bksp='inputBox_bksp'
WIDGET._prototype.inputBox.sound_clear='inputBox_clear'

--[Attention] Not loading IMG/SFX/BGM files here, just read file paths
IMG.init{
    actionIcons={
        mino={
            moveLeft='assets/image/actionIcons/mino/moveLeft.png',
            moveRight='assets/image/actionIcons/mino/moveRight.png',
            rotateCW='assets/image/actionIcons/mino/rotateCW.png',
            rotateCCW='assets/image/actionIcons/mino/rotateCCW.png',
            rotate180='assets/image/actionIcons/mino/rotate180.png',
            softDrop='assets/image/actionIcons/mino/softDrop.png',
            hardDrop='assets/image/actionIcons/mino/hardDrop.png',
            holdPiece='assets/image/actionIcons/mino/holdPiece.png',
            func1='assets/image/actionIcons/mino/func1.png',
            func2='assets/image/actionIcons/mino/func2.png',
            func3='assets/image/actionIcons/mino/func2.png',
            func4='assets/image/actionIcons/mino/func2.png',
            func5='assets/image/actionIcons/mino/func2.png',
            func6='assets/image/actionIcons/mino/func2.png',
        },
        puyo={
            moveLeft='assets/image/actionIcons/puyo/moveLeft.png',
            moveRight='assets/image/actionIcons/puyo/moveRight.png',
            rotateCW='assets/image/actionIcons/puyo/rotateCW.png',
            rotateCCW='assets/image/actionIcons/puyo/rotateCCW.png',
            rotate180='assets/image/actionIcons/puyo/rotate180.png',
            softDrop='assets/image/actionIcons/puyo/softDrop.png',
            hardDrop='assets/image/actionIcons/puyo/hardDrop.png',
            holdPiece='assets/image/actionIcons/puyo/holdPiece.png',
            func1='assets/image/actionIcons/puyo/func1.png',
            func2='assets/image/actionIcons/puyo/func2.png',
            func3='assets/image/actionIcons/puyo/func2.png',
            func4='assets/image/actionIcons/puyo/func2.png',
            func5='assets/image/actionIcons/puyo/func2.png',
            func6='assets/image/actionIcons/puyo/func2.png',
        },
        gem={},
    },
    title_techmino='assets/image/title_techmino.png',
}
SFX.init((function()
    local L={}
    for _,v in next,love.filesystem.getDirectoryItems('assets/sfx/') do
        if FILE.isSafe('assets/sfx/'..v) then
            L[v:sub(1,-5)]=v:sub(1,-5)..'.ogg'
        end
    end
    return L
end)())
SFX.loadSample{name='bass',path='assets/sample/bass',base='A2'}-- A2~C5
SFX.loadSample{name='lead',path='assets/sample/lead',base='A3'}-- A3~C6

SFX.load('assets/sfx/')
BGM.load((function()
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
LANG.add{
    en='assets/language/lang_en.lua',
    zh='assets/language/lang_zh.lua',
}
LANG.setDefault('en')
DEBUG.checkLoadTime("Load Zenitha resources")
--------------------------------------------------------------
-- Load saving data
TABLE.coverR(FILE.load('conf/settings','-json -canskip') or {},SETTINGS)
for k,v in next,SETTINGS._system do SETTINGS._system[k]=nil SETTINGS.system[k]=v end-- Gurantee triggering all setting-triggers
if SETTINGS.system.portrait then-- Brute fullscreen config
    SCR.setSize(1600,2560)
    SCR.resize(love.graphics.getWidth(),love.graphics.getHeight())
end
PROGRESS.load()
MINOMAP:loadUnlocked(PROGRESS.getMinoModeUnlocked())
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
    {act='view',        keys={'lshift'}},
    {act='restart',     keys={'r','`'}},
    {act='back',        keys={'escape'}},
    {act='quit',        keys={'q'}},
    {act='setting',     keys={'s'}},
    {act='help',        keys={'h'}},
    {act='chat',        keys={'t'}},
    {act='up',          keys={'up'}},
    {act='down',        keys={'down'}},
    {act='left',        keys={'left'}},
    {act='right',       keys={'right'}},
    {act='select',      keys={'return'}},
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
    duration=.2,changeTime=.1,
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
DEBUG.logLoadTime()
