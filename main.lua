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
-- 1. A front-end framework Zenitha which also by me is used;
-- 2. It's recommened to install Emmylua/LuaLS extension for better support;
-- 3. Check file `.editorconfig` for detailed formatting rule (but not exactly, don't use it to format code on large scale);
-- 4. Double quotes ("abc") are texts for reading; Single quotes ('abc') are string values used only in code;
-- 5. Readability and Maintainability are not always put to the first place. Codes around hot spot could be optimized for better performance. sorry if it confused you;
-- 6. 26

if not love.window then
    love[('run')]=function() return function() return true end end
    return
end

-------------------------------------------------------------
-- Load Zenitha

require'Zenitha'
UTIL.time("Load Zenitha",true)
-- UTIL.runVarMonitor()
-- UTIL.setCollectGarvageVisible()
-- if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

--------------------------------------------------------------
-- System setting

STRING.install()
math.randomseed(os.time()*626)
love.setDeprecationOutput(false)
love.keyboard.setTextInput(false)
VERSION=require'version'
UTIL.time("System setting",true)

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
UTIL.time("Create directories",true)

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
if SYSTEM=='Web' then
    _G[('DiscordRPC')]={update=NULL}
else
    DiscordRPC=require'assets.discordRPC'
end
UTIL.time("Load game modules",true)

function FMODLoadFunc() -- Will be called again when applying advanced options
    if not (FMOD.C and FMOD.C2) then
        MSG.log('error',"FMOD library loaded failed")
        return
    end

    LOG('debug',"Will loading FMOD banks from "..(SETTINGS.system.fmod_loadMemory and "memory" or "file"))
    local errorLogged=false
    local function loadBank(path)
        local bank,errInfo,errInfo2
        if SETTINGS.system.fmod_loadMemory then
            bank,errInfo=FMOD.loadBank2(path)
            if bank then return bank end
            SETTINGS.system.fmod_loadMemory=false
            LOG('debug',"Will load FMOD banks from file")
            MSG('other',"Switched to another bank loading mode to file")
        end
        bank,errInfo2=FMOD.loadBank(love.filesystem.getSaveDirectory()..'/'..path)
        if bank then return bank end
        if not errorLogged then
            errorLogged=true
            MSG.log('error',"FMOD bank load failed :"..tostring(errInfo))
            MSG.log('error',"FMOD bank load failed :"..tostring(errInfo2))
        end
    end

    LOG('debug',"Ready to init FMOD")
    FMOD.init{
        maxChannel=math.min(SETTINGS.system.fmod_maxChannel,256),
        DSPBufferCount=math.min(SETTINGS.system.fmod_DSPBufferCount,16),
        DSPBufferLength=math.min(SETTINGS.system.fmod_DSPBufferLength,65536),
        studioFlag=bit.bxor(FMOD.FMOD_STUDIO_INIT_SYNCHRONOUS_UPDATE,FMOD.FMOD_INIT_STREAM_FROM_UPDATE,FMOD.FMOD_INIT_MIX_FROM_UPDATE),
        coreFlag=FMOD.FMOD_INIT_NORMAL,
    }

    local noFile
    if not loadBank('soundbank/Master.strings.bank') then
        MSG.log('warn',"Strings bank file load failed")
        noFile=true
    end
    if not loadBank('soundbank/Master.bank') then
        MSG.log('warn',"Master bank file load failed")
        noFile=true
    end
    FMOD.registerMusic((function()
        if not love.filesystem.getInfo('soundbank/Master.bank') then
            MSG.log('warn',"Music bank not found")
            return {}
        end
        local L={}
        for _,bankName in next,{'Music_Beepbox','Music_FL','Music_Community','Music_Extra'} do
            if not love.filesystem.getInfo('soundbank/'..bankName..'.bank') then
                MSG.log('warn',bankName.." bank file not found")
                noFile=true
            else
                local bankMusic=loadBank('soundbank/'..bankName..'.bank')
                if not bankMusic then
                    MSG.log('warn',"bank "..bankName.." load failed")
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
        if noFile then _getLatestBank(2.6) end

        -- print("--------------------------")
        -- print("Musics")
        -- for k,v in next,L do print(k,v)end

        -- Music check
        local regMore={}
        for name in next,SONGBOOK do
            if not L[name] then
                table.insert(regMore,name)
            end
        end
        if #regMore>0 then
            MSG.log('warn',"Music not found in Bank:")
            for i=1,#regMore do MSG.log('warn',regMore[i]) end
        end
        return L
    end)())
    FMOD.registerEffect((function()
        if not love.filesystem.getInfo('soundbank/Effect.bank') then
            MSG.log('warn',"Effect bank not found")
            return {}
        end
        local bankEffect=loadBank('soundbank/Effect.bank')
        if not bankEffect then
            MSG.log('warn',"Effect bank file load failed")
            return {}
        end
        local L={}
        local nameList={}
        local l,c=bankEffect:getEventList()
        for i=1,c do
            local path=l[i-1]:getPath()
            if path then
                local name=path:match('/([^/]+)$'):lower()
                L[name]=path
                if path:find('event:') then
                    table.insert(nameList,name)
                end
                -- print(name,path)
            end
        end
        -- print("--------------------------")
        -- print("Effects")
        -- for k,v in next,L do print(k,v)end

        -- SE check
        local regList=require'datatable.se_names'
        local existMore,regMore=TABLE.copy(nameList),TABLE.copy(regList)
        TABLE.subtract(existMore,regList)
        TABLE.subtract(regMore,nameList)
        if #existMore>0 then
            MSG.log('warn',"SE not registered:")
            for i=1,#existMore do MSG.log('warn',existMore[i]) end
        end
        if #regMore>0 then
            MSG.log('warn',"SE not found in Bank:")
            for i=1,#regMore do MSG.log('warn',regMore[i]) end
        end

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
FMODLoadFunc()
if tostring(FMOD.studio):find('NULL') then
    MSG.log('error',"FMOD initialization failed")
elseif TABLE.getSize(FMOD.banks)==0 then
    MSG.log('error',"no FMOD bank files found")
else
    FMOD.setMainVolume(SETTINGS.system.mainVol,true)
    for name,data in next,SONGBOOK do
        local ED=FMOD.music.getDesc(name)
        if ED then
            if select(2,ED:getParameterDescriptionByName('fade'))~=FMOD.FMOD_OK then
                MSG.log('warn',"Missing 'fade' parameter in music '"..name.."'")
            end
            data.intensity=select(2,ED:getParameterDescriptionByName('intensity'))==FMOD.FMOD_OK
            data.section=select(2,ED:getParameterDescriptionByName('section'))==FMOD.FMOD_OK
            data.multitrack=select(2,ED:getUserProperty('multitrack'))==FMOD.FMOD_OK
            data.hasloop=select(2,ED:getParameterDescriptionByName('loop'))==FMOD.FMOD_OK
            if data.section then
                local param,res=ED:getUserProperty('maxsection')
                if res==FMOD.FMOD_OK then
                    ---@cast param FMOD.Studio.UserProperty
                    data.maxsection=param.intvalue
                else
                    MSG.log('warn',"Missing 'maxsection' property in music '"..name.."'")
                end
            end
            -- print(name..":")
            -- print('itst',data.intensity)
            -- print('sect',data.section)
            -- print('mult',data.multitrack)
            -- print('loop',data.hasloop)
        else
            data.notFound=true
            MSG.log('warn',"Music '"..name.."' not found in FMOD",0)
        end
    end
end
UTIL.time("Load FMOD",true)

--------------------------------------------------------------
-- Config Zenitha

ZENITHA.setAppInfo('Techmino',VERSION.appVer)
ZENITHA.setFirstScene('hello')
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

                exeN=exeN:gsub('\r',''):split('\n')
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
                ]=]:gsub('EXEPATH',path)
                love.filesystem.write('RegisterURL.reg',regCode)
                _CL{COLOR.G,".reg script generated, check it carefully then run it"}
                _CL("Check the file with command 'explorer'.")
            elseif bool=="off" then
                love.filesystem.write('UnregisterURL.reg',[=[Windows Registry Editor Version 5.00\n[-HKEY_CLASSES_ROOT\techmino]]=])
                _CL{COLOR.G,".reg script generated, check it carefully then run it"}
                _CL("Check the file with command 'explorer'.")
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
        end
        _CL("Extraordinary!")
    end,
},true)
ZENITHA.addConsoleCommand('chain',{
    code=function()
        if not PROGRESS.getStyleUnlock('gela') then
            PROGRESS.setStyleUnlock('gela')
            PROGRESS.setExteriorUnlock('chain')
        end
        _CL("Fever!")
    end,
},true)

