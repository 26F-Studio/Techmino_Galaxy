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
        seqType='bag7_stable',
        deathDelay=1260,
        event={
            playerInit=function(P)
                mechLib.brik.chargeLimit.spin_event_playerInit(P)
                mechLib.common.music.set(P,{path='.spinClear',s=12,e=26},'afterClear')
                local T=mechLib.common.task
                T.install(P)
                if PROGRESS.getExteriorModeScore('spin','showPiece') then
                    T.add(P,'spin_piece','modeTask_spin_piece_title','modeTask_spin_piece_desc')
                end
                T.add(P,'spin_column','modeTask_spin_column_title','modeTask_spin_column_desc')
            end,
            always=mechLib.brik.chargeLimit.spin_event_always,
            beforePress=mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
            afterClear={
                function(P)
                    if P.modeData.subMode=='piece' or P.modeData.subMode=='hero' then
                        PROGRESS.setExteriorScore('spin','piece',P.modeData.spinClear,'>')
                    end
                    if P.modeData.subMode=='column' or P.modeData.subMode=='hero' then
                        PROGRESS.setExteriorScore('spin','column',P.modeData.spinClear,'>')
                        if P.modeData.spin_column_pure then
                            PROGRESS.setExteriorScore('spin','column_pure_'..P.modeData.spin_column_pure,P.modeData.spinClear,'>')
                        end
                    end
                end,
                function(P,clear)
                    local T=mechLib.common.task
                    if not P.modeData.subMode and P.lastMovement.immobile then
                        local activePiece,activeColumn
                        if clear.line==1 then
                            P.modeData.subMode='piece'
                            mechLib.brik.chargeLimit.spin_piece_event_init(P)
                            activePiece=true
                        elseif clear.line==2 then
                            P.modeData.subMode='column'
                            mechLib.brik.chargeLimit.spin_column_event_init(P,P.hand.shape)
                            activeColumn=true
                        else
                            P.modeData.subMode='hero'
                            mechLib.brik.chargeLimit.spin_piece_event_init(P)
                            mechLib.brik.chargeLimit.spin_column_event_init(P,P.hand.shape)
                            activePiece=true
                            activeColumn=true
                        end
                        if activePiece then
                            if not PROGRESS.getExteriorModeScore('spin','showPiece') then
                                PROGRESS.setExteriorScore('spin','showPiece',1,'>')
                                T.add(P,'spin_piece','modeTask_spin_piece_title','modeTask_spin_piece_desc')
                                TABLE.reverse(P.modeData.task)
                            end
                            T.set(P,'spin_piece',true)
                        end
                        if activeColumn then
                            T.set(P,'spin_column',true)
                        end
                        return true
                    end
                end,
                function()
                    -- Unlock Gela-chain
                    if PROGRESS.getStyleUnlock('gela') and PROGRESS.getExteriorUnlock('chain') then return true end
                    local data=PROGRESS.get('exteriorMap').spin
                    local Z,S,J,L,T,O,I=
                        0 or data.column_pure_Z,
                        0 or data.column_pure_S,
                        0 or data.column_pure_J,
                        0 or data.column_pure_L,
                        0 or data.column_pure_T,
                        0 or data.column_pure_O,
                        0 or data.column_pure_I
                    if
                        (0 or data.piece)+
                        (0 or data.column)+
                        math.max(Z,S,J,L,T,O,I)/2.6+
                        (Z+S+J+L+T+O+I)/6.26
                        >=70.23
                    then
                        PROGRESS.setStyleUnlock('gela')
                        PROGRESS.setExteriorUnlock('chain')
                    end
                end
            },
            drawOnPlayer=mechLib.brik.chargeLimit.spin_event_drawOnPlayer,
        },
    }},
}
