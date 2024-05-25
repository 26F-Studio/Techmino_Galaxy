-- Fake require function, only do string manipulation, real require when needed
local require=simpRequire(function(path) return 'assets/game/mechanicLib/'..path..'.lua' end)

---@class Techmino.Mech
local mechLib={
    common={
        -- Tool
        timer=require'common/timer',
        characterAnim=require'common/characterAnim',

        -- Story
        exterior=require'common/exterior',
    },
    brik={
        -- Basic
        actions=require'brik/actions',
        statistics=require'brik/statistics',
        sequence=require'brik/sequence',
        clearRule=require'brik/clearRule',
        attackSys=require'brik/attackSys',
        stack=require'brik/stack',
        squeeze=require'brik/squeeze',
        misc=require'brik/misc',

        -- Mode
        sprint=require'brik/sprint',
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
        statistics=require'gela/statistics',
        sequence=require'gela/sequence',
        colorSet=require'gela/colorSet',
        attackSys=require'gela/attackSys',
        misc=require'gela/misc',
    },
    acry={
        -- Basic
        actions=require'acry/actions',
        mergeSys=require'acry/mergeSys',
        attackSys=require'acry/attackSys',
    },
}
return mechLib
