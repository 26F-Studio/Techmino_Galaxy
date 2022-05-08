MinoAtkSys={}

local function _checkAtkSys(sys)
    assert(type(sys)=='table','AtkSys must be table')
    assert(not sys.init or type(sys.init)=='function','AtkSys.init must be function (if exist)')
    assert(type(sys.drop)=='function','AtkSys.init must be function')
    return sys
end

MinoAtkSys.None=    _checkAtkSys(require'assets.game.atksys_mino.none')
MinoAtkSys.Basic=   _checkAtkSys(require'assets.game.atksys_mino.basic')
MinoAtkSys.Modern=  _checkAtkSys(require'assets.game.atksys_mino.modern')
MinoAtkSys.Nextgen= _checkAtkSys(require'assets.game.atksys_mino.nextgen')
MinoAtkSys.Galaxy=  _checkAtkSys(require'assets.game.atksys_mino.galaxy')
