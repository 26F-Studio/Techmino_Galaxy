---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        event={
            playerInit=mechLib.brik.techrashChallenge.hard_event_playerInit,
            always=mechLib.brik.techrashChallenge.hard_event_always,
            afterClear={
                mechLib.brik.techrashChallenge.hard_event_afterClear,
                mechLib.brik.music.techrash_hard_afterClear,
                mechLib.brik.progress.techrash_hard_afterClear,
            },
            drawBelowMarks=mechLib.brik.techrashChallenge.hard_event_drawBelowMarks,
            drawOnPlayer=mechLib.brik.techrashChallenge.hard_event_drawOnPlayer,
        },
    }},
}
