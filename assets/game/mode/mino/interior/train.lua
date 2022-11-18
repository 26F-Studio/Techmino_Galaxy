return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_interior',
        dropDelay=1e99,
        lockDelay=1e99,
        infHold=true,
        spawnDelay=100,
        soundEvent={
            countDown=function(num)
                SFX.playSample('lead',num>0 and 'A3' or 'A4')
            end,
        },
        event={
            -- Display ghost at not-bad places to help new players learn stacking
            always=function(P)
                P.modeData.waitTime=P.modeData.waitTime+1
            end,
            afterResetPos=function(P)
                local field=P.field:export_table_simp()
                local m=P.hand.matrix
                local shape={}
                for y=1,#m do
                    shape[y]={}
                    for x=1,#m[y] do
                        shape[y][x]=m[y][x] and true or false
                    end
                end
                local x,y,dir=AI.retard.findPosition(field,shape)
                P.modeData.x,P.modeData.y,P.modeData.shape=x,y,TABLE.rotate(shape,dir)
                P.modeData.waitTime=0
                -- if dir~='0' then P:rotate(dir) end
                -- P.handX,P.handY=P.modeData.x,P.modeData.y
                -- P:minoDropped()
            end,
            drawBelowMarks=function(P)
                local m=P.modeData.shape
                if type(m)=='table' then
                    GC.setColor(1,1,1,math.min(P.modeData.waitTime/260,1)*.26-.1*math.cos(P.modeData.waitTime*.006))
                    for y=1,#m do for x=1,#m[1] do
                        local C=m[y][x]
                        if C then
                            GC.rectangle('fill',(P.modeData.x+x-2)*40,-(P.modeData.y+y-1)*40,40,40)
                        end
                    end end
                end
            end
        },
    }},
}
