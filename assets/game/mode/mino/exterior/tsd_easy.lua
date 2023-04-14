return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        spin_immobile=true,
        spin_corners=3,
        event={
            playerInit=function(P)
                P.modeData.tsd=0
            end,
            afterClear=function(P,clear)
                local movement=P.lastMovement
                if P.hand.name=='T' and clear.line==2 and movement.action=='rotate' and (movement.corners or movement.immobile) then
                    P.modeData.tsd=P.modeData.tsd+1
                else
                    P:finish('PE')
                end
            end,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80) GC.mStr(P.modeData.tsd,-300,-70)
                FONT.set(30) GC.mStr("TSD",-300,15)
            end,
        },
    }},
}
