---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
    end,
    settings={brik={
        event={
            playerInit=mechLib.common.exterior.dig_event_playerInit,
        },
    }},
}
