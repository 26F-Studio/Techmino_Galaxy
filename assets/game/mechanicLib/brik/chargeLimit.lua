local gc=love.graphics
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_rectangle,gc_line=gc.rectangle,gc.line

local mRect=GC.mRect

---@type Map<Techmino.Event.Brik>
local chargeLimit={}

do -- techrash
    local initPower=3
    local initSidePower=0
    local maxPower=6
    local maxSidePower=4
    local sidePowerRate=0.5
    local maxCharge=6

    function chargeLimit.techrash_event_playerInit(P)
        P.modeData.techrash=0
        P.modeData.chargePower=initPower
        P.modeData.sidePower=initSidePower
        P.modeData.techrashInfo={}
    end
    function chargeLimit.techrash_event_always(P)
        for _,v in next,P.modeData.techrashInfo do
            if v._charge~=v.charge then
                if v._charge<v.charge then
                    v._charge=MATH.expApproach(v._charge,v.charge,.00626)
                else
                    v._charge=math.max(v._charge-.00626,v.charge)
                end
                if math.abs(v._charge-v.charge)<.01 then
                    v._charge=v.charge
                end
            end
        end
    end
    function chargeLimit.techrash_event_afterClear(P,clear)
        if P.hand.name=='I' and clear.line==4 then
            local list=P.modeData.techrashInfo
            local x=P.handX
            P.modeData.techrash=P.modeData.techrash+1
            if P.modeData.techrash>1 then
                local n=P.modeData.techrash
                P:playSound('charge',
                    n<=2 and 1 or
                    n<=4 and 2 or
                    n<=6 and 3 or
                    n<=8 and 4 or
                    n<=10 and 5 or
                    n<=13 and 6 or
                    n<=16 and 7 or
                    n<=19 and 8 or
                    n<=22 and 9 or
                    n<=25 and 10 or
                    11
                )
            end
            if not list[x] then list[x]={charge=0,_charge=0} end
            if list[x].charge>=maxCharge then
                list[x].dead=true
                P:finish('rule')
            else
                for k,v in next,list do
                    if k~=x then
                        v.charge=math.max(v.charge-1,0)
                    end
                end
            end
            list[x].charge=list[x].charge+P.modeData.chargePower
            if not list[x-1] then list[x-1]={charge=0,_charge=0} end
            list[x-1].charge=list[x-1].charge+math.floor(P.modeData.sidePower/2)
            if not list[x+1] then list[x+1]={charge=0,_charge=0} end
            list[x+1].charge=list[x+1].charge+math.floor(P.modeData.sidePower/2)

            local r1,r2=P.modeData.chargePower,P.modeData.sidePower/sidePowerRate
            if P.modeData.chargePower>=maxPower then r1=0 end
            if P.modeData.sidePower>=maxSidePower then r2=0 end
            if r1*r2>0 then r1,r2=r1>=r2 and 1 or 0,r2>=r1 and 1 or 0 end
            if r1>0 then
                P.modeData.sidePower=P.modeData.sidePower+1
            elseif r2>0 then
                P.modeData.chargePower=P.modeData.chargePower+1
            end
        else
            P:finish('rule')
        end
    end
    function chargeLimit.techrash_event_drawBelowMarks(P)
        local t=love.timer.getTime()
        for k,v in next,P.modeData.techrashInfo do
            if v._charge>0 or v.dead then
                local x=40*k-20
                local chargeRate=v._charge/maxCharge
                local barHeight=chargeRate*P.settings.fieldW*80
                if v.dead then
                    if t%.2<.1 then
                        gc_setColor(.6,.4,.8,.626)
                    else
                        gc_setColor(.6,.6,.6,.42)
                    end
                    gc_rectangle('fill',x-15,0,30,-barHeight)
                else
                    if chargeRate<1 then
                        gc_setColor(.8,0,0,.3+.06*math.sin(t*2+k))
                    elseif t%.2<.1 then
                        gc_setColor(.8,.4,.4,.626)
                    else
                        gc_setColor(.6,.6,.6,.42)
                    end
                    gc_rectangle('fill',x-15,0,30,-barHeight)
                    gc_setColor(1,1,1,.42)
                    gc_rectangle('fill',x-15,-barHeight,30,2)
                end
            end
        end
    end
    function chargeLimit.techrash_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(P.modeData.techrash,-300,-70)
        FONT.set(30) GC.mStr(Text.target_techrash,-300,15)
    end
