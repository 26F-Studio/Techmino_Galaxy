---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        initialRisingSpeed=0,
        risingAcceleration=.0006,
        risingDeceleration=.0002,
        maxRisingSpeed=0.5,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.mino.survivor.event_playerInit,
            always=mechLib.mino.survivor.spike_event_always,
            afterClear={
                mechLib.mino.music.survivor_spike_afterClear,
                mechLib.mino.progress.survivor_spike_afterClear,
            },
            drawOnPlayer=mechLib.mino.survivor.event_drawOnPlayer,
        },
    }},
}
