local gc=love.graphics
local fieldW=5

local matrix={}
local score,target
local pieceWeights
local curPiece
local pieceSpawnTimer
local noControl
local choices={}
local texts=TEXT.new()

local pieces={} -- Different orientations of all needed pieces
for k,v in next,STRING.split('S0 SR Z0 ZR J0 JR JF JL L0 LR LF LL T0 TR TF TL O0 IR',' ') do
    local p=Brik.get(v:sub(1,1))
    local shape=TABLE.rotate(TABLE.copy(p.shape),v:sub(2,2))
    local footH={}
    for x=1,#shape[1] do
        for y=1,#shape do
            if shape[y][x] then
                footH[x]=y-1
                break
            end
        end
    end
    pieces[k]={
        id=p.id,
        name=p.name,
        shape=shape,
        color=RGB9[defaultBrikColor[p.id]],
        dir=v:sub(2,2),

        width=#shape[1],
        height=#shape,
        footH=footH,
    }
end

---@type Zenitha.Scene
local scene={}

local function newPiece()
    local solutions={}
    for i=1,#pieces do
        local tempMat=TABLE.copy(matrix)
        local hb0=AI.paperArtist.getBoundCount(tempMat)
        local piece=pieces[i]
        for x=1,1+fieldW-piece.width do
            local point=6.26
            local tempMat2=TABLE.copy(matrix)
            AI.util.lockPiece(tempMat2,piece.shape,x)
            if #tempMat2>=6 then
                point=-1e99
            end
            point=point+AI.util.clearLine(tempMat2)
            local hb,vb=AI.paperArtist.getBoundCount(tempMat2)
            if vb>0 then
                point=-1e99
            else
                point=point+hb0-hb
            end
            if point>0 then
                point=point+pieceWeights[piece.id]
                table.insert(solutions,{
                    point=point,
                    id=piece.id,
                    name=piece.name,
                    color=piece.color,
                    shape=piece.shape,
                    x=x,
                    y=7.023-#piece.shape/2,
                })
            end
        end
    end

    pieceSpawnTimer=.42
    if solutions[1] then
        local sum=0
        for i=1,#solutions do
            sum=sum+solutions[i].point
        end
        sum=sum*math.random()
        for i=1,#solutions do
            sum=sum-solutions[i].point
            if sum<=0 then
                curPiece=solutions[i]
                for i=1,#pieceWeights do
                    local v=pieceWeights[curPiece.id]
                    pieceWeights[curPiece.id]=i==curPiece.id and v*.5 or v+0.26
                end
                break
            end
        end
    else
        MSG.log('warn','No solution found')
    end
end

local function reset()
    autoBack_interior(true)
    noControl=false

    TABLE.clear(matrix)
    score=0
    target=40
    pieceWeights={1,1,1,1,1,1,1}
    newPiece()

    texts:clear()
    texts:add{
        y=-180,
        text=Text.tutorial_shape_1,
        fontSize=40,
        style='appear',
        duration=6.26,
    }
    texts:add{
        y=-120,
        text=Text.tutorial_shape_2,
        fontSize=25,
        style='appear',
        a=0.26,
        duration=6.26,
    }

    TABLE.clear(choices)
    for i=1,7 do
        local p=TABLE.copyAll((Brik.get(i)))
        p.color=RGB9[defaultBrikColor[p.id]]
        choices[i]=p
    end
end

local function endGame(passLevel)
    noControl=true
    texts:add{
        text=passLevel==0 and Text.tutorial_notpass or Text.tutorial_pass,
        color=({[0]=COLOR.lR,COLOR.lG,COLOR.lY})[passLevel],
        fontSize=40,
        k=1.5,
        fontType='bold',
        style='beat',
        styleArg=1,
        duration=2.6,
        inPoint=.1,
        outPoint=0,
    }
    autoBack_interior()
end

local function answer(ansID)
    if noControl then
        if ansID==curPiece.id then
            FMOD.effect('move_failed')
        end
        return
    end
    if ansID==curPiece.id then
        if #matrix==0 then
            matrix[1]=TABLE.new(false,fieldW)
        end
        AI.util.lockPiece(matrix,curPiece.shape,curPiece.x)
        FMOD.effect('drop_old')
        FMOD.effect('lock')
        local m1=TABLE.copy(matrix)
        local lines=AI.util.clearLine(matrix)
        newPiece()
        matrix=m1
        if lines>0 then
            noControl=0.26
        end
    else
        FMOD.effect('move_failed')
    end
