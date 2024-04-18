local ffi=require("ffi")
local path=(...):gsub(".init$", "").."."
local r=require; local function require(m) return r(path..m) end

require("cdef")

---@class FMOD.master
local M=require("master")

-- search for fmod shared libraries in package.cpath
local fmodPath=package.searchpath("fmod", package.cpath)
local fmodstudioPath=package.searchpath("fmodstudio", package.cpath)
assert(fmodPath and fmodstudioPath, "FMOD shared libraries not found!")

-- pretend to load libfmod through Lua (it's going to fail but not raise any errors) so that its location is known when loading libfmodstudio through ffi
-- package.loadlib(paths.fmod, "")

M.C=ffi.load(fmodPath)
M.C2=ffi.load(fmodstudioPath)

require("enums")
require("constants")
require("wrap")
require("errors")

--------------------------

M.studio=M.newStudio()
M.core=M.studio:getCoreSystem()

local studio,core=M.studio,M.core

---@param args {maxChannel:number, DSPBufferLength:number, DSPBufferCount:number, studioFlag:FMOD.Const, coreFlag:FMOD.Const}
function M.init(args)
    core:setDSPBufferSize(8,8)
    studio:initialize(args.maxChannel,args.studioFlag,args.coreFlag)
    TASK.new(function()
        while true do
            studio:update()
            coroutine.yield()
        end
    end)
end

---@param bankPath string
---@param flag? FMOD.Const
function M.loadBank(bankPath,flag)
    if not studio then return end
    flag=flag or M.FMOD_STUDIO_LOAD_BANK_NORMAL
    local bank=studio:loadBankFile(bankPath,flag)
    return bank
end

---@type table<any,FMOD.Studio.EventDescription>
local musicLib={}
function M.registerMusic(map)
    for k,v in next,map do
        local desc,res=studio:getEvent(v)
        assert(res==M.FMOD_OK,M.errorString[res])
        musicLib[k]=desc
    end
end

---@type table<any,FMOD.Studio.EventDescription>
local effectLib={}
function M.registerEffect(map)
    for k,v in next,map do
        local desc,res=studio:getEvent(v)
        assert(res==M.FMOD_OK,M.errorString[res])
        effectLib[k]=desc
    end
end

local vocalLib={}
function M.registerVocal(map)
end

-- Volume things below need three parameters in your fmod project (mainVolume not included)
M.mainVolume=1
M.musicVolume=1
M.effectVolume=1
M.vocalVolume=1
function M.setMainVolume(v)
    M.mainVolume=v
    studio:setParameterByName("MusicVolume",M.mainVolume*M.musicVolume,true)
    studio:setParameterByName("EffectVolume",M.mainVolume*M.effectVolume,true)
    studio:setParameterByName("VocalVolume",M.mainVolume*M.vocalVolume,true)
end
function M.setMusicVolume(v)
    M.musicVolume=v
    studio:setParameterByName("MusicVolume",M.mainVolume*M.musicVolume,true)
end
function M.setEffectVolume(v)
    M.effectVolume=v
    studio:setParameterByName("EffectVolume",M.mainVolume*M.effectVolume,true)
end
function M.setVocalVolume(v)
    M.vocalVolume=v
    studio:setParameterByName("VocalVolume",M.mainVolume*M.vocalVolume,true)
end

local playingEvent ---@type FMOD.Studio.EventInstance?
---@param name string
---@param args? {instant?:boolean, volume?:number, pitch?:number, tune?:number, fine?:number, pos?:table<number,number>, param?:table}
---@return FMOD.Studio.EventInstance?
function M.playMusic(name,args)
    FMOD.stopMusic()
    local desc=musicLib[name]
    if not desc then
        MSG.new('warn',"No BGM named "..name)
        return
    end
    local event,res=desc:createInstance()
    assert(res==M.FMOD_OK,M.errorString[res])
    playingEvent=event

    if not (type(args)=='table' and args.instant==true) then
        event:setParameterByName("fade",0,true)
        event:setParameterByName("fade",1,false)
    end

    if args then
        assert(type(args)=='table',"args must be table")
        if args.volume then event:setVolume(args.volume) end
        if args.pitch then
            event:setPitch(args.pitch)
        elseif args.tune then
            event:setPitch(1.0594630943592953^args.tune)
        elseif args.fine then
            event:setPitch(1.0594630943592953^(args.fine/100))
        end
        if args.param then
            assert(type(args.param)=='table',"initParam must be table")
            if type(args.param[1])~='table' then args.param={args.param} end
            for i=1,#args.param do
                event:setParameterByName(args.param[i][1],args.param[i][2],args.param[i][3]==true)
            end
        end
    end

    event:start()
    return event
end

---@param time? number
function M.stopMusic(time)
    if not playingEvent then return end
    time=time or 0.626
    local e=playingEvent
    playingEvent=nil
    if time<=0 then
        e:stop(M.FMOD_STUDIO_STOP_IMMEDIATE)
    else
        TASK.new(function()
            local startTime=love.timer.getTime()
            while true do
                coroutine.yield()
                local v=1-(love.timer.getTime()-startTime)/time
                if v<=0 then break end
                e:setParameterByName("fade",v,true)
            end
            e:stop(M.FMOD_STUDIO_STOP_IMMEDIATE)
        end)
    end
end

---@param name string
---@param value number
---@param instant? boolean only `true` take effect
function M.setMusicParam(name,value,instant)
    if not playingEvent then return end
    playingEvent:setParameterByName(name,value,instant==true)
end

---@param time number seconds
function M.seekMusic(time)
    if not playingEvent then return end
    playingEvent:setTimelinePosition(time*1000)
end

---@return number?
function M.tellMusic()
    if not playingEvent then return end
    return (playingEvent:getTimelinePosition())
end

---@return FMOD.Studio.EventInstance?
function M.getPlaying()
    return playingEvent
end

---priority: pitch>tune>fine
---
---pos:{x,y,z}
---
---param:{"paramName", 0, true?}
---@param name string
---@param args? {volume?:number, pitch?:number, tune?:number, fine?:number, pos?:table<number,number>, param?:table}
---@return FMOD.Studio.EventInstance?
function M.playEffect(name,args)
    local desc=effectLib[name]
    if not desc then
        MSG.new('warn',"No SE named "..name)
        return
    end
    local event,res=desc:createInstance()
    assert(res==M.FMOD_OK,M.errorString[res])

    if args then
        assert(type(args)=='table',"args must be table")
        if args.volume then event:setVolume(args.volume) end
        if args.pitch then
            event:setPitch(args.pitch)
        elseif args.tune then
            event:setPitch(1.0594630943592953^args.tune)
        elseif args.fine then
            event:setPitch(1.0594630943592953^(args.fine/100))
        end
        -- if args.pos then
        --     local pos=ffi.new('FMOD_VECTOR',args.pos)
        --     local vel=ffi.new('FMOD_VECTOR',{x=0,y=0,z=0})
        --     local fwd=ffi.new('FMOD_VECTOR',{x=0,y=0,z=0})
        --     local up=ffi.new('FMOD_VECTOR',{x=0,y=0,z=0})
        --     local attr=ffi.new('FMOD_3D_ATTRIBUTES',{
        --         position=pos,
        --         velocity=vel,
        --         forward=fwd,
        --         up=up,
        --     })
        --     event:set3DAttributes(attr)
        -- end
        if args.param then
            local p=args.param
            assert(type(p)=='table',"args.param must be table")
            if type(p[1])~='table' then p={p} end
            for i=1,#p do
                event:setParameterByName(p[i][1],p[i][2],p[i][3]==true)
            end
        end
    end

    event:start()
    return event
end

---@param event string
---@param name string
---@param value number
---@param instant? boolean only `true` take effect
function M.setEffectParam(event,name,value,instant)
    local desc=effectLib[event]
    if not desc then return end
    local l,c=desc:getInstanceList(desc:getInstanceCount())
    for i=1,c do
        l[i-1]:setParameterByName(name,value,instant==true)
    end
end

---@param name string
function M.keyOffEffect(name)
    local desc=effectLib[name]
    if not desc then return end
    local l,c=desc:getInstanceList(desc:getInstanceCount())
    for i=1,c do
        l[i-1]:keyOff()
    end
end

---@param name string
---@param instant? boolean only `true` take effect
function M.stopEffect(name,instant)
    local desc=effectLib[name]
    if not desc then return end
    local l,c=desc:getInstanceList(desc:getInstanceCount())
    for i=1,c do
        l[i-1]:stop(instant and M.FMOD_STUDIO_STOP_IMMEDIATE or M.FMOD_STUDIO_STOP_ALLOWFADEOUT)
    end
end

--------------------------

return M
