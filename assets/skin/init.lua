local skinLib={}

local SKIN={}

SKIN.time=0
local function _getTime() return SKIN.time end

---@class Techmino.skin
---@field base string
---@field getTime function
---@field drawFieldBackground fun(fieldW:number)
---@field drawFieldBorder fun()
---@field drawFieldCell fun(C:Techmino.Cell, F:Techmino.RectField, x:number, y:number)
---@field drawFloatHold fun(n:number|string, B:table, handX:number, handY:number, unavailable:boolean)
---@field drawHeightLines fun(fieldW:number, maxSpawnH:number, spawnH,lockoutH:number, deathH:number, voidH:number)
---@field drawAsdIndicator fun(dir:number , charge:number, asdMax:number, aspMax:number, asHalt:number)
---@field drawDelayIndicator fun(color:Zenitha.Color, value:number)
---@field drawGarbageBuffer fun(garbageBuffer:table)
---@field drawLockDelayIndicator fun(freshCondition:string, freshChance:number)
---@field drawGhost fun(B:table, handX:number, ghostY:number)
---@field drawHand fun(B:table, handX:number, handY:number)
---@field drawNextBorder fun(slot:number)
---@field drawNext fun(n:number, B:table, unavailable:boolean)
---@field drawHoldBorder fun(mode:string, slot:number)
---@field drawHold fun(n:number, B:table, unavailable:boolean)
---@field drawTime fun(time:number)
---@field drawInfoPanel fun(x:number, y:number, w:number, h:number)
---@field drawStartingCounter fun(readyDelay:number)

---@class Techmino.skin.mino: Techmino.skin

---@class Techmino.skin.puyo: Techmino.skin

---@class Techmino.skin.gem: Techmino.skin
---@field drawSwapCursor fun(cx:number, cy:number, lock:boolean)
---@field drawTwistCursor fun(sx:number, sy:number)

---@param name string
---@param skin Techmino.skin
function SKIN.add(name,skin)
    assert(type(name)=='string',"Skin name must be string")
    assert(not SKIN[name],"Skin "..name.." already exists")
    assert(type(skin)=='table',"Skin must be table")
    assert(getmetatable(skin)==nil,"Skin table must not have metatable")

    assert(not skin.getTime,"Skin mustn't define 'getTime'")
    skin.getTime=_getTime

    setmetatable(skin,{__index=skin.base and assert(skinLib[skin.base],"no base skin named "..tostring(skin.base))})

    skinLib[name]=skin
end

function SKIN.get(name)
    return assert(skinLib[name])
end

function SKIN.setTime(t)
    SKIN.time=t
end

return SKIN