local _keyDown_orig=ZENITHA.globalEvent.keyDown
function ZENITHA.globalEvent.keyDown(key,isRep)
    if _keyDown_orig(key,isRep) then return true end
    if key=='f11' then
        SETTINGS.system.fullscreen=not SETTINGS.system.fullscreen
        SaveSettings()
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
    if f then
        ZENITHA.setSleepDurationError(SETTINGS.system.stability)
    else
        ZENITHA.setSleepDurationError(-1)
    end
end
local autoGCcount=0
function ZENITHA.globalEvent.lowMemory()
    collectgarbage()
    autoGCcount=autoGCcount+1
    LOG('debug',"Auto GC "..autoGCcount)
    if autoGCcount<=6 then
        MSG('check',Text.autoGC..('.'):rep(4-autoGCcount))
    end
end
function ZENITHA.globalEvent.quit()
    PROGRESS.save('save')
    FMOD.destroy()
end
table.remove(ZENITHA._debugInfo,4)

FONT.load{
    norm='assets/fonts/RHDisplayGalaxy-Medium.otf',
    bold='assets/fonts/RHDisplayGalaxy-ExtraBold.otf',

    number='assets/fonts/RHTextInktrap-Regular.otf',
    codepixel='assets/fonts/codePixel_cjk-Regular.ttf',
    symbols='assets/fonts/symbols.otf',

    galaxy_bold="assets/fonts/26FGalaxySans-Bold.otf",
    galaxy_norm="assets/fonts/26FGalaxySans-Regular.otf",
    galaxy_thin="assets/fonts/26FGalaxySans-Thin.otf",
}
FONT.setDefaultFont('norm')
FONT.setOnInit(function(font,size)
    font:setFallbacks(FONT.get(size,'symbols'))
end)
SCR.setSize(1600,1000)
do -- WIDGET.newClass
    local bFill=WIDGET.newClass('button_fill','button')
    local bInvis=WIDGET.newClass('button_invis','button')

    local gc=love.graphics
    local gc_push,gc_pop=gc.push,gc.pop
    local gc_translate,gc_scale=gc.translate,gc.scale
    local gc_setColor=gc.setColor
    local alignDraw=WIDGET._alignDraw
    function bFill:draw()
        gc_push('transform')
        gc_translate(self._x,self._y)

        if self._pressTime>0 then
            gc_scale(1-self._pressTime/self._pressTimeMax*.0626)
        end

        local w,h=self.w,self.h
        local HOV=self._hoverTime/self._hoverTimeMax

        local c=self.fillColor
        local r,g,b=c[1],c[2],c[3]

        -- Rectangle
        gc_setColor(.15+r*.7*(1-HOV*.26),.15+g*.7*(1-HOV*.26),.15+b*.7*(1-HOV*.26),.9)
        GC.mRect('fill',0,0,w,h,self.cornerR)

        -- Drawable
        if self._image then
            gc_setColor(1,1,1)
            alignDraw(self,self._image)
        end
        if self._text then
            gc_setColor(self.textColor)
            alignDraw(self,self._text)
        end
        gc_pop()
    end
    function bInvis:draw()
        gc_push('transform')
        gc_translate(self._x,self._y)

        local w,h=self.w,self.h
        local HOV=self._hoverTime/self._hoverTimeMax

        local fillC=self.fillColor

        -- Rectangle
        gc_setColor(fillC[1],fillC[2],fillC[3],HOV*.16)
        GC.mRect('fill',0,0,w,h,self.cornerR)

        -- Drawable
        if self._image then
            gc_setColor(1,1,1)
            alignDraw(self,self._image)
        end
        if self._text then
            gc_setColor(self.textColor)
            alignDraw(self,self._text)
        end
        gc_pop()
    end
