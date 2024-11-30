local ffi=require'ffi'
local require=simpRequire(((...):match(".+%.")))

---@alias FMOD.GUID FMOD.GUID
---@alias FMOD.Result FMOD.Result
---@alias FMOD.Const FMOD.Const
---@alias FMOD.Enum FMOD.Enum

---@class FMOD.Master
local M=require'master'
local C=M.C
local C2=M.C2

---------------------
-- manual wrapping --
---------------------

---@return FMOD.Core.System,FMOD.Result
function M.newCore(i1)
    i1=i1 or M.FMOD_VERSION
    local p=ffi.new("FMOD_SYSTEM*[1]")
    local result=C.FMOD_System_Create(p, i1)
    return p[0],result
end

---@return FMOD.Studio.System,FMOD.Result
function M.newStudio(i1)
    i1=i1 or M.FMOD_VERSION
    local p=ffi.new("FMOD_STUDIO_SYSTEM*[1]")
    local result=C2.FMOD_Studio_System_Create(p, i1)
    return p[0],result
end

---@return FMOD.GUID,FMOD.Result
function M.parseID(i1)
    local p=ffi.new("FMOD_GUID[1]")
    local result=C2.FMOD_Studio_ParseID(i1, p)
    return p[0],result
end

--------------------------
-- begin generated code --
--------------------------

---@class FMOD.Core
local core={}
---@class FMOD.Core.System
core.System={}
---@class FMOD.Core.Sound
core.Sound={}
---@class FMOD.Core.ChannelControl
core.ChannelControl={}
---@class FMOD.Core.Channel
core.Channel={}
---@class FMOD.Core.ChannelGroup
core.ChannelGroup={}
---@class FMOD.Core.SoundGroup
core.SoundGroup={}
---@class FMOD.Core.DSP
core.DSP={}
---@class FMOD.Core.DSPConnection
core.DSPConnection={}
---@class FMOD.Core.Geometry
core.Geometry={}
---@class FMOD.Core.Reverb3D
core.Reverb3D={}

---@class FMOD.Studio
local studio={}
---@class FMOD.Studio.System
studio.System={}
---@class FMOD.Studio.EventDescription
studio.EventDescription={}
---@class FMOD.Studio.EventInstance
studio.EventInstance={}
---@class FMOD.Studio.Bus
studio.Bus={}
---@class FMOD.Studio.VCA
studio.VCA={}
---@class FMOD.Studio.Bank
studio.Bank={}
---@class FMOD.Studio.CommandReplay
studio.CommandReplay={}

---@class FMOD.Studio.ParamDescription
---@field name string
---@field id unknown
---@field minimum number
---@field maximum number
---@field defaultvalue number
---@field type unknown
---@field flags unknown
---@field guid FMOD.GUID

---@class FMOD.Studio.UserProperty
---@field name string
---@field type 0 | 1 | 2 | 3 int, bool, float, string
---@field intvalue integer
---@field boolvalue 0 | 1
---@field floatvalue number
---@field stringvalue string

---@return FMOD.Result
function core.System:release()
    local result=C.FMOD_System_Release(self)
    return result
end

---@return FMOD.Result
function core.System:setOutput(i1)
    local result=C.FMOD_System_SetOutput(self,i1)
    return result
end

