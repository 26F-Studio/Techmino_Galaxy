---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1e99,
        maxFreshChance=1e99,
        maxFreshTime=1e99,
        event={
            playerInit=function(P)
                P.modeData.digMode='line'
                P.modeData.target.lineDig=1e99
                P.modeData.infDig_clears=TABLE.new(-1e99,80)
                P.modeData.lineStay=6
                mechLib.brik.dig.event_playerInit(P)
                P.fieldDived=0
            end,
            beforeClear=function(P,lines)
                local CLEAR=P.modeData.infDig_clears
                for i=1,#lines do
                    if lines[i]<=P.modeData.lineStay then
                        table.insert(CLEAR,P.time)

                        PROGRESS.setExteriorScore('dig','line20',CLEAR[81]-CLEAR[61],'<')
                        PROGRESS.setExteriorScore('dig','line40',CLEAR[81]-CLEAR[41],'<')
                        PROGRESS.setExteriorScore('dig','line80',CLEAR[81]-CLEAR[1],'<')
                        -- TODO: balance
                        if P.gameTime<=120e3 then PROGRESS.setExteriorUnlock('excavate') end
                        if P.stat.piece<=260 then PROGRESS.setExteriorUnlock('drill') end

                        table.remove(CLEAR,1)
                    end
                end
            end,
            afterClear=mechLib.brik.dig.event_afterClear,
        },
    }},
}
