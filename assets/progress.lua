local prgs={
    main=1,
    tutorial='000000',
    interiorScore={
        dig=0,
        sprint=0,
        marathon=0,
    },
    bgmUnlocked={},
}

--[[
    I/II:
        Sum>=100 → II
        Single>=200 or Sum>=300 → III
]]

local PROGRESS={}

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
        SCN.swapTo('main_in','fastFade')
    elseif prgs.main<=4 then
        SCN.swapTo('main_out')
    else
        -- TODO
    end
end
function PROGRESS.playBGM_main_in()
    playBgm('blank',prgs.main==1 and 'simp' or 'full')
end
function PROGRESS.setBG_main_out()
    BG.set(prgs.main==3 and 'space' or 'galaxy')
end
function PROGRESS.playBGM_main_out()
    playBgm('nil',prgs.main==3 and 'simp' or 'full')
end
function PROGRESS.applyCoolWaitTemplate()
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
function PROGRESS.setCursor(state)
    local gc=love.graphics
    if state=='interior' then
        Zenitha.setDrawCursor(function(_,x,y)
            if not SETTINGS.system.sysCursor then
                gc.setColor(1,1,1)
                gc.setLineWidth(2)
                gc.translate(x,y)
                gc.rotate(love.timer.getTime()%MATH.tau)
                gc.rectangle('line',-10,-10,20,20)
                if love.mouse.isDown(1) then gc.rectangle('line',-6,-6,12,12) end
                if love.mouse.isDown(2) then gc.rectangle('fill',-4,-4,8,8) end
                if love.mouse.isDown(3) then gc.line(-8,-8,8,8) gc.line(-8,8,8,-8) end
                gc.setColor(1,1,1,.626)
                gc.line(0,-20,0,20)
                gc.line(-20,0,20,0)
            end
        end)
    elseif state=='exterior' then
        Zenitha.setDrawCursor(function(_,x,y)
            if not SETTINGS.system.sysCursor then
                gc.setColor(1,1,1)
                gc.setLineWidth(2)
                gc.translate(x,y)
                gc.rotate(love.timer.getTime()%MATH.tau)
                gc.rectangle('line',-10,-10,20,20)
                if love.mouse.isDown(1) then gc.rectangle('line',-6,-6,12,12) end
                if love.mouse.isDown(2) then gc.rectangle('fill',-4,-4,8,8) end
                if love.mouse.isDown(3) then gc.line(-8,-8,8,8) gc.line(-8,8,8,-8) end
                gc.setColor(1,1,1,.626)
                gc.line(0,-20,0,20)
                gc.line(-20,0,20,0)
            end
        end)
    else
        error("?")
    end
end
function PROGRESS.transendTo(n)
    if n==2 then
        WAIT{
            coverAlpha=0,
            noDefaultDraw=true,
            init=function()
                BGM.stop()
            end,
            update=function(_,t)
                if WAIT.state=='wait' and t>=2.6 then
                    PROGRESS.setMain(2)
                    SCN.scenes['main_in'].enter()
                    WAIT.interrupt()
                end
            end,
            draw=function(_,t)
                GC.replaceTransform(SCR.origin)
                if t<2 then
                    GC.setColor(.9,.9,.9,.626*math.min(t/.626,1))
                else
                    GC.setColor(.826,.826,.826)
                end
                GC.rectangle('fill',0,0,SCR.w,SCR.h)
            end,
        }
    elseif n==3 then
        local sumT=0
        WAIT{
            coverAlpha=0,
            noDefaultDraw=true,
            init=function()
                Zenitha.setDrawCursor(NULL)
                SETTINGS.system.sysCursor=false
            end,
            update=function(dt,t)
                if t<1.626 then
                    sumT=sumT+dt
                    if sumT>=.1 then
                        BGM.set('all','seek',BGM.tell()-.1)
                        sumT=sumT-.1
                    end
                elseif t<2 and BGM.isPlaying() then
                    BGM.stop(0)
                end
                if WAIT.state=='wait' and t>=2.6 then
                    PROGRESS.setMain(3)
                    PROGRESS.setCursor('exterior')
                    SETTINGS.system.sysCursor=true
                    SCN.swapTo('main_out','none')
                    PROGRESS.applyCoolWaitTemplate()
                    WAIT.interrupt()
                    MES.new('error',Text.interior_crash,10)
                end
            end,
            draw=function(_,t)
                GC.replaceTransform(SCR.origin)
                if t<.626 then
                    GC.setColor(.9,.9,.9,.626*math.min(t/.626,1))
                elseif t<2 then
                    GC.setColor(.3,.42,.926)
                else
                    GC.setColor(0,0,0)
                end
                GC.rectangle('fill',0,0,SCR.w,SCR.h)
            end,
        }
    else
        error("?")
    end
end
function PROGRESS.quit()
    if prgs.main<=2 then
        local t=0
        WAIT.setDefaultDraw(NULL)
        WAIT{
            coverAlpha=0,
            update=function(dt)
                t=t+dt
                if t>.626 then
                    love.event.quit()
                end
            end,
            draw=function()
                GC.replaceTransform(SCR.origin)
                GC.setColor(.1,.1,.1,.626)
                GC.rectangle('fill',0,0,SCR.w,SCR.h)
            end,
        }
    elseif prgs.main<=4 then
        Zenitha._quit('slowFade')
    else
        -- TODO
    end
end

function PROGRESS.getMain()
    return prgs.main
end
function PROGRESS.getBgmUnlocked(name)
    return prgs.bgmUnlocked[name]
end
function PROGRESS.getTutorialPassed(n)
    return prgs.tutorial:sub(n,n)=='1'
end
function PROGRESS.getInteriorScore(mode)
    return prgs.interiorScore[mode]
end
function PROGRESS.getMaxInteriorScore()
    return math.max(prgs.interiorScore.dig,prgs.interiorScore.sprint,prgs.interiorScore.marathon)
end
function PROGRESS.getTotalInteriorScore()
    return prgs.interiorScore.dig+prgs.interiorScore.sprint+prgs.interiorScore.marathon
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
function PROGRESS.setBgmUnlocked(name,state)
    local l=math.max(prgs.bgmUnlocked[name] or 0,state)
    if l>(prgs.bgmUnlocked[name] or 0) then
        prgs.bgmUnlocked[name]=l
        PROGRESS.save()
    end
end
function PROGRESS.setTutorialPassed(n)
    if prgs.tutorial:sub(n,n)=='0' then
        prgs.tutorial=prgs.tutorial:sub(1,n-1)..'1'..prgs.tutorial:sub(n+1)
        if prgs.tutorial=='111111' then
            PROGRESS.setMain(2)
        end
        PROGRESS.save()
    end
end
function PROGRESS.setInteriorScore(mode,score)
    score=MATH.clamp(math.floor(score),0,200)
    if score>prgs.interiorScore[mode] then
        prgs.interiorScore[mode]=score
        PROGRESS.save()
    end
end

return PROGRESS
