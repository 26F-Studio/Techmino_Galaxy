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
                for i=0,9 do P:riseGarbage((phase+i)*dir%10+1) end
                P.fieldDived=0
            end,
            afterLock=function(P)
                if P.dropHistory[#P.dropHistory].y==1 then
                    P:finish('AC')
                    PROGRESS.setInteriorScore('dig',
                        P.gameTime<=30e3  and 200 or
                        P.gameTime<=60e3  and MATH.interpolate(P.gameTime,60e3,140,30e3,200) or
                        P.gameTime<=120e3 and MATH.interpolate(P.gameTime,120e3,90,60e3,140) or
                        MATH.interpolate(P.gameTime,200e3,40,120e3,90)
                    )
                end
            end,
        },
    }},
}
