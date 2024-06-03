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
                P.modeData.target.lineDig=40
                P.modeData.lineStay=8
                mechLib.brik.dig.event_playerInit(P)
                P.fieldDived=0
            end,
            afterClear=mechLib.brik.dig.event_afterClear,
            gameOver=function(P)
                if P.finished=='AC' then
                    PROGRESS.setExteriorScore('excavate','main',P.gameTime,'<')

                    -- TODO: balance
                    if P.gameTime<=80e3 then PROGRESS.setExteriorUnlock('survivor') end
                end
            end,
            drawOnPlayer=mechLib.brik.dig.event_drawOnPlayer,
        },
    }},
}
