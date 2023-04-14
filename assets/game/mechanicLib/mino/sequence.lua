local ins,rem=table.insert,table.remove

local sequence={}

function sequence.none()
    while true do coroutine.yield() end
end

function sequence.bag7(P)
    local l={}
    while true do
        if not l[1] then for i=1,7 do l[i]=i end end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.bag7b1(P)
    local l0={}
    local l={}
    while true do
        if not l[1] then
            for i=1,7 do l[i]=i end
            if not l0[1] then for i=1,7 do l0[i]=i end end
            l[8]=rem(l0,P:random(#l0))
        end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.h4r2(P)
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

function sequence.penta_bag18(P)
    local l={}
    while true do
        if not l[1] then for i=8,25 do table.insert(l,i) end end
        coroutine.yield(table.remove(l,P:random(#l)))
    end
end

return sequence
