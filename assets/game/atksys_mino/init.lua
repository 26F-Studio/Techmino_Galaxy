local atksys={}

local function _checkAtkSys(sys)
    assert(type(sys)=='table','AtkSys must be table')
    assert(not sys.init or type(sys.init)=='function','AtkSys.init must be function (if exist)')
    assert(type(sys.drop)=='function','AtkSys.init must be function')
    return sys
end

atksys.None=    _checkAtkSys(require'assets.game.atksys_mino.none')
atksys.Basic=   _checkAtkSys(require'assets.game.atksys_mino.basic')
atksys.Modern=  _checkAtkSys(require'assets.game.atksys_mino.modern')
atksys.Nextgen= _checkAtkSys(require'assets.game.atksys_mino.nextgen')
atksys.Galaxy=  _checkAtkSys(require'assets.game.atksys_mino.galaxy')

return atksys
