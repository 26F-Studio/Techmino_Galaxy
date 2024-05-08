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
        event={
            playerInit=mechLib.brik.tsdChallenge.easy_event_playerInit,
            afterClear=mechLib.brik.tsdChallenge.easy_event_afterClear,
            drawOnPlayer=mechLib.brik.tsdChallenge.easy_event_drawOnPlayer,
        },
    }},
}
