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
                        P.modeData.simplicity=P.modeData.simplicity+(5-clear.line)
                    else
                        P.modeData.simplicity=P.modeData.simplicity-2
                    end
                    P.modeData.simplicity=math.min(P.modeData.simplicity,62-math.floor(P.modeData.stat.line/5))
                    P.modeData.maxSimplicity=math.max(P.modeData.maxSimplicity,P.modeData.simplicity)
                    P.settings.pieceVisTime=math.floor(MATH.cLerp(260,2e3,P.modeData.simplicity/62))
                    P.settings.pieceFadeTime=math.floor(MATH.cLerp(260,1e3,P.modeData.simplicity/62))
                end,
                {1e62,function(P)
                    if not P.isMain then return true end
                    FMOD.music.setParam('intensity',MATH.icLerp(10,30,P.modeData.stat.line))
                end},
            },
            drawInField=mechLib.brik.sprint.event_drawInField[100],
            drawOnPlayer=mechLib.brik.sprint.event_drawOnPlayer[100],
            gameOver=function(P)
                if P.modeData.stat.line<100 then
                    PROGRESS.setExteriorScore('hidden','line',P.modeData.stat.line)
                else
                    if P.modeData.stat.line==100 and P.modeData.stat.clears[1]+P.modeData.stat.clears[2]+P.modeData.stat.clears[3]==0 then
                        PROGRESS.setSecret('exterior_hidden_superBrain')
                    end
                    PROGRESS.setExteriorScore('hidden','easy',P.gameTime,'<')
                    if P.modeData.maxSimplicity<=12 then
                        PROGRESS.setExteriorScore('hidden','hard',P.gameTime,'<')
                        P:showInvis(1,P.settings.pieceFadeTime/2)
                    else
                        P:showInvis(2,P.settings.pieceFadeTime)
                    end
                end
            end,
        },
    }},
}
