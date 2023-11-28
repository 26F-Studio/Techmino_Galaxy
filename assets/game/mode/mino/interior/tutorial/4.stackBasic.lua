local correctPositions={
    { -- Quest 1
        {x=1,y=1,dir={0},       msg="tutorial_stackBasic_m1"},
        {x=4,y=1,dir={0,2}},
        {x=7,y=1,dir={0,2}},
        {x=5,y=2,dir={0,1,2,3}, msg="tutorial_stackBasic_m2"},
        {x=2,y=2,dir={0}},
        {x=4,y=3,dir={2}},
        {x=1,y=3,dir={0,2},     msg="tutorial_stackBasic_m3"},
        {x=7,y=2,dir={2}},
        {x=6,y=4,dir={0,2}},
        {x=1,y=4,dir={1},       msg="tutorial_stackBasic_m4"},
        {x=8,y=4,dir={1,3}},
        {x=10,y=1,dir={1,3},    msg="tutorial_stackBasic_m5"},
    },
    { -- Quest 2
        {x=3,y=1,dir={0}},
        {x=6,y=2,dir={0,1,2,3}},
        {x=3,y=2,dir={0,1,2,3}},
        {x=1,y=2,dir={1,3},     msg="tutorial_stackBasic_m6"},
        {x=8,y=2,dir={3}},
    }
}

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('space','simp')
    end,
    settings={mino={
        skin='mino_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        readyDelay=1,
        spawnDelay=62,
        dropDelay=1e99,
        lockDelay=1e99,
        deathDelay=0,
        nextSlot=3,
        holdSlot=0,
        seqType='none',
        soundEvent={countDown=NULL},
        event={
            playerInit=function(P)
                P.modeData.waitTime=0
                P.modeData.msgTimer=0
            end,
            gameStart=function(P)
                P.spawnTimer=1500
                P.modeData.msg=false
            end,
            always=function(P)
                P.modeData.waitTime=P.modeData.waitTime+1
                P.modeData.msgTimer=P.modeData.msgTimer+1
            end,
            afterResetPos=function(P)
                local ans=P.modeData.quest==1 and correctPositions[1][12-#P.nextQueue] or correctPositions[2][9-#P.nextQueue]
                local shape=TABLE.shift(Mino.getShape(P.hand.name),1)
                if ans then
                    if ans.dir[1]~=0 then
                        shape=TABLE.rotate(shape,ans.dir[1]==1 and 'R' or ans.dir[1]==2 and ans.dir[1] and 'F' or 'L')
                    end
                    P.modeData.x,P.modeData.y=ans.x,ans.y
                    P.modeData.dir=ans.dir
                    P.modeData.shape=shape
                    P.modeData.waitTime=0
                    if ans.msg~=nil and P.modeData.msg~=ans.msg then
                        P.modeData.msg=ans.msg
                        P.modeData.msgTimer=0
                    end
                end
            end,
            afterDrop=function(P)
                if P.modeData.shape and not (P.handX==P.modeData.x and P.handY==P.modeData.y and TABLE.find(P.modeData.dir,P.hand.direction)) then
                    table.insert(P.nextQueue,1,P:getMino(Mino.getID(P.hand.name)))
                    P.hand=false
                else
                    P.modeData.shape=false
                end
            end,
            afterLock=function(P)
                if #P.nextQueue==0 then
                    P.modeData.signal=
                        mechLib.mino.clearRule.line.isFill(P,1) and
                        mechLib.mino.clearRule.line.isFill(P,2) and
                        mechLib.mino.clearRule.line.isFill(P,3) and
                        mechLib.mino.clearRule.line.isFill(P,4) or false
                end
            end,
            drawBelowMarks=function(P)
                local m=P.modeData.shape
                if type(m)=='table' then
                    GC.setColor(1,1,1,.42*(math.min(P.modeData.waitTime/126,1)+.42*math.sin(P.modeData.waitTime*.01)))
                    GC.setLineWidth(6)
                    for y=1,#m do for x=1,#m[1] do
                        local C=m[y][x]
                        if C then
                            GC.rectangle('line',(P.modeData.x+x-2)*40+7,-(P.modeData.y+y-1)*40+7,26,26)
                        end
                    end end
                end
            end,
            drawOnPlayer=function(P)
                if P.modeData.msg then
                    FONT.set(35)
                    GC.setColor(1,.75,.7,math.min(P.modeData.msgTimer/260,1))
                    GC.mStr(Text[P.modeData.msg],0,-30)
                end
            end,
        },
        script={
            {cmd='say',arg={duration='1.5s',text="@tutorial_stackBasic_1",y=-60}},

            "setc quest,1",
            "setc signal,nil",
            "pushNext JIZOTLSJZTSI",
            "wait signal",

            "setc quest,2",
            "setc signal,nil",
            "pushNext LOOSTJZLI",
            "wait signal",
            "jeq win,signal,true",

            "rewind:",
            "pushNext JZLI",
            "setc signal,nil",
            {cmd=function(P)
                P:setField{
                    sudden=true,
                    {2,0,0,0,0,0,0,0,5,0},
                    {2,2,6,6,0,6,6,5,5,0},
                    {5,2,6,6,4,6,6,2,5,0},
                    {5,5,4,4,4,1,1,2,2,0},
                }
            end},
            "wait signal",
            "jeq rewind,signal,false",

            "win:",
            "sfx win",

            "setc msg,false",

            {cmd='say',arg={duration='6.26s',text="@tutorial_pass",size=120,type='bold',style='beat',c=COLOR.lG,y=-30}},
            {cmd=function(P) if P.isMain then PROGRESS.setTutorialPassed(4) end end},
            "finish AC",
        },
    }},
    result=autoQuitInterior,
}
