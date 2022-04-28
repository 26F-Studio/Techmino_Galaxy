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

    hitWaves={},

    seed=false,
    mode=false,
    mainPID=false,
    -- TODO: ...
}

function GAME.reset(mode,seed)
    GAME.players={}
    GAME.playersCount=0

    GAME.hitWaves={}

    GAME.mainPID=false
    GAME.seed=seed or math.random(2^16,2^26)
    GAME.mode=mode and getMode(mode) or NONE
    if GAME.mode.bgm then
        BGM.play(GAME.mode.bgm)
    end
end

function GAME.newPlayer(id,pType)
    local P
    if not (type(id)=='number' and math.floor(id)==id and id>=1 and id<=1000) then
        MES.new('error',"player id must be 1~1000 integer")
        return
    end
    if pType~='mino' then
        MES.new('error',"player type must be 'mino'")
        return
    end
    P=require'assets.game.minoPlayer'.new(GAME.mode)
    P.id=id
    P.isMain=false
    GAME.players[id]=P
    GAME.playersCount=GAME.playersCount+1
end

function GAME.setMain(id)
    if GAME.mainPID then
        GAME.players[GAME.mainPID].isMain=false
    end
    if GAME.players[id] then
        GAME.mainPID=id
        GAME.players[id].isMain=true
        GAME.players[id].sound=true
    end
end

function GAME.start()
    if GAME.mainPID then GAME.players[GAME.mainPID]:loadSettings(SETTINGS.game) end
    if GAME.mode.settings then
        for _,P in next,GAME.players do
            P:loadSettings(GAME.mode.settings)
        end
    end

    if GAME.mode.layout then
        
    end

    for _,P in next,GAME.players do
        P:initialize()
        P:triggerEvent('playerInit')
        P:setPosition(800,500)
    end
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

function GAME.update(dt)
    for _,P in next,GAME.players do P:update(dt) end

    for i=#GAME.hitWaves,1,-1 do
        local wave=GAME.hitWaves[i]
        wave[3]=wave[3]+dt
    end
end

function GAME.render()
    for _,P in next,GAME.players do P:render() end

    gc.replaceTransform(SCR.origin)
    if #GAME.hitWaves>0 then
        SHADER.warp:send('hitWaves',unpack(GAME.hitWaves))
        gc.setShader(SHADER.warp)
    else
        gc.setShader(SHADER.none)-- Directly draw the content, don't consider color, for better performance(?)
    end
    gc.draw(Zenitha.getBigCanvas('player'))
    gc.setShader()
end

function GAME._addHitWave(x,y,power)
    if #GAME.hitWaves>=10 then
        local maxI=1
        for i=2,#GAME.hitWaves do
            if GAME.hitWaves[i][3]>GAME.hitWaves[maxI][3] then
                maxI=i
            end
        end
        table.remove(GAME.hitWaves,maxI)
    end
    table.insert(GAME.hitWaves,{x,y,0,power})
end

return GAME
