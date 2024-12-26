local gc=love.graphics
local recordedLines={20,40,100,260}
local recordedLinesStr={'line20','line40','line100','line260'}
local recordedLinesName={'[20]','[40]','[100]','[260]'}
local setFont,getFont=FONT.set,FONT.get

local function infSprint_turnOn(P)
    P.modeData.infSprint_switch=true
end

regFuncLib(infSprint_turnOn,'exterior_sprint.infSprint_turnOn')

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={brik={
        -- clearRule='line_float',
        spin_immobile=true,
        spin_corners=3,
        seqType='bag7_sprint',
        infHold=true,
        event={
            playerInit=function(P)
                P.modeData.infSprint_switch=false
                P.modeData.infSprint_dropCheckPos=1
                P.modeData.infSprint_clears={}
                P.modeData.target.line=20
                P.modeData.keyCount={}
                P.modeData.curKeyCount=0
                if not PROGRESS.getExteriorUnlock('combo') then
                    P.settings.combo_sound=true
                end
                if PROGRESS.getExteriorUnlock('spin') then
                    P.settings.spin_immobile=false
                    P.settings.spin_corners=false
                end
                P:setAction('func1',infSprint_turnOn)
            end,
            beforePress={
                mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
                function(P)
                    if P.timing then return true end
                    if P.settings.readyDelay%1000~=0 then
                        PROGRESS.setSecret('exterior_sprint_gunJumping')
                    end
                end,
                function(P)
                    P.modeData.curKeyCount=P.modeData.curKeyCount+1
                end,
            },
            afterLock=function(P)
                table.insert(P.modeData.keyCount,P.modeData.curKeyCount)
                P.modeData.curKeyCount=0
            end,
            afterPress=function(P)
                if PROGRESS.getExteriorUnlock('spin') then return true end
                local move=P.lastMovement
                if move and (move.immobile or move.corners) then
                    PROGRESS.setExteriorUnlock('spin')
                    P.settings.spin_immobile=false
                    P.settings.spin_corners=false
                    return true
                end
            end,
            beforeClear={
                function(P,lines) -- Infinite Sprint Core
                    local CLEAR=P.modeData.infSprint_clears
                    ---@type Techmino.Brik.Cell[][]
                    local mat=P.field._matrix
                    for i=1,#lines do
                        local l={[0]=P.time}
                        for x=1,P.settings.fieldW do
                            local c=mat[lines[i]][x]
                            l[c.did]=(l[c.did] or 0)+1
                        end
                        table.insert(CLEAR,l)
                    end

                    local dropCheckPos=P.modeData.infSprint_dropCheckPos
                    while true do
                        local lClearBound
                        local i=1
                        while i<=#CLEAR do
                            if CLEAR[i][dropCheckPos] then
                                lClearBound=i
                                break
                            else
                                local keep
                                for id in next,CLEAR[i] do
                                    if id>=dropCheckPos then
                                        keep=true
                                        break
                                    end
                                end
                                if keep then
                                    i=i+1
                                else
                                    table.remove(CLEAR,i)
                                end
                            end
                        end
                        if not lClearBound then break end

                        local rClearBounds={}
                        local currentCheck=1
                        local count=0
                        for j=lClearBound,#CLEAR do
                            for id,num in next,CLEAR[j] do
                                if id>=dropCheckPos then
                                    count=count+num
                                    if count>=recordedLines[currentCheck]*10 then
                                        rClearBounds[currentCheck]=j
                                        currentCheck=currentCheck+1
                                        if currentCheck>4 then
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        for j=1,4 do
                            if rClearBounds[j] then
                                local drop=P.dropHistory[dropCheckPos-1]
                                local time=CLEAR[rClearBounds[j]][0]-(drop and drop.time or 0)
                                PROGRESS.setExteriorScore('sprint',recordedLinesStr[j],time,'<')
                                -- print(("Time=%.2f"):format(time/1000))
                                -- print(dropCheckPos,lClearBound,rClearBound)
                                if j==4 then
                                    dropCheckPos=dropCheckPos+1
                                    P.modeData.infSprint_dropCheckPos=dropCheckPos
                                end
                            else
                                return
                                -- TODO: calculate approximate time
                            end
                        end
                    end
                end,
            },
            afterClear={
                -- mechLib.brik.misc.chain_event_afterClear,
                function(P)
                    if P.stat.line>=P.modeData.target.line then
                        P.modeData.target.line=TABLE.next(recordedLines,P.modeData.target.line)
                        if not P.modeData.target.line then
                            P:delEvent('drawInField',mechLib.brik.misc.lineClear_event_drawInField)
                            return true
                        end
                    end
                end,
                function(P)
                    if PROGRESS.getExteriorUnlock('allclear') then return true end
                    if P.stat.allclear>0 then
                        PROGRESS.setExteriorUnlock('allclear')
                        return true
                    end
                end,
                function(P)
                    if PROGRESS.getExteriorUnlock('combo') then return true end
                    if P.combo==10 then
                        PROGRESS.setExteriorUnlock('combo')
                        return true
                    end
                end,
                function(P)
                    if PROGRESS.getExteriorUnlock('invis') then return true end
                    if P.stat.line>=40 then
                        if P.stat.clears[1]+P.stat.clears[2]+P.stat.clears[3]==0 then
                            PROGRESS.setExteriorUnlock('invis')
                        end
                        return true
                    end
                end,
                function(P)
                    if PROGRESS.getExteriorUnlock('sequence') then return true end
                    if P.stat.line>=40 then
                        if P.stat.piece<102.6 then
                            PROGRESS.setExteriorUnlock('sequence')
                        end
                        return true
                    end
                end,
                function(P)
                    if P.stat.line>=40 then
                        P:delEvent('drawInField',mechLib.brik.misc.lineClear_event_drawInField)
                        if not P.modeData.infSprint_switch then
                            P:finish('win')
                        end
                        return true
                    end
                end,
            },
            drawInField=mechLib.brik.misc.lineClear_event_drawInField,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-180,160,360)
                local y=-175
                for i=1,4 do
                    if i==3 and not P.modeData.infSprint_switch then
                        gc.setColor(COLOR.lD)
                    end
                    local time=PROGRESS.getExteriorModeScore('sprint',recordedLinesStr[i])
                    if time then
                        setFont(45)
                        local int=tostring(math.floor(time/1000))
                        gc.print(int,-370,y)
                        setFont(25)
                        gc.print('.'..time%1000,-367+getFont(45):getWidth(int),y+20)
                    else
                        setFont(40)
                        gc.print('———',-370,y)
                    end
                    setFont(20,'bold')
                    gc.print(recordedLinesName[i],-370,y+45)
                    y=y+90
                end
            end,
            -- whenSuffocate=mechLib.brik.misc.suffocateLock_event_whenSuffocate,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        ---@cast P Techmino.Player.Brik
        if not P then return end
        if P.stat.line<20 then return end

        local dropInfo={}
        local averageTime=P.gameTime/#P.dropHistory
        local lastPieceTime=0
        for i,d in next,P.dropHistory do
            table.insert(dropInfo,{
                x=d.gameTime/P.gameTime,
                y=i/#P.dropHistory,
                choke=math.min(averageTime/(d.gameTime-lastPieceTime),1),
                key=P.modeData.keyCount[i] or 0,
            })
            lastPieceTime=d.gameTime
        end
        P.modeData.dropInfo=dropInfo

        local clearInfo={}
        local _cleared=0
        for _,c in next,P.clearHistory do
            _cleared=math.min(_cleared+c.line,P.stat.line)
            table.insert(clearInfo,{
                x=c.gameTime/P.gameTime,
                y=_cleared/P.stat.line,
            })
        end
        table.insert(clearInfo,{x=1,y=1})
        P.modeData.clearInfo=clearInfo
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        ---@cast P Techmino.Player.Brik
        if not P then return end

        if P.stat.line<20 then
            setFont(100)
            gc.setColor(1,1,1,math.min(time*2.6,1))
            GC.mStr(P.stat.line.." / 20",800,400)
            return
        end

        local t=MATH.expApproach(0,1,time^2*26)
        local maxH=600*MATH.expApproach(0,1,math.max(time-.26,0)^2*12.6)

        -- Set axis' trasformation
        gc.translate(400,800)
        gc.scale(1,-1)

        -- Reference line
        gc.setLineWidth(3)
        gc.setColor(1,1,.626,.626)
        gc.line(0,0,800*t,600*t)

        -- Line-time
        gc.setLineWidth(2)
        local clearData=P.modeData.clearInfo
        local lastX,lastY=0,0
        for i=1,#clearData do
            gc.setColor(.1,.1,1,.42)
            gc.polygon('fill',
                800*t*lastX,0,
                800*t*lastX,lastY*maxH,
                800*t*clearData[i].x,lastY*maxH, -- FLIP --
                -- 800*t*clearData[i].x,clearData[i].y*maxH, -- FLIP --
                800*t*clearData[i].x,0
            )
            gc.setColor(.2,.3,1)
            gc.line(
                800*t*lastX,lastY*maxH,
                800*t*clearData[i].x,lastY*maxH, -- FLIP --
                800*t*clearData[i].x,clearData[i].y*maxH
            )
            lastX,lastY=clearData[i].x,clearData[i].y
        end

        -- Piece-time
        local dropData=P.modeData.dropInfo
        lastX,lastY=0,0
        for i=1,#dropData do
            local gb=dropData[i].choke
            gc.setColor(.8+gb,gb,gb)
            -- KPP mark
            if dropData[i].key>2.6 then
                gc.setLineWidth(1)
                gc.circle('line',800*t*lastX,lastY*maxH,math.min(dropData[i].key^2/10,4))
            end
            -- Line
            gc.setLineWidth(2)
            gc.line(
                800*t*lastX,lastY*maxH,
                800*t*dropData[i].x,lastY*maxH, -- FLIP --
                800*t*dropData[i].x,dropData[i].y*maxH
            )
            lastX,lastY=dropData[i].x,dropData[i].y
        end

        -- Axis
        gc.setLineWidth(2)
        gc.setColor(COLOR.dL)
        gc.line(0,600*t,0,0,800*t,0)
        setFont(30)
        gc.setColor(1,1,1,t)
        gc.printf(STRING.time(P.gameTime/1000),800*t-260,-10,260,'right',nil,1,-1)
    end,
}
