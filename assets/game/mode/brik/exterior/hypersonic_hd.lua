---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('secret7th_hidden')
        FMOD.music.seek(MATH.roundUnit(FMOD.music.tell(),60/130))
    end,
    settings={brik={
        event={
            playerInit="mechLib.brik.hypersonic.event_playerInit_auto(P,'hidden')",
            afterSpawn=mechLib.brik.music.hypersonic_hd_afterSpawn,
            gameOver=mechLib.brik.progress.hypersonic_hd_gameOver,
        },
    }},
}
