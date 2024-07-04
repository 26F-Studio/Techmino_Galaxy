---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('dream')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1e99,
        maxFreshChance=1e99,
        maxFreshTime=1e99,
        readyDelay=0,
        event={
            playerInit=function(P)
                P.modeData.lineStay=0
                mechLib.brik.dig.event_playerInit(P)
                P:riseGarbage(math.floor(P.settings.fieldW*.5+1+P:rand(-2,2)))
            end,
            gameStart=function(P) P.timing=false end,
            afterClear={
                mechLib.brik.dig.event_afterClear,
                function(P,clear)
                    if clear.linePos[1]<=1 then
                        local split
                        if clear.line>1 then
                            for i=1,#clear.linePos-1 do
                                if clear.linePos[i+1]-clear.linePos[i]>1 then
                                    split=true
                                    break
                                end
                            end
                        end
                        if split then
                            P.modeData.digMode='checker'
                            P.modeData.target.lineDig=8
                            P.modeData.lineStay=8
                            mechLib.common.music.set(P,{path='.lineDig',s=2,e=6},'afterClear')
                        elseif clear.line<=2 then
                            P.modeData.digMode='shale'
                            P.modeData.target.lineDig=40
                            P.modeData.lineStay=6
                            mechLib.common.music.set(P,{path='.lineDig',s=10,e=30},'afterClear')
                        else
                            P.modeData.digMode='volcanics'
                            P.modeData.target.lineDig=20
                            P.modeData.lineStay=5
                            mechLib.common.music.set(P,{path='.lineDig',s=5,e=10},'afterClear')
                        end
                        if P.modeData.digMode then
                            mechLib.brik.dig.event_playerInit(P)
                            P:addEvent('drawOnPlayer',mechLib.brik.dig.event_drawOnPlayer)
                        end
                        return true
                    end
                end,
                -- Start timing when dig first line
                function(P)
                    if P.modeData.lineDig>0 then
                        P.timing=true
                        return true
                    end
                end,
                function(P)
                    if P.modeData.digMode or PROGRESS.getSecret('exterior_excavate_notDig') then return true end
                    if P.stat.line>=10 then
                        PROGRESS.setSecret('exterior_excavate_notDig')
                        return true
                    end
                end,
            },
            gameOver=function(P,reason)
                if reason=='AC' then
                    if P.modeData.digMode=='checker' then
                        PROGRESS.setExteriorScore('dig','checker',P.gameTime,'<')
                    elseif P.modeData.digMode=='shale' then
                        PROGRESS.setExteriorScore('dig','shale',P.gameTime,'<')
                    elseif P.modeData.digMode=='volcanics' then
                        PROGRESS.setExteriorScore('dig','volcanics',P.gameTime,'<')
                    end

                    local playCount=PROGRESS.getExteriorMapState('dig').playCount or 0
                    if
                        (PROGRESS.getExteriorModeState('dig').shale     or 1e99)<=100e3+10e3*playCount or
                        (PROGRESS.getExteriorModeState('dig').volcanics or 1e99)<=100e3+10e3*playCount or
                        (PROGRESS.getExteriorModeState('dig').checker   or 1e99)<=60e3+5e3*playCount
                    then
                        PROGRESS.setExteriorUnlock('backfire')
                        return true
                    end

                    PROGRESS.setExteriorScore('dig','playCount',playCount+1)
                end
            end,
        },
    }},
}
