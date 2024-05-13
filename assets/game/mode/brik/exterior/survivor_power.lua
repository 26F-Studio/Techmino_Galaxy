---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('here')
    end,
    settings={brik={
        atkSys='modern',
        allowCancel=true,
        initialRisingSpeed=1,
        risingAcceleration=.001,
        risingDeceleration=.001,
        maxRisingSpeed=1,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.brik.survivor.event_playerInit,
            always=mechLib.brik.survivor.power_event_always,
            afterClear={
                mechLib.brik.music.survivor_power_afterClear,
                mechLib.brik.progress.survivor_power_afterClear,
            },
            drawOnPlayer=mechLib.brik.survivor.event_drawOnPlayer,
        },
    }},
}
