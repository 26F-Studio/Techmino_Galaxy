local paperArtist={}

local function simulateDrop(field,cb,cx)
    local w=#cb[1]
    local shapeBottom,fieldTop={},{}
    for x=1,w do
        local y=0
        while y+1<=#cb and not cb[y+1][x] do y=y+1 end
        shapeBottom[x]=y

        y=#field
        while y>0 and not field[y][cx+x-1] do y=y-1 end
        fieldTop[x]=y
    end
    local delta={}
    for i=1,w do
        delta[i]=fieldTop[i]-shapeBottom[i]
    end
    return math.max(unpack(delta))+1,delta
end

function paperArtist.calculateFieldScore(field,cb,cy)
    local clear=0

    -- Clear filled lines
    for y=cy+#cb-1,cy,-1 do
        if field[y] then
            for x=1,10 do
                if not field[y][x] then
                    goto CONTINUE_notFull
                end
            end
            table.remove(field,y)
            clear=clear+1
            ::CONTINUE_notFull::
        end
    end

    -- Which boy can refuse PC?
    if #field==0 then
        return 1e99
    end

    local rowB=0
    for y=1,#field do
        local cur=true
        for x=1,#field[1] do
            if cur~=field[y][x] then
                cur=field[y][x]
                rowB=rowB+1
            end
        end
        if cur==false then rowB=rowB+1 end
    end
    local colB=0
    for x=1,#field[1] do
        local cur=true
        for y=1,#field do
            if cur~=field[y][x] then
                cur=field[y][x]
                colB=colB+1
            end
        end
    end

    return clear,rowB,colB
end

local directions={'0','R','F','L'}
function paperArtist.findPosition(field,shape)
    local best={
        score=-1e99,
        x=4,y=4,dir='0',
    }
    if not field[1] then field[1]=TABLE.new(false,10) end
    local w=#field[1]
    for d=1,4 do
        for cx=1,w-#shape[1]+1 do
            local F=TABLE.shift(field,1)
            local cy,colH=simulateDrop(F,shape,cx)
            local score=0

            local clear,rowB,colB=paperArtist.calculateFieldScore(field,shape,cy)
            score=score+clear*2-rowB*3-colB*2
            score=score-cy
            local minH=math.min(unpack(colH))
            for i=1,#colH do
                score=score-(colH[i]-minH)*1.26
            end

            if score>best.score then
                best.x,best.y,best.dir=cx,cy,directions[d]
                best.score=score
            end
        end
        if d<4 then shape=TABLE.rotate(shape,'R') end
    end
    return best.x,best.y,best.dir
end

return paperArtist
