---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('sugar fairy')
    end,
    settings={brik={
        event={
            playerInit=function(P)
                P.modeData.maxSimplicity=0
                P.modeData.simplicity=0
                P.settings.pieceVisTime=260
                P.settings.pieceFadeTime=260
            end,
            afterClear={
                mechLib.brik.sprint.event_afterClear[100],
                function(P,clear)
                    if clear.line<4 then
                        P.modeData.simplicity=P.modeData.simplicity+1
                    end
                    P.modeData.simplicity=math.min(P.modeData.simplicity,20-math.floor(P.modeData.stat.line/5))
                    P.modeData.maxSimplicity=math.max(P.modeData.maxSimplicity,P.modeData.simplicity)
                    P.settings.pieceVisTime=math.floor(MATH.interpolate(1,620,20,2e3,MATH.clamp(P.modeData.simplicity,3,20)))
                    P.settings.pieceFadeTime=math.floor(MATH.interpolate(1,420,20,1e3,MATH.clamp(P.modeData.simplicity,3,20)))
                end,
                {1e62,function(P)
                    if not P.isMain then return true end
                    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
                end},
            },
            drawInField=mechLib.brik.sprint.event_drawInField[100],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[100],
            gameOver={
                mechLib.brik.misc.slowHide_event_gameOver,
            },
        },
    }},
}
