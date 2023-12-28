---@type Techmino.Mode
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
                P.modeData.ac=0
                P.settings.asd=math.max(P.settings.asd,100)
                P.settings.asp=math.max(P.settings.asp,20)
                mechLib.mino.acGenerator.newQuestion(P,{debugging=false,pieceCount=3,holdUsed=true})
            end,
            afterClear=function(P)
                if P.field:getHeight()==0 then
                    mechLib.mino.acGenerator.newQuestion(P,{debugging=false,pieceCount=3+math.floor(P.modeData.stat.allclear^.626),holdUsed=true})
                end
            end,
        },
    }},
}
