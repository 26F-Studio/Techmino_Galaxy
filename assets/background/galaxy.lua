-- More realistic space background
local ins=table.insert
local rnd=math.random
local circle=GC.circle
local stars={}

local t=0
local camX,camY,camZ=0,0,0

local back={}

function back.init()
    for _=1,620 do
        ins(stars,{
            x=rnd()*2-1,y=rnd()*2-1,z=.26+rnd(),
            r=1+1.5*rnd(),
        })
    end
end
function back.update(dt)
    t=t+dt
    camX=.026*math.sin(t*.12)
    camY=.012*math.sin(t*.26)
end
function back.draw()
    GC.clear(.06,.06,.06)
    local w,h=SCR.w,SCR.h
    GC.translate(w/2,h/2)
    GC.setColor(1,1,1)
    for i=1,620 do
        local s=stars[i]
        local x=(s.x-camX)/(1+s.z)
        local y=(s.y-camY)/(1+s.z)
        local r=s.r/(1+s.z-camZ)
        circle('fill',x*w,y*h,r)
    end
end
function back.discard()
    stars={}
end
return back
