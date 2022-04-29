local skinLib={}

local SKIN={}

SKIN.time=0
local function _getTime() return SKIN.time end

function SKIN.add(name,data)
    assert(type(name)=='string',"Skin name must be string")
    assert(not SKIN[name],"Skin "..name.." already exists")
    assert(type(data)=='table',"Skin must be table")
    assert(getmetatable(data)==nil,"Skin table must not have metatable")

    assert(not data.getTime,"Fatal warning: skin table must not define 'getTime'")
    data.getTime=_getTime

    setmetatable(data,{__index=skinLib.default})

    skinLib[name]=data
end

function SKIN.get(name)
    return skinLib[name] or skinLib.default
end

function SKIN.setTime(t)
    SKIN.time=t
end

return SKIN
