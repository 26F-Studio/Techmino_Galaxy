-- Welcome scene with animation

local t
---@type Zenitha.Scene
local scene={}

function scene.load()
    t=0
    ZENITHA.globalEvent.clickFX=NULL
    ZENITHA.globalEvent.drawCursor=NULL
    if PROGRESS.get('main')>=3 then
        PROGRESS.applyCoolWaitTemplate()
        if PROGRESS.get('main')>=4 then
            TASK.new(function()
                repeat
                    coroutine.yield()
                until FMOD.studio
                PlayBGM('singularity')
            end)
        end
    end
end

function scene.update(dt)
    if TASK.getLock('drawBegin') and t<1 then
        t=math.min(t+math.min(dt,.026),1)
        if t==1 then
            PROGRESS.swapMainScene()
        end
    end
end

function scene.draw()
    TASK.lock('drawBegin')
    if PROGRESS.get('main')<=2 then
        GC.clear(0,0,0)
        if t<.42 then
            if t%.26<.13 then
                FONT.set(40)
                GC.print("_",40,20)
            end
        else
            GC.setColor(.62,.62,.62)
            FONT.set(25,'codepixel')
            GC.print("Initiating Boot Protocol...",40,40)
        end
    elseif PROGRESS.get('main')<=4 then
        GC.replaceTransform(SCR.xOy_m)
        GC.scale(1.6,1)
        GC.setLineWidth(19.5)
        for i=0,32 do
            GC.setColor(1,1,1,math.min(t/.26,1)*(62-i)/62*.026)
            GC.circle('line',0,0,i*20,62)
        end
        GC.setColor(1,1,1,math.min(t/.26,1)*.026)
        GC.circle('fill',0,0,10)

        local x=t<.26 and 0 or math.min((t-.26)/.26,1)
        GC.scale(1.25,2*(2-x)*x)
        GC.shear(-.26,0)
        FONT.set(100)
        GC.setColor(1,1,1)
        GC.mStr("Welcome",0,-70)

        GC.replaceTransform(SCR.xOy_dr)
        GC.setColor(1,1,1,math.min(-t*(t-2.6),.626))
        GC.draw(TEX.logo_fmod,-15,-20,nil,.26,nil,TEX.logo_fmod:getWidth(),TEX.logo_fmod:getHeight())
    end
end

return scene
