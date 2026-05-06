---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        PlayBGM('shift')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1e99,
        readyDelay=0,
        maxFreshChance=1e99,
        maxFreshTime=1e99,
        infHold=true,
        event={
            playerInit=function(P)
                P.modeData.digMode='drill'
                P.modeData.target.lineDig=1e99
                P.modeData.infDig_clears={}
                for i=1,100 do P.modeData.infDig_clears[i]={-1e99,-1e99} end
                P.modeData.lineStay=8
                mechLib.brik.dig.event_playerInit(P)
                P.fieldDived=0
            end,
            beforeClear={
                function(P,lines)
                    local CLEARS=P.modeData.infDig_clears
                    for i=1,#lines do
                        if lines[i]<=P.modeData.lineStay then
                            table.insert(CLEARS,1,{P.time/1e3,P.stat.piece})

                            PROGRESS.setExteriorScore('drill','spl10',(CLEARS[1][1]-CLEARS[11][1])/10,'<')
                            PROGRESS.setExteriorScore('drill','spl20',(CLEARS[1][1]-CLEARS[21][1])/20,'<')
                            PROGRESS.setExteriorScore('drill','spl40',(CLEARS[1][1]-CLEARS[41][1])/40,'<')
                            PROGRESS.setExteriorScore('drill','spl100',(CLEARS[1][1]-CLEARS[101][1])/100,'<')
                            PROGRESS.setExteriorScore('drill','ppl10',(CLEARS[1][2]-CLEARS[11][2])/10,'<')
                            PROGRESS.setExteriorScore('drill','ppl20',(CLEARS[1][2]-CLEARS[21][2])/20,'<')
                            PROGRESS.setExteriorScore('drill','ppl40',(CLEARS[1][2]-CLEARS[41][2])/40,'<')
                            PROGRESS.setExteriorScore('drill','ppl100',(CLEARS[1][2]-CLEARS[101][2])/100,'<')

                            table.remove(CLEARS)
                        end
                    end
                end,
                function()
                    if PROGRESS.getExteriorUnlock('survivor') then return true end
                    if
                        0.3/PROGRESS.getExteriorModeScore('drill','spl10')+
                        0.3/PROGRESS.getExteriorModeScore('drill','spl20')+
                        0.2/PROGRESS.getExteriorModeScore('drill','spl40')+
                        0.4/PROGRESS.getExteriorModeScore('drill','spl100')
                        >=0.355 -- lps, ≈2.82 spl
                    then PROGRESS.setExteriorUnlock('survivor') return true end
                end,
                function()
                    -- Unlock Acry-action
                    if PROGRESS.getStyleUnlock('acry') and PROGRESS.getStyleUnlock('acry') then return true end
                    if
                        0.3/PROGRESS.getExteriorModeScore('drill','ppl10')+
                        0.3/PROGRESS.getExteriorModeScore('drill','ppl20')+
                        0.2/PROGRESS.getExteriorModeScore('drill','ppl40')+
                        0.4/PROGRESS.getExteriorModeScore('drill','ppl100')
                        >=0.260 -- lpp, ≈3.85 ppl
                    then
                        PROGRESS.setStyleUnlock('acry')
                        PROGRESS.setExteriorUnlock('action')
                        return true
                    end
                end,
            },
            afterClear=mechLib.brik.dig.event_afterClear,
        },
    }},
}
