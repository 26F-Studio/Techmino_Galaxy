---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        event={
            playerInit=mechLib.common.exterior.sprint_event_playerInit,
        },
    }},
}
