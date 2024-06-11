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
                P.modeData.target.lineDig=40
                P.modeData.lineStay=6
                mechLib.brik.dig.event_playerInit(P)
                P.fieldDived=0
            end,
            afterClear=mechLib.brik.dig.event_afterClear,
            gameOver=function(P,reason)
                if reason=='AC' then
                    PROGRESS.setExteriorScore('dig','main',P.gameTime,'<')

                    -- TODO: balance
                    if P.gameTime<=120e3 then PROGRESS.setExteriorUnlock('excavate') end
                    if P.stat.piece<=260 then PROGRESS.setExteriorUnlock('drill') end
                end
            end,
            drawOnPlayer=mechLib.brik.dig.event_drawOnPlayer,
        },
    }},
}
