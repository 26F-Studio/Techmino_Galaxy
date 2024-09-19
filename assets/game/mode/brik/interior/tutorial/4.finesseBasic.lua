--[[
    关卡类似第一关的移动和旋转，但是教怎么极简
    落块位置会故意设在强调折返/撞墙转/SZ正反转这些点上
]]
---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('space',true)
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        readyDelay=1,
        spawnDelay=62,
        dropDelay=1e99,
        lockDelay=1e99,
        deathDelay=0,
        nextSlot=3,
        holdSlot=0,
        seqType='none',
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            gameStart=function(P)
                P.spawnTimer=1500
            end,
            afterDrop=function(P)
            end,
            afterLock=function(P)
            end,
            drawOnPlayer=function(P)
            end,
        },
        script={
            {cmd='say',arg={duration='1.5s',text="@tutorial_finesseBasic_1",y=-60}},
            -- {cmd='say',arg={duration='6.26s',text="@tutorial_pass",size=60,k=2,type='bold',style='beat',c=COLOR.lG,y=-30}},
            -- {cmd=function(P) if P.isMain then PROGRESS.setTutorialPassed(4,1) end end},
            -- "finish win",
        },
    }},
    result=autoBack_interior,
}