end
WIDGET.setDefaultOption{
    base={
        lineWidth=2,
        sound_hover='any_hover',
    },
    button_fill={
        textColor='L',
    },
    button={
        sound_release='button_norm',
    },
    hint={
        w=40,
        lineWidth=3,
        text="?",
        labelPos='topRight',
        sound_hover='hint_hover',
        -- textColor='lD',
        -- floatFrameColor='X',
        -- floatFillColor={.8,.8,.8,.8},
        -- floatTextColor='D',
        -- floatBox={-20,-120,300,100,10},
    },
    slider={
        sound_drag='slider_drag',
        soundInterval=.042,
        soundPitchRange=7.02,
        textAlwaysShow=true,
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
        labelPos='right',
    },
    selector={
        sound_press='selector',
    },
    listBox={
        sound_select='listbox_select',
        sound_click='listbox_click',
        sound_hover=false,
    },
    inputBox={
        sound_input='inputbox_input',
        sound_bksp='inputbox_bksp',
        sound_clear='inputbox_clear',
        sound_hover=false,
    },
    textBox={
        sound_hover=false,
    },
}
MSG.addCategory('collect',
    {COLOR.HEX'90FFC7'},
    {COLOR.HEX'262626'},
    GC.load{w=40,h=40,
        {'setCL',COLOR.HEX'262626'},
        {'setLW',3},
        {'fRect',17,6,6,28},
        {'fRect',6,17,28,6},
    }
)
MSG.addCategory('achievement',
    {COLOR.HEX'FFF0C2'},
    {COLOR.HEX'262626'},
    GC.load{w=40,h=40,
        {'setCL',COLOR.HEX'262626'},
        {'setLW',3},
        {'dRect',1,1,38,38},
        {'fRect',17,6,6,28},
        {'fRect',6,17,28,6},
    }
)

