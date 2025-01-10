---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.newPlayer(2,'brik')
        GAME.newPlayer(3,'gela')
        GAME.setMain(1)
        PlayBGM('battle')
    end,
    settings={
        brik={
            dropDelay=1000,
            lockDelay=2000,
            atkSys='modern',
            skin='touhou.brik_reimu',
            event={
                playerInit=function(P)
                    -- mechLib.brik.squeeze.turnOn_auto(P,4)
                    -- P:setAction('func1',function(P) mechLib.brik.stack.turnOn_auto(P,true,60e3) end)
                    P.modeData.character={
                        image=TEX.touhou.reimu,
                        effect=NULL,
                    }
                    P:setAction('func1',mechLib.common.characterAnim.start)
                end,
            },
        },
        gela={
            dropDelay=1000,
            lockDelay=2000,
            -- colorSet='classic',
            -- seqType='twin_2S4C',
        },
    },
}
