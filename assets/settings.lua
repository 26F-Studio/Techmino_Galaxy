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
        fmod_DSPBufferLength=256,

        -- Video
        hitWavePower=.6,
        fullscreen=true,
        portrait=false,
        maxTPS=300,
        updateRate=100,
        renderRate=30,
        stability=0,
        msaa=4,

        -- Gameplay
        touchControl=MOBILE,

        -- Other
        powerInfo=true,
        sysCursor=false,
        showTouch=true,
        clean=false,
        locale='en',
        discordConnect=false,
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
        palette={
            844,484,448,864,748,884,488,
            844,484,845,485,468,854,748,684,488,847,884,448,864,468,854,846,486,884,
            478,748,854,484,
        },
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
    maxTPS=         function(v) ZENITHA.setMainLoopSpeed(v) end,
    updateRate=     function(v) ZENITHA.setUpdateRate(v) end,
    renderRate=     function(v) ZENITHA.setRenderRate(v) end,
    stability=      function(v) ZENITHA.setSleepDurationError(v) end,
    sysCursor=      function(v) love.mouse.setVisible(v) end,
    clean=          function(v) ZENITHA.setCleanCanvas(v) end,

    -- Other
    locale=         function(v) Text=LANG.set(v) end,
}

local function updateDiscordRPC(v)
    TASK.yieldT(2.6)
    DiscordRPC.setEnable(v)
end
function settingTriggers.discordConnect(v)
    TASK.removeTask_code(updateDiscordRPC)
    TASK.new(updateDiscordRPC,v)
end

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
