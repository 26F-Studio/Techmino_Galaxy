return {
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

    -- Key setting
    actionNames={
        act_moveLeft=   "Move Left",
        act_moveRight=  "Move Right",
        act_rotateCW=   "Rotate CW",
        act_rotateCCW=  "Rotate CCW",
        act_rotate180=  "Rotate 180",
        act_holdPiece=  "Hold Piece",
        act_softDrop=   "Soft Drop",
        act_hardDrop=   "Hard Drop",
        act_sonicDrop=  "Sonic Drop",
        act_sonicLeft=  "Sonic Left",
        act_sonicRight= "Sonic Right",
        act_function1=  "Function 1",
        act_function2=  "Function 2",
        act_function3=  "Function 3",
        act_function4=  "Function 4",
        act_target1=    "Target 1",
        act_target2=    "Target 2",
        act_target3=    "Target 3",
        act_target4=    "Target 4",
        game_restart=   "Restart",
        game_chat=      "Open Chat",
        menu_up=        "(Menu) Up",
        menu_down=      "(Menu) Down",
        menu_left=      "(Menu) Left",
        menu_right=     "(Menu) Right",
        menu_confirm=   "(Menu) Confirm",
        menu_back=      "(Menu) Back",
        rep_pause=      "(Rep) Pause",
        rep_prevFrame=  "(Rep) Prev Frame",
        rep_nextFrame=  "(Rep) Next Frame",
        rep_speedDown=  "(Rep) Speed Down",
        rep_speedUp=    "(Rep) Speed Up",
        rep_speed1_16x= "(Rep) Speed 1/16x",
        rep_speed1_6x=  "(Rep) Speed 1/6x",
        rep_speed1_2x=  "(Rep) Speed 1/2x",
        rep_speed1x=    "(Rep) Speed 1x",
        rep_speed2x=    "(Rep) Speed 2x",
        rep_speed6x=    "(Rep) Speed 6x",
        rep_speed16x=   "(Rep) Speed 16x",
    },

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
    setting_showTouch="Show touches",

    setting_maxFPS="Max FPS",
    setting_updRate="Update rate",
    setting_drawRate="Draw rate",

    setting_test="Test",
}
