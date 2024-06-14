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
                P.modeData.digMode='excavate'
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

                            PROGRESS.setExteriorScore('excavate','line20',CLEAR[81]-CLEAR[61],'<')
                            PROGRESS.setExteriorScore('excavate','line40',CLEAR[81]-CLEAR[41],'<')
                            PROGRESS.setExteriorScore('excavate','line80',CLEAR[81]-CLEAR[1],'<')
                            -- TODO: balance
                            if P.gameTime<=80e3 then PROGRESS.setExteriorUnlock('survivor') end

                            table.remove(CLEAR,1)
                        end
                    end
                end,
                function(P,lines)
                    if PROGRESS.getSecret('exterior_excavate_notDig') then return true end
                    for i=1,#lines do
                        if lines[i]<=P.modeData.lineStay then return end
                    end
                    if #lines>=4 then
                        PROGRESS.setSecret('exterior_excavate_notDig')
                        return true
                    end
                end,
            },
            afterClear=mechLib.brik.dig.event_afterClear,
            drawOnPlayer=mechLib.brik.dig.event_drawOnPlayer,
        },
    }},
}
