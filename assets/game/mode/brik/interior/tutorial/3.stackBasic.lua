---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('space')
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        readyDelay=1,
        spawnDelay=62,
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=3,
        holdSlot=1,
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.score=0
                P.modeData.scoreDisp=0
                P.modeData.maxScore=0
            end,
            gameStart=function(P)
                P.spawnTimer=1500
            end,
            always=function(P)
                P.modeData.scoreDisp=MATH.expApproach(P.modeData.scoreDisp,P.modeData.score,0.0042)
                P.modeData.maxScore=math.max(P.modeData.scoreDisp,P.modeData.maxScore)
                if P.modeData.maxScore>=1 then
                    P.modeData.score,P.modeData.scoreDisp,P.modeData.maxScore=1,1,1
                    P:finish('taskfail')
                end
            end,
            afterClear={
                function(P,clear)
                    P.modeData._clear=clear
                end,
            },
            beforeDiscard=function(P)
                if P.stat.line>=20 then
                    P:finish('win')
                    local normalClear=P.stat.clears[4]<MATH.sum(P.stat.clears)
                    P:say{duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='beat',c=COLOR.lG,y=-30}
                    if not normalClear then
                        P:say{duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='flicker',c=COLOR.Y,y=-30}
                        PROGRESS.setTutorialPassed(3,2)
                    else
                        PROGRESS.setTutorialPassed(3,1)
                    end
                else
                    local unstabality=0

                    local HBC,VBC=AI.paperArtist.getBoundCount(P.field:export_table_simp())
                    unstabality=unstabality+HBC*4+VBC*2

                    local heights=AI.util.getColumnHeight(P.field._matrix)
                    local diffHeights={}
                    for i=1,#heights-1 do
                        diffHeights[i]=math.min((heights[i+1]-heights[i])^2,12)
                    end
                    unstabality=unstabality+MATH.sum(diffHeights)

                    P.modeData.score=unstabality/100
                end
            end,
            drawOnPlayer=function(P)
                local x,w,h=-320,40,355
                local s=P.modeData.scoreDisp
                GC.setColor(2*s,(2-2*s)*0.95,0)
                GC.rectangle('fill',x,h/2,w,-h*s)
                GC.setColor(COLOR.L)
                GC.setLineWidth(2)
                GC.rectangle('line',x,h/2,w,-h)
                GC.setLineWidth(4)
                GC.line(x,h/2-h*P.modeData.maxScore,x+w,h/2-h*P.modeData.maxScore)
                FONT.set(60,'bold')
                GC.mStr(math.max(20-P.stat.line,0),-300,226)
            end,
        },
        script={
            {cmd='say',arg={duration='3s',text="@tutorial_stackBasic_1",size=80,type='bold',style='beat',y=-60}},
            "[3s]",
            {cmd='say',arg={duration='10s',text="@tutorial_stackBasic_2",size=35,y=-60}},
            "[10s]",
            {cmd='say',arg={duration='10s',text="@tutorial_stackBasic_3",size=35,y=-60}},
            "[10s]",
            {cmd='say',arg={duration='10s',text="@tutorial_stackBasic_4",size=35,y=-60}},
            "[10s]",
            {cmd='say',arg={duration='10s',text="@tutorial_stackBasic_5",size=35,y=-60}},
        },
    }},
    result=autoBack_interior,
}
