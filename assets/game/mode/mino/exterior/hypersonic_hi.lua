return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('secret7th','base')
    end,
    settings={mino={
        event={
            playerInit="mechLib.mino.hypersonic.event_playerInit_auto(P,'high')",
            afterSpawn=mechLib.mino.progress.hypersonic_hi_afterSpawn,
            afterClear=mechLib.mino.progress.hypersonic_hi_afterClear,
            gameOver=mechLib.mino.progress.hypersonic_hi_gameOver,
        },
    }},
}
