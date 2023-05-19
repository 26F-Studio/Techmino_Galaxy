local ins,rem=table.insert,table.remove

--- @type Techmino.Mech.puyo
local sequence={}

function sequence.none()
    while true do coroutine.yield() end
end

function sequence.double3color(P)
    local l={}
    while true do
        if not l[1] then for i=1,3 do for j=1,3 do ins(l,{{i},{j}}) end end end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.double4color(P)
    local l={}
    while true do
        if not l[1] then for i=1,4 do for j=1,4 do ins(l,{{i},{j}}) end end end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

function sequence.double5color(P)
    local l={}
    while true do
        if not l[1] then for i=1,5 do for j=1,5 do ins(l,{{i},{j}}) end end end
        coroutine.yield(rem(l,P:random(#l)))
    end
end

return sequence
