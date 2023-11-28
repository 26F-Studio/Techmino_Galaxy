---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='basic',
        allowCancel=true,
        clearStuck=false,
        initialRisingSpeed=0,
        risingAcceleration=.003,
        risingDeceleration=.001,
        maxRisingSpeed=1,
        minRisingSpeed=1,
        event={
            playerInit=mechLib.mino.survivor.event_playerInit,
            always=mechLib.mino.survivor.cheese_event_always,
            afterClear=mechLib.mino.progress.survivor_cheese_afterClear,
            drawOnPlayer=mechLib.mino.survivor.event_drawOnPlayer,
        },
    }},
}
