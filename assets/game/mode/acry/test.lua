return {
    initialize=function()
        GAME.newPlayer(1,'acry')
        GAME.setMain(1)
    end,
    settings={acry={
        readyDelay=1000,
        swap=true,
        swapForce=false,
        twistR=true,twistL=true,twistF=true,
        twistForce=false,
    }},
}
