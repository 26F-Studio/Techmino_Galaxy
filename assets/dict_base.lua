local baseDict={
    {'intro: aboutDict'},
    {'intro: setting_out',hidden=true},
    {'guide: noobGuide'},
    {'guide: keybinding'},
    {'guide: handling'},
    {'term1: field'},
    {'term1: piece'},
    {'term1: clear'},
    {'term1: clear_big',hidden=function() return false end},
    {'term1: clear_huge',hidden=function() return false end},
    {'term1: next_hold'},
    {'term2: tuning'},
    {'term2: buffered_input'},
    {'term2: combo'},
    {'term2: rotation_system'},
    {'term2: spin',hidden=function() return PROGRESS.getExteriorUnlock('spin') end},
    {'term2: all_clear',hidden=function() return PROGRESS.getExteriorUnlock('allclear') end},
    {'term2: charge',hidden=function() return PROGRESS.getExteriorUnlock('backfire') or PROGRESS.getExteriorUnlock('survivor') end},
    {'term2: sequence',hidden=function() return PROGRESS.getExteriorUnlock('sequence') end},
    {'term2: gravity',hidden=function() return PROGRESS.getExteriorUnlock('hypersonic') end},
    {'term2: delays',hidden=function() return PROGRESS.getExteriorUnlock('hypersonic') end},
    {'term2: death_condition'},
    {'term3: invisible',hidden=function() return PROGRESS.getExteriorUnlock('invis') end},
    {'term3: chain',hidden=function() return PROGRESS.getExteriorUnlock('chain') end},
    {'term3: spike'},
    {'term3: speeds'},
    {'term3: misaction'},
    {'term3: finesse'},
    {'other: 26f_studio'},
}

return baseDict
