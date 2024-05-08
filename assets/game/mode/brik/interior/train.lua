---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        readyDelay=0,
        dropDelay=1e99,
        lockDelay=1e99,
        deathDelay=0,
        infHold=true,
        -- spawnDelay=26,
        soundEvent={countDown=mechLib.brik.misc.interior_soundEvent_countDown},
        event={ -- Display ghost at not-bad places to help new players learn stacking
            playerInit=function(P)
                P.modeData.waitTime=0
                P.modeData.hint=true
                P.modeData.hint_x,P.modeData.hint_y=false,false
                P.modeData.hint_matrix=false
                P.modeData.hint_obey=0
            end,
            always=function(P)
                P.modeData.waitTime=P.modeData.waitTime+1
            end,
            afterResetPos=function(P)
                if P.modeData.hint then
                    local field=P.field:export_table_simp()
                    local m=P.hand.matrix
                    local shape={}
                    for y=1,#m do
                        shape[y]={}
                        for x=1,#m[y] do
                            shape[y][x]=m[y][x] and true or false
                        end
                    end
                    local x,y,dir=AI.paperArtist.findPosition(field,shape)
                    P.modeData.hint_x,P.modeData.hint_y=x,y
                    P.modeData.hint_matrix=TABLE.rotate(shape,dir)
                    P.modeData.waitTime=0
                    -- if dir~='0' then P:rotate(dir) end
                    -- P.handX,P.handY,P.ghostY=P.modeData.hint_x,P.modeData.hint_y,P.modeData.hint_y
                    -- P:brikDropped()
                end
            end,
            afterLock={
                function(P)
                    if P.modeData.hint and P.handX==P.modeData.hint_x and P.handY==P.modeData.hint_y then
                        if P:compareMatrix(P.modeData.hint_matrix) then
                            P.modeData.hint_obey=P.modeData.hint_obey+1
                        end
                    end
                end,
                mechLib.brik.misc.invincible_event_afterLock,
            },
            afterClear=function(P)
                if P.modeData.hint and P.modeData.hint_obey==0 and P.modeData.stat.line>=20 then
                    -- Nice.
                    P.modeData.hint=false
                    P.modeData.hint_x,P.modeData.hint_y=false,false
                    P.modeData.hint_matrix=false
                end
            end,
            drawBelowMarks=function(P)
                local m=P.modeData.hint_matrix
                if m then
                    GC.setColor(1,1,1,.42*(math.min(P.modeData.waitTime/126,1)+.42*math.sin(P.modeData.waitTime*.01)))
                    GC.setLineWidth(6)
                    for y=1,#m do for x=1,#m[1] do
                        local C=m[y][x]
                        if C then
                            GC.rectangle('line',(P.modeData.hint_x+x-2)*40+7,-(P.modeData.hint_y+y-1)*40+7,26,26)
                        end
                    end end
                end
            end,
        },
    }},
    result=autoQuitInterior,
}
