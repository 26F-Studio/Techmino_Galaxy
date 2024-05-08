---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('secret7th')
    end,
    settings={brik={
        event={
            playerInit="mechLib.brik.hypersonic.event_playerInit_auto(P,'high')",
            afterSpawn=mechLib.brik.music.hypersonic_hi_afterSpawn,
            afterClear=mechLib.brik.progress.hypersonic_hi_afterClear,
            gameOver=mechLib.brik.progress.hypersonic_hi_gameOver,
        },
    }},
}
