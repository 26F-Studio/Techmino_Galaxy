--- @class Techmino.particleSystems
--- @field star love.ParticleSystem
--- @field line love.ParticleSystem
--- @field sparkle love.ParticleSystem
--- @field cornerCheck love.ParticleSystem
--- @field rotateFail love.ParticleSystem
--- @field trail love.ParticleSystem
--- @field minoMapBack love.ParticleSystem
local p={}

do-- Moving trail & Frenzy
    p.star=love.graphics.newParticleSystem(GC.load{7,7,
        {'setLW',1},
        {'line',0,3.5,6.5,3.5},
        {'line',3.5,0,3.5,6.5},
        {'fRect',2,2,3,3},
    },2600)
    p.star:setSizes(.26,1,.8,.6,.4,.2,0)
    p.star:setSpread(MATH.tau)
    p.star:setSpeed(0,20)
end

do-- Moving trail & Frenzy
    p.line=love.graphics.newParticleSystem(GC.load{10,3,
        {'clear',1,1,1,1},
    },2600)
    p.line:setSizes(.6,1,.5,.2,0)
    p.line:setRelativeRotation(true)
end

do-- Touching spark
    p.sparkle=love.graphics.newParticleSystem(GC.load{4,4,
        {'clear',1,1,1,1},
    },260)
    p.sparkle:setSizes(.6,.9,1,1)
    p.sparkle:setColors(1,1,1,1,1,1,1,0)
    p.sparkle:setDirection(math.pi/2)
    p.sparkle:setSpread(0)
    p.sparkle:setSpeed(40,100)
    p.sparkle:setLinearDamping(6,12)
    p.sparkle:setParticleLifetime(.42)
end

do-- Rotating corner check
    p.cornerCheck=love.graphics.newParticleSystem(GC.load{1,1,
        {'clear',1,1,1,1},
    },26)
    p.cornerCheck:setSizes(26)
    p.cornerCheck:setColors(1,1,1,.26,1,1,1,0)
    p.cornerCheck:setRotation(0)
    p.cornerCheck:setSpeed(0)
    p.cornerCheck:setParticleLifetime(.126)
end

do-- Rotating failed
    p.rotateFail=love.graphics.newParticleSystem(GC.load{1,1,
        {'clear',1,0,0},
    },26)
    p.rotateFail:setSizes(60,50,25,0)
    p.rotateFail:setColors(1,1,1,1,1,1,1,0)
    p.rotateFail:setRotation(-.26,.26)
    p.rotateFail:setSpin(-2.6,2.6)
    p.rotateFail:setParticleLifetime(.26)
end

do-- Harddrop light
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
end

do-- Background light of mino map
    p.minoMapBack=love.graphics.newParticleSystem(GC.load{10,10,
        {'setCL',1,1,1,.5},
        {'fRect',0,0,10,10},
        {'fRect',1,1,8,8},
        {'fRect',2,2,6,6},
    },260)
    p.minoMapBack:setSizes(26)
    p.minoMapBack:setColors(1,1,1,0,1,1,1,.062,1,1,1,.162,1,1,1,.26,1,1,1,0)
    p.minoMapBack:setRotation(0,MATH.tau)
    p.minoMapBack:setSpin(-.26,.26)
    p.minoMapBack:setSpread(2.6)
    p.minoMapBack:setParticleLifetime(5.62,7.26)
    p.minoMapBack:setSpeed(620,1260)
    p.minoMapBack:setEmissionRate(10)
end

return p
