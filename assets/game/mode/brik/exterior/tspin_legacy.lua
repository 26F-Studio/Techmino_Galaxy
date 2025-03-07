local function degraded_tspin_event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.tspin,-300,-70)
    FONT.set(30) GC.mStr(Text[P.modeData.tspinText],-300,15)
end
RegFuncLib(degraded_tspin_event_drawOnPlayer,'exterior_tspin.degraded_tspin_event_drawOnPlayer')

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        PlayBGM('way')
    end,
    settings={brik={
        spin_immobile=true,
        spin_corners=3,
        seqType='bag7_luckyT',
        event={
            playerInit=function(P)
                P.modeData.superpositionProtect=true
                P.modeData.easyModeFlag=false
                P.modeData.hardModeFlag=true
                mechLib.brik.chargeLimit.tspin_event_playerInit(P)
                mechLib.common.music.set(P,{path='.tsd',s=3,e=12},'afterClear')
            end,
            always=mechLib.brik.chargeLimit.tspin_event_always,
            beforePress=mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
            afterClear={
                mechLib.brik.chargeLimit.tspin_event_afterClear,
                function(P) -- Switch to easy mode when TS not D
                    if P.modeData.tspin then
                        P.modeData.hardModeFlag=false
                        mechLib.common.music.disable(P)
                        FMOD.music.setParam('intensity',0)
                        P:delEvent('drawOnPlayer',mechLib.brik.chargeLimit.tspin_event_drawOnPlayer)
                        P:addEvent('drawOnPlayer',degraded_tspin_event_drawOnPlayer)
                        return true
                    end
                end,
                function(P) -- Confirm hard mode when >4 TSDs
                    if P.modeData.tspin or P.modeData.overChargedTimer then
                        P.modeData.hardModeFlag=false
                        return true
                    elseif P.modeData.hardModeFlag and P.modeData.tsd>=4 then
                        P:playSound('beep_rise')
                        P:addEvent('drawBelowMarks',mechLib.brik.chargeLimit.tspin_event_drawBelowMarks)
                        return true
                    end
                end,
                function(P) -- Progress
                    -- Easy mode finishes after 10 TSs
                    if P.modeData.tspin then
                        P.modeData.tspinText=nil
                        for k,v in next,P.stat.clears do
                            if v~=0 then
                                if P.modeData.tspinText then
                                    P.modeData.tspinText='target_tspin'
                                    break
                                else
                                    P.modeData.tspinText=
                                        k==1 and 'target_tss' or
                                        k==2 and 'target_tsd' or
                                        k==3 and 'target_tst' or
                                        'target_tsq'
                                end
                            end
                        end
                        local goSecretApp
                        if P.modeData.tspin==4 and P.modeData.tspinText=='target_tss' then
                            goSecretApp='polyforge'
                        elseif P.modeData.tspin==3 and P.modeData.tspinText=='target_tst' then
                            goSecretApp='uttt'
                        elseif P.modeData.tspin>=10 then
                            PROGRESS.setExteriorScore('tspin','any',P.modeData.tspin,'>')
                            P:finish('win')
                        end
                        if goSecretApp then
                            TASK.new(task_unloadGame)
                            SCN._pop()
                            SCN.go(goSecretApp)
                        end
                    else
                        PROGRESS.setExteriorScore('tspin','any',P.modeData.tsd,'>')
                        PROGRESS.setExteriorScore('tspin','tsd',P.modeData.tsd,'>')
                        if P.modeData.hardModeFlag then
                            PROGRESS.setExteriorScore('tspin','tsd_hard',P.modeData.tsd,'>')
                        end
                    end

                    -- Unlock Gela
                    if
                        not (PROGRESS.getStyleUnlock('gela') and PROGRESS.getExteriorUnlock('chain')) and
                        (PROGRESS.getExteriorModeScore('tspin','tsd_hard') or 0)+(PROGRESS.getExteriorModeScore('tspin','tsd') or 0)>=12
                    then
                        PROGRESS.setStyleUnlock('gela')
                        PROGRESS.setExteriorUnlock('chain')
                    end
                end
            },
            drawOnPlayer=mechLib.brik.chargeLimit.tspin_event_drawOnPlayer,
        },
    }},
}
