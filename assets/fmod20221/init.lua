local ffi=require'ffi'
local require=simpRequire(((...):gsub(".init$","").."."))

require'cdef'

---@class FMOD.Master
local M=require'master'
M.banks={}

-- (Old method) search for fmod shared libraries in package.cpath
-- local fmodPath=package.searchpath('fmod',package.cpath)
-- local fmodstudioPath=package.searchpath('fmodstudio',package.cpath)
-- -- pretend to load libfmod through Lua (it's going to fail but not raise any errors) so that its location is known when loading libfmodstudio through ffi
-- -- package.loadlib(fmodPath,"")
-- M.C=ffi.load(fmodPath)
-- M.C2=ffi.load(fmodstudioPath)

M.C=ffi.load('fmod')
if not M.C then MSG.new('error',"FMOD library not found") end

M.C2=ffi.load('fmodstudio')
if not M.C2 then MSG.new('error',"FMODstudio library not found") end

require'enums'
require'constants'
require'wrap'
require'errors'

--------------------------------------------------------------

local studio ---@type FMOD.Studio.System?
local core ---@type FMOD.Core.System?

---@param args {maxChannel:number, DSPBufferLength:number, DSPBufferCount:number, studioFlag:FMOD.Const, coreFlag:FMOD.Const}
function M.init(args)
    if not (M.C and M.C2) then return end
    local firstTime=true
    if M.studio then
        M.studio:release()
        firstTime=false
    end
    M.studio=M.newStudio()
    M.core=M.studio:getCoreSystem()
    studio,core=M.studio,M.core
    core:setDSPBufferSize(args.DSPBufferLength or 128,args.DSPBufferCount or 4)
    studio:initialize(args.maxChannel,args.studioFlag,args.coreFlag)
    if firstTime then
        TASK.new(function()
            while studio do
                studio:update()
                coroutine.yield()
            end
        end)
    end
end

---Release studio object (call this when game running into critical error)
function M.destroy()
    if not studio then return end
    studio:release()
    studio=nil
end

---This method can only load files visible to fmod
---@param path string
---@param flag? FMOD.Const
function M.loadBank(path,flag)
    if not studio then return end
    local bank,res=studio:loadBankFile(path,flag or M.FMOD_STUDIO_LOAD_BANK_NORMAL)
    if res~=M.FMOD_OK then
        LOG("FMOD loadBankMemory error: "..M.errorString[res])
        MSG.new('warn',"FMOD loadBankMemory error: "..M.errorString[res])
        return
    end
    M.banks[path]=bank
    return bank
end

---This method uses 'loadBankMemory' instead of 'loadBankFile', which makes all files visible to love2d's filesystem can be loaded
---@param path string
---@param flag? FMOD.Const
---@return FMOD.Studio.Bank?
function M.loadBank2(path,flag)
    if not studio then return end
    if not love.filesystem.getInfo(path) then
        MSG.new('warn',"Bank file not found: "..path)
        return
    end
    local file=love.filesystem.newFile(path)
    local data,size=file:read('data')
    local bank,res=studio:loadBankMemory(data:getPointer(),size,0,flag or M.FMOD_STUDIO_LOAD_BANK_NORMAL)
    file:close(); file:release(); data:release()
    if res~=M.FMOD_OK then
        LOG("FMOD loadBankMemory error: "..M.errorString[res])
        MSG.new('warn',"FMOD loadBankMemory error: "..M.errorString[res])
        return
    end
    M.banks[path]=bank
    return bank
end

---@type Map<FMOD.Studio.EventDescription>
local musicLib={}
function M.registerMusic(map)
    if not studio then return end
    for k,v in next,map do
        local desc,res=studio:getEvent(v)
        assert(res==M.FMOD_OK,M.errorString[res])
        musicLib[k]=desc
    end
end

---@type Map<FMOD.Studio.EventDescription>
local effectLib={}
function M.registerEffect(map)
    if not studio then return end
    for k,v in next,map do
        local desc,res=studio:getEvent(v)
        assert(res==M.FMOD_OK,M.errorString[res])
        effectLib[k]=desc
    end
end

local vocalLib={}
function M.registerVocal(map)
end

-- Volume things need three parameters in your fmod project (mainVolume not included)
M.mainVolume=-1
M.musicVolume=-1
M.effectVolume=-1
M.vocalVolume=-1
---@param v number
---@param instant? boolean only `true` take effect
function M.setMainVolume(v,instant)
    M.mainVolume=v
    if not studio then return end
    studio:setParameterByName('MusicVolume',M.mainVolume*M.musicVolume,instant==true)
    studio:setParameterByName('EffectVolume',M.mainVolume*M.effectVolume,instant==true)
    studio:setParameterByName('VocalVolume',M.mainVolume*M.vocalVolume,instant==true)
end

--------------------------

---@class FMOD._Music
---@overload fun(name:string, args?:{instant?:boolean, volume?:number, pitch?:number, tune?:number, fine?:number, pos?:number[], param?:table}):FMOD.Studio.EventInstance?
M.music={}

---@param v number
---@param instant? boolean only `true` take effect
function M.music.setVolume(v,instant)
    M.musicVolume=v
    if not studio then return end
    studio:setParameterByName('MusicVolume',M.mainVolume*M.musicVolume,instant==true)
end

---@type {desc:FMOD.Studio.EventDescription?, event:FMOD.Studio.EventInstance?}?
local playing=nil

---Get event description by name, to check if a music exists
---@param name string
---@return FMOD.Studio.EventDescription
function M.music.getDesc(name)
    return musicLib[name]
end

---@param name string
---@param args? {instant?:boolean, volume?:number, pitch?:number, tune?:number, fine?:number, pos?:number[], param?:table}
---@return FMOD.Studio.EventInstance?
function M.music.play(name,args)
    if not studio then return end
    FMOD.music.stop()
    local desc=musicLib[name]
    if not desc then
        MSG.new('warn',"No BGM named "..name)
        return
    end
    local event,res=desc:createInstance()
    if res~=M.FMOD_OK then
        MSG.new('warn',"Event named "..name.." created failed: "..M.errorString[res])
        return
    end
    playing={
        desc=desc,
        event=event,
    }

    if not (type(args)=='table' and args.instant==true) then
        event:setParameterByName('fade',0,true)
        event:setParameterByName('fade',1,false)
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

---Set current playing music fading out (need param 'fade' in event)
---@param instant? boolean only `true` take effect
function M.music.stop(instant)
    if not studio or not playing then return end
    local e=playing.event ---@type FMOD.Studio.EventInstance
    if instant then
        e:stop(M.FMOD_STUDIO_STOP_IMMEDIATE)
    else
        TASK.new(function()
            e:setParameterByName('fade',0,false)
            repeat
                DEBUG.yieldT(0.26)
                local _,v=e:getParameterByName('fade')
            until v<=0
            e:stop(M.FMOD_STUDIO_STOP_IMMEDIATE)
        end)
    end
    playing=nil
end

---Get music's param value (and final value) by name
---@param param string
---@return number?,number?
function M.music.getParam(param)
    if not studio or not playing then return end
    local v,fv=playing.event:getParameterByName(param)
    return v,fv
end

---@param param string
---@param value number
---@param instant? boolean only `true` take effect
function M.music.setParam(param,value,instant)
    if not studio or not playing then return end
    return playing.event:setParameterByName(param,value,instant==true)
end

---@param time number seconds
function M.music.seek(time)
    if not studio or not playing then return end
    return playing.event:setTimelinePosition(time*1000)
end

---@return number
function M.music.tell()
    if not studio or not playing then return 0 end
    return (playing.event:getTimelinePosition()/1000)
end

---@return number
function M.music.getDuration()
    if not studio or not playing then return 0 end
    return (playing.desc:getLength()/1000)
end

---@return FMOD.Studio.EventInstance?
function M.music.getPlaying()
    if not studio or not playing then return end
    return playing.event
end

setmetatable(M.music,{__call=function(_,...) return M.music.play(...) end})

--------------------------

---@class FMOD._Effect
---@overload fun(name:string, args?:{instant?:boolean, volume?:number, pitch?:number, tune?:number, fine?:number, pos?:number[], param?:table}):FMOD.Studio.EventInstance?
M.effect={}

---@param v number
---@param instant? boolean only `true` take effect
function M.effect.setVolume(v,instant)
    M.effectVolume=v
    if not studio then return end
    return studio:setParameterByName('EffectVolume',M.mainVolume*M.effectVolume,instant==true)
end

---Get event description by name, to check if a music exists
---@param name string
---@return FMOD.Studio.EventDescription
function M.effect.getDesc(name)
    return effectLib[name]
end

---priority: pitch>tune>fine
---
---pos:{x,y,z}
---
---param:{'paramName', 0, true?}
---@param name string
---@param args? {volume?:number, pitch?:number, tune?:number, fine?:number, pos?:number[], param?:table}
---@return FMOD.Studio.EventInstance?
function M.effect.play(name,args)
    if not studio then return end
    local desc=effectLib[name]
    if not desc then
        MSG.new('warn',"No SE named "..name)
        return
    end
    local event,res=desc:createInstance()
    if res~=M.FMOD_OK then
        MSG.new('warn',"Play SE '"..name.."' failed: "..M.errorString[res])
        return
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

---@param name string
---@param param string
---@param value number
---@param instant? boolean only `true` take effect
function M.effect.setParam(name,param,value,instant)
    if not studio then return end
    local desc=effectLib[name]
    if not desc then return end
    local l,c=desc:getInstanceList(desc:getInstanceCount())
    for i=1,c do
        l[i-1]:setParameterByName(param,value,instant==true)
    end
end

---@param name string
function M.effect.keyOff(name)
    if not studio then return end
    local desc=effectLib[name]
    if not desc then return end
    local l,c=desc:getInstanceList(desc:getInstanceCount())
    for i=1,c do
        l[i-1]:keyOff()
    end
end

---@param name string
---@param instant? boolean only `true` take effect
function M.effect.stop(name,instant)
    if not studio then return end
    local desc=effectLib[name]
    if not desc then return end
    local l,c=desc:getInstanceList(desc:getInstanceCount())
    for i=1,c do
        l[i-1]:stop(instant and M.FMOD_STUDIO_STOP_IMMEDIATE or M.FMOD_STUDIO_STOP_ALLOWFADEOUT)
    end
end

setmetatable(M.effect,{__call=function(_,...) return M.effect.play(...) end})

--------------------------

M.vocal={}

---@param v number
---@param instant? boolean only `true` take effect
function M.vocal.setVolume(v,instant)
    M.vocalVolume=v
    if not studio then return end
    return studio:setParameterByName('VocalVolume',M.mainVolume*M.vocalVolume,instant==true)
end

--------------------------------------------------------------

return M
