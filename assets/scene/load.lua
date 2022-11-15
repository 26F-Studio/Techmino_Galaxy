local t

local scene={}

function scene.enter()
    t=0
end

function scene.update(dt)
    t=t+dt
    if t>=1 then
        PROGRESS.swapMainScene()
    end
end

function scene.draw()
    GC.clear(0,0,0)
    if t<1 and t%.26>.13 then
        FONT.set(50)
        GC.print('_',40,20)
    end
end

return scene
