local PLAYER={}

function PLAYER.new(data)
    local p
    if data.type=='mino' then
        p=require'assets.player.minoPlayer'.new(data)
    elseif data.type=='puyo' then
        error('Peach')
    else
        error("function PLAYER.new(data): data.type must be 'mino'")
    end

    setmetatable(p,{__index=PLAYER})
    return p
end

return PLAYER
