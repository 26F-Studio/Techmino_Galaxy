local gc=love.graphics

local baseFreq=440/4
local step=2^(1/12)
local diffMin,diffMax=0,0

---@class Techmino.App.Harmony.Voice
---@field wave string
---@field tune number
---@field vol number
---@field key string
---@field active boolean
---@field x number
---@field y number
---@field sounds FMOD.Studio.EventInstance[]
local Voice={}
Voice.__index=Voice

---@param v Techmino.App.Harmony.Voice
function Voice.init(v)
    setmetatable(v,{__index=Voice})
    if not v.tune then v.tune=0 end
    if not v.vol then v.vol=.626 end
    v.sounds={}
    for i=1,3 do
        v.sounds[i]=FMOD.effect.play(v.wave,{pitch=(262*step^v.tune)/baseFreq,param={'release',1000}})
    end
    return v
end

function Voice:tuneChange(n)
    self.tune=self.tune+n
    self:randomize()
end
function Voice:volumeChange(n)
    self.vol=MATH.clamp(self.vol+n,0,1)
    for i=1,#self.sounds do
        self.sounds[i]:setVolume(self.vol*.4)
    end
end
function Voice:randomize()
    for i=1,#self.sounds do
        local s=self.sounds[i]
        s:setPitch((262*step^(self.tune+MATH.rand(diffMin,diffMax)))/baseFreq)
    end
end
function Voice:stop()
    for _,v in next,self.sounds do
        v:stop(FMOD.FMOD_STUDIO_STOP_ALLOWFADEOUT)
    end
end

---@type Techmino.App.Harmony.Voice[]
local voiceData={
    {
        wave='organ_wave',
        tune=0,
        key='1',
        x=-600,
        y=0,
    },
    {
        wave='organ_wave',
        tune=4,
        key='2',
        x=-200,
        y=0,
    },
    {
        wave='organ_wave',
        tune=7,
        key='3',
        x=200,
        y=0,
    },
    {
        wave='organ_wave',
        tune=11,
        key='4',
        x=600,
        y=0,
    },
}
local voice={}


---@type Zenitha.Scene
local scene={}

local function bend(n)
    for i=1,#voice do
        local v=voice[i]
        if v.active then
            v:tuneChange(n)
        end
    end
end

function scene.load()
    love.mouse.setRelativeMode(true)
    TABLE.clear(voice)
    for k,v in next,voiceData do
        voice[k]=Voice.init(v)
        voice[k]:volumeChange(0)
    end
end
function scene.unload()
    love.mouse.setRelativeMode(false)
    for _,v in next,voice do
        v:stop()
    end
    voice=nil
end

function scene.mouseDown(x,y,k)
end
function scene.mouseMove(x,y,dx,dy)
    for i=1,#voice do
        local v=voice[i]
        if v.active then
            v:tuneChange(-dy/260)
            v:volumeChange(dx/620)
        end
    end
end

function scene.keyDown(key,isRep)
    if isRep then return end
    for i=1,#voice do
        if voice[i].key==key then
            voice[i].active=true
            return
        end
    end
    if key=='-' or key=='[' then
        bend(-1)
    elseif key=='=' or key==']' then
        bend(1)
    end
end
function scene.keyUp(key)
    for i=1,#voice do
        if voice[i].key==key then
            voice[i].active=false
            return
        end
    end
end

local t1=0
function scene.update(dt)
    t1=t1+dt
    if t1>.042 then
        t1=0
        for i=1,#voice do
            if not voice[i].active then
                voice[i].tune=MATH.linearApproach(voice[i].tune,math.floor(voice[i].tune+.5),0.1)
            end
            voice[i]:randomize()
        end
    end
end

local black={
    [1]=true,
    [3]=true,
    [6]=true,
    [8]=true,
    [10]=true,
}
function scene.draw()
    gc.replaceTransform(SCR.xOy_m)
    gc.translate(0,300)
    gc.setLineWidth(10)
    for i=0,12 do
        gc.setColor(black[i%12] and COLOR.lD or COLOR.DL)
        gc.line(-1000,-i*50,1000,-i*50)
    end

    gc.setLineWidth(3)
    gc.setColor(COLOR.L)
    for i=1,#voice do
        local v=voice[i]
        gc.circle(v.active and 'fill' or 'line',v.x,v.y-v.tune*50,10+40*v.vol)
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-60,y=-60,w=80,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,onPress=WIDGET.c_backScn()},
}
return scene
