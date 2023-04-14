return {
    mino={
        -- Basic
        statistics=require'assets.game.mechanicLib.mino.statistics',

        -- Mode
        sprint=require'assets.game.mechanicLib.mino.sprint',
        survivor=require'assets.game.mechanicLib.mino.survivor',
        hypersonic=require'assets.game.mechanicLib.mino.hypersonic',

        -- Utility
        sequence=require'assets.game.mechanicLib.mino.sequence',
        limit=require'assets.game.mechanicLib.mino.limit',
        stack=require'assets.game.mechanicLib.mino.stack',
    },
    puyo={
        -- Utility
        sequence=require'assets.game.mechanicLib.puyo.sequence',
    },
    gem={},
}
