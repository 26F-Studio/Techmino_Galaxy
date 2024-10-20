local require=simpRequire('assets.game.')
Brik=require'briks'
defaultBrikColor=setmetatable({
    844,484,448,864,748,884,488,
    844,484,845,485,468,854,748,684,488,847,884,448,864,468,854,846,486,884,
    478,748,854,484,
},{__index=function() return math.random(64) end})
require'rotsys_brik'

local gc=love.graphics

---@type Techmino.MechLib
mechLib={}
local modeLib={}
local modeMeta={
    __index={
        initialize=NULL,
        settings={},
        layout='default',
        checkFinish=function() return true end,
        result=NULL,
        resultPage=NULL,
    },
    __metatable=true,
}

local layoutFuncs={}
do -- function layoutFuncs.default():
    local defaultPosList={
        alive={
            [1]={main={0,0}},
            [3]={main={0,0},
                {580,100,.5},
                {-580,100,.5},
            },
            [5]={main={0,0},
                {-580,-240,.5},
                {580,-240,.5},
                {-580,240,.5},
                {580,240,.5},
            },
            [7]={main={0,0},
                {-580,-300,.34},{-580,0,.34},{-580,300,.34},
                {580,-300,.34},{580,0,.34},{580,300,.34},
            },
            [17]={main={0,0},
                {-680,-360,.26},{-680,-120,.26},{-680,120,.26},{-680,360,.26},
                {-480,-360,.26},{-480,-120,.26},{-480,120,.26},{-480,360,.26},
                {480,-360,.26},{480,-120,.26},{480,120,.26},{480,360,.26},
                {680,-360,.26},{680,-120,.26},{680,120,.26},{680,360,.26},
            },
            [37]=(function()
                local l={main={0,0}}
                for y=-2.5,2.5 do
                    for x=0,2 do
                        table.insert(l,{-460-130*x,160*y,.17})
                        table.insert(l,{460+130*x, 160*y,.17})
                    end
                end
                return l
            end)(),
            [73]=(function()
                local l={main={0,0}}
                for y=-4,4 do
                    for x=0,3 do
                        table.insert(l,{-440-100*x,110*y,.13})
                        table.insert(l,{440+100*x, 110*y,.13})
                    end
                end
                return l
            end)(),
            [MATH.inf]={main={0,0}},
        },
        dead={
            [1]={{0,0}},
            [2]={
                {-380,0,.9},{380,0,.9},
            },
            [3]={
                {-520,0,.66},{-800,0,.66},{520,0,.66},
            },
            [4]={
                {-590,0,.5},{-200,0,.5},{200,0,.5},{590,0,.5},
            },
            [15]=(function()
                local l={}
                for y=-1,1 do
                    for x=-2,2 do
                        table.insert(l,{315*x,320*y,.36})
                    end
                end
                return l
            end)(),
            [32]=(function()
                local l={}
                for y=-1.5,1.5 do
                    for x=-3.5,3.5 do
                        table.insert(l,{200*x,240*y,.25})
                    end
                end
                return l
            end)(),
            [72]=(function()
                local l={}
                for y=-2.5,2.5 do
                    for x=-5.5,5.5 do
                        table.insert(l,{130*x,160*y,.17})
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

local function task_switchToResult()
    if SCN.cur=='game_in' then
        SCN.swapTo('result_in','none')
    elseif SCN.cur=='game_out' then
        local time=love.timer.getTime()
        repeat
            if SCN.swapping then return end
            coroutine.yield()
        until love.timer.getTime()-time>1.26
        SCN.swapTo('result_out','none')
    end
end

---@class Techmino.Game
---@field playing boolean
---@field playerList Techmino.Player[]|false
---@field playerMap Map<Techmino.Player>|false
---@field camera Zenitha.Camera
---@field hitWaves table
---@field seed number|false
---@field mode Techmino.Mode|false
---@field mainID number|false
---@field mainPlayer Techmino.Player|false
local GAME={
    playing=false,

    playerList=false,
    playerMap=false,

    camera=GC.newCamera(),
    hitWaves={},

    seed=false,
    mode=false,

    mainID=false,
    mainPlayer=false,
}

GAME.camera.moveSpeed=12

mechLib={}
function GAME._refresh()
    modeLib={}
    TABLE.update(mechLib,TABLE.newResourceTable(require'mechanicLib',function(path) return FILE.load(path,'-lua') end))
    regFuncLib(mechLib,'mechLib')
end
GAME._refresh()

---@return Techmino.Mode
function GAME.getMode(name)
    if modeLib[name] then
        return modeLib[name]
    else
        local path='assets/game/mode/'..name..'.lua'
        assert(love.filesystem.getInfo(path) and FILE.isSafe(path),"No mode named "..tostring(name))
        local M=FILE.load(path,'-lua -canskip')
        assert(type(M)=='table',"WTF")
        setmetatable(M,modeMeta)
        assert(type(M.initialize)         =='function',"[mode].initialize must be function")
        assert(type(M.settings)           =='table',   "[mode].settings must be table")
        assert(type(layoutFuncs[M.layout])=='function',"[mode].layout type wrong")
        assert(type(M.checkFinish)        =='function',"[mode].checkFinish must be function")
        assert(type(M.result)             =='function',"[mode].result must be function")
        assert(type(M.resultPage)         =='function',"[mode].resultPage must be function")

        for _,m in next,{'brik','gela','acry'} do
            if M.settings[m] then
                regFuncLib(M.settings[m].event,name)
            end
        end

        M.name=name
        modeLib[name]=M
        return M
    end
end

function GAME.load(mode,seed)
    -- print("Game Loaded: "..mode.."-"..seed)
    if GAME.mode then
        MSG.new('warn',"Game is running")
        return
    end
    GAME.playing=true
    GAME.playerList={}
    GAME.playerMap={}

    GAME.hitWaves={}

    GAME.mainPlayer=false
    GAME.seed=seed or math.random(2^16,2^26)
    GAME.mode=mode and GAME.getMode(mode) or NONE
    if GAME.mode.initialize then GAME.mode.initialize() end
    TASK.removeTask_code(task_switchToResult)
    TASK.removeTask_code(task_unloadGame)

    if #GAME.playerList==0 then
        MSG.new('warn',"No players created in this mode")
    else
        if GAME.mainPlayer then
            local conf=SETTINGS['game_'..GAME.mainPlayer.gameMode]
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

function GAME.unload()
    -- print("Game Unloaded")
    GAME.playing=false
    GAME.playerList=false
    GAME.playerMap=false

    GAME.hitWaves={}

    GAME.seed=false
    GAME.mode=false

    GAME.mainID=false
    GAME.mainPlayer=false
end

---@param id integer
---@param pType 'brik'|'gela'|'acry'
---@param remote? boolean
function GAME.newPlayer(id,pType,remote)
    if not (type(id)=='number' and math.floor(id)==id and id>=1 and id<=1000) then
        MSG.new('error',"player id must be 1~1000 integer")
        return
    end

    local P
    if pType=='brik' then
        P=require'brikPlayer'.new(remote)
    elseif pType=='gela' then
        P=require'gelaPlayer'.new(remote)
    elseif pType=='acry' then
        P=require'acryPlayer'.new(remote)
    else
        MSG.new('error',"invalid player type :'"..tostring(pType).."'")
        return
    end

    P.gameMode=pType
    P.id=id
    P.team=0
    GAME.playerMap[id]=P
    table.insert(GAME.playerList,P)
end

function GAME.setMain(id)
    if GAME.mainPlayer then
        GAME.playerMap[GAME.mainPlayer].isMain=false
        GAME.mainID=false
        GAME.mainPlayer=false
    end
    if GAME.playerMap[id] then
        GAME.mainID=id
        GAME.mainPlayer=GAME.playerMap[id]
        GAME.mainPlayer.isMain=true
        GAME.mainPlayer.sound=true
    end
end

function GAME.setTeam(id,teamID)
    assert(type(teamID)=='number' and teamID>=0 and teamID%1==teamID,"Invalid team id")
    if GAME.playerMap[id] then
        GAME.playerMap[id].team=teamID
    end
end

function GAME.press(action,id)
    local p=id and GAME.playerMap[id] or GAME.mainPlayer
    p:pressKey(action)
end

function GAME.release(action,id)
    local p=id and GAME.playerMap[id] or GAME.mainPlayer
    p:releaseKey(action)
end

function GAME.cursorDown(x,y,tid,id)
    local p=id and GAME.playerMap[id] or GAME.mainPlayer
    if p.gameMode=='acry' then
    x,y=GAME.camera.transform:inverseTransformPoint(SCR.xOy_m:inverseTransformPoint(SCR.xOy:transformPoint(x,y)))
        p:mouseDown(x,y,tid)
    elseif SETTINGS.system.touchControl then
        VCTRL.press(x,y,tid)
    end
end

function GAME.cursorMove(x,y,dx,dy,tid,id)
    local p=id and GAME.playerMap[id] or GAME.mainPlayer
    if p.gameMode=='acry' then
        x,y=GAME.camera.transform:inverseTransformPoint(SCR.xOy_m:inverseTransformPoint(SCR.xOy:transformPoint(x,y)))
        p:mouseMove(x,y,dx,dy,
            tid or
            love.mouse.isDown(1) and 1 or
            love.mouse.isDown(2) and 2 or
            3
        )
    elseif SETTINGS.system.touchControl then
        VCTRL.move(x,y,tid)
    end
end

function GAME.cursorUp(x,y,tid,id)
    local p=id and GAME.playerMap[id] or GAME.mainPlayer
    if p.gameMode=='acry' then
        x,y=GAME.camera.transform:inverseTransformPoint(SCR.xOy_m:inverseTransformPoint(SCR.xOy:transformPoint(x,y)))
        p:mouseUp(x,y,tid)
    elseif SETTINGS.system.touchControl then
        VCTRL.release(tid)
    end
end

---@class Techmino.Game.Attack
---@field srcMode Techmino.Player.Type
---@field power number -∞~∞, no default
---@field sharpness number 0~∞, default to 1, how strong the attack can cancel the others
---@field hardness number 0~∞, default to 1, how strong the attack can defend the others
---@field mode number 0|1, default to 0, 0: trigger by time, 1:trigger by step
---@field time number 0~∞, default to 0, ms / step
---@field fatal number 0~100, default to 30, percentage
---@field speed number 0~100, default to 30, percentage
---@field target number|Techmino.Player|nil default to nil

local atkTemplate={
    sharpness=1,
    hardness=1,
    mode=0,
    time=0,
    fatal=30,
    speed=30,
}

---@param atk Techmino.Game.Attack
function GAME.initAtk(atk) -- Normalize the attack object
    assert(type(atk)=='table',"GAME.initAtk: need table")

    TABLE.updateMissing(atk,atkTemplate)

    assert(type(atk.power)=='number',"GAME.initAtk: .power need number")
    assert(type(atk.sharpness)=='number' and atk.sharpness>=0,"GAME.initAtk: .sharpness need non-negative number")
    assert(type(atk.hardness)=='number' and atk.hardness>=0,"GAME.initAtk: .hardness need non-negative number")
    assert(atk.mode==0 or atk.mode==1,"mode not 0 or 1")
    assert(type(atk.time)=='number' and atk.time>=0,"GAME.initAtk: .time need non-negative number")
    assert(type(atk.fatal)=='number',"GAME.initAtk: .fatal need number")
    assert(type(atk.speed)=='number',"GAME.initAtk: .speed need number")
    if atk.mode==1 then atk.time=math.floor(atk.time+.5) end
    atk.fatal=MATH.clamp(math.floor(atk.fatal+.5),0,100)
    atk.speed=MATH.clamp(math.floor(atk.speed+.5),0,100)

    return atk
end

---@param sender Techmino.Player|number|false
---@param atk Techmino.Game.Attack?
function GAME.send(sender,atk)
    if not atk then return end

    ---@type Techmino.Player
    local target

    -- Find target
    if atk.target==nil then
        ---@type Techmino.Player[]
        local l=GAME.playerList
        local sourceTeam=sender and sender.team or 0 -- 0 means no team, not Team 0
        if #l>1 then
            local count=0
            for i=1,#l do
                if sourceTeam==0 and l[i]~=sender or sourceTeam~=l[i].team then
                    count=count+1
                end
            end
            if count>0 then
                count=math.random(count)
                for i=1,#l do
                    if sourceTeam==0 and l[i]~=sender or sourceTeam~=l[i].team then
                        count=count-1
                        if count==0 then
                            target=l[i]
                            break
                        end
                    end
                end
            end
        end
    elseif type(atk.target)=='number' then
        target=GAME.playerMap[atk.target]
    else
        error("GAME.send: invalid target type")
    end

    -- Sending airmail
    if target then
        target:receive(atk)
    end
end

function GAME.checkFinish()
    if GAME.playing and GAME.mode.checkFinish() then
        GAME.playing=false
        GAME.mode.result()
        if GAME.mode.resultPage~=NULL then
            TASK.new(task_switchToResult)
        end
    end
end

function GAME.update(dt)
    if not GAME.playerList then return end
    for _,P in next,GAME.playerList do P:update(dt) end

    GAME.camera:update(dt)
    for i=#GAME.hitWaves,1,-1 do
        local wave=GAME.hitWaves[i]
        wave.time=wave.time+dt
    end
end

function GAME.render()
    if not GAME.playerList then return end
    gc.setCanvas({ZENITHA.getBigCanvas('player'),stencil=true})
    gc.replaceTransform(SCR.xOy_m)
    gc.applyTransform(GAME.camera.transform)
    gc.clear(0,0,0,0)
    for _,P in next,GAME.playerList do P:render() end
    gc.setCanvas()

    gc.replaceTransform(SCR.origin)
    if GAME.hitWaves[1] then
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
        gc.setShader(SHADER.none) -- Directly draw the content, don't consider color, for better performance(?)
    end
    gc.draw(ZENITHA.getBigCanvas('player'))
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
        nil,nil, -- power1 & power2, calculated before sending uniform
        time=0,
        power=power*SETTINGS.system.hitWavePower,
    })
end

return GAME
