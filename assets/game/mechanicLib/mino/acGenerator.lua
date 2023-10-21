--- @type Techmino.Mech.mino
local ACGenerator={}

local pieceShapes do
    local O,_=true,false
    pieceShapes={
        {id=1,{_,O,O},{O,O,_}},
        {id=1,{O,_},{O,O},{_,O}},

        {id=2,{O,O,_},{_,O,O}},
        {id=2,{_,O},{O,O},{O,_}},

        {id=3,{O,O,O},{O,_,_}},
        {id=3,{O,O},{_,O},{_,O}},
        {id=3,{_,_,O},{O,O,O}},
        {id=3,{O,_},{O,_},{O,O}},

        {id=4,{O,O,O},{_,_,O}},
        {id=4,{O,O},{O,_},{O,_}},
        {id=4,{O,_,_},{O,O,O}},
        {id=4,{_,O},{_,O},{O,O}},

        {id=5,{O,O,O},{_,O,_}},
        {id=5,{O,_},{O,O},{O,_}},
        {id=5,{_,O,_},{O,O,O}},
        {id=5,{_,O},{O,O},{_,O}},

        {id=6,{O,O},{O,O}},

        {id=7,{O,O,O,O}},
        {id=7,{O},{O},{O},{O}},
    }
end
local function generateSolidGarbage(field,w)
    for _=1, #field<=3 and math.floor(MATH.rand(1.9,2.6)) or math.random(0,2) do
        table.insert(field,math.random(1,#field+1),TABLE.new(true,w))
    end
end
local function getHeight(field,x)
    for y=#field,1,-1 do
        if field[y][x] then
            return y
        end
    end
    return 0
end
local function existInField(field,shape,cx,cy)
    if cx<1 or cy<1 or cx+#shape[1]-1>#field[1] or cy+#shape-1>#field then
        return false
    end
    for y=1,#shape do
        for x=1,#shape[1] do
            if shape[y][x] and not field[cy+y-1][cx+x-1] then
                return false
            end
        end
    end
    return true
end
local function ifOverlap(field,shape,cx,cy)
    for y=1,#shape do
        local l=field[cy+y-1]
        if l then
            for x=1,#shape[1] do
                if shape[y][x] and l[cx+x-1] then
                    return true
                end
            end
        end
    end
    return false
end
local function carveField(field,shape,x,y)
    for cy=1,#shape do
        for cx=1,#shape[1] do
            if shape[cy][cx] then
                field[y+cy-1][x+cx-1]=false
            end
        end
    end
end
local function clearFilledLines(field,someY)
    for y=#field,1,-1 do
        local filled=true
        for x=1,#field[y] do
            if not field[y][x] then
                filled=false
                break
            end
        end
        if filled then
            table.remove(field,y)
            if y<someY then someY=someY-1 end
        end
    end
    return someY
end
local function getExposedFour(field)
    local tar={}
    -- foreach shape
    for i=1,#pieceShapes do
        local piece=pieceShapes[i]
        local widths={}
        for x=1,#field[1] do
            widths[x]=getHeight(field,x)
        end
        -- foreach position
        for cx=1,#field[1]-#piece[1]+1 do
            for cy=math.max(unpack(widths,cx,cx+#piece[1]-1)),1,-1 do
                if existInField(field,piece,cx,cy) then
                    local f=TABLE.shift(field)
                    carveField(f,piece,cx,cy)
                    if cy==1 or ifOverlap(f,piece,cx,cy-1) then
                        local exposed=true
                        local ty=cy
                        repeat
                            if ifOverlap(f,piece,cx,ty) then
                                exposed=false
                                break
                            else
                                ty=ty+1
                            end
                        until ty>#field
                        if exposed then
                            table.insert(tar,{
                                name=Minoes[piece.id].name,
                                shape=TABLE.shift(piece),
                                x=cx,y=cy,
                            })
                        end
                    end
                    break
                end
            end
        end
    end
    return tar
end
local function printField(f)
    print('--------------------------')
    for y=#f,1,-1 do
        local s=""
        for x=1,#f[y] do
            s=s..(f[y][x] and 'X' or '.')
        end
        print(s)
    end
end
local function printSeq(s)
    s=TABLE.shift(s,0)
    TABLE.reverse(s)
    print(table.concat(s))
end
function ACGenerator._shuffleSeq(P,seq,holdSlot)
    local pickArea=holdSlot or P.settings.holdSlot+1
    for i=1,#seq-1 do
        local pick=P:random(pickArea)
        if pick>1 then
            seq[i],seq[pick]=seq[pick],seq[i]
        end
    end
end
function ACGenerator._getQuestion(P,args)
    local field={} -- 0-1 matrix
    local seq={} -- minoes' names
    local failCount=0

    local arg={
        debugging=false,
        pieceCount=4,
        holdUsed=false,
        mergeRate=.5,
        repRate=.5,
        growRate=.5,
        jumpRate=.5,
    }
    if type(args)=='table' then TABLE.cover(args,arg) end

    local debugging=  TABLE.getFirstValue(arg.debugging,false)
    local pieceCount= TABLE.getFirstValue(arg.pieceCount,P and P.settings.nextSlot,4)
    local holdUsed=   TABLE.getFirstValue(arg.holdUsed,P and P.settings.holdSlot,false)
    local width=      TABLE.getFirstValue(arg.width,P and P.settings.fieldW,10)
    local mergeRate=  TABLE.getFirstValue(arg.mergeRate,.5)
    local repRate=    TABLE.getFirstValue(arg.repRate,.5)
    local growRate=   TABLE.getFirstValue(arg.growRate,.5)
    local jumpRate=   TABLE.getFirstValue(arg.jumpRate,.5)

    if holdUsed==true then holdUsed=1 end

    while #seq<pieceCount do
        local field_bak=TABLE.shift(field)
        generateSolidGarbage(field,width)
        local L=getExposedFour(field)

        if #L==0 then
            field=field_bak
            failCount=failCount+1
            if failCount>100000 then
                error("Generating failed")
            end
        else
            if debugging then
                printField(field)
                print(#L.." solutions:")
                for i=1,#L do
                    local piece=L[i]
                    print(piece.name.." "..piece.x.." "..piece.y)
                end
            end

            local piece=L[math.random(#L)]
            carveField(field,piece.shape,piece.x,piece.y)
            piece.y=clearFilledLines(field,piece.y)
            table.insert(seq,piece.name)
        end
    end

    if holdUsed then
        if debugging then
            print("Pre-shuffle: ")
            printSeq(seq)
        end
        ACGenerator._shuffleSeq(P,seq,type(holdUsed)=='number' and holdUsed or holdUsed)
    end

    if debugging then
        printField(field)
        printSeq(seq)
    end

    return field,seq
end

function ACGenerator.newQuestion(P,args)
    local field,seq=ACGenerator._getQuestion(P,args)
    TABLE.reverse(field)
    TABLE.reverse(seq)
    for y=1,#field do
        for x=1,#field[y] do
            field[y][x]=field[y][x] and 8 or 0
        end
    end
    P:setField(field)
    P:pushNext(seq)
end

return ACGenerator
