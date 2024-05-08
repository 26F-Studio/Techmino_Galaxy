---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('distortion')
    end,
    settings={brik={
        event={
            playerInit="mechLib.brik.hypersonic.event_playerInit_auto(P,'titanium')",
            afterSpawn=mechLib.brik.music.hypersonic_ti_afterSpawn,
            afterClear=mechLib.brik.progress.hypersonic_ti_afterClear,
        },
    }},
}
