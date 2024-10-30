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
                P.modeData.keyCount={}
                P.modeData.curKeyCount=0
                local T=mechLib.common.task
                T.install(P)
                T.add(P,'hypersonic_low','modeTask_hypersonic_low_title','modeTask_hypersonic_low_desc','(0/4)')

                if PROGRESS.getExteriorModeScore('hypersonic','showHigh') then
                    T.add(P,'hypersonic_high','modeTask_hypersonic_high_title','modeTask_hypersonic_high_desc')
                end
                if PROGRESS.getExteriorModeScore('hypersonic','showHidden') then
                    T.add(P,'hypersonic_hidden','modeTask_hypersonic_hidden_title','modeTask_hypersonic_hidden_desc')
                end
                if PROGRESS.getExteriorModeScore('hypersonic','showTitanium') then
                    T.add(P,'hypersonic_titanium','modeTask_hypersonic_titanium_title','modeTask_hypersonic_titanium_desc')
                end
            end,
            beforePress={
                mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
                function(P)
                    if P.timing then return true end
                    if P.settings.readyDelay%1000~=0 then
                        PROGRESS.setSecret('exterior_sprint_gunJumping')
                    end
                end,
                function(P)
                    P.modeData.curKeyCount=P.modeData.curKeyCount+1
                end,
            },
            afterClear=function(P,clear)
                local initFunc
                local T=mechLib.common.task
                if P.stat.line<4 then
                    T.set(P,'hypersonic_low',P.stat.line/4,('($1/4)'):repD(P.stat.line))
                end
                if clear.line>=4 then

                    if #P.holdQueue==0 and P.gameTime<=10e3 then
                        -- Titanium: Techrash in 10s without hold
                        if not PROGRESS.getExteriorModeScore('hypersonic','showTitanium') then
                            T.add(P,'hypersonic_titanium','modeTask_hypersonic_titanium_title','modeTask_hypersonic_titanium_desc')
                        end
                        T.set(P,'hypersonic_titanium',true)
                        PROGRESS.setExteriorScore('hypersonic','showTitanium',1)
                        P.modeData.subMode='titanium'
                        initFunc=mechLib.brik.marathon.hypersonic_titanium_event_playerInit
                        playBgm('secret7th remix_hypersonic_titanium')

                    elseif P.gameTime<=6e3 then
                        -- Hidden: Techrash in 6s
                        if not PROGRESS.getExteriorModeScore('hypersonic','showHidden') then
                            T.add(P,'hypersonic_hidden','modeTask_hypersonic_hidden_title','modeTask_hypersonic_hidden_desc')
                        end
                        T.set(P,'hypersonic_hidden',true)
                        PROGRESS.setExteriorScore('hypersonic','showHidden',1)
                        P.modeData.subMode='hidden'
                        initFunc=mechLib.brik.marathon.hypersonic_hidden_event_playerInit
                        playBgm('secret7th_hypersonic_hidden')
                        mechLib.common.music.set(P,{id='point_hypersonic_hidden',path='.point'},'afterSpawn')
                        FMOD.music.seek(MATH.roundUnit(FMOD.music.tell(),60/130))

                    else
                        -- High: Techrash
                        if not PROGRESS.getExteriorModeScore('hypersonic','showHigh') then
                            T.add(P,'hypersonic_high','modeTask_hypersonic_high_title','modeTask_hypersonic_high_desc')
                        end
                        PROGRESS.setExteriorScore('hypersonic','showHigh',1)
                        T.set(P,'hypersonic_high',true)
                        P.modeData.subMode='high'
                        initFunc=mechLib.brik.marathon.hypersonic_high_event_playerInit
                        playBgm('secret7th')
                        mechLib.common.music.set(P,{path='.point',s=100,e=500},'afterSpawn')
                    end

                elseif P.stat.line>=4 then
                    -- Low: 4 Lines
                    P.modeData.subMode='low'
                    T.set(P,'hypersonic_low',true,'(4/4)')
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
            afterLock=function(P)
                if not P.modeData.subMode then return end
                if P.modeData.subMode~='titanium' then return true end
                if P.modeData.point>=200 then
                    if #P.holdQueue==0 then
                        table.insert(P.holdQueue,P:getBrik('I5'))
                        PROGRESS.setSecret('exterior_hypersonic_titanium_holdless')
                    end
                    return true
                end
            end,
            gameOver=function(P,reason)
                if reason=='AC' then
                    PROGRESS.setExteriorScore('hypersonic',P.modeData.subMode,1)
                    if P.modeData.subMode=='low' then
                        PROGRESS.setExteriorScore('hypersonic','showHigh',1)
                    elseif P.modeData.subMode=='high' then
                        PROGRESS.setExteriorScore('hypersonic','showHidden',1)
                        PROGRESS.setExteriorScore('hypersonic','showTitanium',1)
                    end
                end
            end,
        },
    }},
}
