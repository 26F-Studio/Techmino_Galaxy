local function newQuestion(P)
    mechLib.brik.allclearGenerator.newQuestion(P,{
        debugging=false,
        pieceCount=3+math.floor(P.stat.allclear^.6),
        holdUsed=true,
    })
end

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('truth',true)
    end,
    settings={brik={
        nextSlot=8,
        clearDelay=260,
        seqType=function()
        end,
        event={
            playerInit=function(P)
                P.settings.asd=math.max(P.settings.asd,100)
                P.settings.asp=math.max(P.settings.asp,20)
                newQuestion(P)
                return 1,2
            end,
            beforePress=mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
            afterClear=function(P)
                if P.field:getHeight()==0 then
                    newQuestion(P)
                end
            end,
        },
    }},
}
