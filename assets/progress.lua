local prgs={
    main=1,
    tutorial='000000',
    bgmUnlocked={},
}

local PROGRESS={data=prgs}

function PROGRESS.getHash(t)
    local list={}
    for k,v in next,t do
        if k~='hash' then
            if type(v)=='number' or type(v)=='string' or type(v)=='boolean' then
                table.insert(list,k..v)
            elseif type(v)=='table' then
                table.insert(list,k)
            end
        end
    end
    table.sort(list)
    return love.data.encode('string','base64',STRING.digezt(table.concat(list)))
end
function PROGRESS.save()
    prgs.rnd=math.random(26,2e6)
    prgs.hash=PROGRESS.getHash(prgs)
    FILE.save(prgs,'conf/progress','-json')
end
function PROGRESS.load()
    local t=FILE.load('conf/progress','-json -canskip')
    if t then
        if t.hash==PROGRESS.getHash(t) then
            TABLE.coverR(t,prgs)
        else
            MES.new('info',"Hash not match")
        end
    end
end

function PROGRESS.swapMainScene()
    if prgs.main<=2 then
        SCN.swapTo('main_12')
    elseif prgs.main==3 then
        SCN.swapTo('main_3')
    else
        -- TODO
    end
end
function PROGRESS.playBGM_main_12()
    playBgm('blank',prgs.main==1 and 'simp' or 'full')
end
function PROGRESS.playBGM_main_3()
    playBgm('nil',1 and 'simp' or 'full')
end
function PROGRESS.tutorialPassed(n)
    if prgs.tutorial:sub(n,n)=='0' then
        prgs.tutorial=prgs.tutorial:sub(1,n-1)..'1'..prgs.tutorial:sub(n+1)
        if prgs.tutorial=='111111' then
            PROGRESS.setMain(3)
        elseif prgs.tutorial:sub(1,3)=='111' then
            PROGRESS.setMain(2)
        end
        PROGRESS.save()
    end
end
function PROGRESS.setMain(n)
    if n>prgs.main then
        while prgs.main<n do
            prgs.main=prgs.main+1
            if prgs.main==2 then
                prgs.tutorial='111'..prgs.tutorial:sub(4)
            elseif prgs.main==3 then
                prgs.tutorial='111111'
            end
        end
        PROGRESS.save()
    end
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

function PROGRESS.unlockBGM(name,state)
    local l=math.max(prgs.bgmUnlocked[name] or 0,state)
    if l>(prgs.bgmUnlocked[name] or 0) then
        prgs.bgmUnlocked[name]=l
        PROGRESS.save()
    end
end

return PROGRESS
