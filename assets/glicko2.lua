---@diagnostic disable

-- Glicko2 lua implementation

---@class playerInfo
---@field rating number
---@field deviation number
---@field volatility number

---@class matchInfo
---@field p1 playerInfo
---@field p2 playerInfo
---@field score1 number
---@field score2 number
local match={}
function match:settle()
    self.p1=self:_settleP(self.p1,self.p2,self.score1,self.score2)
    self.p2=self:_settleP(self.p2,self.p1,self.score2,self.score1)
end

---@return playerInfo
function match:_settleP(p1,p2,s1,s2)
    return
end