SCN.addSwapStyle('fadeHeader',{
    duration=.5,
    draw=function(t)
        local a=1-(t-.5)*(t-.5)*4
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
    draw=function(t)
        local a=1-(t-.5)*(t-.5)*4
        local h=120*SCR.k
        GC.setColor(.26,.26,.26,a)
        GC.rectangle('fill',0,0,SCR.w,h)
        GC.setColor(1,1,1,a)
        GC.rectangle('fill',0,h,SCR.w,1)
        GC.setColor(.1,.1,.1,a)
        GC.rectangle('fill',0,h+1,SCR.w,SCR.h-h)
    end,
})
SCN.addSwapStyle('blackStun',{
    duration=.42,
    switchTime=.26,
    draw=function() GC.clear() end,
})
local _oldLoad=SCN.scenes._console.load
function SCN.scenes._console.load(...)
    _oldLoad(...)
    local l=SCN.scenes._console.widgetList
    l[5].fontType='codepixel'
    l[6].fontType='codepixel'
    l[5]:reset()
    l[6]:reset()
end

---@type Map<any>
TEX=IMG.init({
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

    love_logo=GC.load{w=128,h=128,
        {'clear',0,0,0,0},
        {'move',64,64},
        {'setCL',COLOR.D},
        {'fCirc',0,0,64},
        {'setCL',.9,.3,.6},
        {'fCirc',0,0,60},
        {'setCL',.16,.66,.88},
        {'fBow',0,0,60,0,3.141593},
        {'move',-4,4},
        {'setCL',COLOR.L},
        {'fRect',-20,-20,40,40},
        {'fCirc',0,-20,20},
        {'fCirc',20,0,20},
    },
    transition_image=(function()
        local l={w=128,h=1}
        for x=0,127 do
            table.insert(l,{'setCL',1,1,1,1-x/128})
            table.insert(l,{'fRect',x,0,1,1})
        end
        return GC.load(l)
    end)(),
},true)

Text=nil ---@type Techmino.I18N
LANG.add{
    en='assets/language/lang_en.lua',
    eo='assets/language/lang_eo.lua',
    it='assets/language/lang_it.lua',
    zh='assets/language/lang_zh.lua',
    vi='assets/language/lang_vi.lua',
}
LANG.setDefault('en')

UTIL.time("Configure Zenitha",true)

--------------------------------------------------------------
-- Load saving data

do -- Load setting file and trigger all setting-triggers only one time
    local setFile=FILE.load('conf/settings','-json') or {}
    setFile._system,setFile.system=setFile.system,nil
    TABLE.update(SETTINGS,setFile)
    for k,v in next,SETTINGS._system do
        SETTINGS._system[k]=nil
        SETTINGS.system[k]=v
    end
end
if SETTINGS.system.portrait then -- Brute fullscreen config for mobile device
    SCR.setSize(1600,2560)
    SCR._resize(love.graphics.getWidth(),love.graphics.getHeight())
