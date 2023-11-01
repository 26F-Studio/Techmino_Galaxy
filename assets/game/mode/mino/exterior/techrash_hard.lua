---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','base')
    end,
    settings={mino={
        event={
            playerInit=mechLib.mino.techrashChallenge.hard_event_playerInit,
            always=mechLib.mino.techrashChallenge.hard_event_always,
            afterClear={
                mechLib.mino.techrashChallenge.hard_event_afterClear,
                mechLib.mino.progress.techrash_hard_afterClear,
            },
            drawBelowMarks=mechLib.mino.techrashChallenge.hard_event_drawBelowMarks,
            drawOnPlayer=mechLib.mino.techrashChallenge.hard_event_drawOnPlayer,
        },
    }},
}
