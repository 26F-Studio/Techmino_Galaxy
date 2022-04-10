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
--------------------------------------------------------------
-- Global Vars Declaration
VERSION=require"version"
FNNS=SYSTEM:find'\79\83'-- What does FNSF stand for? IDK so don't ask me lol
SFXPACKS={'chiptune'}
VOCPACKS={'miya',--[['mono',]]'xiaoya','miku'}
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
for _,v in next,{'conf','progress','record','replay','cache','lib'} do
    local info=love.filesystem.getInfo(v)
    if not info then
        love.filesystem.createDirectory(v)
    elseif info.type~='directory' then
        love.filesystem.remove(v)
        love.filesystem.createDirectory(v)
    end
end
--------------------------------------------------------------
-- Load modules
GAME=require'assets.game'
CHAR=require'assets.char'
require'assets.gamefunc'
require'assets.gametable'
require'assets.rotationsystem'
DEBUG.checkLoadTime("Load Assets")
--------------------------------------------------------------
-- Config Zenitha
STRING.install()
Zenitha.setAppName('Techmino')
Zenitha.setVersionText(VERSION.appVer)
Zenitha.setFirstScene('game_simp')
Zenitha.setMaxFPS(260)
Zenitha.setUpdateFreq(100)
Zenitha.setDrawFreq(60/260*100)
Zenitha.setDrawCursor(NULL)
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
    -- local function task_autoSoundOff()
    --     repeat
    --         local v=math.max(love.audio.getVolume()-coroutine.yield(),0)
    --         love.audio.setVolume(v)
    --     until v==0
    -- end
    -- local function task_autoSoundOn()
    --     repeat
    --         local v=math.min(love.audio.getVolume()+coroutine.yield(),1)
    --         love.audio.setVolume(v)
    --     until v==1
    -- end
    -- Zenitha.setOnFocus(function(f)
    --     if f then
    --         TASK.removeTask_code(task_autoSoundOff)
    --         TASK.new(task_autoSoundOn)
    --     else
    --         TASK.removeTask_code(task_autoSoundOn)
    --         TASK.new(task_autoSoundOff)
    --     end
    -- end)
end
FONT.load{
    norm='assets/fonts/proportional.otf',
    mono='assets/fonts/monospaced.otf',
    norm_jp='assets/fonts/japan.otf',
}
FONT.setDefaultFont('norm')
FONT.setDefaultFallback('norm')
SCR.setSize(1600,1000)
BGM.setMaxSources(20)
VOC.setDiversion(.62)
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

    miyaCH1='assets/image/characters/miya1.png',
    miyaCH2='assets/image/characters/miya2.png',
    miyaCH3='assets/image/characters/miya3.png',
    miyaCH4='assets/image/characters/miya4.png',
    miyaHeart='assets/image/characters/miya_heart.png',
    miyaGlow='assets/image/characters/miya_glow.png',
    monoCH='assets/image/characters/mono.png',
    xiaoyaCH='assets/image/characters/xiaoya.png',
    xiaoyaOmino='assets/image/characters/xiaoya_Omino.png',
    mikuCH='assets/image/characters/miku.png',
    electric='assets/image/characters/electric.png',
    hbm='assets/image/characters/hbm.png',

    lanterns={
        'assets/image/lanterns/1.png',
        'assets/image/lanterns/2.png',
        'assets/image/lanterns/3.png',
        'assets/image/lanterns/4.png',
        'assets/image/lanterns/5.png',
        'assets/image/lanterns/6.png',
    },

    cover='assets/image/db cover.png',
}
SFX.init((function()
    local L={}
    for _,v in next,love.filesystem.getDirectoryItems('assets/effect/chiptune/') do
        if FILE.isSafe('assets/effect/chiptune/'..v) then
            table.insert(L,v:sub(1,-5))
        end
    end
    return L
end)())
BGM.load((function()
    local path='assets/music'
    local L={}
    for _,dir in next,love.filesystem.getDirectoryItems(path) do
        for _,file in next,love.filesystem.getDirectoryItems(path..'/'..dir) do
            local fullPath=path..'/'..dir..'/'..file
            if FILE.isSafe(fullPath) then
                L[dir..'/'..file:sub(1,-5)]=fullPath
            end
        end
    end
    return L
end)())
VOC.init{}
WS.switchHost('101.43.110.22','10026','/tech/socket/v1')
DEBUG.checkLoadTime("Configuring Zenitha")
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
DEBUG.checkLoadTime("Load SDs+BGs+SCNs")
--------------------------------------------------------------
DEBUG.logLoadTime()
