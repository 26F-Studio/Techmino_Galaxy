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
                        -- Titanium: Techrash in 8s without hold
                        P.modeData.subMode='titanium'
                        initFunc=mechLib.brik.marathon.hypersonic_titanium_event_playerInit
                        playBgm('distortion')
                        mechLib.common.music.set(P,{path='.point',s=200,e=600},'afterSpawn')

                    elseif P.gameTime<=6e3 then
                        -- Hidden: Techrash in 6s
                        P.modeData.subMode='hidden'
                        initFunc=mechLib.brik.marathon.hypersonic_hidden_event_playerInit
                        playBgm('secret7th_hidden')
                        mechLib.common.music.set(P,{id='level_hypersonic_exterior',path='.level',s=100,e=300},'afterSpawn')
                        FMOD.music.seek(MATH.roundUnit(FMOD.music.tell(),60/130))

                    else
                        -- High: Techrash
                        P.modeData.subMode='high'
                        initFunc=mechLib.brik.marathon.hypersonic_high_event_playerInit
                        playBgm('secret7th')
                        mechLib.common.music.set(P,{path='.point',s=100,e=500},'afterSpawn')
                    end

                elseif P.stat.line>=4 then
                    -- Low: 4 Lines
                    P.modeData.subMode='low'
                    initFunc=mechLib.brik.marathon.hypersonic_low_event_playerInit
                    playBgm('secret8th')
                    mechLib.common.music.set(P,{path='.point',s=100,e=300},'afterSpawn')
                end
                if initFunc then
                    -- Recover original asd/asp
                    P.settings.asd=P.modeData.storedAsd
                    P.settings.asp=P.modeData.storedAsp
                    initFunc(P)
                    return true
                end
            end,
            gameOver=function(P,reason)
                if reason=='AC' then
                    PROGRESS.setExteriorScore('hypersonic',P.modeData.subMode,(PROGRESS.getExteriorMapState('hypersonic')[P.modeData.subMode] or 0)+1)
                end
            end,
        },
    }},
}
