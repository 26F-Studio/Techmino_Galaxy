return{
    -- Clearing texts
    clearName={
        "Single",
        "Double",
        "Triple",
        "Techrash",
        "Pentacrash",
        "Hexacrash",
        "Heptacrash",
        "Octacrash",
        "Nonacrash",
        "Decacrash",
        "Undecacrash",
        "Dodecacrash",
        "Tridecacrash",
        "Tetradecacrash",
        "Pentadecacrash",
        "Hexadecacrash",
        "Heptadecacrash",
        "Octadecacrash",
        "Nonadecacrash",
        "Ultracrash",
        "Impossicrash",
    },

    combo=function(c)
        if     c<=9  then return c.." Combo"
        elseif c<=13 then return c.." Combo!"
        elseif c<=16 then return c.." Combo!!"
        elseif c<=19 then return c.." Combo!!!"
        else              return "MEGACMB"
        end
    end,

    spin='$1-spin',
    tuck='Tuck',

    allClear='ALL CLEAR',
    halfClear='Half Clear',

    -- Widget texts
    main_1_play="Play",
    main_1_setting="Setting",

    setting_das="DAS",
    setting_arr="ARR",
    setting_sdarr="SDARR",
    setting_shakeness="Shakeness",

    setting_mainVol="Main Volume",
    setting_bgm="BGM",
    setting_sfx="SFX",

    setting_sysCursor="System cursor",
    setting_clickFX="Click FX",
    setting_power="Battery Info",
    setting_clean="Quick Draw",
    setting_fullscreen="Fullscreen",
    setting_autoMute="Mute while unfocused",

    setting_maxFPS="Max FPS",
    setting_updRate="Update rate",
    setting_drawRate="Draw rate",

    setting_showTouch="Show touches",
}
