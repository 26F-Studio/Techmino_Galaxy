function love.conf(t)
    local identity='Techmino_Galaxy'
    local mobile=love._os=='Android' or love._os=='iOS'
    local msaa=4
    local portrait=false

    local fs=love.filesystem
    fs.setIdentity(identity)
    do -- Load grapgic settings from conf/settings
        local fileData=fs.read('conf/settings')
        if fileData then
            msaa=tonumber(fileData:match('"msaa":(%d+)')) or 0
            portrait=mobile and fileData:find('"portrait":true') and true
        end
    end

    t.identity='Techmino_Galaxy'-- Saving folder
    t.version="11.4"
    t.gammacorrect=false
    t.appendidentity=true-- Search files in source then in save directory
    t.accelerometerjoystick=false-- Accelerometer=joystick on ios/android
    if t.audio then
        t.audio.mic=false
        t.audio.mixwithsystem=true
    end

    local W=t.window
    W.title=require"version".appName.."  "..require"version".appVer
    if portrait then
        W.width,W.height=900,1440
        W.minwidth,W.minheight=180,288
    else
        W.width,W.height=1440,900
        W.minwidth,W.minheight=288,180
    end
    W.vsync=0-- Unlimited FPS
    W.msaa=msaa-- Multi-sampled antialiasing
    W.depth=0-- Bits/samp of depth buffer
    W.stencil=true-- Bits/samp of stencil buffer
    W.display=1-- Monitor ID
    W.highdpi=true-- High-dpi mode for the window on a Retina display
    W.x,W.y=nil

    if fs.getInfo('assets/image/icon.png') then
        W.icon='assets/image/icon.png'
    end

    if mobile then
        W.borderless=true
        W.resizable=false
        W.fullscreen=true
    else
        W.borderless=false
        W.resizable=true
        W.fullscreen=false
    end

    local M=t.modules
    M.window,M.system,M.event,M.thread=true,true,true,true
    M.timer,M.math,M.data=true,true,true
    M.video,M.audio,M.sound=true,true,true
    M.graphics,M.font,M.image=true,true,true
    M.mouse,M.touch,M.keyboard,M.joystick=true,true,true,true
    M.physics=false
end
