return {
    initialize=function()
        GAME.newPlayer(1,'gem')
        GAME.setMain(1)
    end,
    settings={gem={
        readyDelay=1000,
        swap=true,
        swapForce=false,
        twistR=true,twistL=true,twistF=true,
        twistForce=false,
    }},
}
