local finesseData={
    {
        {1,2,1,0,1,2,2,1},
        {2,2,2,1,1,2,3,2,2},
        {1,2,1,0,1,2,2,1},
        {2,2,2,1,1,2,3,2,2},
    }, -- Z
    {
        {1,2,1,0,1,2,2,1},
        {2,2,2,1,1,2,3,2,2},
        {1,2,1,0,1,2,2,1},
        {2,2,2,1,1,2,3,2,2},
    }, -- S
    {
        {1,2,1,0,1,2,2,1},
        {2,2,3,2,1,2,3,3,2},
        {3,4,3,2,3,4,4,3},
        {2,3,2,1,2,3,3,2,2},
    }, -- J
    {
        {1,2,1,0,1,2,2,1},
        {2,2,3,2,1,2,3,3,2},
        {3,4,3,2,3,4,4,3},
        {2,3,2,1,2,3,3,2,2},
    }, -- L
    {
        {1,2,1,0,1,2,2,1},
        {2,2,3,2,1,2,3,3,2},
        {3,4,3,2,3,4,4,3},
        {2,3,2,1,2,3,3,2,2},
    }, -- T
    {
        {1,2,2,1,0,1,2,2,1},
        {1,2,2,1,0,1,2,2,1},
        {1,2,2,1,0,1,2,2,1},
        {1,2,2,1,0,1,2,2,1},
    }, -- O
    {
        {1,2,1,0,1,2,1},
        {2,2,2,2,1,1,2,2,2,2},
        {1,2,1,0,1,2,1},
        {2,2,2,2,1,1,2,2,2,2},
    }, -- I
}
local finesseQuests={
    { -- ① Double Rotation Keys
        -- R.I.P. Tetris Journey
        {'J','L',4},
        {'L','R',5},
        {'T','L',4},
        {'J','R',5},
    },
    { -- ② Backtrack
        {'Z','0',7},
        {'L','0',7},
        {'O','0',2},
        {'S','0',7},
        {'I','0',2},
        {'J','0',7},
        {'T','0',2},
    },
    { -- ③ Wall-turn
        {'Z','R',6}, -- CW,r
        {'S','L',8}, -- R,CCW
        {'J','L',3}, -- CCW,l
        {'L','R',6}, -- CW,r
        {'T','L',8}, -- R,CCW
        {'O','0',8}, -- R,l
        {'I','R',3}, -- L,CW
    },
}
local actionCosts={
    moveLeft=1,
    moveRight=1,
    rotateCW=1,
    rotateCCW=1,
    rotate180=2,
}
local dirNum={['0']=1,R=2,F=3,L=4}
local function startQuest(P,n)
    P.modeData.questFin=nil
    P.settings.spawnDelay=1
    P.spawnTimer=1
    local q=finesseQuests[n]
    for i=1,#q do
        local name,dir,pos=unpack(q[i])
        P:pushNext(name)
        local piece=P.nextQueue[i]
        ---@cast piece Techmino.Piece
        local matrix=TABLE.rotate(TABLE.copy(piece.matrix),dir)
        table.insert(P.modeData.targetPreview,{
            x=pos,
            matrix=matrix,
            best=finesseData[piece.shape][dirNum[dir]][pos]
        })
    end
end
local function compMatrix(mat1,mat2)
    for y=1,#mat1 do
        for x=1,#mat1[y] do
            if mat1[y][x] and not mat2[y][x] then
                return false
            end
        end
    end
    return true
