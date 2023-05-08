return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('propel','base')
    end,
    settings={mino={
        spawnDelay=130,
        clearDelay=300,
        event={
            playerInit=mechLib.mino.marathon.event_playerInit_auto,
            afterClear=function(P)
                if not P.modeData.marathon_bgmLevel then P.modeData.marathon_bgmLevel=1 end
                if P.isMain and P.modeData.level>P.modeData.marathon_bgmLevel then
                    if P.modeData.marathon_bgmLevel<15 then
                        BGM.set({
                            'propel/accompany1',
                            'propel/accompany3',
                            'propel/bass3',
                        },'volume',math.min(P.modeData.level/15,1)^2)
                    end
                    if P.modeData.level>=25 and P.modeData.marathon_bgmLevel<25 then
                        BGM.set({'propel/melody','propel/accompany1','propel/accompany3'},'volume',0,26)
                    end
                    if P.modeData.level>=20 then
                        BGM.set('propel/drum','volume',math.min(.2+(P.modeData.level-20)*.8,1),10)
                    end
                    P.modeData.marathon_bgmLevel=P.modeData.level
                end
            end,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if not P then return end
        if P.modeData.line<40 then return end

        local dropInfo={}

        local finalTime=P.time-3000

        for i,d in next,P.dropHistory do
            table.insert(dropInfo,{
                x=(d.time-3000)/finalTime,
                y=i/#P.dropHistory,
            })
        end

        P.modeData.finalTime=finalTime
        P.modeData.dropInfo=dropInfo
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end
        if not P.modeData.finalTime then
            FONT.set(100)
            GC.setColor(1,1,1,math.min(time*2.6,1))
            GC.mStr(P.modeData.line.." / 200",800,400)
            return
        end

        local t=MATH.expApproach(0,1,time^2*26)
        local maxH=600*MATH.expApproach(0,1,math.max(time-.26,0)^2*12.6)

        -- Set axis' trasformation
        GC.translate(400,800)
        GC.scale(1,-1)

        -- Piece-time
        local dropData=P.modeData.dropInfo
        lastX,lastY=0,0
        for i=1,#dropData do
            local clr=i>P.modeData.transition2 and COLOR.R or i>P.modeData.transition1 and COLOR.Y or COLOR.G
            -- Fill
            GC.setColor(clr[1],clr[2],clr[3],.6)
            GC.polygon('fill',
                800*t*lastX,0,
                800*t*lastX,lastY*maxH,
                800*t*dropData[i].x,dropData[i].y*maxH,
                800*t*dropData[i].x,0
            )
            -- Line
            GC.setLineWidth(2)
            GC.setColor(clr)
            GC.line(
                800*t*lastX,lastY*maxH,
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
