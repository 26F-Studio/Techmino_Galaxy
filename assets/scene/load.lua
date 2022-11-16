local t
local scene={}

function scene.enter()
    t=0
    Zenitha.setDrawCursor(NULL)
    if PROGRESS.getMain()>=3 then PROGRESS.applyCoolWaitTemplate() end
end

function scene.update(dt)
    if TASK.getLock('drawBegin') then
        t=t+math.min(dt,.026)
        if t>=1 then
            PROGRESS.setCursor(PROGRESS.getMain()<=2 and 'interior' or 'exterior')
            PROGRESS.swapMainScene()
        end
    end
end

function scene.draw()
    TASK.lock('drawBegin')
    if PROGRESS.getMain()<=2 then
        GC.clear(0,0,0)
        if t<1 and t%.26>.13 then
            FONT.set(50)
            GC.print('_',40,20)
        end
    elseif PROGRESS.getMain()<=4 then
        GC.replaceTransform(SCR.xOy_m)
        local x=t<.26 and 0 or math.min((t-.26)/.26,1)
        GC.scale(2,2*(2-x)*x)
        GC.shear(-.26,0)
        FONT.set(100)
        GC.mStr('Welcome',0,-70)
    end
end

return scene
