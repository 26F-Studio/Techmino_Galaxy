-- Fake require function, only do string manipulation, real require when needed
local require=simpRequire(function(path) return 'assets/game/mechanicLib/'..path..'.lua' end)

---@class Techmino.Mech
local mechLib={
    common={
        timer=require'common/timer',
        finish=require'common/finish',
        characterAnim=require'common/characterAnim',
    },
    brik={
        -- Basic
        actions=require'brik/actions',
        statistics=require'brik/statistics',
        sequence=require'brik/sequence',
        clearRule=require'brik/clearRule',
        attackSys=require'brik/attackSys',
        misc=require'brik/misc',

        -- Mode
        sprint=require'brik/sprint',
        dig=require'brik/dig',
        survivor=require'brik/survivor',
        backfire=require'brik/backfire',
        marathon=require'brik/marathon',
        hypersonic=require'brik/hypersonic',
        comboPractice=require'brik/comboPractice',
        tsdChallenge=require'brik/tsdChallenge',
        techrashChallenge=require'brik/techrashChallenge',
        acGenerator=require'brik/acGenerator',

        -- Special
        stack=require'brik/stack',
        squeeze=require'brik/squeeze',
        progress=require'brik/progress',
        music=require'brik/music',
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
    },
}
return mechLib
