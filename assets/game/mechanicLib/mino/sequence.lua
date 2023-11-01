local min=math.min
local ins,rem=table.insert,table.remove

---@type Techmino.Mech.mino
local sequence={}

local Tetros={1,2,3,4,5,6,7}
local Pentos={8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
local easyPentos={10,11,14,19,20,23,24,25}     -- P Q T5 J5 L5 N H I5
local hardPentos={8,9,12,13,15,16,17,18,21,22} -- Z5 S5 F E U V W X R Y

---@param P Techmino.Player.mino
---@param d table cached data of generator
---@param init boolean true if this is the first initializating call
---@diagnostic disable-next-line: unused-local
function sequence.none(P,d,init)
end

function sequence.bag7(P,d,init)
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then d.bag=TABLE.shift(Tetros) end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_bag1(P,d,init) -- bag8, which the extra piece from another bag
    if init then
        d.bag={}
        d.extra={}
        return
    end
    if not d.bag[1] then
        d.bag=TABLE.shift(Tetros)
        if not d.extra[1] then d.extra=TABLE.shift(Tetros) end
        d.bag[8]=rem(d.extra,P:random(#d.extra))
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_sprint(P,d,init)
    if init then
        d.bag={}

        local mixture
        d.start={}

        -- First bag, try to prevent early S/Z/O
        mixture=TABLE.shift(Tetros)
        for i=7,2,-1 do ins(mixture,rem(mixture,P:random(1,i))) end
        for _=1,2 do
            if mixture[1]==1 or mixture[1]==2 or mixture[1]==6 then
                ins(mixture,P:random(3,7),rem(mixture,1))
            end
        end
        TABLE.connect(d.start,mixture)

        -- Gradually increase the shuffle range until full shuffle
        local rndRange=3
        repeat
            local mixer={}
            for _=1,7 do ins(mixer,rem(mixture,P:random(min(#mixture,rndRange)))) end
            TABLE.connect(d.start,mixer)
            mixture=mixer
            rndRange=rndRange+1
        until rndRange==7

        -- Reverse to make first piece can be popped directly
        TABLE.reverse(d.start)
        return
    end

    if d.start then
        local r=rem(d.start)
        if not d.start[1] then d.start=nil end
        return r
    else
        -- Completely random from fifth Bag
        if not d.bag[1] then d.bag=TABLE.shift(Tetros) end
        return rem(d.bag,P:random(#d.bag))
    end
end

function sequence.bag7_steal1(P,d,init) -- bag7, but each bag steals a piece from the next bag
    if init then
        d.bag={}
        d.victim=TABLE.shift(Tetros)
        rem(d.victim,P:random(7))
        return
    end
    if not d.bag[1] then
        d.bag,d.victim=d.victim,d.bag
        d.victim=TABLE.shift(Tetros)
        ins(d.bag,rem(d.victim,P:random(#d.victim)))
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag16(P,d,init) -- bag7+7+TI
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then d.bag=TABLE.combine(Tetros,TABLE.combine(Tetros,{5,7})) end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag26(P,d,init) -- bag 7+7+7+TTOII
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then d.bag=TABLE.combine(Tetros,TABLE.combine(Tetros,TABLE.combine(Tetros,{5,5,6,7,7}))) end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag12_drought(P,d,init) -- bag14 without I piece
    if init then
        d.bag={}
    end
    if not d.bag[1] then
        for i=1,6 do
            ins(d.bag,i)
            ins(d.bag,i)
        end
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_flood(P,d,init) -- bag7 with extra 3 S pieces and 3 Z pieces
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then
        d.bag=TABLE.shift(Tetros)
        d.bag[8],d.bag[9],d.bag[10]=1,1,1
        d.bag[11],d.bag[12],d.bag[13]=2,2,2
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag4_rect(P,d,init) -- bag4 of JLOI
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then d.bag={3,4,6,7} end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag3_saw(P,d,init) -- bag3 of SZT
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then d.bag={1,2,5} end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.his4_roll4(P,d,init)
    if init then
        d.his=TABLE.new(0,4)
        return
    end
    local r=P:random(7)
    for _=1,4 do
        if TABLE.find(d.his,r) then
            r=P:random(7)
        else
            break
        end
    end
    rem(d.his,1)
    ins(d.his,r)
    return r
end

function sequence.c2(P,d,init)
    if init then
        d.weight=TABLE.new(0,7)
        return
    end
    local maxK=1
    for i=1,7 do
        d.weight[i]=d.weight[i]*.5+P:random()
        if d.weight[i]>d.weight[maxK] then
            maxK=i
        end
    end
    d.weight[maxK]=d.weight[maxK]/3.5
    return maxK
end

function sequence.messy(P,d,init) -- no repeating random
    if init then return end
    repeat
        d.recent=P:random(7)
    until d.recent~=d.prev
    d.prev=d.recent
    return d.recent
end

function sequence.random(P,d,init) -- pure random
    if init then
        d.flandre='cute'
        return
    end
    return P:random(7)
end

function sequence.pento_bag18(P,d,init)
    if init then
        d.bag={}
        return
    end
    if not d.bag[1] then d.bag=TABLE.shift(Pentos) end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.pento_bag_EZ8plusHD4fromBag10(P,d,init)
    if init then
        d.bag={}
        d.extra={}
        return
    end
    if not d.bag[1] then
        d.bag=TABLE.shift(easyPentos)
        for _=1,4 do
            if not d.extra[1] then d.extra=TABLE.shift(hardPentos) end
            ins(d.bag,rem(d.extra,P:random(#d.extra)))
        end
    end
    return rem(d.bag,P:random(#d.bag))
end

sequence.distWeight={}
for variant,data in next,{
    fake7bag={
        pieces=Tetros,
        weights={64606156304596,131327514360144,203786783816133,287098623729448,390038487466665,531106246225509,762542509117884,896123925124349,1108610016824348,1476868735064520,2236067394570951,4591633945951618,1e99}, -- Data from Farter
    },
    noDrought={
        pieces=Tetros,
        weights={1,1,1,1,1,1,1,1,1,1,1,1,1e99},
    },
    hardDrought={
        pieces=Tetros,
        weights={1,1,1,1,2,3,4,5,6,7,8,9,26},
    },
    easyFlood={
        pieces=Tetros,
        weights={10,10,10,10,9,8,7,6,5},
    },
} do
    sequence.distWeight[variant]=function(P,d,init)
        if init then
            d.pieces=data.pieces
            d.weights=data.weights
            d.len=#d.pieces

            d.distances={}
            for i=1,d.len do d.distances[i]=i end
            for i=d.len,2,-1 do ins(d.distances,rem(d.distances,P:random(1,i))) end

            d.tempWei=TABLE.new(false,d.len)
            return
        end
        local sum=0
        for i=1,d.len do
            d.distances[i]=d.distances[i]+1
            d.tempWei[i]=d.weights[d.distances[i]] or d.weights[#d.weights]
            sum=sum+d.tempWei[i]
        end
        local r=P:random()*sum
        for i=1,d.len do
            r=r-d.tempWei[i]
            if r<=0 then
                d.distances[i]=0
                return d.pieces[i]
            end
        end
        error("WTF")
    end
end

return sequence
