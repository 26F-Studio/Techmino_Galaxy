---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('secret8th')
    end,
    settings={brik={
        event={
            playerInit="mechLib.brik.hypersonic.event_playerInit_auto(P,'low')",
            afterSpawn=mechLib.brik.music.hypersonic_lo_afterSpawn,
            afterClear=mechLib.brik.progress.hypersonic_lo_afterClear,
            gameOver=mechLib.brik.progress.hypersonic_lo_gameOver,
        },
    }},
}
