-- Global color table for minoes
defaultMinoColor=setmetatable({2,22,42,6,52,12,32},{__index=function() return math.random(64) end})
defaultPuyoColor=setmetatable({2,12,42,22,52},{__index=function() return math.random(64) end})

do-- bgmList
    bgmList={
        ['8-bit happiness']={
            author="MrZ",
            base={'melody','bass'},
            full={'melody','accompany','bass','drum','sfx'}
        },
        ['8-bit sadness']={
            author="MrZ",
            base={'melody','bass'},
            full={'melody','decoration','bass','sfx'}
        },
        ['battle']={
            author="Aether & MrZ",
            base={'melody','bass','drum'},
            full={'melody','decoration1','decoration2','bass','drum','sfx'},
        },
        ['blank']={
            author="MrZ",
            base={'melody','bass'},
            full={'melody','decoration','bass','drum'},
        },
        ['blox']={
            author="MrZ",
            base={'melody','decoration1','bass'},
            full={'melody','decoration1','decoration2','bass','drum','sfx'},
        },
        ['distortion']={
            author="MrZ",
            base={'melody','bass','sfx1'},
            full={'melody','accompany1','accompany2','decoration','bass','sfx1','sfx2'},
        },
        ['down']={
            author="MrZ",
            base={'melody','accompany','bass1'},
            full={'melody','accompany','bass1','bass2','drum','sfx'},
        },
        ['dream']={
            author="MrZ",
            base={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['echo']={
            author="MrZ",
            base={'melody1','melody2','bass1'},
            full={'melody1','melody2','bass1','bass2','drum','sfx'},
        },
        ['exploration']={
            author="MrZ",
            base={'melody2','decoration','bass2','sfx'},
            full={'melody1','melody2','accompany','decoration','bass1','bass2','sfx'},
        },
        ['far']={
            author="MrZ",
            base={'melody','bass','drum1','drum2'},
            full={'melody','accompany','decoration','bass','drum1','drum2','sfx'},
        },
        ['hope']={
            author="MrZ",
            base={'melody1','melody2','bass'},
            full={'melody1','melody2','decoration','bass','drum','sfx'},
        },
        ['infinite']={
            author="MrZ",
            base={'melody1','bass','drum'},
            full={'melody1','melody2','decoration','bass','drum'},
        },
        ['lounge']={
            author="Hailey (cudsys) & MrZ",
            base={'bass','drum','sfx'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['minoes']={
            author="MrZ",
            base={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['moonbeam']={
            author="Beethoven & MrZ",
            base={'melody','bass'},
            full={'melody','accompany','bass','drum'},
        },
        ['new era']={
            author="MrZ",
            base={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum'},
        },
        ['overzero']={
            author="MrZ",
            base={'melody','bass','drum','sfx'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['oxygen']={
            author="MrZ",
            base={'melody','accompany','bass'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['peak']={
            author="MrZ",
            base={'melody','bass','drum'},
            full={'melody','decoration','bass','drum','sfx'},
        },
        ['pressure']={
            author="MrZ",
            base={'melody1','decoration','bass'},
            full={'melody1','melody2','accompany','decoration','bass','drum1','drum2'},
        },
        ['push']={
            author="MrZ",
            base={'accompany','decoration','bass'},
            full={'melody','accompany','decoration','bass','sfx'},
        },
        ['race']={
            author="MrZ",
            base={'melody','accompany1'},
            full={'melody','accompany1','accompany2','decoration','drum'},
        },
        ['reason']={
            author="MrZ",
            base={'melody2','bass'},
            full={'melody1','melody2','bass','drum'},
        },
        ['rectification']={
            author="MrZ",
            base={'melody','bass','drum'},
            full={'melody','accompany1','accompany2','decoration','bass','drum'},
        },
        ['reminiscence']={
            author="MrZ",
            base={'melody2','bass','drum'},
            full={'melody1','melody2','melody3','bass','drum'},
        },
        ['secret7th']={
            author="MrZ",
            base={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['secret8th']={
            author="MrZ",
            base={'melody1','bass','drum1'},
            full={'melody1','melody2','melody3','bass','drum1','drum2'},
        },
        ['shining terminal']={
            author="MrZ",
            base={'melody1','bass1','drum2'},
            full={'melody1','melody2','decoration','bass1','bass2','drum1','drum2','sfx'},
        },
        ['sine']={
            author="MrZ",
            base={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum'},
        },
        ['space']={
            author="MrZ",
            base={'melody1','melody2','bass'},
            full={'melody1','melody2','accompany','decoration','bass'},
        },
        ['spring festival']={
            author="MrZ",
            base={'melody','accompany','drum1'},
            full={'melody','accompany','bass','drum1','drum2'},
        },
        ['storm']={
            author="MrZ",
            base={'accompany','bass','drum1','sfx'},
            full={'melody','accompany','bass','drum1','drum2','sfx'},
        },
        ['sugar fairy']={
            author="Tchaikovsky & MrZ",
            base={'melody','accompany'},
            full={'melody','accompany','bass','drum'},
        },
        ['supercritical']={
            author="MrZ",
            base={'melody','bass','drum1'},
            full={'melody','accompany','decoration','bass','drum1','drum2'},
        },
        ['truth']={
            author="MrZ",
            base={'melody2','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx1','sfx2'},
        },
        ['vapor']={
            author="MrZ",
            base={'melody','bass','sfx'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['venus']={
            author="MrZ",
            base={'melody','accompany'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['warped']={
            author="MrZ",
            base={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['waterfall']={
            author="MrZ",
            base={'melody1','melody2','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['way']={
            author="MrZ",
            base={'melody1','bass','drum'},
            full={'melody1','melody2','bass','drum'},
        },
        ['xmas']={
            author="MrZ",
            base={'melody','bass','drum'},
            full={'melody','accompany1','accompany2','bass','drum'},
        },
        ['1980s']={
            author="C₂₉H₂₅N₃O₅",
        },
        ['blank orchestra']={
            author="T0722",
        },
        ['empty']={
            author="ERM",
        },
        ['jazz nihilism']={
            author="Trebor",
        },
        ['sakura']={
            author="ZUN & C₂₉H₂₅N₃O₅",
        },
        ['secret7th remix']={
            author="柒栎流星",
        },
        ['secret8th remix']={
            author="MrZ",
        },
        ["race remix"]={
            author="柒栎流星"
        },
    }
    for name,song in next,bgmList do
        if song.base and song.full then
            song.add=TABLE.shift(song.full)
            TABLE.subtract(song.add,song.base)
        else
            song[1]=name
        end
        for info,channels in next,song do
            if info=='base' or info=='full' or info=='add' then
                for i=1,#channels do
                    channels[i]=name..'/'..channels[i]
                end
            end
        end
    end
end

local settings
settings={
    _system={-- We just save values here, do not change them directly.
        -- Audio
        autoMute=false,
        mainVol=1,
        bgmVol=.8,
        sfxVol=1,
        vocVol=0,
        vibVol=1,

        -- Video
        hitWavePower=.6,
        fullscreen=true,
        maxFPS=300,
        updRate=100,
        drawRate=30,

        -- Gameplay
        touchControl=false,

        -- Other
        powerInfo=false,
        sysCursor=false,
        showTouch=true,
        clickFX=true,
        clean=false,
        locale='en',
    },
    game_mino={
        -- Handling
        das=120,
        arr=20,
        sdarr=20,
        dascut=26,

        -- Video
        shakeness=.6,
    },
    game_puyo={
        -- Handling
        das=120,
        arr=20,
        sdarr=20,
        dascut=26,

        -- Video
        shakeness=.6,
    },
    game_gem={
        -- Handling
        das=150,
        arr=40,

        -- Video
        shakeness=.6,
    },
}
local settingTriggers={-- Changing values in SETTINGS.system will trigger these functions (if exist).
    -- Audio
    mainVol=        function(v) love.audio.setVolume(v) end,
    bgmVol=         function(v) BGM.setVol(v) end,
    sfxVol=         function(v) SFX.setVol(v) end,
    vocVol=         function(v) VOC.setVol(v) end,

    -- Video
    fullscreen=     function(v) love.window.setFullscreen(v) love.resize(love.graphics.getWidth(),love.graphics.getHeight()) end,
    maxFPS=         function(v) Zenitha.setMaxFPS(v) end,
    updRate=        function(v) Zenitha.setUpdateFreq(v) end,
    drawRate=       function(v) Zenitha.setDrawFreq(v) end,
    sysCursor=      function(v) love.mouse.setVisible(v) end,
    clickFX=        function(v) Zenitha.setClickFX(v) end,
    clean=          function(v) Zenitha.setCleanCanvas(v) end,

    -- Other
    locale=         function(v) Text=LANG.get(v) LANG.setTextFuncSrc(Text) end,
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
SETTINGS=settings
