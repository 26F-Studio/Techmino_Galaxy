local skinLib={
    default=require'assets.skin.default',
}

local SKIN={}

function SKIN.get(name)
    return skinLib[name] or skinLib.default
end

return SKIN