end

function scene.load()
    reset()
    playBgm('space')
end
function scene.unload()
    texts:clear()
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    local action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        reset()
    elseif action=='back' then
        if sureCheck('back') then SCN.back('none') end
    end
    return true
end

function scene.update(dt)
    if noControl then
        noControl=noControl-dt
        if noControl<=0 then
            local lines=AI.util.clearLine(matrix)
            if lines>0 then gameSoundFunc.clear(lines) end
            if #matrix==0 then
                FMOD.effect('clear_all')
            end
            -- newPiece()
            noControl=nil
        end
    end
    if pieceSpawnTimer>0 then
        pieceSpawnTimer=math.max(pieceSpawnTimer-dt,0)
    end

    if texts then texts:update(dt) end
end

local cell=60
local ansCell=50
function scene.draw()
    gc.replaceTransform(SCR.xOy_m)

    gc.push('transform')
    gc.translate(0,162)
    gc.translate(-fieldW/2*cell,0)
        -- Matrix
        gc.setColor(COLOR.DL)
        gc.rectangle('fill',-2,0,fieldW*cell+4,2)
        gc.draw(transition_image,-2,0,-math.pi/2,cell*4/127,2)
        gc.draw(transition_image,fieldW*cell,0,-math.pi/2,cell*4/127,2)
        for y=1,#matrix do
            for x=1,fieldW do
                if matrix[y][x] then
                    gc.rectangle('fill',(x-1)*cell,-(y-1)*cell,cell,-cell)
                end
            end
        end
        -- Dropping Piece
        if curPiece then
            local dy=pieceSpawnTimer^2*126
            gc.translate(cell*(curPiece.x-1),-curPiece.y*cell-dy)
            -- gc.setColor(curPiece.color)
            local h=#curPiece.shape
            for y=1,#curPiece.shape do
                for x=1,#curPiece.shape[y] do
                    if curPiece.shape[y][x] then
                        for slice=0,7 do
                            gc.setColor(1,1,1,.62/(1+y-slice/8)-(h<=2 and .2 or .16)-dy/260)
                            gc.rectangle('fill',(x-1)*cell,-(y-1-slice/8)*cell-cell,cell,-cell/8)
                        end
                    end
                end
            end
        end
    gc.pop()

    -- Choices
    for i=1,#choices do
        gc.push('transform')
        gc.translate(220*(i-1-(#choices-1)/2),300)
        local mat=choices[i].shape
        gc.translate(-#mat[1]*ansCell/2,#mat*ansCell/2)
        gc.setColor(choices[i].color)
        for y=1,#mat do
            for x=1,#mat[y] do
                if mat[y][x] then
                    GC.rectangle('fill',(x-1)*ansCell,-(y-1)*ansCell,ansCell,-ansCell)
                end
            end
        end
        gc.pop()
    end

    -- Score
    gc.setColor(1,1,1,.42)
    FONT.set(80,'bold')
    GC.mStr(score.."/"..target,500,-26)

    -- Floating texts
    if texts then
        gc.replaceTransform(SCR.xOy_m)
        gc.scale(2)
        texts:draw()
    end
end

scene.widgetList={
    {type='button',pos={.5,.5},x=220*(0-3),y=300,w=210,sound_trigger=false,code=function() answer(1) end},
    {type='button',pos={.5,.5},x=220*(1-3),y=300,w=210,sound_trigger=false,code=function() answer(2) end},
    {type='button',pos={.5,.5},x=220*(2-3),y=300,w=210,sound_trigger=false,code=function() answer(3) end},
    {type='button',pos={.5,.5},x=220*(3-3),y=300,w=210,sound_trigger=false,code=function() answer(4) end},
    {type='button',pos={.5,.5},x=220*(4-3),y=300,w=210,sound_trigger=false,code=function() answer(5) end},
    {type='button',pos={.5,.5},x=220*(5-3),y=300,w=210,sound_trigger=false,code=function() answer(6) end},
    {type='button',pos={.5,.5},x=220*(6-3),y=300,w=210,sound_trigger=false,code=function() answer(7) end},
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
