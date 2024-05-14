local gc=love.graphics

--[[
    I/II:
        Sum>=100 → II
        Single>=200 or Sum>=350 → III
]]
local prgs=setmetatable({
    launchCount=0,
    main=1,
    tutorial='000000',
    interiorScore={
        dig=0,
        sprint=0,
        marathon=0,
    },
    bgmUnlocked={},
    brik_stdMap={
        unlocked=true,
        modeUnlocked={
            -- 0 = unlocked, 1~5 = rank got
            sprint_40=0,
            marathon=0,
            dig_practice=0,
        },
    },
    gela_wip=false,
    acry_wip=false,
},{
    __index=function(_,k)
        LOG("Attempt to read undefined progress data: "..tostring(k))
    end,
})

local function sysInfoFunc()
    if not SETTINGS.system.powerInfo then return end
    gc.replaceTransform(SCR.xOy_ur)
    gc.translate(-130,0)

    -- Box
    gc.setColor(0,0,0,.42)
    gc.polygon('fill',0,0,130,0,130,50,25,50,0,35)

    -- Time
    gc.setColor(1,1,1)
    FONT.set(25,'number')
    gc.printf(os.date("%I:%M %p"),0,-3,125,'right')

    gc.translate(90,28)

    -- Battery
    gc.setLineWidth(1)
    gc.rectangle('fill',33,4,3,10)
    gc.rectangle('line',-1,-1,34,20)
    local state,pow=love.system.getPowerInfo()
    if state=='unknown' then
        FONT.set(20,'number')
        gc.print("?",16,9,love.timer.getTime()*2.6,nil,nil,5,11)
    elseif state=='nobattery' then
        FONT.set(15,'number')
        gc.print("x x",6,-3)
        gc.print("_",13,-1)
    elseif pow then
        FONT.set(20,'number')
        gc.printf(pow.."%",-64,-4,60,'right')

        gc.setColor(
            pow>60 and COLOR.L or
            pow>26 and COLOR.lY or
            COLOR.R
        )
        -- Inside-area: 30*16, (1,1)~(31,17)
        local x=10
        local r=7*math.floor(pow%x/2)*2/x
        gc.rectangle('fill',1,1,30*math.floor(pow/x)*x/100,16)
        gc.rectangle('fill',1+30*math.floor(pow/x)*x/100,8-r,30/100*x,2*r)
        if state=='charging' then
            gc.setColor(COLOR.lG)
            for i=1,math.ceil(pow/x) do
                local a=6.2*math.sin(-love.timer.getTime()*5+i*.626)
                GC.mRect('fill',3*i-.5,9+a,3,3)
                GC.mRect('fill',3*i-.5,9-a,3,3)
            end
        end
    end
end

local PROGRESS={}

local function zDump(t)
    local list={}
    for k,v in next,t do
        if k~='hash' then
            if type(v)=='number' or type(v)=='string' or type(v)=='boolean' then
                table.insert(list,k..tostring(v))
            elseif type(v)=='table' then
                table.insert(list,k..zDump(v))
            end
        end
    end
    table.sort(list)
    return table.concat(list)
end
function PROGRESS.getHash(t)
    return love.data.encode('string','base64',STRING.digezt(zDump(t)))
end
function PROGRESS.save()
    prgs.rnd=math.random(26,2e6)
    prgs.hash=PROGRESS.getHash(prgs)
    FILE.save(prgs,'conf/progress','-json')
end
function PROGRESS.load()
    local success,res=pcall(FILE.load,'conf/progress','-json -canskip')
    if success then
        if res then
            TABLE.update(prgs,res)
            -- if res.hash==PROGRESS.getHash(res) then
            --     TABLE.update(prgs,res)
            -- else
            --     MSG.new('info',"Hash not match")
            -- end
        end
        prgs.launchCount=prgs.launchCount+1
    else
        MSG.new('info',"Load progress failed: "..res)
    end