end
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
        -- asp=0,
        bufferRotate=false,
        dropDelay=1e99,
        lockDelay=1e99,
        spawnDelay=1,
        nextSlot=3,
        holdSlot=0,
        seqType='none',
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.questFin=nil
                P.modeData.curKeyCount=0
                P.modeData.keySaved=0
                P:switchAction('softDrop',false)

                P.modeData.targetPreview={}
            end,
            gameStart=function(P)
                P.spawnTimer=1e99
            end,
            afterResetPos=function(P)
                P.modeData.curKeyCount=0
                TABLE.clear(P.field._matrix)
                P:freshGhost()
            end,
            beforePress=function(P,act)
                P.modeData.curKeyCount=P.modeData.curKeyCount+(actionCosts[act] or 0)
            end,
            afterDrop=function(P)
                local target=P.modeData.targetPreview[1]
                -- Position check
                local posSucc=P.handX==target.x
                if posSucc and not compMatrix(P.hand.matrix,target.matrix) then posSucc=false end

                -- Key count check
                local keySucc=P.modeData.curKeyCount<=target.best

                if posSucc and keySucc then
                    -- Correct
                    table.remove(P.modeData.targetPreview,1)
                    P.modeData.keySaved=P.modeData.keySaved+(target.best-P.modeData.curKeyCount)
                    print(P.modeData.keySaved)
                    if #P.modeData.targetPreview==0 then
                        P.modeData.questFin=true
                        P.settings.spawnDelay=1e99
                    end
                else
                    -- Wrong: restore piece
                    P:restoreBrikState(P.hand)
                    table.insert(P.nextQueue,1,P.hand)
                    P.hand=nil
                    P:playSound(posSucc and 'rotate_failed' or 'move_failed',2)
                end
            end,
            drawInField=function(P)
                GC.setLineWidth(6)
                local dy=0
                for i=1,math.min(3,#P.modeData.targetPreview) do
                    local p=P.modeData.targetPreview[i]
                    GC.setColor(1,1,1,.7023-.162*i)
                    for y=1,#p.matrix do
                        for x=1,#p.matrix[y] do
                            if p.matrix[y][x] then
                                GC.rectangle('line',40*(p.x+x-2)+7,-40*(y+dy)+7,40-14,40-14)
                            end
                        end
                    end
                    dy=dy+#p.matrix+1
                end
            end,
        },
        script={
            {cmd='say',arg={duration='2s',text="@tutorial_finesseBasic_0",  size=80,y=-60,type='bold',style='beat'}},
            "[2s]",
            {cmd='say',arg={duration='5s',text="@tutorial_finesseBasic_0_1",size=35,y=-60}},
            "[5s]",

            {cmd='say',arg={duration='2s',text="@tutorial_finesseBasic_1",  size=60,y=-60}},
            "[2s]",
            {cmd='say',arg={duration='12s',text="@tutorial_finesseBasic_1_1",size=35,y=-60}},
            {cmd='say',arg={duration='12s',text="@tutorial_finesseBasic_1_T",size=20,y=-20}},
            "[7s]",
            {cmd='say',arg={duration='5s',text="@tutorial_finesseBasic_1_2",size=35,y=20}},
            "[3s]",

            {cmd=function(P) startQuest(P,1) end},
            "wait questFin",
            "setField",

            {cmd='say',arg={duration='2s',text="@tutorial_finesseBasic_2",  size=60,y=-60}},
            "[2s]",
            {cmd='say',arg={duration='15s',text="@tutorial_finesseBasic_2_1",size=35,y=-140}},
            {cmd='say',arg={duration='15s',text="@tutorial_finesseBasic_2_2",size=35,y=-100}},
            {cmd='say',arg={duration='15s',text="@tutorial_finesseBasic_2_3",size=35,y=-60}},
            {cmd='say',arg={duration='15s',text="@tutorial_finesseBasic_2_T",size=20,y=-20}},
            "[10s]",
            {cmd='say',arg={duration='5s',text="@tutorial_finesseBasic_2_4",size=35,y=20}},
            "[3s]",

            {cmd=function(P) startQuest(P,2) end},
            "wait questFin",
            "setField",

            {cmd='say',arg={duration='2s',text="@tutorial_finesseBasic_3",  size=60,y=-60}},
            "[2s]",
            {cmd='say',arg={duration='10s',text="@tutorial_finesseBasic_3_1",size=35,y=-60}},
            {cmd='say',arg={duration='10s',text="@tutorial_finesseBasic_3_2",size=35,y=-20}},
            "[5s]",
            {cmd='say',arg={duration='5s',text="@tutorial_finesseBasic_3_3",size=35,y=20}},
            "[3s]",

            {cmd=function(P) startQuest(P,3) end},
            "wait questFin",
            "setField",

            {cmd='say',arg={duration='5s',text="@tutorial_finesseBasic_4_1",  size=35,y=-60}},
            {cmd='say',arg={duration='5s',text="@tutorial_finesseBasic_4_2",  size=35,y=-20}},
            "[5s]",
            {cmd=function(P)
                P:say{duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='beat',c=COLOR.lG,y=-30}
                if P.modeData.keySaved>12.6 then
                    P:say{duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='flicker',c=COLOR.Y,y=-30}
                    PROGRESS.setTutorialPassed(4,2)
                elseif P.modeData.keySaved>6.26  then
                    P:say{duration='1.26s',text=P.modeData.keySaved.."/12",k=2,size=30,type='bold',style='fly',c=COLOR.lY,y=60}
                else
                    PROGRESS.setTutorialPassed(4,1)
                end
                P:finish('win')
            end},
        },
    }},
    result=autoBack_interior,
}