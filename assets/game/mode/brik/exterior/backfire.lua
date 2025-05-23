---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        PlayBGM('echo')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1000,
        readyDelay=0,
        atkSys='nextgen',
        allowCancel=true,
        allowBlock=true,
        event={
            playerInit=function(P)
                P.modeData.target.line=100
                mechLib.common.music.set(P,{path='stat.line',s=40,e=75},'afterClear')
                local T=mechLib.common.task
                T.install(P)
                T.add(P,'backfire_break','modeTask_backfire_break_title','modeTask_backfire_break_desc','(0/8)')
                T.add(P,'backfire_normal','modeTask_backfire_normal_title','modeTask_backfire_normal_desc','(0/6)')
                if PROGRESS.getExteriorModeScore('backfire','showAmplify') then
                    T.add(P,'backfire_amplify','modeTask_backfire_amplify_title','modeTask_backfire_amplify_desc','(0/8)')
                end
            end,
            gameStart=function(P) P.timing=false end,
            beforeSend=function(P,atk)
                if P.modeData.subMode then return true end
                P:receive(atk)
            end,
            beforeDiscard=function(P)
                local T=mechLib.common.task
                T.set(P,'backfire_break',P.stat.line/8,("($1/8)"):repD(P.stat.line))
                if P.stat.line<=6 then
                    T.set(P,'backfire_normal',P.stat.atk/6,("($1/6)"):repD(P.stat.atk))
                else
                    T.set(P,'backfire_normal',0,"---")
                end
                if P.stat.line<=4 then
                    T.set(P,'backfire_amplify',P.stat.atk/8,("($1/8)"):repD(P.stat.atk))
                else
                    T.set(P,'backfire_amplify',0,"---")
                end
                if P.stat.atk>=8 and P.stat.line<=4 then
                    -- Amplify: 8 atk in 4 lines
                    if not PROGRESS.getExteriorModeScore('backfire','showAmplify') then
                        T.add(P,'backfire_amplify','modeTask_backfire_amplify_title','modeTask_backfire_amplify_desc','(0/8)')
                        T.set(P,'backfire_amplify',P.stat.atk/8,("($1/8)"):repD(P.stat.atk))
                    end
                    T.set(P,'backfire_amplify',true)
                    PROGRESS.setExteriorScore('backfire','showAmplify',1,'>')
                    P.modeData.subMode='amplify'
                    P.settings.dropDelay=260
                    P.settings.maxFreshChance=10
                    P.settings.maxFreshTime=2600
                    P:addEvent('beforeCancel',mechLib.brik.survivor.backfire_triplePower_event_beforeCancel)
                    P:addEvent('beforeSend',mechLib.brik.survivor.backfire_easy_event_beforeSend)
                    PlayBGM('supercritical')
                elseif P.stat.atk>=6 and P.stat.line<=6 then
                    -- Normal: 6 atk in 6 lines
                    T.set(P,'backfire_normal',true)
                    P.modeData.subMode='normal'
                    P.settings.dropDelay=620
                    P.settings.maxFreshChance=12
                    P.settings.maxFreshTime=4200
                    P:addEvent('beforeCancel',mechLib.brik.survivor.backfire_storePower_event_beforeCancel)
                    P:addEvent('beforeSend',mechLib.brik.survivor.backfire_normal_event_beforeSend)
                    PlayBGM('storm')
                elseif P.stat.line>=8 then
                    -- Break: 8 lines
                    T.set(P,'backfire_break',true)
                    P.modeData.subMode='break'
                    P.settings.dropDelay=1000
                    P.settings.maxFreshChance=15
                    P.settings.maxFreshTime=6200
                    P:addEvent('beforeCancel',mechLib.brik.survivor.backfire_storePower_event_beforeCancel)
                    P:addEvent('beforeSend',mechLib.brik.survivor.backfire_break_event_beforeSend)
                    PlayBGM('shift')
                end

                if P.modeData.subMode then
                    P.timing=true
                    P:addEvent('afterClear',mechLib.brik.misc.lineClear_event_afterClear)
                    P:addEvent('drawOnPlayer',mechLib.brik.misc.lineClear_event_drawOnPlayer)
                    return true
                end
            end,
            gameOver=function(P)
                if P.modeData.subMode and P.stat.line>=100 then
                    PROGRESS.setExteriorScore('backfire',P.modeData.subMode,P.gameTime,'<')
                    if P.modeData.subMode=='normal' then
                        PROGRESS.setExteriorScore('backfire','showAmplify',1,'>')
                    end
                end
            end,
        },
    }},
}
