local ins,rem=table.insert,table.remove

--- @type table<string, Techmino.mino.clearRule>
local clearRule={}

local function setBias(P,x,y,dx,dy,moveType,clearDelay)
    if dx==0 and dy==0 then return end
    local v
    if moveType=='lineBack' then
        v=40/clearDelay*dy
    elseif moveType=='teleBack' then
        v=clearDelay
    elseif moveType=='expBack' then
        v=math.log(40*(dx^2+dy^2)^.5)/clearDelay
    end
    P:setCellBias(x,y,{x=dx,y=dy,[moveType]=v})
end

do -- none (no line clear)
    --- @type Techmino.mino.clearRule
    clearRule.none={}
    function clearRule.none.getDelay() return 0 end
    clearRule.none.getFill=NULL
    clearRule.none.clear=NULL
end

do -- line (fill row to clear)
    --- @type Techmino.mino.clearRule
    clearRule.line={}

    function clearRule.line.getDelay(P,lines)
        return P.settings.clearDelay
    end

    function clearRule.line.isFill(P,y)
        local F=P.field
        for x=1,P.settings.fieldW do
            if not F:getCell(x,y) then
                return false
            end
        end
        return true
    end

    function clearRule.line.getFill(P)
        local fullLines={}
        for y=1,P.field:getHeight() do
            if mechLib.mino.clearRule.line.isFill(P,y) then
                ins(fullLines,y)
            end
        end
        if #fullLines>0 then
            return fullLines
        end
    end

    function clearRule.line.clear(P,lines)
        local F=P.field
        local sum=0
        local ptr=1
        for y=1,F:getHeight() do
            if y==lines[ptr] then
                sum=sum+1
                ptr=ptr+1
            elseif sum>0 then
                for x=1,P.settings.fieldW do
                    setBias(P,x,y,0,sum,P.settings.clearMovement,P.settings.clearDelay)
                end
            end
        end

        for i=#lines,1,-1 do
            F:removeLine(lines[i])
        end
    end
end

do -- triplets (filled lines which form arithmetic progression to clear, from tetr.js)
    --- @type Techmino.mino.clearRule
    clearRule.triplets={}

    clearRule.triplets.getDelay=clearRule.line.getDelay
    clearRule.triplets.isFill=clearRule.line.isFill

    function clearRule.triplets.getFill(P)
        local fullLines={}
        for y=1,P.field:getHeight() do
            if mechLib.mino.clearRule.line.isFill(P,y) then
                ins(fullLines,y)
            end
        end

        -- Mark lines not in triplets
        local marks=TABLE.new(false,#fullLines)
        for i=1,#fullLines-2 do
            for j=i+1,#fullLines-1 do
                local p=TABLE.find(fullLines,2*fullLines[j]-fullLines[i],j+1)
                if p then
                    marks[i]=true
                    marks[j]=true
                    marks[p]=true
                end
            end
        end

        -- Remove not in triplets
        for i=#marks,1,-1 do
            if not marks[i] then
                rem(fullLines,i)
            end
        end

        if #fullLines>0 then
            return fullLines
        end
    end

    clearRule.triplets.clear=clearRule.line.clear
end

do -- cheese (90% fill to clear)
    --- @type Techmino.mino.clearRule
    clearRule.cheese={}

    clearRule.cheese.getDelay=clearRule.line.getDelay

    function clearRule.cheese.isFill(P,y)
        local F=P.field
        local count=0
        for x=1,P.settings.fieldW do
            if not F:getCell(x,y) then
                count=count+1
            end
        end
        return count<=P.settings.fieldW/10
    end

    function clearRule.cheese.getFill(P)
        local fullLines={}
        for y=1,P.field:getHeight() do
            if mechLib.mino.clearRule.cheese.isFill(P,y) then
                ins(fullLines,y)
            end
        end
        if #fullLines>0 then
            return fullLines
        end
    end

    clearRule.cheese.clear=clearRule.line.clear
end

do -- line_float (fill row to clear, but not move above lines down)
    --- @type Techmino.mino.clearRule
    clearRule.line_float={}

    clearRule.line_float.getDelay=clearRule.line.getDelay
    clearRule.line_float.isFill=clearRule.line.isFill
    clearRule.line_float.getFill=clearRule.line.getFill

    function clearRule.line_float.clear(P,lines)
        local F=P.field

        for i=#lines,1,-1 do
            F._matrix[lines[i]]=TABLE.new(false,F._width)
        end
        F:fresh()
    end
end

return clearRule
