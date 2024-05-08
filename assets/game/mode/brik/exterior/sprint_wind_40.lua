---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        dropDelay=20,
        lockDelay=2600,
        asd=126,
        asp=26,
        maxFreshChance=1e99,
        event={
            playerInit=mechLib.brik.misc.wind_switch_auto,
            afterClear={
                mechLib.brik.sprint.event_afterClear[40],
                mechLib.brik.music.sprint_wind_40_afterClear,
            },
            drawInField=mechLib.brik.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.brik.progress.sprint_wind_40_gameOver,
        },
    }},
}
