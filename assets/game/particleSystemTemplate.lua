local p={}
p.star=love.graphics.newParticleSystem(GC.load{7,7,
    {'setLW',1},
    {'line',0,3.5,6.5,3.5},
    {'line',3.5,0,3.5,6.5},
    {'fRect',2,2,3,3},
},2600)
p.star:setSizes(.26,1,.8,.6,.4,.2,0)
p.star:setSpread(MATH.tau)
p.star:setSpeed(0,20)

local width=80
local height=240
local fadeLength=40
p.trail=love.graphics.newParticleSystem((function()
    local L={width,height}
    for i=1,width/2 do
        table.insert(L,{'setCL',1,1,1,i/(width/2)})
        table.insert(L,{'fRect',i,0,1,height})
        table.insert(L,{'fRect',width-i,0,1,height})
    end
    table.insert(L,{'setBM','multiply','premultiplied'})
    table.insert(L,{'setCM',false,false,false,true})
    for i=0,height-1 do
        if i<height-fadeLength then
            table.insert(L,{'setCL',0,0,0,i/(height-fadeLength)})
        else
            table.insert(L,{'setCL',0,0,0,(height-i)/fadeLength})
        end
        table.insert(L,{'fRect',0,i,width,1})
    end
    return GC.load(L)
end)(),12)
p.trail:setOffset(width/2,height)
p.trail:setParticleLifetime(.32)
p.trail:setColors(
    1,1,1,0.0,
    1,1,1,1.0,
    1,1,1,0.8,
    1,1,1,0.6,
    1,1,1,0.4,
    1,1,1,0.2,
    1,1,1,0.0
)
return p
