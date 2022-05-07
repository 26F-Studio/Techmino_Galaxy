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

local layoutFuncs=setmetatable({},{__index=function(self,k)
    if k==nil then
        return self.default
    elseif type(k)=='string' then
        return self[k] or error("Layout '"..tostring(k).."' not exist")
    else
        error("Layout must be string")
    end
end})
do -- function layoutFuncs.default():
    local defaultPosList={
        alive={
            [1]={main={800,500}},
            [3]={main={800,500},
                {200, 500,.4},
                {1400,500,.4},
            },
            [5]={main={800,500},
                {220, 260,.5},
                {1380,260,.5},
                {220, 740,.5},
                {1380,740,.5},
            },
            [7]={main={800,500},
                {220, 200,.34},
                {220, 500,.34},
                {220, 800,.34},
                {1380,200,.34},
                {1380,500,.34},
                {1380,800,.34},
            },
            [17]={main={800,500},
                {120, 140,.26},{120, 380,.26},{120, 620,.26},{120, 860,.26},
                {320, 140,.26},{320, 380,.26},{320, 620,.26},{320, 860,.26},
                {1280,140,.26},{1280,380,.26},{1280,620,.26},{1280,860,.26},
                {1480,140,.26},{1480,380,.26},{1480,620,.26},{1480,860,.26},
            },
            [31]={},
            [49]={},
            [99]={},
            [MATH.inf]={},
        },
        dead={
            [1]={{800,500}},
            [2]={
                {420, 500,.9},{1180,500,.9},
            },
            [3]={
                {280, 500,.66},{800, 500,.66},{1320,500,.66},
            },
            [4]={
                {210, 500,.5},{600, 500,.5},{1000,500,.5},{1390,500,.5},
            },
            [10]={
                {170, 260,.4},{485, 260,.4},{800, 260,.4},{1115,260,.4},{1430,260,.4},
                {170, 740,.4},{485, 740,.4},{800, 740,.4},{1115,740,.4},{1430,740,.4},
            },
            [24]={
                {150, 200,.32},{410, 200,.32},{670, 200,.32},{930, 200,.32},{1190,200,.32},{1450,200,.32},
                {150, 500,.32},{410, 500,.32},{670, 500,.32},{930, 500,.32},{1190,500,.32},{1450,500,.32},
                {150, 800,.32},{410, 800,.32},{670, 800,.32},{930, 800,.32},{1190,800,.32},{1450,800,.32},
            },
            [48]={},
            [99]={},
            [MATH.inf]={},
        },
    }
    function layoutFuncs.default()
        local mode=GAME.mainPID and defaultPosList.alive or defaultPosList.dead
        local minCap=MATH.inf
        for count in next,mode do
            if count<=minCap and count>=#GAME.playerList then
                minCap=count
            end
        end
        local layoutData=mode[minCap]

        local pos=1
        for _,P in next,GAME.playerList do
            if P.isMain then
                P:setPosition(unpack(layoutData.main))
            else
                P:setPosition(unpack(layoutData[pos]))
                pos=pos+1
            end
        end
    end
end

local GAME={
    playerList=false,
    playerMap=false,

    hitWaves={},

    seed=false,
    mode=false,
    mainPID=false,
    -- TODO: ...
}

function GAME.reset(mode,seed)
    GAME.playerList={}
    GAME.playerMap={}

    GAME.hitWaves={}

    GAME.mainPID=false
    GAME.seed=seed or math.random(2^16,2^26)
    GAME.mode=mode and getMode(mode) or NONE
    if GAME.mode.initialize then GAME.mode.initialize() end
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
    GAME.playerMap[id]=P
    table.insert(GAME.playerList,P)
end

function GAME.setMain(id)
    if GAME.mainPID then
        GAME.playerMap[GAME.mainPID].isMain=false
    end
    if GAME.playerMap[id] then
        GAME.mainPID=id
        GAME.playerMap[id].isMain=true
        GAME.playerMap[id].sound=true
    end
end

function GAME.start()
    if GAME.mainPID then GAME.playerMap[GAME.mainPID]:loadSettings(SETTINGS.game) end
    if GAME.mode.settings then
        for i=1,#GAME.playerList do
            GAME.playerList[i]:loadSettings(GAME.mode.settings)
        end
    end

    for i=1,#GAME.playerList do
        GAME.playerList[i]:initialize()
        GAME.playerList[i]:triggerEvent('playerInit')
    end

    if type(GAME.mode.layout)=='function' then
        GAME.mode.layout()
    else
        layoutFuncs[GAME.mode.layout]()
    end
end

function GAME.press(action,id)
    if not id then id=GAME.mainPID end
    if not id then return end
    GAME.playerMap[id or GAME.mainPID]:press(action)
end

function GAME.release(action,id)
    if not id then id=GAME.mainPID end
    if not id then return end
    GAME.playerMap[id or GAME.mainPID]:release(action)
end

function GAME.update(dt)
    for _,P in next,GAME.playerList do P:update(dt) end

    for i=#GAME.hitWaves,1,-1 do
        local wave=GAME.hitWaves[i]
        wave.time=wave.time+dt
    end
end

function GAME.render()
    gc.setCanvas({Zenitha.getBigCanvas('player'),stencil=true})
    gc.clear(1,1,1,0)
    for _,P in next,GAME.playerList do P:render() end
    gc.setCanvas()

    gc.replaceTransform(SCR.origin)
    if #GAME.hitWaves>0 then
        local L=GAME.hitWaves
        for i=1,#L do
            local timeK=1/(400*L[i].time+50)-.0026
            if timeK<=0 then
                L[i][3]=0
            else
                L[i][3]=6.26-2.6*L[i].time
                L[i][4]=math.cos(L[i].time*26)*L[i].power*timeK
            end
        end
        SHADER.warp:send('hitWaves',unpack(L))
        gc.setShader(SHADER.warp)
    else
        gc.setShader(SHADER.none)-- Directly draw the content, don't consider color, for better performance(?)
    end
    gc.draw(Zenitha.getBigCanvas('player'))
    gc.setShader()
end

function GAME._addHitWave(x,y,power)
    if SETTINGS.system.hitWavePower<=0 then return end
    if #GAME.hitWaves>=8 then
        local maxI=1
        for i=2,#GAME.hitWaves do
            if GAME.hitWaves[i].time>GAME.hitWaves[maxI].time then
                maxI=i
            end
        end
        table.remove(GAME.hitWaves,maxI)
    end
    table.insert(GAME.hitWaves,{
        x,y,
        nil,nil,-- power1 & power2, calculated before sending uniform
        time=0,
        power=power*SETTINGS.system.hitWavePower,
    })
end

return GAME
