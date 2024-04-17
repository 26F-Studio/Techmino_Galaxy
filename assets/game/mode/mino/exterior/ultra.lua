---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('sakura')
        FMOD.seekMusic(0)
    end,
    settings={mino={
        event={
            playerInit="mechLib.common.timer.new(P,120e3,mechLib.common.finish.TLE,'info')",
        },
    }},
}
