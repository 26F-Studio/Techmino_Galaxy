---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        seqType='bag7p7p2_power',
        event={
            playerInit=mechLib.brik.techrashChallenge.event_playerInit,
            always=mechLib.brik.techrashChallenge.event_always,
            afterClear={
                mechLib.brik.techrashChallenge.event_afterClear,
                mechLib.brik.music.techrash_afterClear,
                mechLib.brik.progress.techrash_afterClear,
            },
            drawBelowMarks=mechLib.brik.techrashChallenge.event_drawBelowMarks,
            drawOnPlayer=mechLib.brik.techrashChallenge.event_drawOnPlayer,
        },
    }},
}
