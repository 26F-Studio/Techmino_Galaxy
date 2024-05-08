---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('sakura')
        FMOD.music.seek(0)
    end,
    settings={brik={
        event={
            playerInit="mechLib.common.timer.new(P,120e3,mechLib.common.finish.TLE,'info')",
        },
    }},
}
