local max,min=math.max,math.min
local ins,rem=table.insert,table.remove
local copy,append=TABLE.copy,TABLE.append

-- Fill list when empty, with source
---@return boolean #True when filled
local function supply(list,src,rep)
    if not list[1] then
        for _=1,rep or 1 do
            append(list,src)
        end
        return true
    end
    return false
end

-- Shuffle a list with specified random generator
local function shuffle(L,P)
    for i=#L,2,-1 do
        local r=P.RND:random(i)
        L[i],L[r]=L[r],L[i]
    end
end

local Tetros={1,2,3,4,5,6,7}
local Pentos={8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
local easyPentos={10,11,14,19,20,23,24,25} -- P Q T5 J5 L5 N H I5
local hardPentos={8,9,12,13,15,16,17,18,21,22} -- Z5 S5 F E U V W X R Y

---@enum (key) Techmino.Mech.Brik.SequenceName
local sequence={

-- Strict Bag Variants

bag7=function(P,d,init) -- The where we begin
    if init then d.bag={} return end
    supply(d.bag,Tetros)
    return rem(d.bag,P:random(#d.bag))
end,

bag7p1=function(P,d,init) -- bag7+?
    if init then d.bag={} return end
    if supply(d.bag,Tetros) then
        d.bag[8]=P:random(7)
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7m1p1=function(P,d,init) -- bag7-?+?
    if init then d.bag={} return end
    if supply(d.bag,Tetros) then
        d.bag[P:random(7)]=P:random(7)
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7p7p2_power=function(P,d,init) -- bag7+7+TI
    if init then d.bag={} return end
    if supply(d.bag,Tetros,2) then
        append(d.bag,{5,7})
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7p7p7p5_power=function(P,d,init) -- bag7+7+7+TTOII
    if init then d.bag={} return end
    if supply(d.bag,Tetros,3) then
        append(d.bag,{5,5,6,7,7})
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7p7m2_drought=function(P,d,init) -- bag7+7-II
    if init then d.bag={} return end
    if supply(d.bag,Tetros) then rem(d.bag) rem(d.bag) end
    return rem(d.bag,P:random(#d.bag))
end,

bag7p6_flood=function(P,d,init) -- bag7+SSSZZZ
    if init then d.bag={} return end
    if supply(d.bag,Tetros) then
        append(d.bag,{1,1,1,2,2,2})
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag4_tide=function(P,d,init) -- bag4(SZOI)
    if init then d.bag={} return end
    if not d.bag[1] then d.bag={1,2,6,7} end
    return rem(d.bag,P:random(#d.bag))
end,

bag4_rect=function(P,d,init) -- bag4(JLOI)
    if init then d.bag={} return end
    if not d.bag[1] then d.bag={3,4,6,7} end
    return rem(d.bag,P:random(#d.bag))
end,

bag3_saw=function(P,d,init) -- bag3(SZT)
    if init then d.bag={} return end
    if not d.bag[1] then d.bag={1,2,5} end
    return rem(d.bag,P:random(#d.bag))
end,

bag3_sea=function(P,d,init) -- bag3(III)
    if init then d.bag={} return end
    if not d.bag[1] then d.bag={7,7,7} end
    return rem(d.bag,P:random(#d.bag))
end,

-- General Bag Variants

bag7_p1fromBag7=function(P,d,init) -- bag7+1(from another bag7)
    if init then d.bag,d.extra={},{} return end
    if supply(d.bag) then
        supply(d.extra,Tetros)
        d.bag[8]=rem(d.extra,P:random(#d.extra))
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7_stable=function(P,d,init) -- bag7, but difference between adjacent bags is small
    if init then
        d.bag1={}
        d.bag2=copy(Tetros)
        shuffle(d.bag2,P)
        return
    end

    if supply(d.bag1,d.bag2) then
        local l=d.bag2
        local i=#l-1
        while i>=1 do
            if P:roll(.42) then
                l[i],l[i+1]=l[i+1],l[i]
                i=i-1
            end
            i=i-1
        end
    end
    return rem(d.bag1)
end,

bag7_sprint=function(P,d,init) -- bag7, but no early S/Z/O and shuffling range start from 3, +1 each bag
    if init then
        d.bag={}

        local mixture
        d.start={}

        -- First bag, try to prevent early S/Z/O
        mixture=copy(Tetros)
        for i=7,2,-1 do ins(mixture,rem(mixture,P:random(1,i))) end
        local szo={[1]=0,[2]=0,[6]=0}
        for _=1,2 do
            if szo[mixture[1]] then
                ins(mixture,P:random(2,7),rem(mixture,1))
            end
        end
        append(d.start,mixture)

        -- Gradually increase the shuffle range until full shuffle
        local rndRange=3
        repeat
            local mixer={}
            for _=1,7 do ins(mixer,rem(mixture,P:random(min(#mixture,rndRange)))) end
            append(d.start,mixer)
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
end,

bag7_luckyT=function(P,d,init) -- bag7, but T piece is more likely to appear late then early
    if init then
        d.bag={}
        d.bagCount=0
        d.tSpikes={P:random(4,6),P:random(10,16)}
        return
    end
    if not d.bag[1] then
        d.bagCount=d.bagCount+1
        d.bag={1,2,3,4,6,7}
        shuffle(d.bag,P)

        local r
        if d.bagCount==d.tSpikes[1] then
            -- T Spike Double
            r=P:random(5,7)
            rem(d.tSpikes,1)
        else
            -- Late 10▔\_20 Early
            r=P:random(3,7)
            r=r-P:random(0,math.floor(max(d.bagCount/2.6-4.2,0)))
            r=r-P:random(0,math.floor(d.bagCount^0.42))
            if d.bagCount>6.2 then r=r-P:random(1,3) end
        end

        r=min(max(r,1),7)
        ins(d.bag,8-r,5)
    end
    return rem(d.bag)
end,

bag7_steal1=function(P,d,init) -- bag7, but each bag steals a piece from the next bag
    if init then d.bag,d.victim={},copy(Tetros) return end
    if supply(d.bag,Tetros) then
        d.bag,d.victim=d.victim,d.bag
        ins(d.bag,rem(d.victim,P:random(#d.victim)))
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7_1stSplit3211=function(P,d,init) -- bag7, but split first bag 3+2+1+1-ly into next four bags
    if init then
        d.bag={}
        d.victim=copy(Tetros)
        d.bagCount=0
        return
    end
    if supply(d.bag,Tetros) then
        if d.bagCount then
            d.bagCount=d.bagCount+1
            for _=1,
                d.bagCount==1 and 3 or
                d.bagCount==2 and 2 or
                1
            do ins(d.bag,rem(d.victim,P:random(#d.victim))) end
            if #d.victim==0 then d.bagCount=nil end
        end
    end
    return rem(d.bag,P:random(#d.bag))
end,

bag7_twin=function(P,d,init) -- bag7, but two bags work in turn
    if init then d.bag1,d.bag2={},{} return end
    d.bag1,d.bag2=d.bag2,d.bag1
    supply(d.bag1,Tetros)
    return rem(d.bag1,P:random(#d.bag1))
end,

bag7_pool4=function(P,d,init)
    if init then
        d.bag,d.pool=copy(Tetros),{}
        for _=1,4-1 do
            ins(d.pool,rem(d.bag,P:random(#d.bag)))
        end
        return
    end
    supply(d.bag,Tetros)
    ins(d.pool,rem(d.bag,P:random(#d.bag)))
    return rem(d.pool,P:random(#d.pool))
end,

-- Others

balanced=function(P,d,init) -- TODO, now exactly same with bag7
    if init then
        d.weights=TABLE.new(1,7)
        d.targetCount=TABLE.new(0,7)
        d.realCount=TABLE.new(0,7)
        d._cache={}
        return
    end
    local totalWeight=MATH.sum(d.weights)
    for i=1,#d.weights do
        d.targetCount[i]=d.targetCount[i]+d.weights[i]/totalWeight
        d._cache[i]=max(d.targetCount[i]-d.realCount[i],0)
    end
    local sum=MATH.sum(d._cache)
    local r=P:random()*sum
    for i=1,#d._cache do
        r=r-d._cache[i]
        if r<=0 then
            d.realCount[i]=d.realCount[i]+1
            return i
        end
    end
    return #d.weights -- Fallback
end,

his4_roll4=function(P,d,init)
    if init then d.his=TABLE.new(0,4) return end
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
end,

c2=function(P,d,init)
    if init then d.weight=TABLE.new(0,7) return end
    local maxK=1
    for i=1,7 do
        d.weight[i]=d.weight[i]*.5+P:random()
        if d.weight[i]>d.weight[maxK] then
            maxK=i
        end
    end
    d.weight[maxK]=d.weight[maxK]/3.5
    return maxK
end,

messy=function(P,d,init) -- no repeating random
    if init then return end
    repeat
        d.recent=P:random(7)
    until d.recent~=d.prev
    d.prev=d.recent
    return d.recent
end,

random=function(P,d,init) -- pure random
    if init then d.flandre='cute' return end
    return P:random(7)
end,

-- Pento

bag18_pento=function(P,d,init)
    if init then d.bag={} return end
    supply(d.bag,Pentos)
    return rem(d.bag,P:random(#d.bag))
end,

bag8_pentoEZ_p4fromBag10_pentoHD=function(P,d,init)
    if init then d.bag1,d.bag2={},{} return end
    if supply(d.bag1,easyPentos) then
        for _=1,4 do
            supply(d.bag2,hardPentos)
            ins(d.bag1,rem(d.bag2,P:random(#d.bag2)))
        end
    end
    return rem(d.bag1,P:random(#d.bag1))
end,

}

---@param P Techmino.Player.Brik
---@param d table cached data of generator
---@param init boolean true if this is the first initializating call
---@diagnostic disable-next-line
function sequence.none(P,d,init)
end

--------------------------------------------------------------
-- Dist-Weight sequence invented by MrZ & Farter

sequence.distWeight={}
for variant,data in next,{
    sim7bag={
        pieces=Tetros,
        weights={64606156304596,131327514360144,203786783816133,287098623729448,390038487466665,531106246225509,762542509117884,896123925124349,1108610016824348,1476868735064520,2236067394570951,4591633945951618,1e99}, -- Data from Farter
    },
    natural={
        pieces=Tetros,
        weights={0,0,1,1,1,2,3,4,6,8,10,26},
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

            d.tempWei=TABLE.new(0,d.len)
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

---@cast sequence Map<Techmino.Event.Brik | Map<Techmino.Event.Brik>>
return sequence
