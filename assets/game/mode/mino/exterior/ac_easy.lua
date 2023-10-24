--- @type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('truth','full')
    end,
    settings={mino={
        nextSlot=8,
        clearDelay=260,
        seqType=function()
        end,
        event={
            playerInit=function(P)
                P.settings.das=math.max(P.settings.das,100)
                P.settings.arr=math.max(P.settings.arr,20)
                mechLib.mino.acGenerator.newQuestion(P,{debugging=false,pieceCount=6,holdUsed=true})
            end,
            afterClear=function(P)
                if P.field:getHeight()==0 then
                    mechLib.mino.acGenerator.newQuestion(P,{debugging=false,pieceCount=6,holdUsed=true})
                end
            end,
        },
    }},
}
