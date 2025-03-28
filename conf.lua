ZENITHA={path='Zenitha/'}
ShellOption=require'shell'

if ShellOption.bootDisabled then
    function love.conf(t)
        for k in next,t.modules do t.modules[k]=false end
        t.window.vsync=0
        t.window.msaa=0
        t.window.depth=0
        t.window.stencil=0
    end
    return
end

if love['_os']=='Web' then
    local oldRead=love.filesystem.read
    love.filesystem[('read')]=function(name,size)
        if love.filesystem.getInfo(name) then return oldRead(name,size) end
    end
    if math.log(8,2)~=3 then
        -- Fix log function if it doesn't support base
        local log=math.log
        math[('log')]=function(x,base)
            return base and log(x)/log(base) or log(x)
        end
    end
end

function love.conf(t)
    local identity='Techmino_Galaxy'
    local mobile=love._os=='Android' or love._os=='iOS'
    local web=love._os=='Web'
    local msaa=4
    local portrait=false ---@type boolean|nil

    local fs=love.filesystem
    fs.setIdentity(identity)
    do -- Load grapgic settings from conf/settings
        local fileData=fs.read('conf/settings')
        if fileData then
            msaa=tonumber(fileData:match('"msaa":(%d+)')) or 0
            portrait=mobile and fileData:find('"portrait":true') and true
        end
    end

    t.identity='Techmino_Galaxy' -- Saving folder
    t.externalstorage=true -- Use external storage on Android
    t.version="11.5"
    t.gammacorrect=false
    t.appendidentity=true -- Search files in source then in save directory
    t.accelerometerjoystick=false -- Accelerometer=joystick on ios/android
    if t.audio then
        t.audio.mic=false
        t.audio.mixwithsystem=true
    end

    local M=t.modules
    M.window,M.system,M.event,M.thread=true,true,true,true
    M.timer,M.math,M.data=true,true,true
    M.video,M.audio,M.sound=true,web,false
    M.graphics,M.font,M.image=true,true,true
    M.mouse,M.touch,M.keyboard,M.joystick=true,true,true,true
    M.physics=false

    local W=t.window
    W.vsync=0 -- Unlimited FPS
    W.msaa=msaa -- Multi-sampled antialiasing
    W.depth=0 -- Bits/samp of depth buffer
    W.stencil=1 -- Bits/samp of stencil buffer
    W.display=1 -- Monitor ID
    W.highdpi=true -- High-dpi mode for the window on a Retina display
    W.x,W.y=nil,nil
    W.borderless=mobile
    W.resizable=not mobile
    W.fullscreentype=mobile and "exclusive" or "desktop" -- Fullscreen type
    if portrait then
        W.width,W.height=900,1440
        W.minwidth,W.minheight=180,288
    else
        W.width,W.height=1440,900
        W.minwidth,W.minheight=288,180
    end
    W.title=require'version'.appName..'  '..require'version'.appVer

    if love._os=='Linux' and fs.getInfo('assets/image/icon.png') then
        W.icon='assets/image/icon.png'
    end
end
