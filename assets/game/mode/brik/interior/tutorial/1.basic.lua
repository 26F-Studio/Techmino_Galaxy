--[[
    （启用出块打断das）
    一块一个pc，讲解基础操作
    （会故意放几个不可能无意按出极简的情况，作为里关卡入口）
]]
local parScore={1e26,2,4,3,2}
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
        bufferMove=false,
        bufferRotate=false,
        stopMoveWhenSpawn=true,
        -- asd=120,
        -- asp=10,
        spawnDelay=260,
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=0,
        holdSlot=0,
        seqType='none',
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P:switchAction('rotateCW',false)
                P:switchAction('rotateCCW',false)
                P:switchAction('rotate180',false)
                P:switchAction('softDrop',false)
                P:switchAction('hardDrop',false)
                P.modeData.curKeyCount=0
                P.modeData.allFinesse=true
            end,
            gameStart=function(P)
                P.spawnTimer=5500
            end,
            afterResetPos=function(P)
                P.modeData.curKeyCount=0
            end,
            beforePress=function(P,act)
                if act=='hardDrop' then
                    if P.modeData.quest and P.modeData.curKeyCount>parScore[P.modeData.quest] then
                        P.modeData.allFinesse=false
                    end
                else
                    P.modeData.curKeyCount=P.modeData.curKeyCount+(
                        act=='moveLeft' and 1 or
                        act=='moveRight' and 1 or
                        act=='rotateCW' and 1 or
                        act=='rotateCCW' and 1 or
                        act=='rotate180' and 2 or
                        0
                    )
                end
            end,
            afterDrop=function(P)
                P.modeData.signal=P.handY==1
                if P.handY~=1 then P.hand=false end
            end,
        },
        script={
            {cmd='say',arg={duration='3s',text="@tutorial_basic_1",size=80,type='bold',style='beat',y=-60}},
            "[3s]",

            "pushNext O",
            {cmd='say',arg={duration='2s',text="@tutorial_basic_2",y=-60}},
            "[2s]",

            {cmd='say',arg={duration='6s',text="@tutorial_basic_3",size=50,y=-100}},
            "[3s]",

            {cmd='say',arg={duration='4s',text="@tutorial_basic_4",size=50,y=-30}},

            "switchAction hardDrop",
            "setc quest,1",
            "j skipFirstO",

            "setc quest,1",
            "quest1:",
            "pushNext O",
            "skipFirstO:",
            "setc signal,nil",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=P:random(4,6)
                d[1][r],d[2][r],d[1][r+1],d[2][r+1]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest1,signal,false",
            "sfx beep_rise",

            "setc quest,2",
            "quest2:",
            "setc signal,nil",
            "pushNext O",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=P:coin(3,7)
                d[1][r],d[2][r],d[1][r+1],d[2][r+1]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest2,signal,false",
            "sfx beep_rise",

            "switchAction rotateCW",
            "switchAction rotateCCW",
            "switchAction rotate180",
            {cmd='say',arg={duration='3s',text="@tutorial_basic_5",size=50,y=40}},

            "setc quest,3",
            "quest3:",
            "setc signal,nil",
            "pushNext T",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=P:coin(2,7)
                d[1][r],d[1][r+1],d[1][r+2],d[2][r+1]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest3,signal,false",
            "sfx beep_rise",

            "setc quest,4",
            "quest4:",
            "setc signal,nil",
            "pushNext J",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=P:coin(3,8)
                d[1][r+1],d[1][r],d[2][r],d[3][r]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest4,signal,false",
            "sfx beep_rise",

            "setc quest,5",
            "quest5:",
            "setc signal,nil",
            "pushNext I",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=2^P:random(3)
                for i=1,4 do d[i][r]=0 end
                P:setField(d)
            end},
            "wait signal",
            "jeq quest5,signal,false",
            "sfx beep_rise",

            {cmd=function(P)
                P:say{duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='beat',c=COLOR.lG,y=-30}
                if P.modeData.allFinesse then
                    P:say{duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='flicker',c=COLOR.Y,y=-30}
                    PROGRESS.setTutorialPassed(1,3)
                else
                    PROGRESS.setTutorialPassed(1,2)
                end
                PROGRESS.setTutorialPassed(2,1)
                P:finish('win')
            end},
        },
    }},
    result=autoBack_interior,
}
