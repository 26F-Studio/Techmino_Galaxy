return {
    common={
        timer=require'assets.game.mechanicLib.common.timer',
        finish=require'assets.game.mechanicLib.common.finish',
    },
    mino={
        -- Basic
        statistics=require'assets.game.mechanicLib.mino.statistics',
        sequence=require'assets.game.mechanicLib.mino.sequence',
        clearRule=require'assets.game.mechanicLib.mino.clearRule',
        attackSys=require'assets.game.mechanicLib.mino.attackSys',
        misc=require'assets.game.mechanicLib.mino.misc',

        -- Mode
        sprint=require'assets.game.mechanicLib.mino.sprint',
        dig=require'assets.game.mechanicLib.mino.dig',
        survivor=require'assets.game.mechanicLib.mino.survivor',
        backfire=require'assets.game.mechanicLib.mino.backfire',
        marathon=require'assets.game.mechanicLib.mino.marathon',
        hypersonic=require'assets.game.mechanicLib.mino.hypersonic',
        comboPractice=require'assets.game.mechanicLib.mino.comboPractice',
        tsdChallenge=require'assets.game.mechanicLib.mino.tsdChallenge',
        techrashChallenge=require'assets.game.mechanicLib.mino.techrashChallenge',

        -- Special
        stack=require'assets.game.mechanicLib.mino.stack',
        squeeze=require'assets.game.mechanicLib.mino.squeeze',
    },
    puyo={
        -- Basic
        statistics=require'assets.game.mechanicLib.puyo.statistics',
        sequence=require'assets.game.mechanicLib.puyo.sequence',
        attackSys=require'assets.game.mechanicLib.puyo.attackSys',
        misc=require'assets.game.mechanicLib.puyo.misc',
    },
    gem={},
}
