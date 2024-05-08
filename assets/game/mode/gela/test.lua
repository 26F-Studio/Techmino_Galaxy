---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'gela')
        GAME.setMain(1)
    end,
    settings={gela={
        readyDelay=1000,
    }},
}
