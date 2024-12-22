local allclearGenerator={}

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
local function generateSolidGarbage(P,field,w,growRate,splitRate)
    local count=math.floor(P:rand(#field<3 and 1 or 0,growRate+1)*2)
    local pos=P:random(1,#field+1)
    while count>0 do
        table.insert(field,pos,TABLE.new(true,w))
        if P:random()<splitRate then
            pos=P:random()<.5 and pos-1 or pos+2
        end
        pos=MATH.clamp(pos,1,#field+1)
        count=count-1
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
local function clearFilledLines(field,piece) -- Move piece down when needed
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
            if y<piece.y then piece.y=piece.y-1 end
        end
    end
end
local function getExposedFour(field)
    local tar={}
    -- foreach shape
    for i=1,#pieceShapes do
        local piece=pieceShapes[i]
        local heights={}
        for x=1,#field[1] do
            heights[x]=getHeight(field,x)
        end
        -- foreach position
        for cx=1,#field[1]-#piece[1]+1 do
            for cy=math.max(unpack(heights,cx,cx+#piece[1]-1)),1,-1 do
                if existInField(field,piece,cx,cy) then
                    local f=TABLE.copy(field)
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
                                name=Brik.getName(piece.id),
                                shape=TABLE.copy(piece),
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
local function filterTop(field,pieces)
    local height=#field
    local line=field[height]
    local fieldTopCount=0
    for x=1,#line do
        if line[x] then
            fieldTopCount=fieldTopCount+1
        end
    end
    for i=#pieces,1,-1 do
        local piece=pieces[i]
        local shape=piece.shape
        if piece.y+#shape-1>=#field then
            local shapeTop=shape[#shape]
            local pieceTopCount=0
            for x=1,#shape[1] do
                if shapeTop[x] then
                    pieceTopCount=pieceTopCount+1
                end
            end
        end
    end
end
local function printField(f)
    local s=STRING.newBuf()
    s:put("--------------------------")
    for y=#f,1,-1 do
        for x=1,#f[y] do
            s:put(f[y][x] and "X" or ".")
        end
    end
    print(s)
end
local function printSeq(s)
    s=TABLE.copy(s,0)
    TABLE.reverse(s)
    print(table.concat(s))
end
function allclearGenerator._shuffleSeq(P,seq,holdSlot)
    local backup=TABLE.copy(seq)
    local pickArea=holdSlot or P.settings.holdSlot+1
    local pointers={}
    for i=1,pickArea do pointers[i]=i end

    for i=1,#backup do
        local pick=P:random(#pointers)
        seq[pointers[pick]]=backup[i]
        pointers[pick]=i+#pointers
        if pointers[pick]>#backup then
            table.remove(pointers,pick)
        end
    end
end
---@return Mat<boolean> field, Techmino.Brik.Name[] seq
function allclearGenerator._generateQuestion(P,args)
    ---@cast P Techmino.Player.Brik
    local field={} -- 0-1 matrix
    local seq={} -- briks' names
    local failCount=0

    local args1={
        debugging=false,
        pieceCount=4,
        holdUsed=false,
        emptyTop=false,
        mergeRate=.5,
        repRate=.5,
        growRate=.5,
        splitRate=.26,
        highRate=0,
    }
    if type(args)=='table' then TABLE.update(args1,args) end

    local debugging=  args1.debugging
    local width=      TABLE.getFirstValue(args1.width,P and P.settings.fieldW)
    local pieceCount= TABLE.getFirstValue(args1.pieceCount,P and P.settings.nextSlot)
    local holdUsed=   TABLE.getFirstValue(args1.holdUsed,P and P.settings.holdSlot)
    local emptyTop=   args1.emptyTop
    local mergeRate=  args1.mergeRate
    local repRate=    args1.repRate
    local growRate=   args1.growRate
    local splitRate=  args1.splitRate
    local highRate=   args1.highRate

    if holdUsed==true then holdUsed=1 end

    while #seq<pieceCount do
        local field_bak=TABLE.copy(field)
        generateSolidGarbage(P,field,width,growRate,splitRate)
        local pieces=getExposedFour(field)

        if emptyTop then
            filterTop(field,pieces)
        end

        if #pieces==0 then
            field=field_bak
            failCount=failCount+1
            assert(failCount<1000,"Generating failed")
        else
            if debugging then
                printField(field)
                print(#pieces.." solutions:")
                for i=1,#pieces do
                    local piece=pieces[i]
                    print(piece.name.." "..piece.x.." "..piece.y)
                end
            end

            local totalScore=0
            for i=1,#pieces do
                local piece=pieces[i]
                piece.score=(1+highRate*.62)^piece.y
                totalScore=totalScore+piece.score
            end
            local r=totalScore*P:random()
            local piece
            for i=1,#pieces do
                r=r-pieces[i].score
                if r<=0 then
                    piece=pieces[i]
                    break
                end
            end
            carveField(field,piece.shape,piece.x,piece.y)
            clearFilledLines(field,piece)
            table.insert(seq,piece.name)
        end
    end

    if holdUsed then
        if debugging then
            print("Pre-shuffle: ")
            printSeq(seq)
        end
        allclearGenerator._shuffleSeq(P,seq,type(holdUsed)=='number' and holdUsed or holdUsed)
    end

    if debugging then
        printField(field)
        printSeq(seq)
    end

    TABLE.reverse(field)
    TABLE.reverse(seq)

    for y=1,#field do
        for x=1,#field[y] do
            field[y][x]=field[y][x] and 8 or 0
        end
    end

    return field,seq
end

---@return Mat<number> field, Techmino.Brik.Name[] seq
function allclearGenerator._getLibQuestion(P,args)
    ---@cast P Techmino.Player.Brik
    local field={} -- 0-1 matrix
    local seq={} -- briks' names

    local pool=require'datatable.allclearQuestLib'
    local basePool=pool.base[args.lib]
    local seqPool=pool.sequence[args.lib]

    local args1={
        debugging=false,
        holdUsed=false,
        startPiece=false,
        avoidRepeat=true,
    }
    if type(args)=='table' then TABLE.update(args1,args) end

    local debugging=  args1.debugging
    local holdUsed=   TABLE.getFirstValue(args1.holdUsed,P and P.settings.holdSlot)
    local startPiece= args1.startPiece

    -- Initialize
    if not P.modeData.allclearBaseID then
        P.modeData.allclearBaseID={}
        P.modeData.allclearSeqHis={}
        for lib in next,pool.base do
            P.modeData.allclearBaseID[lib]=1
            P.modeData.allclearSeqHis[lib]={}
        end
    end

    local baseID=P.modeData.allclearBaseID[args.lib]
    local seqHis=P.modeData.allclearSeqHis[args.lib]

    field=basePool[baseID]
    local attempts=0
    local r
    while true do
        r=P:random(#seqPool)
        attempts=attempts+1
        if attempts>26 then break end
        if not args1.avoidRepeat then break end
        if not TABLE.find(seqHis,r) then
            table.insert(seqHis,1,r)
            seqHis[11]=nil
            break
        end
    end
    seq=seqPool[r]

    field=TABLE.copy(field)
    seq=STRING.atomize(seq)
    if 1 or P:roll() then
        for i=1,#seq do
            seq[i]=
                seq[i]=='Z' and 'S' or
                seq[i]=='S' and 'Z' or
                seq[i]=='J' and 'L' or
                seq[i]=='L' and 'J' or
                seq[i]
        end
        for y=1,#field do
            TABLE.reverse(field[y])
            for x=1,#field[y] do
                local c=field[y][x]
                field[y][x]=c==0 and 0 or c<=2 and 3-c or c<=4 and 7-c or c
            end
        end
    end

    if holdUsed==true then holdUsed=1 end
    if holdUsed then
        if debugging then
            print("Pre-shuffle: ")
            printSeq(seq)
        end
        allclearGenerator._shuffleSeq(P,seq,type(holdUsed)=='number' and holdUsed or holdUsed)
    end

    if debugging then
        printField(field)
        printSeq(seq)
    end

    P.modeData.allclearBaseID[args.lib]=baseID%#basePool+1

    return field,seq
end

---@class Techmino.Mech.Brik.AllclearGenerator.arg1
---@field debugging boolean
---@field raw boolean
---@field pieceCount integer
---@field holdUsed boolean | integer
---@field emptyTop boolean
---@field mergeRate number
---@field repRate number
---@field growRate number
---@field splitRate number
---@field highRate number

---@class Techmino.Mech.Brik.AllclearGenerator.arg2
---@field lib 'box3' | 'pco3' | 'box4' | 'pco4'
---@field debugging boolean
---@field raw boolean
---@field holdUsed boolean | integer
---@field startPiece boolean
---@field avoidRepeat boolean

---@param args Techmino.Mech.Brik.AllclearGenerator.arg1 | Techmino.Mech.Brik.AllclearGenerator.arg2
function allclearGenerator.newQuestion(P,args)
    local field,seq
    if args.lib then
        field,seq=allclearGenerator._getLibQuestion(P,args)
    else
        field,seq=allclearGenerator._generateQuestion(P,args)
    end
    if args.raw then
        return field,seq
    else
        P:setField(field)
        P:pushNext(seq)
    end
end

return allclearGenerator
