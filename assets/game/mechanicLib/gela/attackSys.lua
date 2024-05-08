local atkSys={}

-- No attack
atkSys.none={}

for _,sys in next,atkSys do
    setmetatable(sys,{__index=atkSys.none})
end

setmetatable(atkSys.none,{__index=function() return NULL end})

return setmetatable(atkSys,{__index=function() return atkSys.none end})
