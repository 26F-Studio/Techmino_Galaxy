local GC=GC
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
local actionCosts={
    moveLeft=1,
    moveRight=1,
    rotateCW=1,
    rotateCCW=1,
    rotate180=2,
}
local function pushFinesseTarget(P,n)
    local piece=P.nextQueue[n]
    ---@cast piece Techmino.Piece
    local matrix=TABLE.copy(piece.matrix)
    local dir=MATH.selectFreq(P:random()*15,{3,5,2,5})-1
    if P:random()*62>P.modeData.finesseCombo then dir=(dir+1)%4 end
    for _=1,dir do matrix=TABLE.rotate(matrix,'R') end
    local xList=TABLE.copy(finesseData[piece.shape][dir+1])
    local freqFinetune=-math.min(unpack(xList))*0.626+math.max(10-P.modeData.finesseCombo/2.6,0)
    for i=1,#xList do
        xList[i]=xList[i]+freqFinetune
    end
    local x=MATH.selectFreq(P:random()*MATH.sum(xList),xList)
    table.insert(P.modeData.targetPreview,{
        x=x,
        matrix=matrix,
        best=finesseData[piece.shape][dir+1][x]
    })
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
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=3,
        holdSlot=0,
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.curKeyCount=0
                P.modeData.finesseCombo=0
                P.modeData.display=false
                P.modeData.correct=true
                P.modeData.protect=false
                P:switchAction('softDrop',false)

                P.modeData.targetPreview={}
                for i=1,3 do pushFinesseTarget(P,i) end

                PROGRESS.setInteriorScore('tuto5_score',0)
                PROGRESS.setInteriorScore('tuto5_time',2600e3,'<')

                if PROGRESS.getInteriorScore('tuto5_score')<99 then
                    P.modeData.display=PROGRESS.getInteriorScore('tuto5_score').."/99"
                else
                    P.modeData.display=STRING.time(PROGRESS.getInteriorScore('tuto5_time')/1000)
                end
            end,
            afterResetPos=function(P)
                P.modeData.curKeyCount=0
                if P.modeData.correct then
                    pushFinesseTarget(P,3)
                    P.modeData.correct=false
                end
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
                    P.modeData.finesseCombo=P.modeData.finesseCombo+1
                    if P.modeData.finesseCombo%3==0 then
                        PROGRESS.setInteriorScore('tuto5_score',P.modeData.finesseCombo)
                    end
                    if P.modeData.finesseCombo==99 then
                        PROGRESS.setInteriorScore('tuto5_time',P.gameTime)
                        P.modeData.display=STRING.time(P.gameTime/1000)
                        P:finish('win')
                    end
                    table.remove(P.modeData.targetPreview,1)
                    P.modeData.correct=true
                    P.modeData.protect=false
                else
                    -- Wrong: restore piece & reduce combo
                    P:restoreBrikState(P.hand)
                    table.insert(P.nextQueue,1,P.hand)
                    P.hand=nil
                    P:playSound(posSucc and 'rotate_failed' or 'move_failed',2)
                    if not P.modeData.protect then
                        P.modeData.finesseCombo=math.max(P.modeData.finesseCombo-6,0)
                        P.modeData.protect=true
                    end
                end
            end,
            drawBelowBlock=function(P)
                local alpha=MATH.interpolate(26,.42,94.2,0,P.modeData.finesseCombo)
                GC.setColor(1,1,1,alpha)
                GC.line(120,0,120,-888)
                GC.line(240,0,240,-888)
                GC.setColor(1,1,1,alpha*.126)
                GC.rectangle('fill',120,0,120,-888)
            end,
            drawInField=function(P)
                GC.setLineWidth(6)
                local dy=0
                for i=1,3 do
                    local p=P.modeData.targetPreview[i]
                    GC.setColor(1,1,1,.872-.226*i)
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
            drawOnPlayer=function(P)
                GC.push('transform')
                GC.translate(-300,0)
                GC.setColor(1,1,1,P.modeData.protect and .5 or 1)
                FONT.set(80) GC.mStr(P.modeData.finesseCombo,0,-90)
                FONT.set(30) GC.mStr(Text.target_combo,0,-5)
                FONT.set(20)
                GC.setColor(1,1,1,.872)
                GC.mStr(P.modeData.display,0,40)

                if P.modeData.finesseCombo<=62 or P.modeData.protect then
                    GC.setColor(COLOR.lD)
                    FONT.set(50)
                    GC.print(P.modeData.curKeyCount,-40-5,120)
                    GC.print("/",-5-5,115)
                    GC.print(P.modeData.targetPreview[1].best,20-5,120)
                    FONT.set(30) GC.mStr(Text.tutorial_finessePractice_par,0,175)
                end
                GC.pop()
            end,
        },
        script={
            {cmd='say',arg={duration='4.2s',text="@tutorial_finessePractice_1",size=60,type='bold',y=-80}},
            {cmd='say',arg={duration='4.2s',text="@tutorial_finessePractice_2",size=30,y=60}},
        },
    }},
    result=autoBack_interior,
}
