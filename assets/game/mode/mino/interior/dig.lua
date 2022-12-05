return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
        BG.set('none')
    end,
    settings={mino={
        skin='mino_interior',
        shakeness=0,
        dropDelay=1000,
        lockDelay=1000,
        soundEvent={
            countDown=function(num)
                SFX.playSample('lead',num>0 and 'A3' or 'A4')
            end,
        },
        event={
            playerInit=function(P)
                local phase=P.seqRND:random(0,9)
                local dir=P.seqRND:random(0,1)*2-1
                for i=1,12 do P:riseGarbage((phase+i)*dir%10+1) end
                P.fieldDived=0
                P.modeData.garbageRemain=12
            end,
            afterLock=function(P)
                P.modeData.garbageRemain=math.min(P.modeData.garbageRemain,P.dropHistory[#P.dropHistory].y-1)
                if P.modeData.garbageRemain==0 then
                    P:finish('AC')
                end
            end,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if P and P.finished=='AC' then
            PROGRESS.setInteriorScore('dig',
                P.gameTime<=30e3  and 160 or
                P.gameTime<=60e3  and MATH.interpolate(P.gameTime,60e3,120,30e3,160) or
                P.gameTime<=120e3 and MATH.interpolate(P.gameTime,120e3,90,60e3,120) or
                MATH.interpolate(P.gameTime,200e3,40,120e3,90)
            )
        end
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end

        local line=math.min(12-P.modeData.garbageRemain,math.floor(math.max(time-.26,0)*16))

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
