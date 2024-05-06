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

---@type Techmino.Mech.puyo
local sequence={}

---@param P Techmino.Player.Puyo
---@param d table cached data of generator
---@param init boolean true if this is the first initializating call
---@diagnostic disable-next-line
function sequence.none(P,d,init)
end

--------------------------------------------------------------
-- Twin

-- Simply all permutations
local TwinSet={}
for i=1,8 do
    TwinSet[i]={}
    for x=1,i do for y=1,i do
        ins(TwinSet[i],{{x},{y}})
    end end
end
for _,bagCount in next,{2,4,8} do for colors=3,8 do
    sequence['twin_'..bagCount..'S'..colors..'C']=function(P,d,init)
        if init then d.bag={} return end
        supply(d.bag,TwinSet[colors],bagCount)
        return rem(d.bag,P:random(#d.bag))
    end
end end

-- No repeat in one set
local NRTwinSet={}
for i=1,8 do
    NRTwinSet[i]={}
    for x=1,i do for y=1,x do
        ins(NRTwinSet[i],{{x},{y}})
    end end
end
for _,bagCount in next,{2,4,8} do for colors=3,8 do
    sequence['twin_'..bagCount..'S'..colors..'NRC']=function(P,d,init)
        if init then d.bag={} return end
        supply(d.bag,NRTwinSet[colors],bagCount)
        return rem(d.bag,P:random(#d.bag))
    end
end end

--------------------------------------------------------------
-- Multi

-- TODO

return sequence
