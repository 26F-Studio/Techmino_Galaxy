---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('here')
    end,
    settings={brik={
        atkSys='basic',
        allowCancel=true,
        allowBlock=false,
        initialRisingSpeed=0,
        risingAcceleration=.003,
        risingDeceleration=.001,
        maxRisingSpeed=1,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.brik.survivor.event_playerInit,
            always=mechLib.brik.survivor.cheese_event_always,
            afterClear={
                mechLib.brik.music.survivor_cheese_afterClear,
                mechLib.brik.progress.survivor_cheese_afterClear,
            },
            drawOnPlayer=mechLib.brik.survivor.event_drawOnPlayer,
        },
    }},
}
