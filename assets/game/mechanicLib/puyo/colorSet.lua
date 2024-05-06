---@type Techmino.Mech.puyo
local colorSet={}

-- R Y B G P C O M
colorSet.light={955,994,469,696,759,699,974,969}
colorSet.classic={933,882,249,484,539,489,952,849}
colorSet.black={400,440,014,141,204,144,420,414}

colorSet.grey={111,333,555,999,888,666,444,222}

function colorSet.getRandom(P)
    P:random()
end

setmetatable(colorSet,{
    __index=function(_,k)
        assertf(k=='random','Invalid color set key : %s',k)
        if 1 then
            local l={}
            -- TODO
            return l
        else
            error('Not color set : '..k)
        end
    end
})

return colorSet
