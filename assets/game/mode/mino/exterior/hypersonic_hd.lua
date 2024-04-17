---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('secret7th_hidden')
        FMOD.seekMusic(MATH.roundUnit(FMOD.tellMusic(),60/130))
    end,
    settings={mino={
        event={
            playerInit="mechLib.mino.hypersonic.event_playerInit_auto(P,'hidden')",
            afterSpawn=mechLib.mino.music.hypersonic_hd_afterSpawn,
            gameOver=mechLib.mino.progress.hypersonic_hd_gameOver,
        },
    }},
}
