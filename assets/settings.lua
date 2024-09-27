local settings={
    _system={ -- We just save values here, do not change them directly.
        -- Audio
        autoMute=false,
        mainVol=1,
        bgmVol=.8,
        sfxVol=1,
        vocVol=0,
        vibVol=1,
        fmod_loadMemory=true,
        fmod_maxChannel=32,
        fmod_DSPBufferCount=4,
        fmod_DSPBufferLength=8,

        -- Video
        hitWavePower=.6,
        fullscreen=true,
        portrait=false,
        maxFPS=300,
        updRate=100,
        drawRate=30,
        msaa=4,

        -- Gameplay
        touchControl=MOBILE,

        -- Other
        powerInfo=true,
        sysCursor=false,
        showTouch=true,
        clean=false,
        locale='en',
    },
    game_brik={
        -- Handling
        asd=120,
        asp=20,
        adp=20,
        ash=26,
        softdropSkipAsd=true,

        -- Video
        shakeness=.6,
    },
    game_gela={
        -- Handling
        asd=120,
        asp=20,
        adp=20,
        ash=26,
        aHdLock=200,
        mHdLock=62,

        -- Video
        shakeness=.6,
    },
    game_acry={
        -- Handling
        asd=150,
        asp=40,

        -- Video
        shakeness=.6,
    },
}
local settingTriggers={ -- Changing values in SETTINGS.system will trigger these functions (if exist).
    -- Audio
    mainVol=        function(v) FMOD.setMainVolume(v,true) end,
    bgmVol=         function(v) FMOD.music.setVolume(v,true) end,
    sfxVol=         function(v) FMOD.effect.setVolume(v,true) end,
    vocVol=         function(v) FMOD.vocal.setVolume(v,true) end,

    -- Video
    fullscreen=     function(v) love.window.setFullscreen(v); love.resize(love.graphics.getWidth(),love.graphics.getHeight()) end,
    maxFPS=         function(v) ZENITHA.setMaxFPS(v) end,
    updRate=        function(v) ZENITHA.setUpdateFreq(v) end,
    drawRate=       function(v) ZENITHA.setDrawFreq(v) end,
    sysCursor=      function(v) love.mouse.setVisible(v) end,
    clean=          function(v) ZENITHA.setCleanCanvas(v) end,

    -- Other
    locale=         function(v) Text=LANG.set(v) end,
}
settings.system=setmetatable({},{
    __index=settings._system,
    __newindex=function(_,k,v)
        if settings._system[k]~=v then
            settings._system[k]=v
            if settingTriggers[k] then
                settingTriggers[k](v)
            end
        end
    end,
    __metatable=true,
})
return settings
