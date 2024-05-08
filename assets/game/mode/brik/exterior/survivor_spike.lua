---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('here')
    end,
    settings={brik={
        atkSys='nextgen',
        allowCancel=true,
        initialRisingSpeed=0,
        risingAcceleration=.0006,
        risingDeceleration=.0002,
        maxRisingSpeed=0.5,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.brik.survivor.event_playerInit,
            always=mechLib.brik.survivor.spike_event_always,
            afterClear={
                mechLib.brik.music.survivor_spike_afterClear,
                mechLib.brik.progress.survivor_spike_afterClear,
            },
            drawOnPlayer=mechLib.brik.survivor.event_drawOnPlayer,
        },
    }},
}
