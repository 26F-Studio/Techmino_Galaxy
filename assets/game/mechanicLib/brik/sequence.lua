local min=math.min
local ins,rem=table.insert,table.remove

-- Fill list when empty, with source
---@return boolean #True when filled
local function supply(list,src,rep)
    if not list[1] then
        for _=1,rep or 1 do
            TABLE.connect(list,src)
        end
        return true
    end
    return false
end

---@type Map<Techmino.Mech.Brik|Map<Techmino.Mech.Brik>>
local sequence={}

---@param P Techmino.Player.Brik
---@param d table cached data of generator
---@param init boolean true if this is the first initializating call
---@diagnostic disable-next-line
function sequence.none(P,d,init)
end

--------------------------------------------------------------
-- Tetro

local Tetros={1,2,3,4,5,6,7}

function sequence.bag7(P,d,init)
    if init then
        d.bag={}
        return
    end
    supply(d.bag,Tetros)
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_p1fromBag7(P,d,init) -- bag7 + 1 from another bag7
    if init then
        d.bag={}
        d.extra={}
        return
    end
    if supply(d.bag) then
        supply(d.extra,Tetros)
        d.bag[8]=rem(d.extra,P:random(#d.extra))
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_p1(P,d,init) -- bag7 + 1rnd
    if init then
        d.bag={}
        return
    end
    if supply(d.bag,Tetros) then
        d.bag[8]=P:random(7)
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_m1p1(P,d,init) -- bag7 -1rnd +1rnd
    if init then
        d.bag={}
        return
    end
    if supply(d.bag,Tetros) then
        d.bag[P:random(7)]=P:random(7)
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_twin(P,d,init) -- bag7, but two bags work in turn
    if init then
        d.bag1,d.bag2={},{}
        return
    end
    d.bag1,d.bag2=d.bag2,d.bag1
    supply(d.bag1,Tetros)
    return rem(d.bag1,P:random(#d.bag1))
end

function sequence.bag7_sprint(P,d,init) -- bag7, but no early S/Z/O and shuffling range start from 3, +1 each bag
    if init then
        d.bag={}

        local mixture
        d.start={}

        -- First bag, try to prevent early S/Z/O
        mixture=TABLE.copy(Tetros)
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
        -- Completely random from fifth bag
        supply(d.bag,Tetros)
        return rem(d.bag,P:random(#d.bag))
    end
end

function sequence.bag7_spread1stTo3211(P,d,init) -- bag7, but first bag 3+2+1+1-ly splited into next four bags 
    if init then
        d.bag={}
        d.victim=TABLE.copy(Tetros)
        d.wave=1
        return
    end
    if supply(d.bag,Tetros) then
        if d.wave then
            for _=1,
                d.wave==1 and 3 or
                d.wave==2 and 2 or
                1
            do ins(d.bag,rem(d.victim,P:random(#d.victim))) end
            d.wave=d.wave+1 if #d.victim==0 then d.wave=nil end
        end
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7_steal1(P,d,init) -- bag7, but each bag steals a piece from the next bag
    if init then
        d.bag={}
        d.victim=TABLE.copy(Tetros)
        return
    end
    if supply(d.bag,Tetros) then
        d.bag,d.victim=d.victim,d.bag
        ins(d.bag,rem(d.victim,P:random(#d.victim)))
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7p7p2_power(P,d,init) -- bag7+7+TI
    if init then
        d.bag={}
        return
    end
    if supply(d.bag,Tetros,2) then
        TABLE.connect(d.bag,{5,7})
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7p7p7p5_power(P,d,init) -- bag 7+7+7+TTOII
    if init then
        d.bag={}
        return
    end
    if supply(d.bag,Tetros,3) then
        TABLE.connect(d.bag,{5,5,6,7,7})
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag6p6_drought(P,d,init) -- bag7+7 without I piece
    if init then
        d.bag={}
    end
    if not d.bag[1] then
        for _=1,2 do
            for i=1,6 do
                ins(d.bag,i)
            end
        end
    end
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag7p6_flood(P,d,init) -- bag7 with extra 3 S pieces and 3 Z pieces
    if init then
        d.bag={}
        return
    end
    if supply(d.bag,Tetros) then
        TABLE.connect(d.bag,{1,1,1,2,2,2})
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

function sequence.pool8_bag7(P,d,init)
    if init then
        d.pool=TABLE.copy(Tetros)
        d.bag={}
        return
    end
    supply(d.bag,Tetros)
    d.pool[8]=rem(d.bag,P:random(#d.bag))
    return rem(d.pool,P:random(7))
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

--------------------------------------------------------------
-- Dist-Weight sequence invented by MrZ & Farter

sequence.distWeight={}
for variant,data in next,{
    sim7bag={
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

--------------------------------------------------------------
-- Pento

local Pentos={8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
local easyPentos={10,11,14,19,20,23,24,25} -- P Q T5 J5 L5 N H I5
local hardPentos={8,9,12,13,15,16,17,18,21,22} -- Z5 S5 F E U V W X R Y

function sequence.bag18_pento(P,d,init)
    if init then
        d.bag={}
        return
    end
    supply(d.bag,Pentos)
    return rem(d.bag,P:random(#d.bag))
end

function sequence.bag8_pentoEZ_p4fromBag10_pentoHD(P,d,init)
    if init then
        d.bag1={}
        d.bag2={}
        return
    end
    if supply(d.bag1,easyPentos) then
        for _=1,4 do
            supply(d.bag2,hardPentos)
            ins(d.bag1,rem(d.bag2,P:random(#d.bag2)))
        end
    end
    return rem(d.bag1,P:random(#d.bag1))
end

return sequence