end

do -- spin
    ---@class Techmino.Mech.Brik.PieceDevice
    ---@field pow number power
    ---@field _pow number show power
    ---@field visible boolean show the whole device or not
    ---@field doom boolean exploded

    ---@class Techmino.Mech.Brik.ColumnDevice
    ---@field pow number power
    ---@field _pow number show power
    ---@field doom boolean exploded

    local styles={
        {name='I',id=7,x=-300-80,y=-60-40*3-15,w=160,h=30,color=RGB9 [488], colorD=RGB9 [233], colorL=RGB9 [699] },
        {name='L',id=4,x=-300-80,y=-60-40*2-15,w=160,h=30,color=RGB9 [864], colorD=RGB9 [332], colorL=RGB9 [976] },
        {name='J',id=3,x=-300-80,y=-60-40*1-15,w=160,h=30,color=RGB9 [448], colorD=RGB9 [223], colorL=RGB9 [669] },
        {name='O',id=6,x=-300-80,y= 00+00*0-30,w=160,h=60,color=RGBA9[8843],colorD=RGBA9[3323],colorL=RGBA9[9963]},
        {name='Z',id=1,x=-300-80,y= 60+40*1-15,w=160,h=30,color=RGB9 [844], colorD=RGB9 [322], colorL=RGB9 [966] },
        {name='S',id=2,x=-300-80,y= 60+40*2-15,w=160,h=30,color=RGB9 [484], colorD=RGB9 [232], colorL=RGB9 [696] },
        {name='T',id=5,x=-300-80,y= 60+40*3-15,w=160,h=30,color=RGB9 [748], colorD=RGB9 [423], colorL=RGB9 [869] },
    }
    local colorToID={
        [defaultBrikColor[1]]=1,
        [defaultBrikColor[2]]=2,
        [defaultBrikColor[3]]=3,
        [defaultBrikColor[4]]=4,
        [defaultBrikColor[5]]=5,
        [defaultBrikColor[6]]=6,
        [defaultBrikColor[7]]=7,
    }
    local columnPureTextColor={
        RGB9[966],
        RGB9[696],
        RGB9[679],
        RGB9[986],
        RGB9[869],
        RGB9[996],
        RGB9[699],
    }

    local pieceDev_init=20
    local pieceDev_max=26
    local pieceDev_cost=5
    local pieceDev_punish=10
    local columnDev_init=20
    local columnDev_max=20
    local columnDev_cost=5
    local columnDev_punish=10

    local function shutdown(P)
        if not P.modeData.spin_explodeTimer then
            P.modeData.spin_explodeTimer=26
            P:addEvent('always',chargeLimit.spin_death_event_always)
        end
    end
    function chargeLimit.spin_death_event_always(P)
        P.modeData.spin_explodeTimer=P.modeData.spin_explodeTimer-1
        if P.modeData.spin_explodeTimer<=0 then
            P:finish('rule')
            return true
        end
    end
    function chargeLimit.spin_event_playerInit(P)
        P.modeData.spinClear=0
        P:addEvent('afterDrop',chargeLimit.spin_event_afterDrop)
        P:addEvent('afterClear',{-1e99,chargeLimit.spin_event_afterClear})
        P:addEvent('drawBelowMarks',chargeLimit.spin_event_drawBelowMarks)
    end
    function chargeLimit.spin_event_afterDrop(P)
        local F=P.field
        if not P.lastMovement.immobile then return end
        local CB=P.hand.matrix
        for y=1,#CB do for x=1,#CB[1] do
            local C=CB[y][x]
            if C then
                local cx,cy=x+P.handX-1,y+P.handY-1
                if
                    F:getCell(cx-1,cy) or
                    F:getCell(cx+1,cy) or
                    F:getCell(cx,cy-1) or
                    F:getCell(cx,cy+1)
                then
                    C.spin_charge=true
                end
            end
        end end
    end
    function chargeLimit.spin_event_afterClear(P,clear)
        if P.lastMovement.immobile then
            P.modeData.spinClear=P.modeData.spinClear+clear.line
        end
    end
    function chargeLimit.spin_event_drawBelowMarks(P)
        gc_setColor(1,1,1,.62)
        local mat=P.field._matrix
        for y=1,#mat do for x=1,#mat[1] do
            local C=mat[y][x]
            if C and C.spin_charge then
                gc_rectangle('fill',40*(x-1)+10,-40*(y-1)-10,20,-20)
            end
        end end
    end
    function chargeLimit.spin_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(30) GC.mStr(Text.target_line,-300,15)
        if P.modeData.spin_column_pure then
            gc_setColor(columnPureTextColor[P.modeData.spin_column_pure])
        end
        FONT.set(80) GC.mStr(P.modeData.spinClear,-300,-70)
    end

    function chargeLimit.spin_piece_event_init(P)
        if not P.modeData.spinClear then
            chargeLimit.spin_event_playerInit(P)
        end
        local devices={}
        for i=1,7 do
            devices[i]={
                pow=pieceDev_init,
                _pow=0,
                visible=true,
                doom=false
            }
        end
        devices[6].visible=false
        P.modeData.spin_powDevice=devices
        P:addEvent('always',chargeLimit.spin_piece_event_always)
        P:addEvent('beforeClear',{-1,chargeLimit.spin_piece_event_beforeClear})
        P:addEvent('drawOnPlayer',chargeLimit.spin_piece_event_drawOnPlayer)
    end
    function chargeLimit.spin_piece_event_always(P)
        ---@type Techmino.Mech.Brik.PieceDevice[]
        local devices=P.modeData.spin_powDevice
        for i=1,7 do
            local device=devices[i]
            if device._pow~=device.pow then
                if device._pow<device.pow then
                    device._pow=MATH.expApproach(device._pow,device.pow,.00626)
                else
                    device._pow=math.max(device._pow-.026,device.pow)
                end
                if math.abs(device._pow-device.pow)<.01 then
                    device._pow=device.pow
                end
            end
        end
    end
    function chargeLimit.spin_piece_event_beforeClear(P,fullLines)
        ---@type Techmino.Mech.Brik.PieceDevice[]
        local devices=P.modeData.spin_powDevice
        local mainDev=P.hand and devices[Brik.getID(P.hand.name)]

        -- Death cheak
        if mainDev then
            if not mainDev.visible then
                mainDev.visible=true
            end
            if mainDev.pow<0 then
                mainDev.doom=true
                shutdown(P)
            end
        end

        -- Clear charged cells
        local mat=P.field._matrix
        local lines=#fullLines
        for i=1,lines do
            local y=fullLines[i]
            for x=1,P.settings.fieldW do
                local C=mat[y][x]
                if C and C.spin_charge then
                    local id=colorToID[C.color]
                    if id then
                        devices[id].pow=devices[id].pow-pieceDev_cost
                    end
                end
            end
        end

        -- Add power for colors
        for i=1,7 do
            local device=devices[i]
            if device~=mainDev then
                device.pow=device.pow+math.max(3-lines,0)
            end
            device.pow=math.min(device.pow,pieceDev_max)
        end

        -- Non-spin punishing
        if not P.lastMovement.immobile and mainDev then
            mainDev.pow=math.max(mainDev.pow-pieceDev_punish,-1)
        end
    end
    function chargeLimit.spin_piece_event_drawOnPlayer(P)
        ---@type Techmino.Mech.Brik.PieceDevice[]
        local devices=P.modeData.spin_powDevice
        gc_setLineWidth(2)
        for i=1,7 do
            local device=devices[styles[i].id]
            if device.visible then
                local x,y,w,h=styles[i].x,styles[i].y,styles[i].w,styles[i].h
                if device.doom then
                    gc_setColor(COLOR.lR)
                    gc_line(x,y,x+w,y+h)
                    gc_line(x+w,y,x,y+h)
                elseif device.pow>=0 then
                    gc_setColor(styles[i].colorL)
                    mRect('fill',x+w*.5,y+h*.5,w*device._pow/pieceDev_max,h)
                elseif P.time%420>=260 then
                    gc_setColor(styles[i].colorD)
                    gc_rectangle('fill',x,y,w,h)
                end
                gc_setColor(styles[i].color)
                gc_rectangle('line',x,y,w,h)
            end
        end
    end

    function chargeLimit.spin_column_event_init(P,shape)
        if not P.modeData.spinClear then
            chargeLimit.spin_event_playerInit(P)
        end
        P.modeData.spin_powColumn={}
        P.modeData.spin_column_pure=shape
        for i=1,P.settings.fieldW do
            P.modeData.spin_powColumn[i]={
                pow=columnDev_init,
                _pow=0,
                doom=false,
            }
        end
        P:addEvent('always',chargeLimit.spin_column_event_always)
        P:addEvent('beforeClear',{-1,chargeLimit.spin_column_event_beforeClear})
        P:addEvent('drawBelowMarks',chargeLimit.spin_column_event_drawBelowMarks)
    end
    function chargeLimit.spin_column_event_always(P)
        ---@type Techmino.Mech.Brik.ColumnDevice[]
        local devices=P.modeData.spin_powColumn
        for i=1,#devices do
            local device=devices[i]
            if device._pow~=device.pow then
                device._pow=MATH.expApproach(device._pow,device.pow,.026)
                if math.abs(device._pow-device.pow)<.01 then
                    device._pow=device.pow
                end
            end
        end
    end
    function chargeLimit.spin_column_event_beforeClear(P,fullLines)
        ---@type Techmino.Mech.Brik.ColumnDevice[]
        local devices=P.modeData.spin_powColumn

        -- Clear charged cells
        local mat=P.field._matrix
        local lines=#fullLines
        for i=1,lines do
            local y=fullLines[i]
            for x=1,P.settings.fieldW do
                local C=mat[y][x]
                if C and C.spin_charge then
                    devices[x].pow=devices[x].pow-columnDev_cost
                end
            end
        end

        -- Add power for colors
        for i=1,#devices do
            devices[i].pow=devices[i].pow+lines
        end

        if P.hand then
            -- Check pure
            if P.lastMovement.immobile and P.modeData.spin_column_pure~=P.hand.shape then
                P.modeData.spin_column_pure=false
            end

            local CB=P.hand.matrix
            for y=1,#CB do for x=1,#CB[1] do
                local C=CB[y][x]
                if C then
                    local cx,cy=x+P.handX-1,y+P.handY-1
                    if TABLE.find(fullLines,cy) then
                        if devices[cx].pow<0 then
                            -- Death cheak
                            devices[cx].doom=true
                            shutdown(P)
                        elseif not P.lastMovement.immobile then
                            -- Non-spin punishing
                            local device=devices[cx]
                            device.pow=math.max(device.pow-columnDev_punish,-1)
                        end
                    end
                end
            end end
        end

        -- Limit max power
        for i=1,#devices do
            devices[i].pow=math.min(devices[i].pow,columnDev_max)
        end
    end
    function chargeLimit.spin_column_event_drawBelowMarks(P)
        ---@type Techmino.Mech.Brik.ColumnDevice[]
        local devices=P.modeData.spin_powColumn
        for i=1,#devices do
            local device=devices[i]
            local x=40*i-20
            if device.doom then
                gc_setColor(1,.26,.26,.42)
                gc_rectangle('fill',x-15,0,30,-20*40)
            elseif device.pow>=0 then
                gc_setColor(1,1,1,.2)
                gc_rectangle('fill',x-15,0,30,-device._pow*40-5)
            elseif P.time%420<260 then
                gc_setColor(1,.42,.42,.26)
                gc_rectangle('fill',x-15,0,30,-20*40)
            end
        end
    end
