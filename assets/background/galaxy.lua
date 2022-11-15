-- More realistic space background
local ins,rem=table.insert,table.remove
local rnd=math.random
local circle=GC.circle
local stars={}
local camX,camY=0,0

local back={}

function back.init()
    for _=1,620 do
        ins(stars,{
            x=rnd()*2-1,y=rnd()*2-1,z=.26+rnd(),
            r=1+1.5*rnd(),
        })
    end
end
function back.update()
    camX=.026*math.sin(love.timer.getTime()*.12)
    camY=.012*math.sin(love.timer.getTime()*.26)
end
function back.draw()
    GC.clear(.06,.06,.06)
    local w,h=SCR.w,SCR.h
    GC.translate(w/2,h/2)
    GC.setColor(1,1,1)
    for i=1,620 do
        local s=stars[i]
        local x=(s.x-camX)*1/(1+s.z)
        local y=(s.y-camY)*1/(1+s.z)
        local r=s.r*1/(1+s.z)
        circle('fill',x*w,y*h,r)
    end
end
function back.discard()
    stars={}
end
return back
