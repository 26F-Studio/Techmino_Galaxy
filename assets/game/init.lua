require'assets.game.rotsys_mino'
MinoAtkSys=require'assets.game.atksys_mino'
Minoes=require'assets.game.minoes'
particleTemplate=require'assets.game.particleSystemTemplate'
ColorTable=require'assets.game.colorTable'

local gc=love.graphics

local layoutFuncs={}
do -- function layoutFuncs.default():
    local defaultPosList={
        alive={
            [1]={main={800,500}},
            [3]={main={800,500},
                {1380,600,.5},
                {220,600,.5},
            },
            [5]={main={800,500},
                {220,260,.5},
                {1380,260,.5},
                {220,740,.5},
                {1380,740,.5},
            },
            [7]={main={800,500},
                {220,200,.34},{220,500,.34},{220,800,.34},
                {1380,200,.34},{1380,500,.34},{1380,800,.34},
            },
            [17]={main={800,500},
                {120,140,.26},{120,380,.26},{120,620,.26},{120,860,.26},
                {320,140,.26},{320,380,.26},{320,620,.26},{320,860,.26},
                {1280,140,.26},{1280,380,.26},{1280,620,.26},{1280,860,.26},
                {1480,140,.26},{1480,380,.26},{1480,620,.26},{1480,860,.26},
            },
            [37]=(function()
                local l={main={800,500}}
                for y=-2.5,2.5 do
                    for x=0,2 do
                        table.insert(l,{340-130*x ,500+160*y,.17})
                        table.insert(l,{1260+130*x,500+160*y,.17})
                    end
                end
                return l
            end)(),
            [73]=(function()
                local l={main={800,500}}
                for y=-4,4 do
                    for x=0,3 do
                        table.insert(l,{360-100*x ,500+110*y,.13})
                        table.insert(l,{1240+100*x,500+110*y,.13})
                    end
                end
                return l
            end)(),
            [MATH.inf]={main={800,500}},
        },
        dead={
            [1]={{800,500}},
            [2]={
                {420,500,.9},{1180,500,.9},
            },
            [3]={
                {280,500,.66},{800,500,.66},{1320,500,.66},
            },
            [4]={
                {210,500,.5},{600,500,.5},{1000,500,.5},{1390,500,.5},
            },
            [15]=(function()
                local l={}
                for y=-1,1 do
                    for x=-2,2 do
                        table.insert(l,{800+315*x ,500+320*y,.36})
                    end
                end
                return l
            end)(),
            [32]=(function()
                local l={}
                for y=-1.5,1.5 do
                    for x=-3.5,3.5 do
                        table.insert(l,{800+200*x ,500+240*y,.25})
                    end
                end
                return l
            end)(),
            [72]=(function()
                local l={}
                for y=-2.5,2.5 do
                    for x=-5.5,5.5 do
                        table.insert(l,{800+130*x ,500+160*y,.17})
                    end
                end
                return l
            end)(),
            [MATH.inf]={},
        },
    }
    function layoutFuncs.default()
        local mode=GAME.mainPlayer and defaultPosList.alive or defaultPosList.dead
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

local modeLib={}
local modeMeta={
    __index={
        initialize=NULL,
        settings={},
        layout='default',
        checkFinish=function() return true end,
        result=NULL,
        scorePage=NULL,
    },
    __metatable=true,
}
local function getMode(name)
    if modeLib[name] then
        return modeLib[name]
    else
        local path='assets/game/mode/'..name..'.lua'
        assert(love.filesystem.getInfo(path) and FILE.isSafe(path),"No mode called "..tostring(name))
        local M=FILE.load(path,'-lua -canskip')
        assert(type(M)=='table')
        setmetatable(M,modeMeta)
        assert(type(M.initialize)         =='function',"[mode].initialize must be function")
        assert(type(M.settings)           =='table',   "[mode].settings must be table")
        assert(type(layoutFuncs[M.layout])=='function',"[mode].layout type wrong")
        assert(type(M.checkFinish)        =='function',"[mode].checkFinish must be function")
        assert(type(M.result)             =='function',"[mode].result must be function")
        assert(type(M.scorePage)          =='function',"[mode].scorePage must be function")

        M.name=name
        modeLib[name]=M
        return M
    end
end

local GAME={
    playerList=false,
    playerMap=false,

    hitWaves={},

    seed=false,
    mode=false,

    mainPID=false,
    mainPlayer=false,
}