end

do -- tspin (legacy)
    function chargeLimit.tspin_event_playerInit(P)
        P.modeData.tsd=0
        P.modeData.tsdInfo={}
    end

    local tsdPower=3
    local maxCharge=5

    function chargeLimit.tspin_event_always(P)
        for _,v in next,P.modeData.tsdInfo do
            if v._charge~=v.charge then
                if v._charge<v.charge then
                    v._charge=MATH.expApproach(v._charge,v.charge,.00626)
                else
                    v._charge=math.max(v._charge-.00626,v.charge)
                end
                if math.abs(v._charge-v.charge)<.01 then
                    v._charge=v.charge
                end
            end
        end
    end
    function chargeLimit.tspin_death_event_always(P)
        P.modeData.overChargedTimer=P.modeData.overChargedTimer+1
        if P.modeData.overChargedTimer>=620 then
            if P.modeData.superpositionProtect then
                P:delEvent('drawBelowMarks',chargeLimit.tspin_event_drawBelowMarks)
                P:playSound('beep_drop')
            else
                P:finish('rule')
            end
            return true
        end
    end
    function chargeLimit.tspin_event_afterClear(P,clear)
        local movement=P.lastMovement
        if P.hand.name=='T' and movement.action=='rotate' and (movement.corners or movement.immobile) then
            if P.modeData.tsd and clear.line==2 then
                P.modeData.tsd=P.modeData.tsd+1
                if P.modeData.tsd>1 then
                    local n=P.modeData.tsd
                    P:playSound('charge',
                        n<=3 and 1 or
                        n<=5 and 2 or
                        n<=7 and 3 or
                        n<=9 and 4 or
                        n<=11 and 5 or
                        n<=13 and 6 or
                        n<=15 and 7 or
                        n<=17 and 8 or
                        n<=19 and 9 or
                        n<=22 and 10 or
                        11
                    )
                end

                if not P.modeData.overChargedTimer then
                    local list=P.modeData.tsdInfo
                    local settings=P.settings
                    local RS=brikRotSys[settings.rotSys]
                    local brikData=RS[P.hand.shape]
                    local state=brikData[P.hand.direction]
                    local centerPos=state and state.center or type(brikData.center)=='function' and brikData.center(P)

                    if centerPos then
                        local x=P.handX+centerPos[1]-.5
                        if not list[x] then list[x]={charge=0,_charge=0} end
                        if list[x].charge>=maxCharge then
                            list[x].dead=true
                            P.modeData.overChargedTimer=0
                            P:addEvent('always',chargeLimit.tspin_death_event_always)
                            if P.modeData.superpositionProtect then
                                P:playSound('beep_drop')
                            end
                        else
                            for k,v in next,list do
                                if k~=x then
                                    v.charge=math.max(v.charge-1,0)
                                end
                            end
                        end
                        list[x].charge=list[x].charge+tsdPower
                    end
                end
            elseif P.modeData.superpositionProtect then
                -- Degrade to tspin
                if not P.modeData.tspin then
                    P.modeData.tspin=P.modeData.tsd
                    P.modeData.tsd=nil
                    P:playSound('beep_drop')
                end
                P.modeData.tspin=P.modeData.tspin+1
            else
                P:finish('rule')
            end
        else
            P:finish('rule')
        end
    end
    function chargeLimit.tspin_event_drawBelowMarks(P)
        local t=love.timer.getTime()
        for k,v in next,P.modeData.tsdInfo do
            if v._charge>0 or v.dead then
                local x=40*k-20
                local chargeRate=v._charge/maxCharge
                local barHeight=chargeRate*P.settings.fieldW*80
                if v.dead then
                    if t%.2<.1 then
                        gc_setColor(.6,.4,.8,.626)
                    else
                        gc_setColor(.6,.6,.6,.42)
                    end
                    gc_rectangle('fill',x-15,0,30,-barHeight)
                else
                    if chargeRate<1 then
                        gc_setColor(.8,0,0,.3+.06*math.sin(t*2+k))
                    elseif t%.2<.1 then
                        gc_setColor(.8,.4,.4,.626)
                    else
                        gc_setColor(.6,.6,.6,.42)
                    end
                    gc_rectangle('fill',x-15,0,30,-barHeight)
                    gc_setColor(1,1,1,.42)
                    gc_rectangle('fill',x-15,-barHeight,30,2)
                end
            end
        end
    end
    function chargeLimit.tspin_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(P.modeData.tsd,-300,-70)
        FONT.set(30) GC.mStr(Text.target_tsd,-300,15)
    end
end

return chargeLimit
