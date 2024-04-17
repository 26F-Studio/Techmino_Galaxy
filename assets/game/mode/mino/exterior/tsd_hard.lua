---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={mino={
        spin_immobile=true,
        spin_corners=3,
        event={
            playerInit=mechLib.mino.tsdChallenge.hard_event_playerInit,
            always=mechLib.mino.tsdChallenge.hard_event_always,
            afterClear=mechLib.mino.tsdChallenge.hard_event_afterClear,
            drawBelowMarks=mechLib.mino.tsdChallenge.hard_event_drawBelowMarks,
            drawOnPlayer=mechLib.mino.tsdChallenge.hard_event_drawOnPlayer,
        },
    }},
}
