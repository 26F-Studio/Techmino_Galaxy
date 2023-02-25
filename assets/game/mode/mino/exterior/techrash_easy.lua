local gc=love.graphics

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        seqType=function(P)
            P.modeData.bagLoop=0
            local l={}
            local l2={}
            while true do
                -- Fill list1 (bag7 + 0~4)
                if not l[1] then
                    P.modeData.bagLoop=P.modeData.bagLoop+1
                    for i=1,7 do table.insert(l,i) end
                    for _=1,
                        P.modeData.bagLoop<=4  and 0 or
                        P.modeData.bagLoop<=10 and 1 or
                        P.modeData.bagLoop<=20 and 2 or
                        P.modeData.bagLoop<=40 and 3 or
                        4
                    do
                        -- Fill list2 (bag6)
                        if not l2[1] then for i=1,6 do table.insert(l2,i) end end
                        table.insert(l,table.remove(l2,P.seqRND:random(#l2)))
                    end
                end
                coroutine.yield(table.remove(l,P.seqRND:random(#l)))
            end
        end,
        event={
            playerInit=function(P)
                P.modeData.techrash=0
                P.modeData.minH=0
            end,
            afterLock=function(P)
                local minH=P.field:getHeight()
                for x=1,P.settings.fieldW do
                    for y=P.field:getHeight(),0,-1 do
                        if P.field:getCell(x,y) then
                            if y<minH then minH=y end
                            break
                        end
                    end
                end
                P.modeData.minH=minH
            end,
            afterClear=function(P,movement)
                P:triggerEvent('afterLock')-- Another Fresh
                if P.hand.name=='I' and #movement.clear==4 then
                    P.modeData.techrash=P.modeData.techrash+1
                    local semiPC=P.field:getHeight()==0
                    if not semiPC then
                        semiPC=true
                        for x=1,P.settings.fieldW do
                            if #P:getConnectedCells(x,1)%4~=0 then
                                semiPC=false
                                break
                            end
                        end
                    end
                    if semiPC then
                        P:playSound('frenzy')
                        P.modeData.bagLoop=P.modeData.bagLoop-1
                    end
                else
                    P:finish('PE')
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                for y=P.modeData.minH+4,19,4 do
                    gc.rectangle('fill',0,-y*40-2,P.settings.fieldW*40,4)
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(P.modeData.techrash,-300,-55)
                FONT.set(30)
                GC.mStr("Techrash",-300,30)
            end,
        },
    }},
}
