---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        spin_immobile=true,
        spin_corners=3,
        event={
            playerInit=mechLib.mino.tsdChallenge.easy_event_playerInit,
            afterClear=mechLib.mino.tsdChallenge.easy_event_afterClear,
            drawOnPlayer=mechLib.mino.tsdChallenge.easy_event_drawOnPlayer,
        },
    }},
}
