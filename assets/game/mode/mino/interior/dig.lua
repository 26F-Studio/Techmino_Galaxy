return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
        BG.set('none')
    end,
    settings={mino={
        skin='mino_interior',
        particles=false,
        shakeness=0,
        soundEvent={
            countDown=function(num)
                SFX.playSample('lead',num>0 and 'E4' or 'E5')
            end,
        },
        event={
            playerInit=mechLib.mino.dig.practice_event_playerInit[12],
            afterClear=mechLib.mino.dig.practice_event_afterClear,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if P and P.finished=='AC' then
            PROGRESS.setInteriorScore('dig',
                P.gameTime<=30e3  and 160 or
                P.gameTime<=60e3  and MATH.interpolate(P.gameTime,60e3,120,30e3,160) or
                P.gameTime<=120e3 and MATH.interpolate(P.gameTime,120e3,90,60e3,120) or
                math.max(MATH.interpolate(P.gameTime,200e3,40,120e3,90),0)
            )
        end
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end

        local line=math.min(12-P.modeData.lineExist,math.floor(math.max(time-.26,0)*16))

        -- XX/12
        FONT.set(100)
        GC.setColor(COLOR.L)
        GC.mStr(line.." / 12",800,350)

        -- Bar frame
        GC.setLineWidth(6)
        GC.rectangle('line',800-200-15,550-50-15,400+30,100+30)

        -- Filling bar
        if line==12 then
            GC.setColor(1,.4,.4,.8)
        else
            GC.setColor(1,1,1,.626)
        end
        GC.rectangle('fill',800-200,550-50,line/12*400,100)

        -- Timer
        if line==12 and time>1.26 then
            FONT.set(60)
            GC.setColor(COLOR.L)
            GC.mStr(STRING.time(P.gameTime/1000),800,510)
        end
    end,
}