end
function PROGRESS.fix()
    if prgs.brik_stdMap.modeUnlocked.survivor_b2b then
        prgs.brik_stdMap.modeUnlocked.survivor_power,prgs.brik_stdMap.modeUnlocked.survivor_b2b=prgs.brik_stdMap.modeUnlocked.survivor_b2b,nil
    end
end

function PROGRESS.swapMainScene()
    if prgs.main<=2 then
        SCN.swapTo('main_in','none')
    elseif prgs.main<=4 then
        SCN.swapTo('main_out')
    else
        -- TODO: phase 5+
    end
end
function PROGRESS.applyCoolWaitTemplate()
    local list={}
    for i=1,52 do list[i]=('assets/image/loading/%d.png'):format(i) end
    local success,z=pcall(gc.newArrayImage,list)
    if success then
        WAIT.setDefaultDraw(function(a,t)
            GC.setBlendMode('add','alphamultiply')
            GC.setColor(1,1,1,a)
            GC.applyTransform(SCR.xOy_dr)
            GC.mDrawL(z,
                math.min(math.floor(t*60)%62,52)%52+1, -- floor(t*60)%62 → 0~61; min(ans) → 0~52~52; ans%52+1 → 1~52,1~1
                -160,-150,nil,1.5*(1-(1-a)^2.6)
            )
            GC.setBlendMode('alpha')
        end)
    end
end
function PROGRESS.setInteriorBG() BG.set('none') end
function PROGRESS.setExteriorBG() BG.set(prgs.main==3 and 'space' or 'galaxy') end
function PROGRESS.playInteriorBGM() playBgm('blank',prgs.main~=1) end
function PROGRESS.playExteriorBGM() playBgm('vacuum',prgs.main~=3) end
function PROGRESS.setEnv(env)
    if env=='interior' then
        PROGRESS.setInteriorBG()
        PROGRESS.playInteriorBGM()
        ZENITHA.setClickFX(true)
        function ZENITHA.globalEvent.drawCursor(_,x,y)
            if not SETTINGS.system.sysCursor then
                gc.setColor(1,1,1)
                gc.setLineWidth(2)
                gc.translate(x,y)
                if love.mouse.isDown(1) then GC.mRect('fill',0,0,10,10) end
                if love.mouse.isDown(2) then GC.mRect('line',0,0,16,16) end
                gc.setColor(1,1,1,.626)
                gc.setLineWidth(4)
                gc.line(0,-15,0,15)
                gc.line(-15,0,15,0)
            end
        end
    elseif env=='exterior' then
        PROGRESS.setExteriorBG()
        PROGRESS.playExteriorBGM()
        ZENITHA.setClickFX(function(x,y) SYSFX.new('glow',2,x,y,20) end)
        function ZENITHA.globalEvent.drawCursor(_,x,y)
            if not SETTINGS.system.sysCursor then
                gc.setColor(1,1,1)
                gc.setLineWidth(2)
                gc.translate(x,y)
                gc.rotate(love.timer.getTime()%MATH.tau)
                GC.mRect('line',0,0,20,20)
                if love.mouse.isDown(1) then GC.mRect('fill',0,0,8,8) end
                if love.mouse.isDown(2) then GC.mRect('line',0,0,12,12) end
                if love.mouse.isDown(3) then gc.line(-8,-8,8,8) gc.line(-8,8,8,-8) end
                gc.setColor(1,1,1,.626)
                gc.line(0,-20,0,20)
                gc.line(-20,0,20,0)
            end
        end
        ZENITHA.globalEvent.drawSysInfo=sysInfoFunc
    else
        error("?")
    end
