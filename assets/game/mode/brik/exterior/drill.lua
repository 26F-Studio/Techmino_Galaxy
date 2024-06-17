---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('shift')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1e99,
        maxFreshChance=1e99,
        maxFreshTime=1e99,
        event={
            playerInit=function(P)
                P.modeData.digMode='drill'
                P.modeData.target.lineDig=1e99
                P.modeData.infDig_clears=TABLE.new(-1e99,80)
                P.modeData.lineStay=8
                mechLib.brik.dig.event_playerInit(P)
                P.fieldDived=0
            end,
            beforeClear={
                function(P,lines)
                    local CLEAR=P.modeData.infDig_clears
                    for i=1,#lines do
                        if lines[i]<=P.modeData.lineStay then
                            table.insert(CLEAR,P.stat.piece)

                            PROGRESS.setExteriorScore('drill','line20',CLEAR[81]-CLEAR[61],'<')
                            PROGRESS.setExteriorScore('drill','line40',CLEAR[81]-CLEAR[41],'<')
                            PROGRESS.setExteriorScore('drill','line80',CLEAR[81]-CLEAR[1],'<')

                            local lpp20=(CLEAR[81]-CLEAR[61])/20
                            local lpp40=(CLEAR[81]-CLEAR[41])/40
                            local lpp80=(CLEAR[81]-CLEAR[1])/80
                            -- TODO: balance
                            if false then PROGRESS.setExteriorUnlock('survivor') end
                            -- Unlock Acry
                            if false then
                                PROGRESS.setStyleUnlock('acry')
                                PROGRESS.setExteriorUnlock('action')
                            end

                            table.remove(CLEAR,1)
                        end
                    end
                end,
                function(P)
                    if P.modeData.digMode or PROGRESS.getSecret('exterior_drill_notDig') then return true end
                    if P.stat.line>=10 then
                        PROGRESS.setSecret('exterior_drill_notDig')
                        return true
                    end
                end,
            },
            afterClear=mechLib.brik.dig.event_afterClear,
        },
    }},
}
