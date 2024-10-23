-- Fake require function, only do string manipulation, real require when needed
local require=simpRequire(function(path) return 'assets/game/mechanicLib/'..path..'.lua' end)

---@class Techmino.MechLib
local mechLib={
    common={
        -- Tool
        task=require'common/task',
        timer=require'common/timer',
        music=require'common/music',
        characterAnim=require'common/characterAnim',
    },
    brik={
        -- Basic
        actions=require'brik/actions',
        sequence=require'brik/sequence',
        clearRule=require'brik/clearRule',
        attackSys=require'brik/attackSys',
        stack=require'brik/stack',
        squeeze=require'brik/squeeze',
        misc=require'brik/misc',

        -- Mode
        dig=require'brik/dig',
        survivor=require'brik/survivor',
        marathon=require'brik/marathon',
        chargeLimit=require'brik/chargeLimit',
        comboGenerator=require'brik/comboGenerator',
        allclearGenerator=require'brik/allclearGenerator',
    },
    gela={
        -- Basic
        actions=require'gela/actions',
        sequence=require'gela/sequence',
        colorSet=require'gela/colorSet',
        attackSys=require'gela/attackSys',
        misc=require'gela/misc',
    },
    acry={
        -- Basic
        actions=require'acry/actions',
        propSys=require'acry/propSys',
        mergeSys=require'acry/mergeSys',
        attackSys=require'acry/attackSys',
    },
}
return mechLib
