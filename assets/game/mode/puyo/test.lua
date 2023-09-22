--- @type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'puyo')
        GAME.setMain(1)
    end,
    settings={puyo={
        readyDelay=1000,
    }},
}
