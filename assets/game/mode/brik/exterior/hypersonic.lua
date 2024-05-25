local function low_music_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,300,P.modeData.point))
end
local function high_music_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,500,P.modeData.point))
end
local function hidden_music_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(100,500,P.modeData.point))
    FMOD.music.setParam('level_hypersonic_exterior',P.modeData.level)
end
local function titanium_music_afterSpawn(P)
    if not P.isMain then return true end
    FMOD.music.setParam('intensity',MATH.icLerp(200,600,P.modeData.point))
end

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('warped')
    end,
    settings={brik={
        event={
            playerInit=function(P)
                P.modeData.storedAsd=P.settings.asd
                P.modeData.storedAsp=P.settings.asp
                P.settings.asd=math.max(P.modeData.storedAsd,200)
                P.settings.asp=math.max(P.modeData.storedAsp,40)
                P.settings.dropDelay=0
                P.settings.lockDelay=1e99
                P.settings.spawnDelay=260
            end,
            afterClear=function(P,clear)
                local initFunc
                if clear.line>=4 then
                    if #P.holdQueue==0 and P.gameTime<=8e3 then
                        initFunc=mechLib.brik.marathon.hypersonic_titanium_event_playerInit
                        playBgm('distortion')
                        P:addEvent('afterSpawn',titanium_music_afterSpawn)
                    elseif P.gameTime<=6e3 then
                        initFunc=mechLib.brik.marathon.hypersonic_hidden_event_playerInit
                        playBgm('secret7th_hidden')
                        P:addEvent('afterSpawn',hidden_music_afterSpawn)
                        FMOD.music.seek(MATH.roundUnit(FMOD.music.tell(),60/130))
                    else
                        initFunc=mechLib.brik.marathon.hypersonic_high_event_playerInit
                        playBgm('secret7th')
                        P:addEvent('afterSpawn',high_music_afterSpawn)
                    end
                elseif P.modeData.stat.line>=4 then
                    initFunc=mechLib.brik.marathon.hypersonic_low_event_playerInit
                    playBgm('secret8th')
                    P:addEvent('afterSpawn',low_music_afterSpawn)
                end
                if initFunc then
                    -- Recover original asd/asp
                    P.settings.asd=P.modeData.storedAsd
                    P.settings.asp=P.modeData.storedAsp
                    initFunc(P)
                    return true
                end
            end,
        },
    }},
}
