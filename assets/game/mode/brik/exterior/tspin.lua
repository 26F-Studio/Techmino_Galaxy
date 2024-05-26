local function degraded_tspin_event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.tspin,-300,-70)
    FONT.set(30) GC.mStr(Text.target_tspin,-300,15)
end

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
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
            end,
            always=mechLib.brik.chargeLimit.tspin_event_always,
            afterClear={
                mechLib.brik.chargeLimit.tspin_event_afterClear,
                function(P) -- Enter easy mode when TS not D
                    if P.modeData.tspin then
                        P.modeData.easyModeFlag=true
                        P:delEvent('drawOnPlayer',mechLib.brik.chargeLimit.tspin_event_drawOnPlayer)
                        P:addEvent('drawOnPlayer',degraded_tspin_event_drawOnPlayer)
                        return true
                    end
                end,
                function(P) -- Cancel hard mode flag when overcharged
                    if P.modeData.easyModeFlag or P.modeData.overChargedTimer then
                        P.modeData.hardModeFlag=false
                        return true
                    end
                end,
                function(P) -- Enter hard mode when >4 TSDs
                    if P.modeData.hardModeFlag and P.modeData.tsd>=4 then
                        P:playSound('beep_rise')
                        P:addEvent('drawBelowMarks',mechLib.brik.chargeLimit.tspin_event_drawBelowMarks)
                        return true
                    elseif P.modeData.easyModeFlag or not P.modeData.hardModeFlag then
                        return true
                    end
                end,
                function(P) -- Progress
                    -- Easy mode finishes after 12 TSs
                    if P.modeData.easyModeFlag then
                        local goSecretApp
                        if P.modeData.tspin==4 and P.modeData.stat.line==4 and PROGRESS.getSecret('exterior_tspin_12TSS') then
                            goSecretApp=true
                        elseif P.modeData.tspin>=12 then
                            PROGRESS.setExteriorScore('tspin','any',P.modeData.tspin)
                            if P.modeData.stat.line==12 then
                                PROGRESS.setSecret('exterior_tspin_12TSS')
                                goSecretApp=true
                            else
                                P:finish('AC')
                            end
                        end
                        if goSecretApp then
                            TASK.new(task_unloadGame)
                            SCN._pop()
                            SCN.go('app_UTTT')
                        end
                    else
                        PROGRESS.setExteriorScore('tspin','any',P.modeData.tspin)
                        PROGRESS.setExteriorScore('tspin','tsd',P.modeData.tspin)
                        if P.modeData.hardModeFlag then
                            PROGRESS.setExteriorScore('tspin','tsd_hard',P.modeData.tspin)
                        end
                    end
                end,
                {1e62,function(P)
                    if not P.isMain then return true end
                    FMOD.music.setParam('intensity',P.modeData.easyModeFlag and 0 or MATH.icLerp(3,12,P.modeData.stat.line))
                end},
            },
            drawOnPlayer=mechLib.brik.chargeLimit.tspin_event_drawOnPlayer,
        },
    }},
}
