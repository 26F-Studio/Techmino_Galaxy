---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('secret8th','base')
    end,
    settings={mino={
        event={
            playerInit="mechLib.mino.hypersonic.event_playerInit_auto(P,'low')",
            afterSpawn=mechLib.mino.progress.hypersonic_lo_afterSpawn,
            afterClear=mechLib.mino.progress.hypersonic_lo_afterClear,
            gameOver=mechLib.mino.progress.hypersonic_lo_gameOver,
        },
    }},
}
