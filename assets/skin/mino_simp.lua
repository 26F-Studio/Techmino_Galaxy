--[[
    Base on mino_template:
    Remove HeightLines
    Remove DelayIndicator
    Static starting counter
]]
local gc=love.graphics
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_line=gc.line

local COLOR=COLOR

---@type Techmino.skin.mino
local S={}
S.base='mino_template'

function S.drawFieldBorder()
    gc_setLineWidth(2)
    gc_setColor(1,1,1)
    gc_line(-201,-401,-201,401,201,401,201,-401)
end

function S.drawHeightLines(fieldW,maxSpawnH,spawnH,lockoutH,deathH,voidH)
end

function S.drawDasIndicator(dir,charge,dasMax,arrMax)
end

function S.drawDelayIndicator(color,value)
end

function S.drawLockDelayIndicator(freshCondition,freshChance)
end

function S.drawStartingCounter(readyDelay)
    FONT.set(100)
    gc_setColor(COLOR.L)
    GC.mStr(math.floor((readyDelay-S.getTime())/1000)+1,0,-70)
end

return S