function GAME.reset(mode,seed)
    GAME.playerList={}
    GAME.playerMap={}

    GAME.hitWaves={}

    GAME.mainPlayer=false
    GAME.seed=seed or math.random(2^16,2^26)
    GAME.mode=mode and getMode(mode) or NONE
    if GAME.mode.initialize then GAME.mode.initialize() end
end

function GAME.newPlayer(id,pType)
    if not (type(id)=='number' and math.floor(id)==id and id>=1 and id<=1000) then
        MES.new('error',"player id must be 1~1000 integer")
        return
    end

    local P
    if pType=='mino' then
        P=require'assets.game.minoPlayer'.new(GAME.mode)
    elseif pType=='puyo' then
        P=require'assets.game.puyoPlayer'.new(GAME.mode)
    elseif pType=='gem' then
        P=require'assets.game.gemPlayer'.new(GAME.mode)
    else
        MES.new('error',"invalid player type :'"..tostring(pType).."'")
        return
    end

    P.gameMode=pType
    P.id=id
    P.isMain=false
    GAME.playerMap[id]=P
    table.insert(GAME.playerList,P)
end

function GAME.setMain(id)
    if GAME.mainPlayer then
        GAME.playerMap[GAME.mainPlayer].isMain=false
        GAME.mainPID=false
        GAME.mainPlayer=false
    end
    if GAME.playerMap[id] then
        GAME.mainPID=id
        GAME.mainPlayer=GAME.playerMap[id]
        GAME.mainPlayer.isMain=true
        GAME.mainPlayer.sound=true
    end
end

function GAME.start()
    if #GAME.playerList==0 then
        MES.new('warn',"No players created in this mode")
    else
        if GAME.mainPlayer then
            local conf=SETTINGS["game_"..GAME.mainPlayer.gameMode]
            if conf then GAME.mainPlayer:loadSettings(conf) end
        end
        if GAME.mode.settings then
            for i=1,#GAME.playerList do
                local conf=GAME.mode.settings[GAME.playerList[i].gameMode]
                if conf then
                    GAME.playerList[i]:loadSettings(conf)
                end
            end
        end

        for i=1,#GAME.playerList do
            GAME.playerList[i]:initialize()
            GAME.playerList[i]:triggerEvent('playerInit')
        end

        layoutFuncs[GAME.mode['layout']]()
    end
end

function GAME.press(action,id)
    if id then
        GAME.playerMap[id]:press(action)
    elseif GAME.mainPlayer then
        GAME.mainPlayer:press(action)
    end
end

function GAME.release(action,id)
    if id then
        GAME.playerMap[id]:release(action)
    elseif GAME.mainPlayer then
        GAME.mainPlayer:release(action)
    end
end

--[[ data:
    power (0~∞,  no default)
    mode  (0~1,   default to 0, 0: trigger by time, 1:trigger by step)
    time  (0~∞,  default to 0, seconds)
    fatal (0~100, default to 50, percentage)
    speed (0~100, default to 50, percentage)
]]
function GAME.send(source,data)
    -- Format normalization
    assert(type(data)=='table',"data not table")
    assert(type(data.power)=='number' and data.power>0,"bad power value")
    if data.mode==nil then data.mode=0 end
    assert(data.mode==0 or data.mode==1,"bad mode value")
    if data.time==nil then data.time=0 else
        assert(type(data.time)=='number',"time not number")
        data.time=math.max(data.time,0)
        if data.mode==1 then data.time=math.floor(data.time) end
    end
    if data.fatal==nil then data.fatal=50 else
        assert(type(data.fatal)=='number',"fatal not number")
        data.fatal=MATH.clamp(data.fatal,0,100)
    end
    if data.speed==nil then data.speed=50 else
        assert(type(data.speed)=='number',"speed not number")
        data.speed=MATH.clamp(data.speed,0,100)
    end

    local d={
        power=data.power,
        mode=data.mode,
        time=data.time,
        fatal=data.fatal,
        speed=data.speed,
    }

    -- Find target
    local target=d.target
    if not (target and GAME.playerMap[target]) and #GAME.playerList>1 then
        local r=math.random(#GAME.playerList)
        if GAME.playerList[r]==source then
            r=math.random(#GAME.playerList-1)
            if r>=(TABLE.find(GAME.playerList,source)) then r=r+1 end
        end
        target=GAME.playerList[r]
    end

    -- Sending airmail
    if target then
        target:receive(d)
    end
end

function GAME.checkFinish()
    if GAME.mode.checkFinish() then
        GAME.mode.result()
    end
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
    gc.clear(0,0,0,0)
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
