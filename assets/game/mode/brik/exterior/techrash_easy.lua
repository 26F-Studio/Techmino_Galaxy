---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('way')
    end,
    settings={brik={
        seqType=mechLib.brik.techrashChallenge.easy_seqType,
        event={
            playerInit=mechLib.brik.techrashChallenge.easy_event_playerInit,
            afterLock=mechLib.brik.techrashChallenge.easy_event_afterLock,
            afterClear={
                mechLib.brik.techrashChallenge.easy_event_afterClear,
                mechLib.brik.music.techrash_easy_afterClear,
                mechLib.brik.progress.techrash_easy_afterClear,
            },
            drawInField=mechLib.brik.techrashChallenge.easy_event_drawInField,
            drawOnPlayer=mechLib.brik.techrashChallenge.easy_event_drawOnPlayer,
        },
    }},
}
