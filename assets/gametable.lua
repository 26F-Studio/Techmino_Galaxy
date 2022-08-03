-- Global color table for minoes
defaultMinoColor=setmetatable({2,22,42,6,52,12,32},{__index=function() return math.random(64) end})
defaultPuyoColor=setmetatable({2,12,42,22,52},{__index=function() return math.random(64) end})

do-- bgmList
    bgmList={
        ['8-bit happiness']={
            base={'melody','bass'},
            full={'melody','accompany','bass','drum','sfx'}
        },
        ['8-bit sadness']={
            base={'melody','bass'},
            full={'melody','decoration','bass','sfx'}
        },
        ['battle']={
            base={'melody','bass','drum'},
            full={'melody','decoration1','decoration2','bass','drum','sfx'},
        },
        ['blank']={
            base={'melody','bass'},
            full={'melody','decoration','bass','drum'},
        },
        ['blox']={
            base={'melody','decoration1','bass'},
            full={'melody','decoration1','decoration2','bass','drum','sfx'},
        },
        ['distortion']={
            base={'melody','bass','sfx1'},
            full={'melody','accompany1','accompany2','decoration','bass','sfx1','sfx2'},
        },
        ['down']={
            base={'melody','accompany','bass1'},
            full={'melody','accompany','bass1','bass2','drum','sfx'},
        },
        ['dream']={
            base={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['echo']={
            base={'melody1','melody2','bass1'},
            full={'melody1','melody2','bass1','bass2','drum','sfx'},
        },
        ['exploration']={
            base={'melody2','decoration','bass2','sfx'},
            full={'melody1','melody2','accompany','decoration','bass1','bass2','sfx'},
        },
        ['far']={
            base={'melody','bass','drum1','drum2'},
            full={'melody','accompany','decoration','bass','drum1','drum2','sfx'},
        },
        ['hope']={
            base={'melody1','melody2','bass'},
            full={'melody1','melody2','decoration','bass','drum','sfx'},
        },
        ['infinite']={
            base={'melody1','bass','drum'},
            full={'melody1','melody2','decoration','bass','drum'},
        },
        ['lounge']={
            base={'bass','drum','sfx'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['minoes']={
            base={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['moonbeam']={
            base={'melody','bass'},
            full={'melody','accompany','bass','drum'},
        },
        ['new era']={
            base={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum'},
        },
        ['overzero']={
            base={'melody','bass','drum','sfx'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['oxygen']={
            base={'melody','accompany','bass'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['peak']={
            base={'melody','bass','drum'},
            full={'melody','decoration','bass','drum','sfx'},
        },
        ['pressure']={
            base={'melody1','decoration','bass'},
            full={'melody1','melody2','accompany','decoration','bass','drum1','drum2'},
        },
        ['push']={
            base={'accompany','decoration','bass'},
            full={'melody','accompany','decoration','bass','sfx'},
        },
        ['race']={
            base={'melody','accompany1'},
            full={'melody','accompany1','accompany2','decoration','drum'},
        },
        ['reason']={
            base={'melody2','bass'},
            full={'melody1','melody2','bass','drum'},
        },
        ['rectification']={
            base={'melody','bass','drum'},
            full={'melody','accompany1','accompany2','decoration','bass','drum'},
        },
        ['reminiscence']={
            base={'melody2','bass','drum'},
            full={'melody1','melody2','melody3','bass','drum'},
        },
        ['secret7th']={
            base={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['secret8th']={
            base={'melody1','bass','drum1'},
            full={'melody1','melody2','melody3','bass','drum1','drum2'},
        },
        ['shining terminal']={
            base={'melody1','bass1','drum2'},
            full={'melody1','melody2','decoration','bass1','bass2','drum1','drum2','sfx'},
        },
        ['sine']={
            base={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum'},
        },
        ['space']={
            base={'melody1','melody2','bass'},
            full={'melody1','melody2','accompany','decoration','bass'},
        },
        ['spring festival']={
            base={'melody','accompany','drum1'},
            full={'melody','accompany','bass','drum1','drum2'},
        },
        ['storm']={
            base={'accompany','bass','drum1','sfx'},
            full={'melody','accompany','bass','drum1','drum2','sfx'},
        },
        ['sugar fairy']={
            base={'melody','accompany'},
            full={'melody','accompany','bass','drum'},
        },
        ['supercritical']={
            base={'melody','bass','drum1'},
            full={'melody','accompany','decoration','bass','drum1','drum2'},
        },
        ['truth']={
            base={'melody2','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx1','sfx2'},
        },
        ['vapor']={
            base={'melody','bass','sfx'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['venus']={
            base={'melody','accompany'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['warped']={
            base={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['waterfall']={
            base={'melody1','melody2','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['way']={
            base={'melody1','bass','drum'},
            full={'melody1','melody2','bass','drum'},
        },
        ['xmas']={
            base={'melody','bass','drum'},
            full={'melody','accompany1','accompany2','bass','drum'},
        },
        ['1980s']=true,
        ['blank orchestra']=true,
        ['empty']=true,
        ['jazz nihilism']=true,
        ['sakura']=true,
        ['secret7th remix']=true,
        ['secret8th remix']=true,
    }
    for name,song in next,bgmList do
        if type(song)=='table' then
            if song.base and song.full then
                song.add=TABLE.shift(song.full)
                TABLE.subtract(song.add,song.base)
            end
            for mode,channels in next,song do
                for i=1,#channels do
                    channels[i]=name..'/'..channels[i]
                end
            end
        else
            bgmList[name]={name}
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
