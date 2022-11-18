minoAtkSys={}

local function _checkAtkSys(sys)
    assert(type(sys)=='table','AtkSys must be table')
    assert(not sys.init or type(sys.init)=='function','AtkSys.init must be function (if exist)')
    assert(type(sys.drop)=='function','AtkSys.init must be function')
    return sys
end

minoAtkSys.none=    _checkAtkSys(require'assets.game.atksys_mino.none')
minoAtkSys.basic=   _checkAtkSys(require'assets.game.atksys_mino.basic')
minoAtkSys.modern=  _checkAtkSys(require'assets.game.atksys_mino.modern')
minoAtkSys.nextgen= _checkAtkSys(require'assets.game.atksys_mino.nextgen')
minoAtkSys.galaxy=  _checkAtkSys(require'assets.game.atksys_mino.galaxy')

return minoAtkSys
