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

    -- Widget texts
    main_1_play="Play",
    main_1_setting="Setting",

    setting_das="DAS",
    setting_arr="ARR",
    setting_sdarr="SDARR",
    setting_shakeness="Shakeness",
    setting_hitWavePower="Hitwave Power",

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

    setting_key_touch="Touch",
    setting_key_test="Test",

    -- Key setting
    key_act_moveLeft=   "Act: Move Left",
    key_act_moveRight=  "Act: Move Right",
    key_act_rotateCW=   "Act: Rotate CW",
    key_act_rotateCCW=  "Act: Rotate CCW",
    key_act_rotate180=  "Act: Rotate180",
    key_act_holdPiece=  "Act: Hold Piece",
    key_act_softDrop=   "Act: Soft Drop",
    key_act_hardDrop=   "Act: Hard Drop",
    key_act_sonicDrop=  "Act: Sonic Drop",
    key_act_sonicLeft=  "Act: Sonic Left",
    key_act_sonicRight= "Act: Sonic Right",
    key_act_function1=  "Act: Function 1",
    key_act_function2=  "Act: Function 2",
    key_act_function3=  "Act: Function 3",
    key_act_function4=  "Act: Function 4",
    key_act_function5=  "Act: Function 5",
    key_act_function6=  "Act: Function 6",
    key_game_restart=   "Game: Restart",
    key_game_chat=      "Game: Chat",
    key_menu_up=        "Menu: Up",
    key_menu_down=      "Menu: Down",
    key_menu_left=      "Menu: Left",
    key_menu_right=     "Menu: Right",
    key_menu_confirm=   "Menu: Confirm",
    key_menu_back=      "Menu: Back",
    key_rep_pause=      "Rep: Pause",
    key_rep_prevFrame=  "Rep: Prev Frame",
    key_rep_nextFrame=  "Rep: Next Frame",
    key_rep_speedDown=  "Rep: Speed Down",
    key_rep_speedUp=    "Rep: Speed Up",
    key_rep_speed1_16x= "Rep: Speed 1/16x",
    key_rep_speed1_6x=  "Rep: Speed 1/6x",
    key_rep_speed1_2x=  "Rep: Speed 1/2x",
    key_rep_speed1x=    "Rep: Speed 1x",
    key_rep_speed2x=    "Rep: Speed 2x",
    key_rep_speed6x=    "Rep: Speed 6x",
    key_rep_speed16x=   "Rep: Speed 16x",

    setting_key_pressKey="Press a key",
    setting_key_deleted= "*Deleted*",
    setting_key_info=    "[Esc]: cancel\n[Backspace]: delete",

    setting_touch_stick2way="Virtual joystick",
    setting_touch_button="Add/Remove button",
    setting_touch_buttonSize="Button size",
    settinh_touch_buttonShape="Change button shape",
    setting_touch_stickLength="Stick length",
    setting_touch_stickSize="Stick size",
}
