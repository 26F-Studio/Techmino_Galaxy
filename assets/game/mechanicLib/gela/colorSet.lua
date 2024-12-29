---@type Map<Techmino.Event.Gela | number[]>
local colorSet={}

-- R Y B G P C O M
colorSet.light  ={955,994,469,696,759,699,974,968}
colorSet.classic={933,882,249,484,639,489,952,948}
colorSet.dark   ={400,440,014,141,204,144,420,413}

-- (Garbage use 666)
colorSet.greyscale={111,333,777,999,888,555,444,222}

function colorSet.getRandom(P)
    -- TODO: reasonable random color
end

return colorSet