end
PROGRESS.load()
PROGRESS.fix()
VCTRL.importSettings(FILE.load('conf/touch','-json'))
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
    {act='swapLeft', keys={'a'}},
    {act='swapRight',keys={'d'}},
    {act='swapUp',   keys={'w'}},
    {act='swapDown', keys={'s'}},
    {act='twistCW',  keys={'e'}},
    {act='twistCCW', keys={'q'}},
    {act='twist180', keys={'z'}},
    {act='moveLeft', keys={'left'}},
    {act='moveRight',keys={'right'}},
    {act='moveUp',   keys={'up'}},
    {act='moveDown', keys={'down'}},
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
local keys=FILE.load('conf/keymap','-json')
if keys then
    KEYMAP.brik:import(keys['brik'])
    KEYMAP.gela:import(keys['gela'])
    KEYMAP.acry:import(keys['acry'])
    KEYMAP.sys:import(keys['sys'])
end
UTIL.time("Load savedata",true)

--------------------------------------------------------------
-- Load SOURCE ONLY resources and utils

---@type table<string, love.Shader>
SHADER={}
for _,v in next,love.filesystem.getDirectoryItems('assets/shader') do
    if FILE.isSafe('assets/shader/'..v) then
        local name=v:sub(1,-6)
        local suc,res=pcall(love.graphics.newShader,'assets/shader/'..name..'.hlsl')
        SHADER[name]=suc and res or error("Shader '"..name.."' compile error: "..tostring(res))
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

UTIL.time("Load shaders",true)

for _,v in next,love.filesystem.getDirectoryItems('assets/background') do
    if FILE.isSafe('assets/background/'..v) and v:sub(-3)=='lua' then
        local name=v:sub(1,-5)
        BG.add(name,FILE.load('assets/background/'..v,'-lua'))
    end
end

UTIL.time("Load backgrounds",true)

for _,v in next,love.filesystem.getDirectoryItems('assets/scene') do
    if FILE.isSafe('assets/scene/'..v) then
        local sceneName=v:sub(1,-5)
        SCN.add(sceneName,FILE.load('assets/scene/'..v,'-lua'))
    end
end
local appletSceneSet={} ---@type Set<string>
for _,v in next,love.filesystem.getDirectoryItems('assets/scene_app') do
    if FILE.isSafe('assets/scene_app/'..v) then
        local sceneName=v:sub(1,-5)
        appletSceneSet[sceneName]=true
        SCN.add(sceneName,FILE.load('assets/scene_app/'..v,'-lua'))
    end
end
-- No hover sound for all interior scenes
for name,scn in next,SCN.scenes do
    if name:match('^.*_in$') then
        for _,W in next,scn.widgetList do
            W.sound_hover=false
        end
    end
end
-- Special launch mode
if PROGRESS.get('main')>=3 and ShellOption.launchApplet then
    if appletSceneSet[ShellOption.launchApplet] then
        ZENITHA.setFirstScene(ShellOption.launchApplet)
    else
        ZENITHA.setFirstScene('_quit')
        LOG('error',"Applet scene '"..ShellOption.launchApplet.."' doesn't exist")
        return
    end
end

UTIL.time("Load scenes",true)

for _,v in next,{
    'brik_template', -- Shouldn't be used
    'brik_plastic',
    'brik_interior',

    'gela_template', -- Shouldn't be used
    'gela_jelly',

    'acry_template',

    'touhou/brik_reimu',
} do
    if FILE.isSafe('assets/skin/'..v..'.lua') then
        SKIN.add(v,FILE.load('assets/skin/'..v..'.lua','-lua'))
    end
end

UTIL.time("Load skins",true)

do -- Power Manager
    local warnThres={-1,2.6,6.26,14.2,26}
    local warnCheck=5
    TASK.new(function()
        while true do
            local state,pow=love.system.getPowerInfo()
            if not pow then return end
            if state=='charging' or state=='charged' then
                while warnCheck<5 and pow>warnThres[warnCheck] do
                    warnCheck=warnCheck+1
                end
            else
                if pow<=warnThres[warnCheck] then
                    repeat
                        warnCheck=warnCheck-1
                    until warnCheck==1 or pow>warnThres[warnCheck]
                    MSG(({'check','error','warn','info'})[warnCheck],Text.batteryWarn[warnCheck])
                end
            end
            TASK.yieldT(6.26)
        end
    end)
end

DiscordRPC.update("Online")

love.joystick.loadGamepadMappings('datatable/gamecontrollerdb.txt')

UTIL.time("Load utils",true)

--------------------------------------------------------------
-- Finale

print("--------------------------")
UTIL.showTimeLog()
