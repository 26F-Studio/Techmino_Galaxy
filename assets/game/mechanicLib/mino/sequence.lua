local min,max=math.min,math.max
local ins,rem=table.insert,table.remove

local shift=TABLE.shift

--- @type Techmino.Mech.mino
local sequence={}

local Tetros={1,2,3,4,5,6,7}
local Pentos={8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
local easyPentos={10,11,14,19,20,23,24,25}-- P Q T5 J5 L5 N H I5
local hardPentos={8,9,12,13,15,16,17,18,21,22}-- Z5 S5 F E U V W X R Y

function sequence.none()
    while true do coroutine.yield() end
end

function sequence.bag7(P)
    local l={}
    while true do
        if not l[1] then l=shift(Tetros) end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.bag7_bag1(P)
    local l,ex={},{}
    while true do
        if not l[1] then
            l=shift(Tetros)
            if not ex[1] then ex=shift(Tetros) end
            l[8]=rem(ex,P:random(#ex))
        end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.bag7_sprint(P)
    -- First Bag, try to prevent early S/Z/O
    local l=shift(Tetros)
    for i=7,2,-1 do ins(l,rem(l,P:random(1,i))) end
    for _=1,2 do
        if l[1]==1 or l[1]==2 or l[1]==6 then
            ins(l,P:random(7),rem(l,1))
        end
    end
    for i=1,7 do coroutine.yield(l[i]) end

    -- Second to fourth Bag, gradually increase the shuffle range
    local rndRange=4
    while rndRange<7 do
        local l2={}
        for _=1,7 do ins(l2,rem(l,P:random(min(#l,rndRange)))) end
        for i=1,7 do coroutine.yield(l2[i]) end
        l=l2
        rndRange=rndRange+1
    end

    -- Completely random from fifth Bag
    while true do
        if not l[1] then l=shift(Tetros) end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.bag7_steal1(P)
    local l={}
    local victim=shift(Tetros)
    rem(victim,P:random(7))
    while true do
        if not l[1] then
            l,victim=victim,l
            victim=shift(Tetros)
            ins(l,rem(victim,P:random(#victim)))
        end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.bag12_drought(P)-- bag14 without I piece
    local l={}
    while true do
        if not l[1] then for i=1,6 do
            ins(l,i)
            ins(l,i)
        end end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.bag7_flood(P)-- bag7 with extra 3 S pieces and 3 Z pieces
    local l={}
    while true do
        if not l[1] then
            l=shift(Tetros)
            l[8],l[9],l[10]=1,1,1
            l[11],l[12],l[13]=2,2,2
        end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.his4_roll2(P)
    local history=TABLE.new(0,2)
    while true do
        local r
        for _=1,#history do-- Reroll up to [hisLen] times
            r=P:random(7)
            local repeated
            for i=1,#history do
                if r==history[i] then
                    repeated=true
                    break
                end
            end
            if not repeated then break end-- Not repeated means success, available r value
        end
        rem(history,1)
        ins(history,r)
        if history[1]~=0 then-- Initializing, just continue generating until history is full
            coroutine.yield(r)
        end
    end
end

function sequence.c2(P)
    local weight=TABLE.new(0,7)
    while true do
        local maxK=1
        for i=1,7 do
            weight[i]=weight[i]*.5+P:random()
            if weight[i]>weight[maxK] then
                maxK=i
            end
        end
        weight[maxK]=weight[maxK]/3.5
        coroutine.yield(maxK)
    end
end

function sequence.random(P)
    local r,prev
    while true do
        repeat
            r=P:random(7)
        until r~=prev
        prev=r
        coroutine.yield(r)
    end
end

function sequence.mess(P)
    while true do
        coroutine.yield(P:random(7))
    end
end

function sequence.pento_bag18(P)
    local l={}
    while true do
        if not l[1] then l=shift(Pentos) end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.pento_bag_ez8hd4Bag10(P)
    local l,ex={},{}
    while true do
        if not l[1] then
            l=shift(easyPentos)
            for _=1,4 do
                if not ex[1] then ex=shift(hardPentos) end
                ins(l,rem(ex,P:random(#ex)))
            end
        end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

local weight_bag7={1,3,6,10,15,21,28,34,39,43,46,48,49}
function sequence.distWeight_bag7(P)
    local dist={1,1,1,1,1,1,1}
    local rate={0,0,0,0,0,0,0}
    while true do
        for i=1,7 do
            dist[i]=dist[i]+1
            rate[i]=weight_bag7[dist[i]] or 2e6
        end
        local sum=0
        for i=1,7 do
            sum=sum+rate[i]
        end
        local r=P:random()*sum
        for i=1,7 do
            r=r-rate[i]
            if r<=0 then
                coroutine.yield(i)
                dist[i]=0
                break
            end
        end
    end
end

return sequence
