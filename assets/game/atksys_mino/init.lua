minoAtkSys={}

local function _checkAtkSys(sys)
    assert(type(sys)=='table','AtkSys must be table')
    assert(not sys.init or type(sys.init)=='function','AtkSys.init must be function (if exist)')
    assert(type(sys.drop)=='function','AtkSys.init must be function')
    return sys
end

minoAtkSys.None=    _checkAtkSys(require'assets.game.atksys_mino.none')
minoAtkSys.Basic=   _checkAtkSys(require'assets.game.atksys_mino.basic')
minoAtkSys.Modern=  _checkAtkSys(require'assets.game.atksys_mino.modern')
minoAtkSys.Nextgen= _checkAtkSys(require'assets.game.atksys_mino.nextgen')
minoAtkSys.Galaxy=  _checkAtkSys(require'assets.game.atksys_mino.galaxy')