end
function PROGRESS.transcendTo(n)
    MSG.clear()
    if n==2 then
        WAIT{
            coverAlpha=0,
            noDefaultDraw=true,
            init=stopBgm,
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
        PROGRESS.setBgmUnlocked('blank',2) -- Or it can be skiped if sub 60 in 40L at first play
        local sumT=0
        WAIT{
            coverAlpha=0,
            noDefaultDraw=true,
            init=function()
                ZENITHA.globalEvent.drawCursor=NULL
            end,
            update=function(dt,t)
                if t<1.626 then
                    sumT=sumT+dt
                    if sumT>=.1 then
                        FMOD.music.seek(FMOD.music.tell()-.1)
                        sumT=sumT-.1
                    end
                elseif t<2 and getBgm() then
                    stopBgm(true)
                end
                if WAIT.state=='wait' and t>=2.6 then
                    PROGRESS.setMain(3)
                    SCN.swapTo('main_out','none')
                    PROGRESS.applyCoolWaitTemplate()
                    WAIT.interrupt()
                    TASK.new(function()
                        MSG.new('warn',Text.interior_crash,10)
                        DEBUG.yieldT(3)
                        MSG.new('info',Text.booting_changed,7)
                    end)
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
        stopBgm()
        local t=1
        WAIT.setDefaultDraw(NULL)
        WAIT{
            coverAlpha=0,
            update=function(dt)
                t=t-dt
                if t<=0 then
                    love.event.quit()
                end
            end,
            draw=function()
                GC.replaceTransform(SCR.origin)
                GC.setColor(.1,.1,.1,(1-t)/.26)
                GC.rectangle('fill',0,0,SCR.w,SCR.h)

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
                GC.setColor(1,1,1,(1-t)/.26)
                GC.mStr('Bye',0,-70)
            end,
        }
    else
        -- TODO: phase 5+
    end
end
function PROGRESS.drawExteriorHeader(h)
    GC.replaceTransform(SCR.origin)
    GC.setColor(.26,.26,.26)
    local y=(h or 120)*SCR.k
    GC.rectangle('fill',0,0,SCR.w,y)
    GC.setColor(1,1,1)
    GC.rectangle('fill',0,y,SCR.w,1)
end

-- Get
function PROGRESS.get(k) return prgs[k] end
function PROGRESS.getBgmUnlocked(name) return prgs.bgmUnlocked[name] end
function PROGRESS.getTutorialPassed(n)
    if n then
        return prgs.tutorial:sub(n,n)=='1'
    else
        return prgs.tutorial=='111111'
    end
end
function PROGRESS.getInteriorScore(mode) return prgs.interiorScore[mode] end
function PROGRESS.getTotalInteriorScore() return prgs.interiorScore.dig+prgs.interiorScore.sprint+prgs.interiorScore.marathon end
function PROGRESS.getModeUnlocked(mode) return prgs[mode] and prgs[mode].unlocked end
function PROGRESS.getModeState(style,mode) return prgs[style] and (mode and prgs[style].modeUnlocked[mode] or prgs[style].modeUnlocked) end

-- Set
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
    local newState=math.max(prgs.bgmUnlocked[name] or 0,state)
    if newState>(prgs.bgmUnlocked[name] or 0) then
        prgs.bgmUnlocked[name]=newState
        PROGRESS.save()
    end
end
function PROGRESS.setTutorialPassed(n)
    if prgs.tutorial:sub(n,n)=='0' then
        prgs.tutorial=prgs.tutorial:sub(1,n-1)..'1'..prgs.tutorial:sub(n+1)
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
function PROGRESS.setModeUnlocked(style,bool)
    if not prgs[style] then return end
    prgs[style].unlocked=bool
    PROGRESS.save()
end
function PROGRESS.setModeState(style,name,state,force)
    if not prgs[style] then return end
    if not state then state=0 end
    local orgState=prgs[style].modeUnlocked[name] or -1
    if state>orgState or force then
        prgs[style].modeUnlocked[name]=state
        PROGRESS.save()
        if state==0 and state>orgState then
            if TASK.lock('brikmap_unlockSound_background',2.6) then
                FMOD.effect('map_unlock_background')
                MSG.new('check',Text.new_level_unlocked,2.6)
            end
        end
    end
end

return PROGRESS
