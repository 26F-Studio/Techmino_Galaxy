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
            playerInit=mechLib.brik.tsdChallenge.hard_event_playerInit,
            always=mechLib.brik.tsdChallenge.hard_event_always,
            afterClear=mechLib.brik.tsdChallenge.hard_event_afterClear,
            drawBelowMarks=mechLib.brik.tsdChallenge.hard_event_drawBelowMarks,
            drawOnPlayer=mechLib.brik.tsdChallenge.hard_event_drawOnPlayer,
        },
    }},
}
