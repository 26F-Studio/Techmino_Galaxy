local prgs={
    main=1,
    tutorial=1,
}

local PROGRESS={}

function PROGRESS.getHash(t)
    local list={}
    for k,v in next,t do table.insert(list,k..v) end
    table.sort(list)
    return STRING.digezt(table.concat(list))
end
function PROGRESS.save()
    prgs.rnd=math.random(26,2e6)
    prgs.hash=PROGRESS.getHash(prgs)
    FILE.save(prgs,'conf/progress','-json')
end
function PROGRESS.load()
    local t=FILE.load('conf/progress','-json -canskip')
    if t then
        local hash=t.hash
        t.hash=nil
        if hash==PROGRESS.getHash(t) then
            TABLE.cover(t,prgs)
        else
            MES.new('info',"Hash not match")
        end
    end
end

function PROGRESS.getTutorialPage()
    return prgs.tutorial
end
function PROGRESS.playBgm_main_12()
    playBgm('blank',prgs.main==1 and 'simp' or 'full')
end
function PROGRESS.playBgm_tutorial_12()
    playBgm('space',prgs.main==1 and 'simp' or 'full')
end
function PROGRESS.setCoolWaitTemplate()
    local list={}
    for i=1,52 do list[i]=('assets/image/loading/%d.png'):format(i) end
    local z=love.graphics.newArrayImage(list)
    WAIT.setDefaultDraw(function(a,t)
        GC.setBlendMode('add','alphamultiply')
        GC.setColor(1,1,1,a)
        GC.applyTransform(SCR.xOy_dr)
        GC.mDrawL(z,
            math.min(math.floor(t*60)%62,52)%52+1,-- floor(t*60)%62 → 0~61; min(ans) → 0~52~52; ans%52+1 → 1~52,1~1
            -160,-150,nil,1.5*(1-(1-a)^2.6)
        )
        GC.setBlendMode('alpha')
    end)
end

return PROGRESS
