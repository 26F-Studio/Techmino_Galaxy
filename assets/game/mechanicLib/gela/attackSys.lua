---@type Map<Map<fun(P:Techmino.Player.Gela):any>>
local atkSys={}

-- No attack
atkSys.none={
    init=NULL,
    clear=NULL,
}

-- Classic
atkSys.classic={
    clear=function(P)
        -- TODO
    end,
}

for _,sys in next,atkSys do
    setmetatable(sys,{__index=atkSys.none})
end

setmetatable(atkSys.none,{__index=function() return NULL end})

return atkSys
