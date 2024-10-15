local skinLib={}

local SKIN={}

SKIN.time=0
local function _getTime() return SKIN.time end

---@class Techmino.Skin
---@field base string
---@field getTime function
---@field drawFieldBackground fun(fieldW:number)
---@field drawFieldCell fun(C:Techmino.Brik.Cell, F:Techmino.RectField, x:number, y:number)
---@field drawGhostCell fun(C:Techmino.Brik.Cell, B:Techmino.RectPiece, x:number, y:number)
---@field drawHandCellStroke fun(C:Techmino.Brik.Cell, B:Techmino.RectPiece, x:number, y:number)
---@field drawHandCell fun(C:Techmino.Brik.Cell, B:Techmino.RectPiece, x:number, y:number)
---@field drawFloatHoldCell fun(C:Techmino.Brik.Cell, disabled:boolean, B:Techmino.RectPiece, x:number, y:number)
---@field drawFloatHoldMark fun(n:number, disabled:boolean)
---@field drawHeightLines fun(fieldW:number, maxSpawnH:number, spawnH:number, lockoutH:number, deathH:number, voidH:number)
---@field drawFieldBorder fun()
---@field drawAsdIndicator fun(dir:number , charge:number, asdMax:number, aspMax:number, ash:number)
---@field drawDelayIndicator fun(color:Zenitha.Color, value:number)
---@field drawGarbageBuffer fun(garbageBuffer:table)
---@field drawLockDelayIndicator fun(freshCondition:string, freshChance:number, maxFreshTime:number, freshTime:number)
---@field drawNextBorder fun(slot:number)
---@field drawNextCell fun(C:Techmino.Brik.Cell, disabled:boolean, B:Techmino.RectPiece, x:number, y:number)
---@field drawHoldBorder fun(mode:string, slot:number)
---@field drawHoldCell fun(C:Techmino.Brik.Cell, disabled:boolean, B:Techmino.RectPiece, x:number, y:number)
---@field drawTime fun(time:number)
---@field drawStartingCounter fun(readyDelay:number)
---@field drawInfoPanel fun(x:number, y:number, w:number, h:number) Only called by mode

---@class Techmino.Skin.Brik: Techmino.Skin

---@class Techmino.Skin.Gela: Techmino.Skin
---@field drawFieldCell fun(C:Techmino.Brik.Cell, F:Techmino.RectField, x:number, y:number, connH?:number)

---@class Techmino.Skin.Acry: Techmino.Skin
---@field drawSwapCursor fun(cx:number, cy:number, lock:boolean)
---@field drawTwistCursor fun(sx:number, sy:number)

---@param name string
---@param skin Techmino.Skin
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
