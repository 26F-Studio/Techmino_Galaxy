-- Fake require function, only do string manipulation, real require when needed
local require=simpRequire(function(path) return 'assets/game/mechanicLib/'..path..'.lua' end)

---@class Techmino.Mech
local mechLib={
    common={
        timer=require'common/timer',
        finish=require'common/finish',
    },
    mino={
        -- Basic
        actions=require'mino/actions',
        statistics=require'mino/statistics',
        sequence=require'mino/sequence',
        clearRule=require'mino/clearRule',
        attackSys=require'mino/attackSys',
        misc=require'mino/misc',

        -- Mode
        sprint=require'mino/sprint',
        dig=require'mino/dig',
        survivor=require'mino/survivor',
        backfire=require'mino/backfire',
        marathon=require'mino/marathon',
        hypersonic=require'mino/hypersonic',
        comboPractice=require'mino/comboPractice',
        tsdChallenge=require'mino/tsdChallenge',
        techrashChallenge=require'mino/techrashChallenge',
        acGenerator=require'mino/acGenerator',

        -- Special
        stack=require'mino/stack',
        squeeze=require'mino/squeeze',
        progress=require'mino/progress',
        music=require'mino/music',
    },
    puyo={
        -- Basic
        actions=require'puyo/actions',
        statistics=require'puyo/statistics',
        sequence=require'puyo/sequence',
        colorSet=require'puyo/colorSet',
        attackSys=require'puyo/attackSys',
        misc=require'puyo/misc',
    },
    gem={
        -- Basic
        actions=require'gem/actions',
    },
}
return mechLib
