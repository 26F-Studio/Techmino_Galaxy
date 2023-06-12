return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        seqType='bag7_sprint',
        event={
            playerInit={
                function(P)
                    P.modeData.lineTarget=40
                    P.modeData.keyCount={}
                    P.modeData.curKeyCount=0
                end,
                mechLib.mino.statistics.event_playerInit,
                "P:addEvent('afterClear',mechLib.mino.progress.sprint_40_afterClear)",
            },
            beforePress=function(P)
                P.modeData.curKeyCount=P.modeData.curKeyCount+1
            end,
            afterLock=function(P)
                table.insert(P.modeData.keyCount,P.modeData.curKeyCount)
                P.modeData.curKeyCount=0
            end,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if not P then return end
        if P.modeData.line<10 then return end

        local dropInfo={}
        local clearInfo={}

        local finalTime=P.gameTime
        local finRate=P.modeData.line/P.modeData.lineTarget
        local averageTime=finalTime/#P.dropHistory

        local lastPieceTime=3000
        for i,d in next,P.dropHistory do
            table.insert(dropInfo,{
                x=(d.time-3000)/finalTime*finRate,
                y=i/#P.dropHistory*finRate,
                choke=math.min(averageTime/(d.time-lastPieceTime),1),
                key=P.modeData.keyCount[i] or 0,
            })
            lastPieceTime=d.time
        end

        local _cleared=0
        for _,d in next,P.clearHistory do
            _cleared=math.min(_cleared+d.line,P.modeData.lineTarget)
            table.insert(clearInfo,{
                x=(d.time-3000)/finalTime*finRate,
                y=_cleared/P.modeData.lineTarget*(100/#P.dropHistory)*finRate,
            })
        end

        P.modeData.finalTime=finalTime
        P.modeData.dropInfo=dropInfo
        P.modeData.clearInfo=clearInfo
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end
        if not P.modeData.finalTime then
            FONT.set(100)
            GC.setColor(1,1,1,math.min(time*2.6,1))
            GC.mStr(P.modeData.line.." / "..P.modeData.lineTarget,800,400)
            return
        end

        local t=MATH.expApproach(0,1,time^2*26)
        local maxH=600*MATH.expApproach(0,1,math.max(time-.26,0)^2*12.6)

        -- Set axis' trasformation
        GC.translate(400,800)
        GC.scale(1,-1)

        -- Reference line
        GC.setLineWidth(6)
        GC.setColor(1,1,.626,.5)
        if P.modeData.line==P.modeData.lineTarget then
            GC.line(0,0,800*t,(100/#P.dropHistory)*600*t)
        else
            GC.line(0,0,800*t,600*t)
        end

        -- Line-time
        GC.setLineWidth(2)
        local clearData=P.modeData.clearInfo
        local lastX,lastY=0,0
        for i=1,#clearData do
            GC.setColor(.1,.1,1,.42)
            GC.polygon('fill',
                800*t*lastX,0,
                800*t*lastX,lastY*maxH,
                800*t*clearData[i].x,lastY*maxH,-- FLIP --
                -- 800*t*clearData[i].x,clearData[i].y*maxH,-- FLIP --
                800*t*clearData[i].x,0
            )
            GC.setColor(.2,.3,1)
            GC.line(
                800*t*lastX,lastY*maxH,
                800*t*clearData[i].x,lastY*maxH,-- FLIP --
                800*t*clearData[i].x,clearData[i].y*maxH
            )
            lastX,lastY=clearData[i].x,clearData[i].y
        end

        -- Piece-time
        local dropData=P.modeData.dropInfo
        lastX,lastY=0,0
        for i=1,#dropData do
            local gb=dropData[i].choke
            GC.setColor(.8+gb,gb,gb)
            -- KPP mark
            GC.setLineWidth(1)
            GC.circle('line',800*t*lastX,lastY*maxH,math.min(dropData[i].key^2/10,4))
            -- Line
            GC.setLineWidth(2)
            GC.line(
                800*t*lastX,lastY*maxH,
                800*t*dropData[i].x,lastY*maxH,-- FLIP --
                800*t*dropData[i].x,dropData[i].y*maxH
            )
            lastX,lastY=dropData[i].x,dropData[i].y
        end

        -- Axis
        GC.setLineWidth(2)
        GC.setColor(COLOR.dL)
        GC.line(0,600*t,0,0,800*t,0)
        FONT.set(30)
        GC.setColor(1,1,1,t)
        GC.printf(STRING.time(P.modeData.finalTime/1000),800*t-260,-10,260,'right',nil,1,-1)
    end,
}