---@return any,FMOD.Result
function core.System:getOutput()
    local o1=ffi.new("FMOD_OUTPUTTYPE[1]")
    local result=C.FMOD_System_GetOutput(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:getNumDrivers()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_GetNumDrivers(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:getDriverInfo(i1,i2,i3,i4,i5,i6,i7)
    local result=C.FMOD_System_GetDriverInfo(self,i1,i2,i3,i4,i5,i6,i7)
    return result
end

---@return FMOD.Result
function core.System:setDriver(i1)
    local result=C.FMOD_System_SetDriver(self,i1)
    return result
end

---@return number,FMOD.Result
function core.System:getDriver()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_GetDriver(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:setSoftwareChannels(i1)
    local result=C.FMOD_System_SetSoftwareChannels(self,i1)
    return result
end

---@return number,FMOD.Result
function core.System:getSoftwareChannels()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_GetSoftwareChannels(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:setSoftwareFormat(i1,i2,i3)
    local result=C.FMOD_System_SetSoftwareFormat(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.System:getSoftwareFormat(i1,i2,i3)
    local result=C.FMOD_System_GetSoftwareFormat(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.System:setDSPBufferSize(i1,i2)
    local result=C.FMOD_System_SetDSPBufferSize(self,i1,i2)
    return result
end

---@return number,number,FMOD.Result
function core.System:getDSPBufferSize()
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_System_GetDSPBufferSize(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.System:setFileSystem(i1,i2,i3,i4,i5,i6,i7)
    local result=C.FMOD_System_SetFileSystem(self,i1,i2,i3,i4,i5,i6,i7)
    return result
end

---@return FMOD.Result
function core.System:attachFileSystem(i1,i2,i3,i4)
    local result=C.FMOD_System_AttachFileSystem(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.System:setAdvancedSettings(i1)
    local result=C.FMOD_System_SetAdvancedSettings(self,i1)
    return result
end

---@return any,FMOD.Result
function core.System:getAdvancedSettings()
    local o1=ffi.new("FMOD_ADVANCEDSETTINGS[1]")
    local result=C.FMOD_System_GetAdvancedSettings(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:setCallback(i1,i2)
    local result=C.FMOD_System_SetCallback(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.System:setPluginPath(i1)
    local result=C.FMOD_System_SetPluginPath(self,i1)
    return result
end

---@return number,FMOD.Result
function core.System:loadPlugin(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_LoadPlugin(self,i1,o1,i2)
    return o1[0],result
end

---@return FMOD.Result
function core.System:unloadPlugin(i1)
    local result=C.FMOD_System_UnloadPlugin(self,i1)
    return result
end

---@return FMOD.Result
function core.System:getNumNestedPlugins(i1,i2)
    local result=C.FMOD_System_GetNumNestedPlugins(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function core.System:getNestedPlugin(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_GetNestedPlugin(self,i1,i2,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:getNumPlugins(i1)
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_GetNumPlugins(self,i1,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:getPluginHandle(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_GetPluginHandle(self,i1,i2,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:getPluginInfo(i1,i2,i3,i4,i5)
    local result=C.FMOD_System_GetPluginInfo(self,i1,i2,i3,i4,i5)
    return result
end

---@return FMOD.Result
function core.System:setOutputByPlugin(i1)
    local result=C.FMOD_System_SetOutputByPlugin(self,i1)
    return result
end

---@return number,FMOD.Result
function core.System:getOutputByPlugin()
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_GetOutputByPlugin(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:createDSPByPlugin(i1)
    local o1=ffi.new("FMOD_DSP*[1]")
    local result=C.FMOD_System_CreateDSPByPlugin(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:getDSPInfoByPlugin(i1)
    local o1=ffi.new("const FMOD_DSP_DESCRIPTION*[1]")
    local result=C.FMOD_System_GetDSPInfoByPlugin(self,i1,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:registerCodec(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_RegisterCodec(self,i1,o1,i2)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:registerDSP(i1)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_RegisterDSP(self,i1,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:registerOutput(i1)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_RegisterOutput(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:init(i1,i2,i3)
    local result=C.FMOD_System_Init(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.System:close()
    local result=C.FMOD_System_Close(self)
    return result
end

---@return FMOD.Result
function core.System:update()
    local result=C.FMOD_System_Update(self)
    return result
end

---@return FMOD.Result
function core.System:setSpeakerPosition(i1,i2,i3,i4)
    local result=C.FMOD_System_SetSpeakerPosition(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.System:getSpeakerPosition(i1,i2,i3,i4)
    local result=C.FMOD_System_GetSpeakerPosition(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.System:setStreamBufferSize(i1,i2)
    local result=C.FMOD_System_SetStreamBufferSize(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.System:getStreamBufferSize(i1,i2)
    local result=C.FMOD_System_GetStreamBufferSize(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.System:set3DSettings(i1,i2,i3)
    local result=C.FMOD_System_Set3DSettings(self,i1,i2,i3)
    return result
end

---@return number,number,number,FMOD.Result
function core.System:get3DSettings()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_System_Get3DSettings(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return number,FMOD.Result
function core.System:set3DNumListeners()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_Set3DNumListeners(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:get3DNumListeners()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_Get3DNumListeners(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:set3DListenerAttributes(i1,i2,i3,i4,i5)
    local result=C.FMOD_System_Set3DListenerAttributes(self,i1,i2,i3,i4,i5)
    return result
end

---@return any,any,any,any,FMOD.Result
function core.System:get3DListenerAttributes(i1)
    local o1=ffi.new("FMOD_VECTOR[1]")
    local o2=ffi.new("FMOD_VECTOR[1]")
    local o3=ffi.new("FMOD_VECTOR[1]")
    local o4=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_System_Get3DListenerAttributes(self,i1,o1,o2,o3,o4)
    return o1[0],o2[0],o3[0],o4[0],result
end

---@return FMOD.Result
function core.System:set3DRolloffCallback(i1)
    local result=C.FMOD_System_Set3DRolloffCallback(self,i1)
    return result
end

---@return FMOD.Result
function core.System:mixerSuspend()
    local result=C.FMOD_System_MixerSuspend(self)
    return result
end

---@return FMOD.Result
function core.System:mixerResume()
    local result=C.FMOD_System_MixerResume(self)
    return result
end

---@return number,FMOD.Result
function core.System:getDefaultMixMatrix(i1,i2,i3)
    local o1=ffi.new("float[1]")
    local result=C.FMOD_System_GetDefaultMixMatrix(self,i1,i2,o1,i3)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:getSpeakerModeChannels(i1)
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_GetSpeakerModeChannels(self,i1,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.System:getVersion()
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_GetVersion(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:getOutputHandle()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_System_GetOutputHandle(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:getChannelsPlaying(i1,i2)
    local result=C.FMOD_System_GetChannelsPlaying(self,i1,i2)
    return result
end

---@return any,FMOD.Result
function core.System:getCPUUsage()
    local o1=ffi.new("FMOD_CPU_USAGE[1]")
    local result=C.FMOD_System_GetCPUUsage(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:getFileUsage(i1,i2,i3)
    local result=C.FMOD_System_GetFileUsage(self,i1,i2,i3)
    return result
end

---@return any,FMOD.Result
function core.System:createSound(i1,i2,i3)
    local o1=ffi.new("FMOD_SOUND*[1]")
    local result=C.FMOD_System_CreateSound(self,i1,i2,i3,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:createStream(i1,i2,i3)
    local o1=ffi.new("FMOD_SOUND*[1]")
    local result=C.FMOD_System_CreateStream(self,i1,i2,i3,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:createDSP(i1)
    local o1=ffi.new("FMOD_DSP*[1]")
    local result=C.FMOD_System_CreateDSP(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:createDSPByType(i1)
    local o1=ffi.new("FMOD_DSP*[1]")
    local result=C.FMOD_System_CreateDSPByType(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:createChannelGroup(i1)
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C.FMOD_System_CreateChannelGroup(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:createSoundGroup(i1)
    local o1=ffi.new("FMOD_SOUNDGROUP*[1]")
    local result=C.FMOD_System_CreateSoundGroup(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Core.Reverb3D,FMOD.Result
function core.System:createReverb3D()
    local o1=ffi.new("FMOD_REVERB3D*[1]")
    local result=C.FMOD_System_CreateReverb3D(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:playSound(i1,i2,i3,i4)
    local result=C.FMOD_System_PlaySound(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.System:playDSP(i1,i2,i3,i4)
    local result=C.FMOD_System_PlayDSP(self,i1,i2,i3,i4)
    return result
end

---@return any,FMOD.Result
function core.System:getChannel(i1)
    local o1=ffi.new("FMOD_CHANNEL*[1]")
    local result=C.FMOD_System_GetChannel(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:getDSPInfoByType(i1)
    local o1=ffi.new("const FMOD_DSP_DESCRIPTION*[1]")
    local result=C.FMOD_System_GetDSPInfoByType(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:getMasterChannelGroup()
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C.FMOD_System_GetMasterChannelGroup(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:getMasterSoundGroup()
    local o1=ffi.new("FMOD_SOUNDGROUP*[1]")
    local result=C.FMOD_System_GetMasterSoundGroup(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:attachChannelGroupToPort(i1,i2,i3,i4)
    local result=C.FMOD_System_AttachChannelGroupToPort(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.System:detachChannelGroupFromPort(i1)
    local result=C.FMOD_System_DetachChannelGroupFromPort(self,i1)
    return result
end

---@return FMOD.Result
function core.System:setReverbProperties(i1,i2)
    local result=C.FMOD_System_SetReverbProperties(self,i1,i2)
    return result
end

---@return any,FMOD.Result
function core.System:getReverbProperties(i1)
    local o1=ffi.new("FMOD_REVERB_PROPERTIES[1]")
    local result=C.FMOD_System_GetReverbProperties(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:lockDSP()
    local result=C.FMOD_System_LockDSP(self)
    return result
end

---@return FMOD.Result
function core.System:unlockDSP()
    local result=C.FMOD_System_UnlockDSP(self)
    return result
end

---@return FMOD.Result
function core.System:getRecordNumDrivers(i1,i2)
    local result=C.FMOD_System_GetRecordNumDrivers(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.System:getRecordDriverInfo(i1,i2,i3,i4,i5,i6,i7,i8)
    local result=C.FMOD_System_GetRecordDriverInfo(self,i1,i2,i3,i4,i5,i6,i7,i8)
    return result
end

---@return number,FMOD.Result
function core.System:getRecordPosition(i1)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_System_GetRecordPosition(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:recordStart(i1,i2,i3)
    local result=C.FMOD_System_RecordStart(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.System:recordStop(i1)
    local result=C.FMOD_System_RecordStop(self,i1)
    return result
end

---@return FMOD.Result
function core.System:isRecording(i1,i2)
    local result=C.FMOD_System_IsRecording(self,i1,i2)
    return result
end

---@return FMOD.Core.Geometry,FMOD.Result
function core.System:createGeometry(i1,i2)
    local o1=ffi.new("FMOD_GEOMETRY*[1]")
    local result=C.FMOD_System_CreateGeometry(self,i1,i2,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:setGeometrySettings(i1)
    local result=C.FMOD_System_SetGeometrySettings(self,i1)
    return result
end

---@return number,FMOD.Result
function core.System:getGeometrySettings()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_System_GetGeometrySettings(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.System:loadGeometry(i1,i2)
    local o1=ffi.new("FMOD_GEOMETRY*[1]")
    local result=C.FMOD_System_LoadGeometry(self,i1,i2,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:getGeometryOcclusion(i1,i2,i3,i4)
    local result=C.FMOD_System_GetGeometryOcclusion(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.System:setNetworkProxy(i1)
    local result=C.FMOD_System_SetNetworkProxy(self,i1)
    return result
end

---@return string,FMOD.Result
function core.System:getNetworkProxy()
    local o1=ffi.new("char[256]")
    local result=C.FMOD_System_GetNetworkProxy(self,o1,256)
    return ffi.string(o1),result
end

---@return FMOD.Result
function core.System:setNetworkTimeout(i1)
    local result=C.FMOD_System_SetNetworkTimeout(self,i1)
    return result
end

---@return number,FMOD.Result
function core.System:getNetworkTimeout()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_System_GetNetworkTimeout(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.System:setUserData(i1)
    local result=C.FMOD_System_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.System:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_System_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:release()
    local result=C.FMOD_Sound_Release(self)
    return result
end

---@return any,FMOD.Result
function core.Sound:getSystemObject()
    local o1=ffi.new("FMOD_SYSTEM*[1]")
    local result=C.FMOD_Sound_GetSystemObject(self,o1)
    return o1[0],result
end

---@return any,any,number,number,FMOD.Result
function core.Sound:lock(i1,i2)
    local o1=ffi.new("void*[1]")
    local o2=ffi.new("void*[1]")
    local o3=ffi.new("unsigned int[1]")
    local o4=ffi.new("unsigned int[1]")
    local result=C.FMOD_Sound_Lock(self,i1,i2,o1,o2,o3,o4)
    return o1[0],o2[0],o3[0],o4[0],result
end

---@return FMOD.Result
function core.Sound:unlock(i1,i2,i3,i4)
    local result=C.FMOD_Sound_Unlock(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.Sound:setDefaults(i1,i2)
    local result=C.FMOD_Sound_SetDefaults(self,i1,i2)
    return result
end

---@return number,number,FMOD.Result
function core.Sound:getDefaults()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetDefaults(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Sound:set3DMinMaxDistance(i1,i2)
    local result=C.FMOD_Sound_Set3DMinMaxDistance(self,i1,i2)
    return result
end

---@return number,number,FMOD.Result
function core.Sound:get3DMinMaxDistance()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C.FMOD_Sound_Get3DMinMaxDistance(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Sound:set3DConeSettings(i1,i2,i3)
    local result=C.FMOD_Sound_Set3DConeSettings(self,i1,i2,i3)
    return result
end

---@return number,number,number,FMOD.Result
function core.Sound:get3DConeSettings()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_Sound_Get3DConeSettings(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.Sound:set3DCustomRolloff(i1,i2)
    local result=C.FMOD_Sound_Set3DCustomRolloff(self,i1,i2)
    return result
end

---@return any,number,FMOD.Result
function core.Sound:get3DCustomRolloff()
    local o1=ffi.new("FMOD_VECTOR*[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_Sound_Get3DCustomRolloff(self,o1,o2)
    return o1[0],o2[0],result
end

---@return any,FMOD.Result
function core.Sound:getSubSound(i1)
    local o1=ffi.new("FMOD_SOUND*[1]")
    local result=C.FMOD_Sound_GetSubSound(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.Sound:getSubSoundParent()
    local o1=ffi.new("FMOD_SOUND*[1]")
    local result=C.FMOD_Sound_GetSubSoundParent(self,o1)
    return o1[0],result
end

---@return string,FMOD.Result
function core.Sound:getName()
    local o1=ffi.new("char[256]")
    local result=C.FMOD_Sound_GetName(self,o1,256)
    return ffi.string(o1),result
end

---@return number,FMOD.Result
function core.Sound:getLength(i1)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_Sound_GetLength(self,o1,i1)
    return o1[0],result
end

---@return any,any,number,number,FMOD.Result
function core.Sound:getFormat()
    local o1=ffi.new("FMOD_SOUND_TYPE[1]")
    local o2=ffi.new("FMOD_SOUND_FORMAT[1]")
    local o3=ffi.new("int[1]")
    local o4=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetFormat(self,o1,o2,o3,o4)
    return o1[0],o2[0],o3[0],o4[0],result
end

---@return number,FMOD.Result
function core.Sound:getNumSubSounds()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetNumSubSounds(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function core.Sound:getNumTags()
    local o1=ffi.new("int[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetNumTags(self,o1,o2)
    return o1[0],o2[0],result
end

---@return any,FMOD.Result
function core.Sound:getTag(i1,i2)
    local o1=ffi.new("FMOD_TAG[1]")
    local result=C.FMOD_Sound_GetTag(self,i1,i2,o1)
    return o1[0],result
end

---@return any,number,number,number,FMOD.Result
function core.Sound:getOpenState()
    local o1=ffi.new("FMOD_OPENSTATE[1]")
    local o2=ffi.new("unsigned int[1]")
    local o3=ffi.new("FMOD_BOOL[1]")
    local o4=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Sound_GetOpenState(self,o1,o2,o3,o4)
    return o1[0],o2[0],o3[0],o4[0],result
end

---@return number,FMOD.Result
function core.Sound:readData(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_Sound_ReadData(self,i1,i2,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:seekData(i1)
    local result=C.FMOD_Sound_SeekData(self,i1)
    return result
end

---@return FMOD.Result
function core.Sound:setSoundGroup(i1)
    local result=C.FMOD_Sound_SetSoundGroup(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Sound:getSoundGroup()
    local o1=ffi.new("FMOD_SOUNDGROUP*[1]")
    local result=C.FMOD_Sound_GetSoundGroup(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.Sound:getNumSyncPoints()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetNumSyncPoints(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.Sound:getSyncPoint(i1)
    local o1=ffi.new("FMOD_SYNCPOINT*[1]")
    local result=C.FMOD_Sound_GetSyncPoint(self,i1,o1)
    return o1[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function core.Sound:getSyncPointInfo(i1,i2,i3)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("unsigned int[1]")
    local result=C.FMOD_Sound_GetSyncPointInfo(self,i1,o1,i2,o2,i3)
    return o1[0],o2[0],result
end

---@return any,FMOD.Result
function core.Sound:addSyncPoint(i1,i2,i3)
    local o1=ffi.new("FMOD_SYNCPOINT*[1]")
    local result=C.FMOD_Sound_AddSyncPoint(self,i1,i2,i3,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:deleteSyncPoint(i1)
    local result=C.FMOD_Sound_DeleteSyncPoint(self,i1)
    return result
end

---@return FMOD.Result
function core.Sound:setMode(i1)
    local result=C.FMOD_Sound_SetMode(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Sound:getMode()
    local o1=ffi.new("FMOD_MODE[1]")
    local result=C.FMOD_Sound_GetMode(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:setLoopCount(i1)
    local result=C.FMOD_Sound_SetLoopCount(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Sound:getLoopCount()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetLoopCount(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:setLoopPoints(i1,i2,i3,i4)
    local result=C.FMOD_Sound_SetLoopPoints(self,i1,i2,i3,i4)
    return result
end

---@return number,number,FMOD.Result
function core.Sound:getLoopPoints(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("unsigned int[1]")
    local result=C.FMOD_Sound_GetLoopPoints(self,o1,i1,o2,i2)
    return o1[0],o2[0],result
end

---@return number,FMOD.Result
function core.Sound:getMusicNumChannels()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Sound_GetMusicNumChannels(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:setMusicChannelVolume(i1,i2)
    local result=C.FMOD_Sound_SetMusicChannelVolume(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function core.Sound:getMusicChannelVolume(i1)
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Sound_GetMusicChannelVolume(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:setMusicSpeed(i1)
    local result=C.FMOD_Sound_SetMusicSpeed(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Sound:getMusicSpeed()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Sound_GetMusicSpeed(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Sound:setUserData(i1)
    local result=C.FMOD_Sound_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Sound:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_Sound_GetUserData(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.Channel:getSystemObject()
    local o1=ffi.new("FMOD_SYSTEM*[1]")
    local result=C.FMOD_Channel_GetSystemObject(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:stop()
    local result=C.FMOD_Channel_Stop(self)
    return result
end

---@return FMOD.Result
function core.Channel:setPaused(i1)
    local result=C.FMOD_Channel_SetPaused(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getPaused()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Channel_GetPaused(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setVolume(i1)
    local result=C.FMOD_Channel_SetVolume(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getVolume()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetVolume(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setVolumeRamp(i1)
    local result=C.FMOD_Channel_SetVolumeRamp(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getVolumeRamp()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Channel_GetVolumeRamp(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.Channel:getAudibility()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetAudibility(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setPitch(i1)
    local result=C.FMOD_Channel_SetPitch(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getPitch()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetPitch(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setMute(i1)
    local result=C.FMOD_Channel_SetMute(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getMute()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Channel_GetMute(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setReverbProperties(i1,i2)
    local result=C.FMOD_Channel_SetReverbProperties(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function core.Channel:getReverbProperties(i1)
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetReverbProperties(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setLowPassGain(i1)
    local result=C.FMOD_Channel_SetLowPassGain(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getLowPassGain()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetLowPassGain(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setMode(i1)
    local result=C.FMOD_Channel_SetMode(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Channel:getMode()
    local o1=ffi.new("FMOD_MODE[1]")
    local result=C.FMOD_Channel_GetMode(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setCallback(i1)
    local result=C.FMOD_Channel_SetCallback(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:isPlaying()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Channel_IsPlaying(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setPan(i1)
    local result=C.FMOD_Channel_SetPan(self,i1)
    return result
end

---@return FMOD.Result
function core.Channel:setMixLevelsOutput(i1,i2,i3,i4,i5,i6,i7,i8)
    local result=C.FMOD_Channel_SetMixLevelsOutput(self,i1,i2,i3,i4,i5,i6,i7,i8)
    return result
end

---@return FMOD.Result
function core.Channel:setMixLevelsInput(i1,i2)
    local result=C.FMOD_Channel_SetMixLevelsInput(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.Channel:setMixMatrix(i1,i2,i3,i4)
    local result=C.FMOD_Channel_SetMixMatrix(self,i1,i2,i3,i4)
    return result
end

---@return number,number,number,number,FMOD.Result
function core.Channel:getMixMatrix()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("int[1]")
    local o3=ffi.new("int[1]")
    local o4=ffi.new("int[1]")
    local result=C.FMOD_Channel_GetMixMatrix(self,o1,o2,o3,o4)
    return o1[0],o2[0],o3[0],o4[0],result
end

---@return number,number,FMOD.Result
function core.Channel:getDSPClock()
    local o1=ffi.new("unsigned long long int[1]")
    local o2=ffi.new("unsigned long long int[1]")
    local result=C.FMOD_Channel_GetDSPClock(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Channel:setDelay(i1,i2,i3)
    local result=C.FMOD_Channel_SetDelay(self,i1,i2,i3)
    return result
end

---@return number,number,number,FMOD.Result
function core.Channel:getDelay()
    local o1=ffi.new("unsigned long long int[1]")
    local o2=ffi.new("unsigned long long int[1]")
    local o3=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Channel_GetDelay(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.Channel:addFadePoint(i1,i2)
    local result=C.FMOD_Channel_AddFadePoint(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.Channel:setFadePointRamp(i1,i2)
    local result=C.FMOD_Channel_SetFadePointRamp(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.Channel:removeFadePoints(i1,i2)
    local result=C.FMOD_Channel_RemoveFadePoints(self,i1,i2)
    return result
end

---@return number,number,number,FMOD.Result
function core.Channel:getFadePoints()
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("unsigned long long int[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetFadePoints(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return any,FMOD.Result
function core.Channel:getDSP(i1)
    local o1=ffi.new("FMOD_DSP*[1]")
    local result=C.FMOD_Channel_GetDSP(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:addDSP(i1,i2)
    local result=C.FMOD_Channel_AddDSP(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.Channel:removeDSP(i1)
    local result=C.FMOD_Channel_RemoveDSP(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getNumDSPs()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Channel_GetNumDSPs(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setDSPIndex(i1,i2)
    local result=C.FMOD_Channel_SetDSPIndex(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function core.Channel:getDSPIndex(i1)
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Channel_GetDSPIndex(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:set3DAttributes(i1,i2)
    local result=C.FMOD_Channel_Set3DAttributes(self,i1,i2)
    return result
end

---@return any,any,FMOD.Result
function core.Channel:get3DAttributes()
    local o1=ffi.new("FMOD_VECTOR[1]")
    local o2=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_Channel_Get3DAttributes(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Channel:set3DMinMaxDistance(i1,i2)
    local result=C.FMOD_Channel_Set3DMinMaxDistance(self,i1,i2)
    return result
end

---@return number,number,FMOD.Result
function core.Channel:get3DMinMaxDistance()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DMinMaxDistance(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Channel:set3DConeSettings(i1,i2,i3)
    local result=C.FMOD_Channel_Set3DConeSettings(self,i1,i2,i3)
    return result
end

---@return number,number,number,FMOD.Result
function core.Channel:get3DConeSettings()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DConeSettings(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.Channel:set3DConeOrientation(i1)
    local result=C.FMOD_Channel_Set3DConeOrientation(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Channel:get3DConeOrientation()
    local o1=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_Channel_Get3DConeOrientation(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:set3DCustomRolloff(i1,i2)
    local result=C.FMOD_Channel_Set3DCustomRolloff(self,i1,i2)
    return result
end

---@return any,number,FMOD.Result
function core.Channel:get3DCustomRolloff()
    local o1=ffi.new("FMOD_VECTOR*[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_Channel_Get3DCustomRolloff(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Channel:set3DOcclusion(i1,i2)
    local result=C.FMOD_Channel_Set3DOcclusion(self,i1,i2)
    return result
end

---@return number,number,FMOD.Result
function core.Channel:get3DOcclusion()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DOcclusion(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Channel:set3DSpread(i1)
    local result=C.FMOD_Channel_Set3DSpread(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:get3DSpread()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DSpread(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:set3DLevel(i1)
    local result=C.FMOD_Channel_Set3DLevel(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:get3DLevel()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DLevel(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:set3DDopplerLevel(i1)
    local result=C.FMOD_Channel_Set3DDopplerLevel(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:get3DDopplerLevel()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DDopplerLevel(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:set3DDistanceFilter(i1,i2,i3)
    local result=C.FMOD_Channel_Set3DDistanceFilter(self,i1,i2,i3)
    return result
end

---@return number,number,number,FMOD.Result
function core.Channel:get3DDistanceFilter()
    local o1=ffi.new("FMOD_BOOL[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_Channel_Get3DDistanceFilter(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.Channel:setUserData(i1)
    local result=C.FMOD_Channel_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Channel:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_Channel_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setFrequency(i1)
    local result=C.FMOD_Channel_SetFrequency(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getFrequency()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_Channel_GetFrequency(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setPriority(i1)
    local result=C.FMOD_Channel_SetPriority(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getPriority()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Channel_GetPriority(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setPosition(i1,i2)
    local result=C.FMOD_Channel_SetPosition(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function core.Channel:getPosition(i1)
    local o1=ffi.new("unsigned int[1]")
    local result=C.FMOD_Channel_GetPosition(self,o1,i1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setChannelGroup(i1)
    local result=C.FMOD_Channel_SetChannelGroup(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Channel:getChannelGroup()
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C.FMOD_Channel_GetChannelGroup(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setLoopCount(i1)
    local result=C.FMOD_Channel_SetLoopCount(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Channel:getLoopCount()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Channel_GetLoopCount(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Channel:setLoopPoints(i1,i2,i3,i4)
    local result=C.FMOD_Channel_SetLoopPoints(self,i1,i2,i3,i4)
    return result
end

---@return number,number,FMOD.Result
function core.Channel:getLoopPoints(i1,i2)
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("unsigned int[1]")
    local result=C.FMOD_Channel_GetLoopPoints(self,o1,i1,o2,i2)
    return o1[0],o2[0],result
end

---@return number,FMOD.Result
function core.Channel:isVirtual()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Channel_IsVirtual(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.Channel:getCurrentSound()
    local o1=ffi.new("FMOD_SOUND*[1]")
    local result=C.FMOD_Channel_GetCurrentSound(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.Channel:getIndex()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Channel_GetIndex(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.ChannelGroup:getSystemObject(i1)
    local result=C.FMOD_ChannelGroup_GetSystemObject(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:stop()
    local result=C.FMOD_ChannelGroup_Stop(self)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setPaused(i1)
    local result=C.FMOD_ChannelGroup_SetPaused(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getPaused(i1)
    local result=C.FMOD_ChannelGroup_GetPaused(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setVolume(i1)
    local result=C.FMOD_ChannelGroup_SetVolume(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getVolume(i1)
    local result=C.FMOD_ChannelGroup_GetVolume(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setVolumeRamp(i1)
    local result=C.FMOD_ChannelGroup_SetVolumeRamp(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getVolumeRamp(i1)
    local result=C.FMOD_ChannelGroup_GetVolumeRamp(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getAudibility(i1)
    local result=C.FMOD_ChannelGroup_GetAudibility(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setPitch(i1)
    local result=C.FMOD_ChannelGroup_SetPitch(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getPitch(i1)
    local result=C.FMOD_ChannelGroup_GetPitch(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setMute(i1)
    local result=C.FMOD_ChannelGroup_SetMute(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getMute(i1)
    local result=C.FMOD_ChannelGroup_GetMute(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setReverbProperties(i1,i2)
    local result=C.FMOD_ChannelGroup_SetReverbProperties(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getReverbProperties(i1,i2)
    local result=C.FMOD_ChannelGroup_GetReverbProperties(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setLowPassGain(i1)
    local result=C.FMOD_ChannelGroup_SetLowPassGain(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getLowPassGain(i1)
    local result=C.FMOD_ChannelGroup_GetLowPassGain(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setMode(i1)
    local result=C.FMOD_ChannelGroup_SetMode(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getMode(i1)
    local result=C.FMOD_ChannelGroup_GetMode(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setCallback(i1)
    local result=C.FMOD_ChannelGroup_SetCallback(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:isPlaying(i1)
    local result=C.FMOD_ChannelGroup_IsPlaying(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setPan(i1)
    local result=C.FMOD_ChannelGroup_SetPan(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setMixLevelsOutput(i1,i2,i3,i4,i5,i6,i7,i8)
    local result=C.FMOD_ChannelGroup_SetMixLevelsOutput(self,i1,i2,i3,i4,i5,i6,i7,i8)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setMixLevelsInput(i1,i2)
    local result=C.FMOD_ChannelGroup_SetMixLevelsInput(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setMixMatrix(i1,i2,i3,i4)
    local result=C.FMOD_ChannelGroup_SetMixMatrix(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getMixMatrix(i1,i2,i3,i4)
    local result=C.FMOD_ChannelGroup_GetMixMatrix(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getDSPClock(i1,i2)
    local result=C.FMOD_ChannelGroup_GetDSPClock(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setDelay(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_SetDelay(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getDelay(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_GetDelay(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:addFadePoint(i1,i2)
    local result=C.FMOD_ChannelGroup_AddFadePoint(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setFadePointRamp(i1,i2)
    local result=C.FMOD_ChannelGroup_SetFadePointRamp(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:removeFadePoints(i1,i2)
    local result=C.FMOD_ChannelGroup_RemoveFadePoints(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getFadePoints(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_GetFadePoints(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getDSP(i1,i2)
    local result=C.FMOD_ChannelGroup_GetDSP(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:addDSP(i1,i2)
    local result=C.FMOD_ChannelGroup_AddDSP(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:removeDSP(i1)
    local result=C.FMOD_ChannelGroup_RemoveDSP(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getNumDSPs(i1)
    local result=C.FMOD_ChannelGroup_GetNumDSPs(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setDSPIndex(i1,i2)
    local result=C.FMOD_ChannelGroup_SetDSPIndex(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getDSPIndex(i1,i2)
    local result=C.FMOD_ChannelGroup_GetDSPIndex(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DAttributes(i1,i2)
    local result=C.FMOD_ChannelGroup_Set3DAttributes(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DAttributes(i1,i2)
    local result=C.FMOD_ChannelGroup_Get3DAttributes(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DMinMaxDistance(i1,i2)
    local result=C.FMOD_ChannelGroup_Set3DMinMaxDistance(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DMinMaxDistance(i1,i2)
    local result=C.FMOD_ChannelGroup_Get3DMinMaxDistance(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DConeSettings(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_Set3DConeSettings(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DConeSettings(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_Get3DConeSettings(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DConeOrientation(i1)
    local result=C.FMOD_ChannelGroup_Set3DConeOrientation(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DConeOrientation(i1)
    local result=C.FMOD_ChannelGroup_Get3DConeOrientation(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DCustomRolloff(i1,i2)
    local result=C.FMOD_ChannelGroup_Set3DCustomRolloff(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DCustomRolloff(i1,i2)
    local result=C.FMOD_ChannelGroup_Get3DCustomRolloff(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DOcclusion(i1,i2)
    local result=C.FMOD_ChannelGroup_Set3DOcclusion(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DOcclusion(i1,i2)
    local result=C.FMOD_ChannelGroup_Get3DOcclusion(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DSpread(i1)
    local result=C.FMOD_ChannelGroup_Set3DSpread(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DSpread(i1)
    local result=C.FMOD_ChannelGroup_Get3DSpread(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DLevel(i1)
    local result=C.FMOD_ChannelGroup_Set3DLevel(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DLevel(i1)
    local result=C.FMOD_ChannelGroup_Get3DLevel(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DDopplerLevel(i1)
    local result=C.FMOD_ChannelGroup_Set3DDopplerLevel(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DDopplerLevel(i1)
    local result=C.FMOD_ChannelGroup_Get3DDopplerLevel(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:set3DDistanceFilter(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_Set3DDistanceFilter(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:get3DDistanceFilter(i1,i2,i3)
    local result=C.FMOD_ChannelGroup_Get3DDistanceFilter(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:setUserData(i1)
    local result=C.FMOD_ChannelGroup_SetUserData(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:getUserData(i1)
    local result=C.FMOD_ChannelGroup_GetUserData(self,i1)
    return result
end

---@return FMOD.Result
function core.ChannelGroup:release()
    local result=C.FMOD_ChannelGroup_Release(self)
    return result
end

---@return any,FMOD.Result
function core.ChannelGroup:addGroup(i1,i2)
    local o1=ffi.new("FMOD_DSPCONNECTION*[1]")
    local result=C.FMOD_ChannelGroup_AddGroup(self,i1,i2,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.ChannelGroup:getNumGroups()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_ChannelGroup_GetNumGroups(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.ChannelGroup:getGroup(i1)
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C.FMOD_ChannelGroup_GetGroup(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.ChannelGroup:getParentGroup()
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C.FMOD_ChannelGroup_GetParentGroup(self,o1)
    return o1[0],result
end

---@return string,FMOD.Result
function core.ChannelGroup:getName(i1)
    local o1=ffi.new("char[256]")
    local result=C.FMOD_ChannelGroup_GetName(self,o1,256)
    return ffi.string(o1),result
end

---@return number,FMOD.Result
function core.ChannelGroup:getNumChannels()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_ChannelGroup_GetNumChannels(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.ChannelGroup:getChannel(i1)
    local o1=ffi.new("FMOD_CHANNEL*[1]")
    local result=C.FMOD_ChannelGroup_GetChannel(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:release()
    local result=C.FMOD_SoundGroup_Release(self)
    return result
end

---@return any,FMOD.Result
function core.SoundGroup:getSystemObject()
    local o1=ffi.new("FMOD_SYSTEM*[1]")
    local result=C.FMOD_SoundGroup_GetSystemObject(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:setMaxAudible(i1)
    local result=C.FMOD_SoundGroup_SetMaxAudible(self,i1)
    return result
end

---@return number,FMOD.Result
function core.SoundGroup:getMaxAudible()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_SoundGroup_GetMaxAudible(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:setMaxAudibleBehavior(i1)
    local result=C.FMOD_SoundGroup_SetMaxAudibleBehavior(self,i1)
    return result
end

---@return any,FMOD.Result
function core.SoundGroup:getMaxAudibleBehavior()
    local o1=ffi.new("FMOD_SOUNDGROUP_BEHAVIOR[1]")
    local result=C.FMOD_SoundGroup_GetMaxAudibleBehavior(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:setMuteFadeSpeed(i1)
    local result=C.FMOD_SoundGroup_SetMuteFadeSpeed(self,i1)
    return result
end

---@return number,FMOD.Result
function core.SoundGroup:getMuteFadeSpeed()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_SoundGroup_GetMuteFadeSpeed(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:setVolume(i1)
    local result=C.FMOD_SoundGroup_SetVolume(self,i1)
    return result
end

---@return number,FMOD.Result
function core.SoundGroup:getVolume()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_SoundGroup_GetVolume(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:stop()
    local result=C.FMOD_SoundGroup_Stop(self)
    return result
end

---@return string,FMOD.Result
function core.SoundGroup:getName(i1)
    local o1=ffi.new("char[256]")
    local result=C.FMOD_SoundGroup_GetName(self,o1,256)
    return ffi.string(o1),result
end

---@return number,FMOD.Result
function core.SoundGroup:getNumSounds()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_SoundGroup_GetNumSounds(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.SoundGroup:getSound(i1)
    local o1=ffi.new("FMOD_SOUND*[1]")
    local result=C.FMOD_SoundGroup_GetSound(self,i1,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.SoundGroup:getNumPlaying()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_SoundGroup_GetNumPlaying(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.SoundGroup:setUserData(i1)
    local result=C.FMOD_SoundGroup_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.SoundGroup:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_SoundGroup_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:release()
    local result=C.FMOD_DSP_Release(self)
    return result
end

---@return any,FMOD.Result
function core.DSP:getSystemObject()
    local o1=ffi.new("FMOD_SYSTEM*[1]")
    local result=C.FMOD_DSP_GetSystemObject(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.DSP:addInput(i1,i2)
    local o1=ffi.new("FMOD_DSPCONNECTION*[1]")
    local result=C.FMOD_DSP_AddInput(self,i1,o1,i2)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:disconnectFrom(i1,i2)
    local result=C.FMOD_DSP_DisconnectFrom(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.DSP:disconnectAll(i1,i2)
    local result=C.FMOD_DSP_DisconnectAll(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function core.DSP:getNumInputs()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_DSP_GetNumInputs(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.DSP:getNumOutputs()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_DSP_GetNumOutputs(self,o1)
    return o1[0],result
end

---@return any,any,FMOD.Result
function core.DSP:getInput(i1)
    local o1=ffi.new("FMOD_DSP*[1]")
    local o2=ffi.new("FMOD_DSPCONNECTION*[1]")
    local result=C.FMOD_DSP_GetInput(self,i1,o1,o2)
    return o1[0],o2[0],result
end

---@return any,any,FMOD.Result
function core.DSP:getOutput(i1)
    local o1=ffi.new("FMOD_DSP*[1]")
    local o2=ffi.new("FMOD_DSPCONNECTION*[1]")
    local result=C.FMOD_DSP_GetOutput(self,i1,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.DSP:setActive(i1)
    local result=C.FMOD_DSP_SetActive(self,i1)
    return result
end

---@return number,FMOD.Result
function core.DSP:getActive()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_DSP_GetActive(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:setBypass(i1)
    local result=C.FMOD_DSP_SetBypass(self,i1)
    return result
end

---@return number,FMOD.Result
function core.DSP:getBypass()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_DSP_GetBypass(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:setWetDryMix(i1,i2,i3)
    local result=C.FMOD_DSP_SetWetDryMix(self,i1,i2,i3)
    return result
end

---@return number,number,number,FMOD.Result
function core.DSP:getWetDryMix()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_DSP_GetWetDryMix(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.DSP:setChannelFormat(i1,i2,i3)
    local result=C.FMOD_DSP_SetChannelFormat(self,i1,i2,i3)
    return result
end

---@return any,number,any,FMOD.Result
function core.DSP:getChannelFormat()
    local o1=ffi.new("FMOD_CHANNELMASK[1]")
    local o2=ffi.new("int[1]")
    local o3=ffi.new("FMOD_SPEAKERMODE[1]")
    local result=C.FMOD_DSP_GetChannelFormat(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return any,number,any,FMOD.Result
function core.DSP:getOutputChannelFormat(i1,i2,i3)
    local o1=ffi.new("FMOD_CHANNELMASK[1]")
    local o2=ffi.new("int[1]")
    local o3=ffi.new("FMOD_SPEAKERMODE[1]")
    local result=C.FMOD_DSP_GetOutputChannelFormat(self,i1,i2,i3,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.DSP:reset()
    local result=C.FMOD_DSP_Reset(self)
    return result
end

---@return FMOD.Result
function core.DSP:setCallback(i1)
    local result=C.FMOD_DSP_SetCallback(self,i1)
    return result
end

---@return FMOD.Result
function core.DSP:setParameterFloat(i1,i2)
    local result=C.FMOD_DSP_SetParameterFloat(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.DSP:setParameterInt(i1,i2)
    local result=C.FMOD_DSP_SetParameterInt(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.DSP:setParameterBool(i1,i2)
    local result=C.FMOD_DSP_SetParameterBool(self,i1,i2)
    return result
end

---@return FMOD.Result
function core.DSP:setParameterData(i1,i2,i3)
    local result=C.FMOD_DSP_SetParameterData(self,i1,i2,i3)
    return result
end

---**Warning:** string wrongly retrieved
---@return number,any,FMOD.Result
function core.DSP:getParameterFloat(i1,i2)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("char[1]")
    local result=C.FMOD_DSP_GetParameterFloat(self,i1,o1,o2,i2)
    return o1[0],o2[0],result
end

---**Warning:** string wrongly retrieved
---@return number,any,FMOD.Result
function core.DSP:getParameterInt(i1,i2)
    local o1=ffi.new("int[1]")
    local o2=ffi.new("char[1]")
    local result=C.FMOD_DSP_GetParameterInt(self,i1,o1,o2,i2)
    return o1[0],o2[0],result
end

---**Warning:** string wrongly retrieved
---@return number,any,FMOD.Result
function core.DSP:getParameterBool(i1,i2)
    local o1=ffi.new("FMOD_BOOL[1]")
    local o2=ffi.new("char[1]")
    local result=C.FMOD_DSP_GetParameterBool(self,i1,o1,o2,i2)
    return o1[0],o2[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,any,FMOD.Result
function core.DSP:getParameterData(i1,i2)
    local o1=ffi.new("void*[1]")
    local o2=ffi.new("unsigned int[1]")
    local o3=ffi.new("char[1]")
    local result=C.FMOD_DSP_GetParameterData(self,i1,o1,o2,o3,i2)
    return o1[0],o2[0],o3[0],result
end

---@return number,FMOD.Result
function core.DSP:getNumParameters()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_DSP_GetNumParameters(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.DSP:getParameterInfo(i1)
    local o1=ffi.new("FMOD_DSP_PARAMETER_DESC*[1]")
    local result=C.FMOD_DSP_GetParameterInfo(self,i1,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.DSP:getDataParameterIndex(i1)
    local o1=ffi.new("int[1]")
    local result=C.FMOD_DSP_GetDataParameterIndex(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:showConfigDialog(i1,i2)
    local result=C.FMOD_DSP_ShowConfigDialog(self,i1,i2)
    return result
end

---**Warning:** string wrongly retrieved
---@return any,number,number,number,number,FMOD.Result
function core.DSP:getInfo()
    local o1=ffi.new("char[1]")
    local o2=ffi.new("unsigned int[1]")
    local o3=ffi.new("int[1]")
    local o4=ffi.new("int[1]")
    local o5=ffi.new("int[1]")
    local result=C.FMOD_DSP_GetInfo(self,o1,o2,o3,o4,o5)
    return o1[0],o2[0],o3[0],o4[0],o5[0],result
end

---@return any,FMOD.Result
function core.DSP:getType()
    local o1=ffi.new("FMOD_DSP_TYPE[1]")
    local result=C.FMOD_DSP_GetType(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.DSP:getIdle()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_DSP_GetIdle(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:setUserData(i1)
    local result=C.FMOD_DSP_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.DSP:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_DSP_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSP:setMeteringEnabled(i1,i2)
    local result=C.FMOD_DSP_SetMeteringEnabled(self,i1,i2)
    return result
end

---@return number,number,FMOD.Result
function core.DSP:getMeteringEnabled()
    local o1=ffi.new("FMOD_BOOL[1]")
    local o2=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_DSP_GetMeteringEnabled(self,o1,o2)
    return o1[0],o2[0],result
end

---@return any,any,FMOD.Result
function core.DSP:getMeteringInfo()
    local o1=ffi.new("FMOD_DSP_METERING_INFO[1]")
    local o2=ffi.new("FMOD_DSP_METERING_INFO[1]")
    local result=C.FMOD_DSP_GetMeteringInfo(self,o1,o2)
    return o1[0],o2[0],result
end

---@return number,number,FMOD.Result
function core.DSP:getCPUUsage()
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("unsigned int[1]")
    local result=C.FMOD_DSP_GetCPUUsage(self,o1,o2)
    return o1[0],o2[0],result
end

---@return any,FMOD.Result
function core.DSPConnection:getInput()
    local o1=ffi.new("FMOD_DSP*[1]")
    local result=C.FMOD_DSPConnection_GetInput(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function core.DSPConnection:getOutput()
    local o1=ffi.new("FMOD_DSP*[1]")
    local result=C.FMOD_DSPConnection_GetOutput(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSPConnection:setMix(i1)
    local result=C.FMOD_DSPConnection_SetMix(self,i1)
    return result
end

---@return number,FMOD.Result
function core.DSPConnection:getMix()
    local o1=ffi.new("float[1]")
    local result=C.FMOD_DSPConnection_GetMix(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSPConnection:setMixMatrix(i1,i2,i3,i4)
    local result=C.FMOD_DSPConnection_SetMixMatrix(self,i1,i2,i3,i4)
    return result
end

---@return number,number,number,FMOD.Result
function core.DSPConnection:getMixMatrix(i1)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("int[1]")
    local o3=ffi.new("int[1]")
    local result=C.FMOD_DSPConnection_GetMixMatrix(self,o1,o2,o3,i1)
    return o1[0],o2[0],o3[0],result
end

---@return any,FMOD.Result
function core.DSPConnection:getType()
    local o1=ffi.new("FMOD_DSPCONNECTION_TYPE[1]")
    local result=C.FMOD_DSPConnection_GetType(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.DSPConnection:setUserData(i1)
    local result=C.FMOD_DSPConnection_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.DSPConnection:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_DSPConnection_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Geometry:release()
    local result=C.FMOD_Geometry_Release(self)
    return result
end

---@return number,FMOD.Result
function core.Geometry:addPolygon(i1,i2,i3,i4,i5)
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Geometry_AddPolygon(self,i1,i2,i3,i4,i5,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function core.Geometry:getNumPolygons()
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Geometry_GetNumPolygons(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function core.Geometry:getMaxPolygons()
    local o1=ffi.new("int[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_Geometry_GetMaxPolygons(self,o1,o2)
    return o1[0],o2[0],result
end

---@return number,FMOD.Result
function core.Geometry:getPolygonNumVertices(i1)
    local o1=ffi.new("int[1]")
    local result=C.FMOD_Geometry_GetPolygonNumVertices(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Geometry:setPolygonVertex(i1,i2,i3)
    local result=C.FMOD_Geometry_SetPolygonVertex(self,i1,i2,i3)
    return result
end

---@return any,FMOD.Result
function core.Geometry:getPolygonVertex(i1,i2)
    local o1=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_Geometry_GetPolygonVertex(self,i1,i2,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Geometry:setPolygonAttributes(i1,i2,i3,i4)
    local result=C.FMOD_Geometry_SetPolygonAttributes(self,i1,i2,i3,i4)
    return result
end

---@return number,number,number,FMOD.Result
function core.Geometry:getPolygonAttributes(i1)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Geometry_GetPolygonAttributes(self,i1,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.Geometry:setActive(i1)
    local result=C.FMOD_Geometry_SetActive(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Geometry:getActive()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Geometry_GetActive(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Geometry:setRotation(i1,i2)
    local result=C.FMOD_Geometry_SetRotation(self,i1,i2)
    return result
end

---@return any,any,FMOD.Result
function core.Geometry:getRotation()
    local o1=ffi.new("FMOD_VECTOR[1]")
    local o2=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_Geometry_GetRotation(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Geometry:setPosition(i1)
    local result=C.FMOD_Geometry_SetPosition(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Geometry:getPosition()
    local o1=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_Geometry_GetPosition(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Geometry:setScale(i1)
    local result=C.FMOD_Geometry_SetScale(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Geometry:getScale()
    local o1=ffi.new("FMOD_VECTOR[1]")
    local result=C.FMOD_Geometry_GetScale(self,o1)
    return o1[0],result
end

---@return any,number,FMOD.Result
function core.Geometry:save()
    local o1=ffi.new("void[1]")
    local o2=ffi.new("int[1]")
    local result=C.FMOD_Geometry_Save(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function core.Geometry:setUserData(i1)
    local result=C.FMOD_Geometry_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Geometry:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_Geometry_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Reverb3D:release()
    local result=C.FMOD_Reverb3D_Release(self)
    return result
end

---@return FMOD.Result
function core.Reverb3D:set3DAttributes(i1,i2,i3)
    local result=C.FMOD_Reverb3D_Set3DAttributes(self,i1,i2,i3)
    return result
end

---@return any,number,number,FMOD.Result
function core.Reverb3D:get3DAttributes()
    local o1=ffi.new("FMOD_VECTOR[1]")
    local o2=ffi.new("float[1]")
    local o3=ffi.new("float[1]")
    local result=C.FMOD_Reverb3D_Get3DAttributes(self,o1,o2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return FMOD.Result
function core.Reverb3D:setProperties(i1)
    local result=C.FMOD_Reverb3D_SetProperties(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Reverb3D:getProperties()
    local o1=ffi.new("FMOD_REVERB_PROPERTIES[1]")
    local result=C.FMOD_Reverb3D_GetProperties(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Reverb3D:setActive(i1)
    local result=C.FMOD_Reverb3D_SetActive(self,i1)
    return result
end

---@return number,FMOD.Result
function core.Reverb3D:getActive()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C.FMOD_Reverb3D_GetActive(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function core.Reverb3D:setUserData(i1)
    local result=C.FMOD_Reverb3D_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function core.Reverb3D:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C.FMOD_Reverb3D_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.System:isValid()
    local result=C2.FMOD_Studio_System_IsValid(self)
    return result
end

---@return FMOD.Result
function studio.System:setAdvancedSettings(i1)
    local result=C2.FMOD_Studio_System_SetAdvancedSettings(self,i1)
    return result
end

---@return any,FMOD.Result
function studio.System:getAdvancedSettings()
    local o1=ffi.new("FMOD_STUDIO_ADVANCEDSETTINGS[1]")
    local result=C2.FMOD_Studio_System_GetAdvancedSettings(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.System:initialize(i1,i2,i3,i4)
    local result=C2.FMOD_Studio_System_Initialize(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function studio.System:release()
    local result=C2.FMOD_Studio_System_Release(self)
    return result
end

---@return FMOD.Result
function studio.System:update()
    local result=C2.FMOD_Studio_System_Update(self)
    return result
end

---@return FMOD.Core.System,FMOD.Result
function studio.System:getCoreSystem()
    local o1=ffi.new("FMOD_SYSTEM*[1]")
    local result=C2.FMOD_Studio_System_GetCoreSystem(self,o1)
    return o1[0],result
end

---@return FMOD.Studio.EventDescription,FMOD.Result
function studio.System:getEvent(i1)
    local o1=ffi.new("FMOD_STUDIO_EVENTDESCRIPTION*[1]")
    local result=C2.FMOD_Studio_System_GetEvent(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.Bus,FMOD.Result
function studio.System:getBus(i1)
    local o1=ffi.new("FMOD_STUDIO_BUS*[1]")
    local result=C2.FMOD_Studio_System_GetBus(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.VCA,FMOD.Result
function studio.System:getVCA(i1)
    local o1=ffi.new("FMOD_STUDIO_VCA*[1]")
    local result=C2.FMOD_Studio_System_GetVCA(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.Bank,FMOD.Result
function studio.System:getBank(i1)
    local o1=ffi.new("FMOD_STUDIO_BANK*[1]")
    local result=C2.FMOD_Studio_System_GetBank(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.EventDescription,FMOD.Result
function studio.System:getEventByID(i1)
    local o1=ffi.new("FMOD_STUDIO_EVENTDESCRIPTION*[1]")
    local result=C2.FMOD_Studio_System_GetEventByID(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.Bus,FMOD.Result
function studio.System:getBusByID(i1)
    local o1=ffi.new("FMOD_STUDIO_BUS*[1]")
    local result=C2.FMOD_Studio_System_GetBusByID(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.VCA,FMOD.Result
function studio.System:getVCAByID(i1)
    local o1=ffi.new("FMOD_STUDIO_VCA*[1]")
    local result=C2.FMOD_Studio_System_GetVCAByID(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Studio.Bank,FMOD.Result
function studio.System:getBankByID(i1)
    local o1=ffi.new("FMOD_STUDIO_BANK*[1]")
    local result=C2.FMOD_Studio_System_GetBankByID(self,i1,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function studio.System:getSoundInfo(i1)
    local o1=ffi.new("FMOD_STUDIO_SOUND_INFO[1]")
    local result=C2.FMOD_Studio_System_GetSoundInfo(self,i1,o1)
    return o1[0],result
end

---@param name string
---@return FMOD.Studio.ParamDescription,FMOD.Result
function studio.System:getParameterDescriptionByName(name)
    local o1=ffi.new("FMOD_STUDIO_PARAMETER_DESCRIPTION[1]")
    local result=C2.FMOD_Studio_System_GetParameterDescriptionByName(self,name,o1)
    return o1[0],result
end

---@return FMOD.Studio.ParamDescription,FMOD.Result
function studio.System:getParameterDescriptionByID(i1)
    local o1=ffi.new("FMOD_STUDIO_PARAMETER_DESCRIPTION[1]")
    local result=C2.FMOD_Studio_System_GetParameterDescriptionByID(self,i1,o1)
    return o1[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function studio.System:getParameterLabelByName(i1,i2,i3)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetParameterLabelByName(self,i1,i2,o1,i3,o2)
    return o1[0],o2[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function studio.System:getParameterLabelByID(i1,i2,i3)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetParameterLabelByID(self,i1,i2,o1,i3,o2)
    return o1[0],o2[0],result
end

---@return number,number,FMOD.Result
function studio.System:getParameterByID(i1)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_System_GetParameterByID(self,i1,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.System:setParameterByID(i1,i2,i3)
    local result=C2.FMOD_Studio_System_SetParameterByID(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function studio.System:setParameterByIDWithLabel(i1,i2,i3)
    local result=C2.FMOD_Studio_System_SetParameterByIDWithLabel(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function studio.System:setParametersByIDs(i1,i2,i3,i4)
    local result=C2.FMOD_Studio_System_SetParametersByIDs(self,i1,i2,i3,i4)
    return result
end

---@param name string
---@return number,number,FMOD.Result
function studio.System:getParameterByName(name)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_System_GetParameterByName(self,name,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.System:setParameterByName(i1,i2,i3)
    local result=C2.FMOD_Studio_System_SetParameterByName(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function studio.System:setParameterByNameWithLabel(i1,i2,i3)
    local result=C2.FMOD_Studio_System_SetParameterByNameWithLabel(self,i1,i2,i3)
    return result
end

---@return any,FMOD.Result
function studio.System:lookupID(i1)
    local o1=ffi.new("FMOD_GUID[1]")
    local result=C2.FMOD_Studio_System_LookupID(self,i1,o1)
    return o1[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function studio.System:lookupPath(i1,i2)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_LookupPath(self,i1,o1,i2,o2)
    return o1[0],o2[0],result
end

---@return number,FMOD.Result
function studio.System:getNumListeners()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetNumListeners(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.System:setNumListeners(i1)
    local result=C2.FMOD_Studio_System_SetNumListeners(self,i1)
    return result
end

---@return any,any,FMOD.Result
function studio.System:getListenerAttributes(i1)
    local o1=ffi.new("FMOD_3D_ATTRIBUTES[1]")
    local o2=ffi.new("FMOD_VECTOR[1]")
    local result=C2.FMOD_Studio_System_GetListenerAttributes(self,i1,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.System:setListenerAttributes(i1,i2,i3)
    local result=C2.FMOD_Studio_System_SetListenerAttributes(self,i1,i2,i3)
    return result
end

---@return number,FMOD.Result
function studio.System:getListenerWeight(i1)
    local o1=ffi.new("float[1]")
    local result=C2.FMOD_Studio_System_GetListenerWeight(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.System:setListenerWeight(i1,i2)
    local result=C2.FMOD_Studio_System_SetListenerWeight(self,i1,i2)
    return result
end

---@return FMOD.Studio.Bank,FMOD.Result
function studio.System:loadBankFile(i1,i2)
    local o1=ffi.new("FMOD_STUDIO_BANK*[1]")
    local result=C2.FMOD_Studio_System_LoadBankFile(self,i1,i2,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function studio.System:loadBankMemory(i1,i2,i3,i4)
    local o1=ffi.new("FMOD_STUDIO_BANK*[1]")
    local result=C2.FMOD_Studio_System_LoadBankMemory(self,i1,i2,i3,i4,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function studio.System:loadBankCustom(i1,i2)
    local o1=ffi.new("FMOD_STUDIO_BANK*[1]")
    local result=C2.FMOD_Studio_System_LoadBankCustom(self,i1,i2,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.System:registerPlugin(i1)
    local result=C2.FMOD_Studio_System_RegisterPlugin(self,i1)
    return result
end

---@return FMOD.Result
function studio.System:unregisterPlugin(i1)
    local result=C2.FMOD_Studio_System_UnregisterPlugin(self,i1)
    return result
end

---@return FMOD.Result
function studio.System:unloadAll()
    local result=C2.FMOD_Studio_System_UnloadAll(self)
    return result
end

---@return FMOD.Result
function studio.System:flushCommands()
    local result=C2.FMOD_Studio_System_FlushCommands(self)
    return result
end

---@return FMOD.Result
function studio.System:flushSampleLoading()
    local result=C2.FMOD_Studio_System_FlushSampleLoading(self)
    return result
end

---@return FMOD.Result
function studio.System:startCommandCapture(i1,i2)
    local result=C2.FMOD_Studio_System_StartCommandCapture(self,i1,i2)
    return result
end

---@return FMOD.Result
function studio.System:stopCommandCapture()
    local result=C2.FMOD_Studio_System_StopCommandCapture(self)
    return result
end

---@return any,FMOD.Result
function studio.System:loadCommandReplay(i1,i2)
    local o1=ffi.new("FMOD_STUDIO_COMMANDREPLAY*[1]")
    local result=C2.FMOD_Studio_System_LoadCommandReplay(self,i1,i2,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.System:getBankCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetBankCount(self,o1)
    return o1[0],result
end

---@return any,number,FMOD.Result
function studio.System:getBankList(i1)
    local o1=ffi.new("FMOD_STUDIO_BANK*[?]", i1)
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetBankList(self,o1,i1,o2)
    return o1,o2[0],result
end

---@return number,FMOD.Result
function studio.System:getParameterDescriptionCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetParameterDescriptionCount(self,o1)
    return o1[0],result
end

---@return FMOD.Studio.ParamDescription[],number,FMOD.Result
function studio.System:getParameterDescriptionList(i1)
    local o1=ffi.new("FMOD_STUDIO_PARAMETER_DESCRIPTION[?]", i1)
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_System_GetParameterDescriptionList(self,o1,i1,o2)
    return o1,o2[0],result
end

---@return any,any,FMOD.Result
function studio.System:getCPUUsage()
    local o1=ffi.new("FMOD_STUDIO_CPU_USAGE[1]")
    local o2=ffi.new("FMOD_CPU_USAGE[1]")
    local result=C2.FMOD_Studio_System_GetCPUUsage(self,o1,o2)
    return o1[0],o2[0],result
end

---@return any,FMOD.Result
function studio.System:getBufferUsage()
    local o1=ffi.new("FMOD_STUDIO_BUFFER_USAGE[1]")
    local result=C2.FMOD_Studio_System_GetBufferUsage(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.System:resetBufferUsage()
    local result=C2.FMOD_Studio_System_ResetBufferUsage(self)
    return result
end

---@return FMOD.Result
function studio.System:setCallback(i1,i2)
    local result=C2.FMOD_Studio_System_SetCallback(self,i1,i2)
    return result
end

---@return FMOD.Result
function studio.System:setUserData(i1)
    local result=C2.FMOD_Studio_System_SetUserData(self,i1)
    return result
end

---@return any,FMOD.Result
function studio.System:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C2.FMOD_Studio_System_GetUserData(self,o1)
    return o1[0],result
end

---@return number,number,number,FMOD.Result
function studio.System:getMemoryUsage()
    local o1=ffi.new("FMOD_STUDIO_MEMORY_USAGE[1]")
    local result=C2.FMOD_Studio_System_GetMemoryUsage(self,o1)
    return o1[0].exclusive,o1[0].inclusive,o1[0].sampledata,result
end

---@return FMOD.Result
function studio.EventDescription:isValid()
    local result=C2.FMOD_Studio_EventDescription_IsValid(self)
    return result
end

---@return FMOD.GUID,FMOD.Result
function studio.EventDescription:getID()
    local o1=ffi.new("FMOD_GUID[1]")
    local result=C2.FMOD_Studio_EventDescription_GetID(self,o1)
    return o1[0],result
end

---@return string?,FMOD.Result
function studio.EventDescription:getPath()
    local o1=ffi.new("char[0]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetPath(self,o1,0,o2)
    if result~=M.FMOD_OK then return nil,result end
    o1=ffi.new("char[?]",o2[0])
    result=C2.FMOD_Studio_EventDescription_GetPath(self,o1,o2[0],o2)
    return ffi.string(o1),result
end

---@return number,FMOD.Result
function studio.EventDescription:getParameterDescriptionCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterDescriptionCount(self,o1)
    return o1[0],result
end

---@param i1 number
---@return FMOD.Studio.ParamDescription,FMOD.Result
function studio.EventDescription:getParameterDescriptionByIndex(i1)
    local o1=ffi.new("FMOD_STUDIO_PARAMETER_DESCRIPTION[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterDescriptionByIndex(self,i1,o1)
    return o1[0],result
end

---@param name string
---@return FMOD.Studio.ParamDescription,FMOD.Result
function studio.EventDescription:getParameterDescriptionByName(name)
    local o1=ffi.new("FMOD_STUDIO_PARAMETER_DESCRIPTION[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterDescriptionByName(self,name,o1)
    return o1[0],result
end

---@return FMOD.Studio.ParamDescription,FMOD.Result
function studio.EventDescription:getParameterDescriptionByID(i1)
    local o1=ffi.new("FMOD_STUDIO_PARAMETER_DESCRIPTION[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterDescriptionByID(self,i1,o1)
    return o1[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function studio.EventDescription:getParameterLabelByIndex(i1,i2,i3)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterLabelByIndex(self,i1,i2,o1,i3,o2)
    return o1[0],o2[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function studio.EventDescription:getParameterLabelByName(i1,i2,i3)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterLabelByName(self,i1,i2,o1,i3,o2)
    return o1[0],o2[0],result
end

---**Warning:** string wrongly retrieved
---@return any,number,FMOD.Result
function studio.EventDescription:getParameterLabelByID(i1,i2,i3)
    local o1=ffi.new("char[1]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetParameterLabelByID(self,i1,i2,o1,i3,o2)
    return o1[0],o2[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:getUserPropertyCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetUserPropertyCount(self,o1)
    return o1[0],result
end

---@param index number
---@return FMOD.Studio.UserProperty?,FMOD.Result
function studio.EventDescription:getUserPropertyByIndex(index)
    local o1=ffi.new("FMOD_STUDIO_USER_PROPERTY[1]")
    local result=C2.FMOD_Studio_EventDescription_GetUserPropertyByIndex(self,index,o1)
    return o1[0],result
end

---@param name string
---@return FMOD.Studio.UserProperty?,FMOD.Result
function studio.EventDescription:getUserProperty(name)
    local o1=ffi.new("FMOD_STUDIO_USER_PROPERTY[1]")
    local result=C2.FMOD_Studio_EventDescription_GetUserProperty(self,name,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:getLength()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetLength(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function studio.EventDescription:getMinMaxDistance()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventDescription_GetMinMaxDistance(self,o1,o2)
    return o1[0],o2[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:getSoundSize()
    local o1=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventDescription_GetSoundSize(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:isSnapshot()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventDescription_IsSnapshot(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:isOneshot()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventDescription_IsOneshot(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:isStream()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventDescription_IsStream(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:is3D()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventDescription_Is3D(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:isDopplerEnabled()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventDescription_IsDopplerEnabled(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:hasSustainPoint()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventDescription_HasSustainPoint(self,o1)
    return o1[0],result
end

---@return FMOD.Studio.EventInstance,FMOD.Result
function studio.EventDescription:createInstance()
    local o1=ffi.new("FMOD_STUDIO_EVENTINSTANCE*[1]")
    local result=C2.FMOD_Studio_EventDescription_CreateInstance(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.EventDescription:getInstanceCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetInstanceCount(self,o1)
    return o1[0],result
end

---@return table<number, FMOD.Studio.EventInstance>,number,FMOD.Result
function studio.EventDescription:getInstanceList(i1)
    local o1=ffi.new("FMOD_STUDIO_EVENTINSTANCE*[?]", i1)
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventDescription_GetInstanceList(self,o1,i1,o2)
    return o1,o2[0],result
end

---@return FMOD.Result
function studio.EventDescription:loadSampleData()
    local result=C2.FMOD_Studio_EventDescription_LoadSampleData(self)
    return result
end

---@return FMOD.Result
function studio.EventDescription:unloadSampleData()
    local result=C2.FMOD_Studio_EventDescription_UnloadSampleData(self)
    return result
end

---@return any,FMOD.Result
function studio.EventDescription:getSampleLoadingState()
    local o1=ffi.new("FMOD_STUDIO_LOADING_STATE[1]")
    local result=C2.FMOD_Studio_EventDescription_GetSampleLoadingState(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventDescription:releaseAllInstances()
    local result=C2.FMOD_Studio_EventDescription_ReleaseAllInstances(self)
    return result
end

---@return FMOD.Result
function studio.EventDescription:setCallback(i1,i2)
    local result=C2.FMOD_Studio_EventDescription_SetCallback(self,i1,i2)
    return result
end

---@return any,FMOD.Result
function studio.EventDescription:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C2.FMOD_Studio_EventDescription_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventDescription:setUserData(i1)
    local result=C2.FMOD_Studio_EventDescription_SetUserData(self,i1)
    return result
end

---@return FMOD.Result
function studio.EventInstance:isValid()
    local result=C2.FMOD_Studio_EventInstance_IsValid(self)
    return result
end

---@return any,FMOD.Result
function studio.EventInstance:getDescription()
    local o1=ffi.new("FMOD_STUDIO_EVENTDESCRIPTION*[1]")
    local result=C2.FMOD_Studio_EventInstance_GetDescription(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function studio.EventInstance:getVolume()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetVolume(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.EventInstance:setVolume(i1)
    local result=C2.FMOD_Studio_EventInstance_SetVolume(self,i1)
    return result
end

---@return number,number,FMOD.Result
function studio.EventInstance:getPitch()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetPitch(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.EventInstance:setPitch(i1)
    local result=C2.FMOD_Studio_EventInstance_SetPitch(self,i1)
    return result
end

---@return any,FMOD.Result
function studio.EventInstance:get3DAttributes()
    local o1=ffi.new("FMOD_3D_ATTRIBUTES[1]")
    local result=C2.FMOD_Studio_EventInstance_Get3DAttributes(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:set3DAttributes(i1)
    local result=C2.FMOD_Studio_EventInstance_Set3DAttributes(self,i1)
    return result
end

---@return number,FMOD.Result
function studio.EventInstance:getListenerMask()
    local o1=ffi.new("unsigned int[1]")
    local result=C2.FMOD_Studio_EventInstance_GetListenerMask(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:setListenerMask(i1)
    local result=C2.FMOD_Studio_EventInstance_SetListenerMask(self,i1)
    return result
end

---@return number,FMOD.Result
function studio.EventInstance:getProperty(i1)
    local o1=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetProperty(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:setProperty(i1,i2)
    local result=C2.FMOD_Studio_EventInstance_SetProperty(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function studio.EventInstance:getReverbLevel(i1)
    local o1=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetReverbLevel(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:setReverbLevel(i1,i2)
    local result=C2.FMOD_Studio_EventInstance_SetReverbLevel(self,i1,i2)
    return result
end

---@return number,FMOD.Result
function studio.EventInstance:getPaused()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventInstance_GetPaused(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:setPaused(i1)
    local result=C2.FMOD_Studio_EventInstance_SetPaused(self,i1)
    return result
end

---@return FMOD.Result
function studio.EventInstance:start()
    local result=C2.FMOD_Studio_EventInstance_Start(self)
    return result
end

---@return FMOD.Result
function studio.EventInstance:stop(i1)
    local result=C2.FMOD_Studio_EventInstance_Stop(self,i1)
    return result
end

---@return number,FMOD.Result
function studio.EventInstance:getTimelinePosition()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_EventInstance_GetTimelinePosition(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:setTimelinePosition(i1)
    local result=C2.FMOD_Studio_EventInstance_SetTimelinePosition(self,i1)
    return result
end

---@return any,FMOD.Result
function studio.EventInstance:getPlaybackState()
    local o1=ffi.new("FMOD_STUDIO_PLAYBACK_STATE[1]")
    local result=C2.FMOD_Studio_EventInstance_GetPlaybackState(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function studio.EventInstance:getChannelGroup()
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C2.FMOD_Studio_EventInstance_GetChannelGroup(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function studio.EventInstance:getMinMaxDistance()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetMinMaxDistance(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.EventInstance:release()
    local result=C2.FMOD_Studio_EventInstance_Release(self)
    return result
end

---@return number,FMOD.Result
function studio.EventInstance:isVirtual()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_EventInstance_IsVirtual(self,o1)
    return o1[0],result
end

---@param name string
---@return number,number,FMOD.Result
function studio.EventInstance:getParameterByName(name)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetParameterByName(self,name,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.EventInstance:setParameterByName(i1,i2,i3)
    local result=C2.FMOD_Studio_EventInstance_SetParameterByName(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function studio.EventInstance:setParameterByNameWithLabel(i1,i2,i3)
    local result=C2.FMOD_Studio_EventInstance_SetParameterByNameWithLabel(self,i1,i2,i3)
    return result
end

---@return number,number,FMOD.Result
function studio.EventInstance:getParameterByID(i1)
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_EventInstance_GetParameterByID(self,i1,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.EventInstance:setParameterByID(i1,i2,i3)
    local result=C2.FMOD_Studio_EventInstance_SetParameterByID(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function studio.EventInstance:setParameterByIDWithLabel(i1,i2,i3)
    local result=C2.FMOD_Studio_EventInstance_SetParameterByIDWithLabel(self,i1,i2,i3)
    return result
end

---@return FMOD.Result
function studio.EventInstance:setParametersByIDs(i1,i2,i3,i4)
    local result=C2.FMOD_Studio_EventInstance_SetParametersByIDs(self,i1,i2,i3,i4)
    return result
end

---@return FMOD.Result
function studio.EventInstance:keyOff()
    local result=C2.FMOD_Studio_EventInstance_KeyOff(self)
    return result
end

---@return FMOD.Result
function studio.EventInstance:setCallback(i1,i2)
    local result=C2.FMOD_Studio_EventInstance_SetCallback(self,i1,i2)
    return result
end

---@return any,FMOD.Result
function studio.EventInstance:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C2.FMOD_Studio_EventInstance_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.EventInstance:setUserData(i1)
    local result=C2.FMOD_Studio_EventInstance_SetUserData(self,i1)
    return result
end

---@return number,number,FMOD.Result
function studio.EventInstance:getCPUUsage()
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("unsigned int[1]")
    local result=C2.FMOD_Studio_EventInstance_GetCPUUsage(self,o1,o2)
    return o1[0],o2[0],result
end

---@return number,number,number,FMOD.Result
function studio.EventInstance:getMemoryUsage()
    local o1=ffi.new("FMOD_STUDIO_MEMORY_USAGE[1]")
    local result=C2.FMOD_Studio_EventInstance_GetMemoryUsage(self,o1)
    return o1[0].exclusive,o1[0].inclusive,o1[0].sampledata,result
end

---@return FMOD.Result
function studio.Bus:isValid()
    local result=C2.FMOD_Studio_Bus_IsValid(self)
    return result
end

---@return FMOD.GUID,FMOD.Result
function studio.Bus:getID()
    local o1=ffi.new("FMOD_GUID[1]")
    local result=C2.FMOD_Studio_Bus_GetID(self,o1)
    return o1[0],result
end

---@return string?,FMOD.Result
function studio.Bus:getPath()
    local o1=ffi.new("char[0]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bus_GetPath(self,o1,0,o2)
    if result~=M.FMOD_OK then return nil,result end
    o1=ffi.new("char[?]",o2[0])
    result=C2.FMOD_Studio_Bus_GetPath(self,o1,o2[0],o2)
    return ffi.string(o1),result
end

---@return number,number,FMOD.Result
function studio.Bus:getVolume()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_Bus_GetVolume(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.Bus:setVolume(i1)
    local result=C2.FMOD_Studio_Bus_SetVolume(self,i1)
    return result
end

---@return number,FMOD.Result
function studio.Bus:getPaused()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_Bus_GetPaused(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.Bus:setPaused(i1)
    local result=C2.FMOD_Studio_Bus_SetPaused(self,i1)
    return result
end

---@return number,FMOD.Result
function studio.Bus:getMute()
    local o1=ffi.new("FMOD_BOOL[1]")
    local result=C2.FMOD_Studio_Bus_GetMute(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.Bus:setMute(i1)
    local result=C2.FMOD_Studio_Bus_SetMute(self,i1)
    return result
end

---@return FMOD.Result
function studio.Bus:stopAllEvents(i1)
    local result=C2.FMOD_Studio_Bus_StopAllEvents(self,i1)
    return result
end

---@return any,FMOD.Result
function studio.Bus:getPortIndex()
    local o1=ffi.new("FMOD_PORT_INDEX[1]")
    local result=C2.FMOD_Studio_Bus_GetPortIndex(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.Bus:setPortIndex(i1)
    local result=C2.FMOD_Studio_Bus_SetPortIndex(self,i1)
    return result
end

---@return FMOD.Result
function studio.Bus:lockChannelGroup()
    local result=C2.FMOD_Studio_Bus_LockChannelGroup(self)
    return result
end

---@return FMOD.Result
function studio.Bus:unlockChannelGroup()
    local result=C2.FMOD_Studio_Bus_UnlockChannelGroup(self)
    return result
end

---@return any,FMOD.Result
function studio.Bus:getChannelGroup()
    local o1=ffi.new("FMOD_CHANNELGROUP*[1]")
    local result=C2.FMOD_Studio_Bus_GetChannelGroup(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function studio.Bus:getCPUUsage()
    local o1=ffi.new("unsigned int[1]")
    local o2=ffi.new("unsigned int[1]")
    local result=C2.FMOD_Studio_Bus_GetCPUUsage(self,o1,o2)
    return o1[0],o2[0],result
end

---@return number,number,number,FMOD.Result
function studio.Bus:getMemoryUsage()
    local o1=ffi.new("FMOD_STUDIO_MEMORY_USAGE[1]")
    local result=C2.FMOD_Studio_Bus_GetMemoryUsage(self,o1)
    return o1[0].exclusive,o1[0].inclusive,o1[0].sampledata,result
end

---@return FMOD.Result
function studio.VCA:isValid()
    local result=C2.FMOD_Studio_VCA_IsValid(self)
    return result
end

---@return FMOD.GUID,FMOD.Result
function studio.VCA:getID()
    local o1=ffi.new("FMOD_GUID[1]")
    local result=C2.FMOD_Studio_VCA_GetID(self,o1)
    return o1[0],result
end

---@return string?,FMOD.Result
function studio.VCA:getPath()
    local o1=ffi.new("char[0]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_VCA_GetPath(self,o1,0,o2)
    if result~=M.FMOD_OK then return nil,result end
    o1=ffi.new("char[?]",o2[0])
    result=C2.FMOD_Studio_VCA_GetPath(self,o1,o2[0],o2)
    return ffi.string(o1),result
end

---@return number,number,FMOD.Result
function studio.VCA:getVolume()
    local o1=ffi.new("float[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_VCA_GetVolume(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.VCA:setVolume(i1)
    local result=C2.FMOD_Studio_VCA_SetVolume(self,i1)
    return result
end

---@return FMOD.Result
function studio.Bank:isValid()
    local result=C2.FMOD_Studio_Bank_IsValid(self)
    return result
end

---@return FMOD.GUID,FMOD.Result
function studio.Bank:getID()
    local o1=ffi.new("FMOD_GUID[1]")
    local result=C2.FMOD_Studio_Bank_GetID(self,o1)
    return o1[0],result
end

---@return string?,FMOD.Result
function studio.Bank:getPath()
    local o1=ffi.new("char[0]")
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetPath(self,o1,0,o2)
    if result~=M.FMOD_OK then return nil,result end
    o1=ffi.new("char[?]",o2[0])
    result=C2.FMOD_Studio_Bank_GetPath(self,o1,o2[0],o2)
    return ffi.string(o1),result
end

---@return FMOD.Result
function studio.Bank:unload()
    local result=C2.FMOD_Studio_Bank_Unload(self)
    return result
end

---@return FMOD.Result
function studio.Bank:loadSampleData()
    local result=C2.FMOD_Studio_Bank_LoadSampleData(self)
    return result
end

---@return FMOD.Result
function studio.Bank:unloadSampleData()
    local result=C2.FMOD_Studio_Bank_UnloadSampleData(self)
    return result
end

---@return any,FMOD.Result
function studio.Bank:getLoadingState()
    local o1=ffi.new("FMOD_STUDIO_LOADING_STATE[1]")
    local result=C2.FMOD_Studio_Bank_GetLoadingState(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function studio.Bank:getSampleLoadingState()
    local o1=ffi.new("FMOD_STUDIO_LOADING_STATE[1]")
    local result=C2.FMOD_Studio_Bank_GetSampleLoadingState(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.Bank:getStringCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetStringCount(self,o1)
    return o1[0],result
end

---**Warning:** string wrongly retrieved
---@return any,any,number,FMOD.Result
function studio.Bank:getStringInfo(i1,i2)
    local o1=ffi.new("FMOD_GUID[1]")
    local o2=ffi.new("char[1]")
    local o3=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetStringInfo(self,i1,o1,o2,i2,o3)
    return o1[0],o2[0],o3[0],result
end

---@return number,FMOD.Result
function studio.Bank:getEventCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetEventCount(self,o1)
    return o1[0],result
end

---@return table<number, FMOD.Studio.EventDescription>,number,FMOD.Result
function studio.Bank:getEventList(i1)
    if not i1 then i1=self:getEventCount() end
    local o1=ffi.new("FMOD_STUDIO_EVENTDESCRIPTION*[?]", i1)
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetEventList(self,o1,i1,o2)
    return o1,o2[0],result
end

---@return number,FMOD.Result
function studio.Bank:getBusCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetBusCount(self,o1)
    return o1[0],result
end

---@return any,number,FMOD.Result
function studio.Bank:getBusList(i1)
    local o1=ffi.new("FMOD_STUDIO_BUS*[?]", i1)
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetBusList(self,o1,i1,o2)
    return o1,o2[0],result
end

---@return number,FMOD.Result
function studio.Bank:getVCACount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetVCACount(self,o1)
    return o1[0],result
end

---@return any,number,FMOD.Result
function studio.Bank:getVCAList(i1)
    local o1=ffi.new("FMOD_STUDIO_VCA*[?]", i1)
    local o2=ffi.new("int[1]")
    local result=C2.FMOD_Studio_Bank_GetVCAList(self,o1,i1,o2)
    return o1,o2[0],result
end

---@return any,FMOD.Result
function studio.Bank:getUserData()
    local o1=ffi.new("void*[1]")
    local result=C2.FMOD_Studio_Bank_GetUserData(self,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.Bank:setUserData(i1)
    local result=C2.FMOD_Studio_Bank_SetUserData(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:isValid()
    local result=C2.FMOD_Studio_CommandReplay_IsValid(self)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:getSystem(i1)
    local result=C2.FMOD_Studio_CommandReplay_GetSystem(self,i1)
    return result
end

---@return number,FMOD.Result
function studio.CommandReplay:getLength()
    local o1=ffi.new("float[1]")
    local result=C2.FMOD_Studio_CommandReplay_GetLength(self,o1)
    return o1[0],result
end

---@return number,FMOD.Result
function studio.CommandReplay:getCommandCount()
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_CommandReplay_GetCommandCount(self,o1)
    return o1[0],result
end

---@return any,FMOD.Result
function studio.CommandReplay:getCommandInfo(i1)
    local o1=ffi.new("FMOD_STUDIO_COMMAND_INFO[1]")
    local result=C2.FMOD_Studio_CommandReplay_GetCommandInfo(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.CommandReplay:getCommandString(i1,i2,i3)
    local result=C2.FMOD_Studio_CommandReplay_GetCommandString(self,i1,i2,i3)
    return result
end

---@return number,FMOD.Result
function studio.CommandReplay:getCommandAtTime(i1)
    local o1=ffi.new("int[1]")
    local result=C2.FMOD_Studio_CommandReplay_GetCommandAtTime(self,i1,o1)
    return o1[0],result
end

---@return FMOD.Result
function studio.CommandReplay:setBankPath(i1)
    local result=C2.FMOD_Studio_CommandReplay_SetBankPath(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:start()
    local result=C2.FMOD_Studio_CommandReplay_Start(self)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:stop()
    local result=C2.FMOD_Studio_CommandReplay_Stop(self)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:seekToTime(i1)
    local result=C2.FMOD_Studio_CommandReplay_SeekToTime(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:seekToCommand(i1)
    local result=C2.FMOD_Studio_CommandReplay_SeekToCommand(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:getPaused(i1)
    local result=C2.FMOD_Studio_CommandReplay_GetPaused(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:setPaused(i1)
    local result=C2.FMOD_Studio_CommandReplay_SetPaused(self,i1)
    return result
end

---@return any,FMOD.Result
function studio.CommandReplay:getPlaybackState()
    local o1=ffi.new("FMOD_STUDIO_PLAYBACK_STATE[1]")
    local result=C2.FMOD_Studio_CommandReplay_GetPlaybackState(self,o1)
    return o1[0],result
end

---@return number,number,FMOD.Result
function studio.CommandReplay:getCurrentCommand()
    local o1=ffi.new("int[1]")
    local o2=ffi.new("float[1]")
    local result=C2.FMOD_Studio_CommandReplay_GetCurrentCommand(self,o1,o2)
    return o1[0],o2[0],result
end

---@return FMOD.Result
function studio.CommandReplay:release()
    local result=C2.FMOD_Studio_CommandReplay_Release(self)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:setFrameCallback(i1)
    local result=C2.FMOD_Studio_CommandReplay_SetFrameCallback(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:setLoadBankCallback(i1)
    local result=C2.FMOD_Studio_CommandReplay_SetLoadBankCallback(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:setCreateInstanceCallback(i1)
    local result=C2.FMOD_Studio_CommandReplay_SetCreateInstanceCallback(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:getUserData(i1)
    local result=C2.FMOD_Studio_CommandReplay_GetUserData(self,i1)
    return result
end

---@return FMOD.Result
function studio.CommandReplay:setUserData(i1)
    local result=C2.FMOD_Studio_CommandReplay_SetUserData(self,i1)
    return result
end

for _,v in next,core do v.__index=v end
for _,v in next,studio do v.__index=v end
ffi.metatype("FMOD_SYSTEM", core.System)
ffi.metatype("FMOD_SOUND", core.Sound)
ffi.metatype("FMOD_CHANNELCONTROL", core.ChannelControl)
ffi.metatype("FMOD_CHANNEL", core.Channel)
ffi.metatype("FMOD_CHANNELGROUP", core.ChannelGroup)
ffi.metatype("FMOD_SOUNDGROUP", core.SoundGroup)
ffi.metatype("FMOD_DSP", core.DSP)
ffi.metatype("FMOD_DSPCONNECTION", core.DSPConnection)
ffi.metatype("FMOD_GEOMETRY", core.Geometry)
ffi.metatype("FMOD_REVERB3D", core.Reverb3D)
ffi.metatype("FMOD_STUDIO_SYSTEM", studio.System)
ffi.metatype("FMOD_STUDIO_EVENTDESCRIPTION", studio.EventDescription)
ffi.metatype("FMOD_STUDIO_EVENTINSTANCE", studio.EventInstance)
ffi.metatype("FMOD_STUDIO_BUS", studio.Bus)
ffi.metatype("FMOD_STUDIO_VCA", studio.VCA)
ffi.metatype("FMOD_STUDIO_BANK", studio.Bank)
ffi.metatype("FMOD_STUDIO_COMMANDREPLAY", studio.CommandReplay)
