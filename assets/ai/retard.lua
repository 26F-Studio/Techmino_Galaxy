local retard={}

local function ifoverlap(field,cb,cx,cy)
    if cy>#field then return false end
    for y=1,#cb do for x=1,#cb[1] do
        if cb[y][x] and field[cy+y-1] and field[cy+y-1][cx+x-1] then
            return true
        end
    end end
    return false
end
local function simulateDrop(field,cb,cx)
    for cy=#field,0,-1 do
        if cy==0 or ifoverlap(field,cb,cx,cy) then
            cy=cy+1
            for by=1,#cb do for bx=1,#cb[1] do
                if cb[by][bx] then
                    local x,y=cx+bx-1,cy+by-1
                    if not field[y] then field[y]={} end
                    field[y][x]=true
                end
            end end
            return cy
        end
    end
end

local LclearScore={[0]=0,-200,-150,-100,200}
local HclearScore={[0]=0,100,140,200,500}
function retard.calculateFieldScore(field,cb,cy)
    local score=0
    local highest=0
    local height=TABLE.new(0,10)
    local clear=0
    local hole=0

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
    for x=1,10 do
        local h=#field
        while field[h][x]==0 and h>1 do
            h=h-1
        end
        height[x]=h
        if x>3 and x<8 and h>highest then
            highest=h
        end
        if h>1 then
            for h1=h-1,1,-1 do
                if field[h1][x]==0 then
                    hole=hole*.8+1
                    if hole>3 then
                        break
                    end
                end
            end
        end
    end
    local sdh=0
    local h1,mh1=0,0
    for x=1,9 do
        local dh=math.abs(height[x]-height[x+1])
        if dh==1 then
            h1=h1+1
            if h1>mh1 then
                mh1=h1
            end
        else
            h1=0
        end
        sdh=sdh+math.min(dh^1.6,20)
    end

    score=
        -#field*10
        -#cb*15
        +(#field>10 and
            HclearScore[clear]-- Clearing
            -hole*200-- Hole
            -cy*50-- Height
            -sdh-- Sum of DeltaH
        or
            LclearScore[clear]
            -hole*120
            -cy*40
            -sdh*3
        )
    if mh1>3 then-- Max staircase length
        score=score-mh1*15
    end
    return score
end

local directions={'0','R','F','L'}
function retard.findPosition(field,shape)
    local best={
        score=-1e99,
        x=4,y=4,dir='0',
    }
    if not field[1] then field[1]=TABLE.new(false,10) end
    local w=#field[1]
    for d=1,4 do
        for cx=1,w-#shape[1]+1 do
            local F=TABLE.shift(field,1)
            local cy=simulateDrop(F,shape,cx)
            local score=retard.calculateFieldScore(field,shape,cy)
            if score>best.score then
                best.x,best.y,best.dir=cx,cy,directions[d]
                best.score=score
            end
        end
        if d<4 then shape=TABLE.rotate(shape,'R') end
    end
    return best.x,best.y,best.dir
end

return retard
