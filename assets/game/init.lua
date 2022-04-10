local gc=love.graphics

local modeLib={}
local function getMode(name)
    if modeLib[name] then
        return modeLib[name]
    else
        local path='assets/game/mode/'..name..'.lua'
        if FILE.isSafe(path) then
            modeLib[name]=FILE.load(path,'-lua')
            return modeLib[name]
        end
    end
end

local GAME={
    players={},
    playersCount=0,

    seed=false,
    mode=false,
    mainPID=false,
    -- TODO: ,,,
}

function GAME.reset(mode)
    GAME.players={}
    GAME.playersCount=0
    GAME.seed=math.random(2600,62600)
    GAME.mode=getMode(mode) or NONE
end

function GAME.newPlayer(id,pType)
    local P
    assert(type(id)=='number',"newPlayer: wrong data.id")
    if pType=='mino' then
        P=require'assets.game.minoPlayer'.new(id,GAME.mode)
    else
        error("player type must be 'mino'")
    end
    GAME.players[id]=P
    GAME.playersCount=GAME.playersCount+1
end

function GAME.setMain(id)
    GAME.mainPID=id
end

function GAME.press(action,id)
    if not id then id=GAME.mainPID end
    if not id then return end
    GAME.players[id or GAME.mainPID]:press(action)
end

function GAME.release(action,id)
    if not id then id=GAME.mainPID end
    if not id then return end
    GAME.players[id or GAME.mainPID]:release(action)
end

function GAME.start()
    for id,P in next,GAME.players do P:setPosition(800,500) end
end

function GAME.update(dt)
    for id,P in next,GAME.players do P:update(dt) end
end

function GAME.render()
    for id,P in next,GAME.players do P:render() end

    gc.replaceTransform(SCR.origin)
    gc.setShader(SHADER.none)-- Directly draw the content, don't consider color, for better performance(?)
    gc.draw(Zenitha.getBigCanvas('player'))
    gc.setShader()
end

return GAME
