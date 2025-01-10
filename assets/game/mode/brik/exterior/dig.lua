---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        PlayBGM('way')
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
                P.modeData.digMode='line'
                P.modeData.target.lineDig=1e99
                P.modeData.infDig_clears={}
                for i=1,100 do P.modeData.infDig_clears[i]={-1e99,-1e99} end
                P.modeData.lineStay=6
                mechLib.brik.dig.event_playerInit(P)
                P.fieldDived=0
            end,
            beforeClear={
                function(P,lines)
                    local CLEARS=P.modeData.infDig_clears
                    for i=1,#lines do
                        if lines[i]<=P.modeData.lineStay then
                            table.insert(CLEARS,1,{P.time/1e3,P.stat.piece})

                            PROGRESS.setExteriorScore('dig','spl10',(CLEARS[1][1]-CLEARS[11][1])/10,'<')
                            PROGRESS.setExteriorScore('dig','spl20',(CLEARS[1][1]-CLEARS[21][1])/20,'<')
                            PROGRESS.setExteriorScore('dig','spl40',(CLEARS[1][1]-CLEARS[41][1])/40,'<')
                            PROGRESS.setExteriorScore('dig','spl100',(CLEARS[1][1]-CLEARS[101][1])/100,'<')
                            PROGRESS.setExteriorScore('dig','ppl10',(CLEARS[1][2]-CLEARS[11][2])/10,'<')
                            PROGRESS.setExteriorScore('dig','ppl20',(CLEARS[1][2]-CLEARS[21][2])/20,'<')
                            PROGRESS.setExteriorScore('dig','ppl40',(CLEARS[1][2]-CLEARS[41][2])/40,'<')
                            PROGRESS.setExteriorScore('dig','ppl100',(CLEARS[1][2]-CLEARS[101][2])/100,'<')

                            table.remove(CLEARS)
                        end
                    end
                end,
                function()
                    if PROGRESS.getExteriorUnlock('excavate') then return true end
                    if
                        0.4/PROGRESS.getExteriorModeScore('dig','spl10')+
                        0.3/PROGRESS.getExteriorModeScore('dig','spl20')+
                        0.2/PROGRESS.getExteriorModeScore('dig','spl40')+
                        0.3/PROGRESS.getExteriorModeScore('dig','spl100')
                        >=0.26 -- lps, ≈3.85 spl
                    then PROGRESS.setExteriorUnlock('excavate') return true end
                end,
                function()
                    if PROGRESS.getExteriorUnlock('drill') then return true end
                    if
                        0.4/PROGRESS.getExteriorModeScore('dig','ppl10')+
                        0.3/PROGRESS.getExteriorModeScore('dig','ppl20')+
                        0.2/PROGRESS.getExteriorModeScore('dig','ppl40')+
                        0.3/PROGRESS.getExteriorModeScore('dig','ppl100')
                        >=0.42 -- lpp, ≈2.38 ppl
                    then PROGRESS.setExteriorUnlock('drill') return true end
                end,
            },
            afterClear=mechLib.brik.dig.event_afterClear,
        },
    }},
}
