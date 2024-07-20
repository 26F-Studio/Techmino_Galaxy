---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
        BG.set('none')
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        deathDelay=0,
        soundEvent={countDown=mechLib.brik.misc.interior_soundEvent_countDown},
        event={
            playerInit=function(P)
                P.modeData.target.line=40
                mechLib.common.music.set(P,{path='stat.line',s=10,e=30},'afterClear')
            end,
            afterClear=mechLib.brik.misc.lineClear_event_afterClear,
            drawOnPlayer=mechLib.brik.misc.lineClear_event_drawOnPlayer,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if not P then return end
        if P.finished=='AC' then
            P.stat.line=40
            PROGRESS.setInteriorScore('marathon',30)
            PROGRESS.setInteriorScore('sprint',
                P.gameTime<60e3  and 200 or
                P.gameTime<90e3  and MATH.interpolate(90e3,140,60e3,200,P.gameTime) or
                P.gameTime<180e3 and MATH.interpolate(180e3,90,90e3,140,P.gameTime) or
                P.gameTime<300e3 and MATH.interpolate(300e3,40,180e3,90,P.gameTime) or
                40
            )
        else
            PROGRESS.setInteriorScore('marathon',P.stat.line*0.75)
            PROGRESS.setInteriorScore('sprint',P.stat.line)
        end
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end

        local line=math.min(P.stat.line,math.floor(math.max(time-.26,0)*62),40)

        -- XX/40
        FONT.set(100)
        GC.setColor(COLOR.L)
        GC.mStr(line.." / 40",800,350)

        -- Bar frame
        GC.setLineWidth(6)
        GC.rectangle('line',800-300-15,550-50-15,600+30,100+30)

        -- Filling bar
        if line>=40 then
            GC.setColor(.2,1,.4,.626)
        else
            GC.setColor(1,1,1,.626)
        end
        GC.rectangle('fill',800-300,550-50,math.floor(line/4)*4/40*600,100)

        -- Timer
        if line>=40 and time>1.26 then
            FONT.set(60)
            GC.setColor(COLOR.L)
            GC.mStr(STRING.time(P.gameTime/1000),800,510)
        end
    end,
}
