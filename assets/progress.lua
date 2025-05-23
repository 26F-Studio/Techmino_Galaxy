local gc=love.graphics

--[[
    I/II:
        Sum>=150 → II
        Single>=200 or Sum>=350 → III
]]
local prgs=setmetatable({
    launchCount=0,
    main=1,
    interiorScore={
        dig=0,
        sprint=0,
        marathon=0,
        tutorial='1000', -- 0:Not Unlocked  1: Not Finished,  2: Passed,  3: Perfect Passed (unlock B side)
        tuto5_score=0,
        tuto5_time=2600e3,
        tuto6_score=0,
        tuto6_time=2600e3,
        tuto7_score=0,
        tuto7_time=2600e3,
        tuto8_keys=260,
    },
    styles={
        brik=true,
        gela=false,
        acry=false,
    },
    exteriorMap={
        sprint={},
        marathon={},
        dig={},
    },
    bgmUnlocked={},
    secretFound={},

    -- Utility
    musicTime=0,
},{
    __index=function(_,k)
        LOG('warn',"Attempt to read undefined progress data: "..tostring(k))
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
local function getHash(t)
    return love.data.encode('string','base64',STRING.digezt(zDump(t)))
end

local PROGRESS={}

--------------------------------------------------------------
-- Save & Load

---@async
---@param step nil | 'yield' | 'save'
function PROGRESS.save(step)
    if step==nil then
        -- Wait 1 frame before saving
        TASK.removeTask_code(PROGRESS.save)
        TASK.new(PROGRESS.save,'yield')
    elseif step=='yield' then
        -- Do wait
        coroutine.yield()
        PROGRESS.save('save')
    elseif step=='save' then
        prgs.rnd=math.random(26,2e6)
        prgs.hash=getHash(prgs)
        FILE.save(prgs,'conf/progress','-json')
        ShowSaveIcon(CHAR.icon.save)
    end
end
function PROGRESS.load()
    local suc,res=pcall(FILE.load,'conf/progress','-json')
    if not suc then return MSG.log('info',"Load progress failed: "..tostring(res)) end
    if res then
        TABLE.update(prgs,res)
        -- if res.hash==getHash(res) then
        --     TABLE.update(prgs,res)
        -- else
        --     MSG('info',"Hash not match")
        -- end
    end
    prgs.launchCount=prgs.launchCount+1
end
function PROGRESS.fix()
    if type(prgs.interiorScore.tutorial)=='table' then
        prgs.interiorScore.tutorial='1000'
        prgs.interiorScore.tuto5_score,prgs.interiorScore.tuto5_time=0,2600e3
        prgs.interiorScore.tuto6_score,prgs.interiorScore.tuto6_time=0,2600e3
        prgs.interiorScore.tuto7_score,prgs.interiorScore.tuto7_time=0,2600e3
        prgs.interiorScore.tuto8_keys=260
    end
    for k in next,prgs.interiorScore do
        if k:find("tuto_B") then
            prgs.interiorScore[k]=nil
        end
    end
    prgs.tutorial=nil
    prgs.tuto5_score,prgs.tuto5_time=nil,nil
    prgs.tuto6_score,prgs.tuto6_time=nil,nil
    prgs.tuto7_score,prgs.tuto7_time=nil,nil
    prgs.tuto8_keys=nil
    prgs.brik_stdMap=nil
    prgs.secretFound.exterior_tspin_10TSS=nil
    prgs.secretFound.exterior_tspin_10TST=nil
    prgs.secretFound.dial_password=nil
    prgs.secretFound.exterior_sprint_gunJumping=nil
    if prgs.exteriorMap.tspin then
        prgs.exteriorMap.tspin=nil
        prgs.exteriorMap.spin={}
    end
end

--------------------------------------------------------------
-- Function

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
    if not GC.getTextureTypes().array then return LOG('warn',"System doesn't support ArrayImage") end
    local list={}
    for i=1,52 do list[i]=('assets/image/loading/%d.png'):format(i) end
    local suc,res=pcall(gc.newArrayImage,list)
    if not suc then return LOG('warn',"Failed to create ArrayImage: "..tostring(res)) end
    WAIT.setDefaultDraw(function(a,t)
        GC.setBlendMode('add','alphamultiply')
        GC.setColor(1,1,1,a)
        GC.applyTransform(SCR.xOy_dr)
        GC.mDrawL(res,
            math.min(math.floor(t*60)%62,52)%52+1, -- floor(t*60)%62 → 0~61; min(ans) → 0~52~52; ans%52+1 → 1~52,1~1
            -160,-150,nil,1.5*(1-(1-a)^2.6)
        )
        GC.setBlendMode('alpha')
    end)
end
function PROGRESS.applyInteriorBG() BG.set('none') end
function PROGRESS.applyExteriorBG() BG.set(prgs.main==3 and 'space' or 'galaxy') end

local function fuse()
    repeat TASK.yieldT(6.26) until SCN.cur~='main_in'
    FMOD.effect.keyOff('music_glitch')
    TASK.unlock('musicroom_glitchFX')
end
function PROGRESS.applyInteriorBGM()
    PlayBGM('blank',prgs.main~=1)
    if prgs.main>=3 then
        FMOD.effect('music_glitch')
        TASK.removeTask_code(fuse)
        TASK.new(fuse)
    end
end
function PROGRESS.applyExteriorBGM()
    if prgs.main==3 then
        PlayBGM('vacuum')
    else
        if love.timer.getTime()>3.55 and GetBGM()~='singularity' then
            PlayBGM('singularity')
            FMOD.music.seek(3.9)
        end
    end
end
function PROGRESS.applyEnv(env)
    if env=='interior' then
        PROGRESS.applyInteriorBG()
        PROGRESS.applyInteriorBGM()
        ZENITHA.globalEvent.touchClick=NULL
        function ZENITHA.globalEvent.mouseDown(x,y) SYSFX.rectRipple(.26,x-10,y-10,20,20) end
        ZENITHA.globalEvent.mouseMove=NULL
        ZENITHA.globalEvent.mouseUp=NULL
        function ZENITHA.globalEvent.drawCursor(x,y)
            if not SETTINGS.system.sysCursor then
                gc.setColor(1,1,1)
                gc.setLineWidth(2)
                gc.translate(x,y)
                if IsMouseDown(1) then GC.mRect('fill',0,0,10,10) end
                if IsMouseDown(2) then GC.mRect('line',0,0,16,16) end
                gc.setColor(1,1,1,.626)
                gc.setLineWidth(4)
                gc.line(0,-15,0,15)
                gc.line(-15,0,15,0)
            end
        end
        ZENITHA.globalEvent.sceneSwap=NULL
    elseif env=='exterior' then
        PROGRESS.applyExteriorBG()
        PROGRESS.applyExteriorBGM()
        function ZENITHA.globalEvent.touchClick(x,y) SYSFX.tap(.26,x,y) end

        local R,W=.8,.55 -- Rotation, Width
        local C={0,0,0,0} -- Color
        ---@type number | false, number | false
        local pX,pY=false,false -- dragPoint position
        local dragOn
        local lastT=-1
        local Crv={} -- Curve
        local sin,cos=math.sin,math.cos
        local function updateCursor(w)
            W=w
            Crv[01],Crv[02],Crv[03],Crv[04],
            Crv[05],Crv[06],Crv[07],Crv[08],
            Crv[09],Crv[10],Crv[11],Crv[12],
            Crv[13],Crv[14],Crv[15],Crv[16],
            Crv[17],Crv[18],Crv[19],Crv[20]
            =
            00*cos(0     ),00*sin(0     ),
            02*cos(0-w*2.),02*sin(0-w*2.),
            45*cos(0-w   ),45*sin(0-w   ),
            46*cos(0-w*.9),46*sin(0-w*.9),
            45*cos(0-w*.8),45*sin(0-w*.8),
            30*cos(0     ),30*sin(0     ),
            45*cos(0+w*.8),45*sin(0+w*.8),
            46*cos(0+w*.9),46*sin(0+w*.9),
            45*cos(0+w   ),45*sin(0+w   ),
            02*cos(0+w*2.),02*sin(0+w*2.)
        end
        updateCursor(.55)
        local _wid1,_wid2
        local function cursor_anim(t) updateCursor(MATH.lerp(_wid1,_wid2,t)) end
        local function cursor_anim2(t) C[4]=1-t end
        function ZENITHA.globalEvent.mouseDown(x,y,k)
            C[1],C[2],C[3]=unpack(k==1 and COLOR.lP or k==2 and COLOR.lS or COLOR.lR)
            C[4]=1

            TWEEN.tag_kill('cursor_anim')
            TWEEN.tag_kill('cursor_anim2')
            _wid1,_wid2=W,.4
            TWEEN.new(cursor_anim):setTag('cursor_anim'):setDuration(.0626):run()

            if     k==1 then SYSFX.ripple(.26,x,y,26,.8,.62,1)
            elseif k==2 then SYSFX.ripple(.26,x,y,26,.62,.8,1)
            elseif k==3 then SYSFX.ripple(.26,x,y,26,1,.62,.62)
            else             SYSFX.ripple(.26,x,y,26,9,.9,.9)
            end

            if not pX then
                pX,pY=x,y
            end

            SFX.play('mouse_down')
        end
        function ZENITHA.globalEvent.mouseMove(mx,my)
            if pX then
                local vX,vY=pX-mx,pY-my
                local dist=(vX*vX+vY*vY)^.5
                if dist>100 then
                    pX,pY=mx+vX/dist*100,my+vY/dist*100
                    dragOn=true
                    lastT=love.timer.getTime()
                end
            end
        end
        function ZENITHA.globalEvent.mouseUp(x,y,k)
            if not IsMouseDown(1,2,3) then
                TWEEN.tag_kill('cursor_anim')
                _wid1,_wid2=W,.55
                TWEEN.new(cursor_anim):setTag('cursor_anim'):setDuration(.0626):run()
                TWEEN.new(cursor_anim2):setEase('OutQuad'):setTag('cursor_anim2'):setDuration(.26):run()
                pX,pY,dragOn=false,false,false
            end
            SFX.play('mouse_up')
        end

        local abs,floor,atan2=math.abs,math.floor,math.atan2
        local pi,tau=math.pi,math.pi*2
        function ZENITHA.globalEvent.drawCursor(x,y)
            if not SETTINGS.system.sysCursor then
                -- if pX then
                --     GC.setColor(1,1,1,.62)
                --     GC.circle('fill',pX,pY,10)
                --     GC.setColor(1,1,1)
                --     GC.setLineWidth(1)
                --     GC.circle('line',pX,pY,100)
                -- end
                if not pX or dragOn then
                    local t=love.timer.getTime()
                    if pX then
                        local spd=math.min(((y-pY)^2+(x-pX)^2)/2600,1)*16

                        -- Find closest new R on Riemann surface
                        -- local r=atan2(y-pY,x-pX) -- The new R
                        -- local R_cycle=floor((R+pi)/tau)
                        -- r=r+tau*R_cycle
                        -- local d1,d2,d3=
                        --     abs(r-R),
                        --     abs(r-R-tau),
                        --     abs(r-R+tau)
                        -- local d=(d1<d2 and d1<d3 and 0) or (d2<d3 and -tau) or tau
                        -- r=r+d

                        -- Optimized version
                        local dR=atan2(y-pY,x-pX)+tau*floor((R+pi)/tau)-R
                        local d1,d2,d3=abs(dR),abs(dR-tau),abs(dR+tau)
                        R=MATH.expApproach(R,R+dR+((d1<d2 and d1<d3 and 0) or (d2<d3 and -1) or 1)*tau,(t-lastT)*spd)
                        lastT=t
                    elseif R~=.8 then
                        if abs(R-.8)<.00626 then
                            R=.8
                        else
                            R=MATH.expApproach(R,.8,(t-lastT)*16)
                            lastT=t
                        end
                    end
                end
                GC.translate(x,y)
                GC.rotate(R)
                -- GC.scale(10)
                if C[4]>0 then
                    GC.setColor(C)
                    GC.polygon('fill',Crv)
                end
                GC.setColor(COLOR.D) GC.setLineWidth(8) GC.polygon('line',Crv)
                GC.setColor(COLOR.L) GC.setLineWidth(2) GC.polygon('line',Crv)
            end
        end
        ZENITHA.globalEvent.drawSysInfo=sysInfoFunc
        function ZENITHA.globalEvent.sceneSwap(state)
            if state=='swap' then
                SFX.play(SCN.stackChange<0 and 'scene_backward' or 'scene_forward')
            end
        end
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
            init=StopBGM,
            update=function(_,t)
                if WAIT.state=='wait' and t>=2.6 then
                    PROGRESS.setMain(2)
                    SCN.scenes['main_in'].load()
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
                elseif t<2 and GetBGM() then
                    StopBGM(true)
                end
                if WAIT.state=='wait' and t>=2.6 then
                    PROGRESS.setMain(3)
                    SCN.swapTo('main_out','none')
                    PROGRESS.applyCoolWaitTemplate()
                    WAIT.interrupt()
                    TASK.new(function()
                        MSG('warn',Text.interior_crash,10)
                        TASK.yieldT(3)
                        MSG('info',Text.booting_changed,7)
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
    elseif n==4 then
        -- TODO
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
        StopBGM()
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
                GC.mStr("Bye",0,-70)
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

--------------------------------------------------------------
-- Lock

local lock=false
function PROGRESS.lock()
    lock=true
end
function PROGRESS.unlock()
    lock=false
end

--------------------------------------------------------------
-- Get

function PROGRESS.get(k) return prgs[k] end
function PROGRESS.getBgmUnlocked(name) return prgs.bgmUnlocked[name] end
function PROGRESS.getStyleUnlock(style) return prgs.styles[style] end
function PROGRESS.getTutorialPassed(n)
    if n then
        return tonumber(prgs.interiorScore.tutorial:sub(n,n))
    else
        return not prgs.interiorScore.tutorial:find('[01]')
    end
end
function PROGRESS.getInteriorScore(mode) return prgs.interiorScore[mode] end
function PROGRESS.getTotalInteriorScore() return prgs.interiorScore.dig+prgs.interiorScore.sprint+prgs.interiorScore.marathon end
function PROGRESS.getExteriorMapState() return prgs.exteriorMap end
function PROGRESS.getExteriorUnlock(mode) return not not prgs.exteriorMap[mode] end ---@param mode Techmino.ModeName
function PROGRESS.getExteriorModeScore(mode,key) local M=prgs.exteriorMap[mode] return M and M[key] end --[[@param mode Techmino.ModeName]] --[[@param key string]]
function PROGRESS.getSecret(id) return not not prgs.secretFound[id] end ---@param id Techmino.Text.Achievement

--------------------------------------------------------------
-- Set

-- function PROGRESS.set(k,v)
--     prgs[k]=v
--     PROGRESS.save()
-- end
function PROGRESS.setMain(n)
    if n>prgs.main then
        while prgs.main<n do
            prgs.main=prgs.main+1
            if prgs.main==2 then
                prgs.interiorScore.tutorial=prgs.interiorScore.tutorial:gsub('0','1')
            elseif prgs.main==3 then
                prgs.interiorScore.tutorial=prgs.interiorScore.tutorial:gsub('[01]','2')
            elseif prgs.main==4 then
                -- ?
            elseif prgs.main==5 then
                -- ?
            end
        end
        PROGRESS.save()
    end
end
function PROGRESS.setBgmUnlocked(name,state)
    if type(name)=='table' then
        for _,v in next,name do
            PROGRESS.setBgmUnlocked(v,state)
        end
        return
    end
    local newState=math.max(prgs.bgmUnlocked[name] or 0,state)
    if newState>(prgs.bgmUnlocked[name] or 0) then
        prgs.bgmUnlocked[name]=newState
        if prgs.main>=3 then
            MSG('collect',Text.bgm_collected:repD(SONGBOOK[name].title))
        end
        PROGRESS.save()
    end
end
function PROGRESS.setStyleUnlock(style)
    if not prgs.styles[style] then
        prgs.styles[style]=true
        if TABLE.countAll(prgs.styles,true)>=2 then
            PROGRESS.setMain(4)
        end
        PROGRESS.save()
    end
end
function PROGRESS.setTutorialPassed(n,v)
    local l=STRING.atomize(prgs.interiorScore.tutorial)
    if v>tonumber(l[n]) then
        l[n]=v
        prgs.interiorScore.tutorial=table.concat(l)
        PROGRESS.save()
    end
end
---@param sign? '<' | '>' #default to `'>'` bigger=better, `'<'` smaller=better
function PROGRESS.setInteriorScore(mode,score,sign)
    sign=sign or '>'
    if not prgs.interiorScore[mode] or sign=='>' and score>prgs.interiorScore[mode] or sign=='<' and score<prgs.interiorScore[mode] then
        prgs.interiorScore[mode]=score
        PROGRESS.save()
    end
end

---@param mode Techmino.ModeName
---@param outsideGame? true
function PROGRESS.setExteriorUnlock(mode,outsideGame)
    if not prgs.exteriorMap[mode] then
        if TASK.lock(outsideGame and 'exMap_unlockSound' or 'exMap_unlockSound_background',2.6) then
            FMOD.effect(outsideGame and 'map_unlock' or 'map_unlock_bg')
        end
        prgs.exteriorMap[mode]={}
        PROGRESS.save()
    end
end

---@param mode Techmino.ModeName
---@param key string
---@param value number
---@param sign? '>' | '<' `'>'` bigger=better, `'<'` smaller=better
---@return boolean success
function PROGRESS.setExteriorScore(mode,key,value,sign)
    assert(sign=='<' or sign=='>',"Saving condition required '<'|'>'")
    local data=prgs.exteriorMap[mode]
    if not data then
        data={}
        prgs.exteriorMap[mode]=data
        PROGRESS.save()
    end
    if
        not data[key] or
        sign=='>' and value>data[key] or
        sign=='<' and value<data[key]
    then
        data[key]=value
        PROGRESS.save()
        return true
    end
    return false
end

---@param id Techmino.Text.Achievement
---@return boolean success
function PROGRESS.setSecret(id)
    if not prgs.secretFound[id] then
        FMOD.effect('unlock_secret')
        prgs.secretFound[id]=1
        if rawget(Text.achievementMessage,id) then
            MSG('achievement',Text.achievementMessage[id])
        end
        PROGRESS.save()
        return true
    end
    return false
end

---@param dt number
function PROGRESS.updateMusicTime(dt)
    prgs.musicTime=prgs.musicTime+dt
end

--------------------------------------------------------------
-- Make all 'set' functions lockable
for k,f in next,PROGRESS do
    if k:sub(1,3)=='set' then
        PROGRESS[k]=function(...)
            if not lock then
                f(...)
            end
        end
    end
end

return PROGRESS
