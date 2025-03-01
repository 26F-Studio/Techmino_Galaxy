--[[
    If you want to contribute translations, play and unlock "Exterior" chapter first
    Try keeping all language files have same line count, will make translators easier to find what's missing
    You can check if there are missing strings by "Ctrl + [Pick a Language]"
    Don't ignore the "TRASLATING NOTE" mark, it's necessary to be accurate because there's lore and memes
    Ask MrZ for more information if you cannot fully understand the text, don't worry about disturbing me!
]]
---@class Techmino.I18N
local L={
    -- Info
    sureText={
        back="Press again to go back",
        quit="Press again to quit",
        reset="Press again to reset",
        enter="Press again to enter",
    },
    setting_needRestart="This setting will take effect after reboot",
    noMode="Could not load mode '$1': $2",
    interior_crash="Sandbox exited due to performance rate overflow",
    booting_changed="Booting application changed",
    musicroom_lowVolume="Please increase BGM volume (bottom right)",
    bgm_collected="BGM collected: $1",
    autoGC="[Auto GC] Low Memory",
    batteryWarn={
        "See you!",
        "Battery depleted, popup may appear soon",
        "Low battery, please charge",
        "Device power insufficient, may affect performance",
    },

    -- In-Game
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
    clearLines="$1 Lines",

    combo_small="$1 Combo",
    combo_large="$1 Combo!",
    mega_combo="MEGACMB",

    charge="CHG",
    spin="$1-spin",

    allClear="ALL CLEAR",
    halfClear="Half Clear",

    target_piece="Piece",
    target_line="Line",
    target_key="Key",
    target_time="Time",
    target_score="Score",
    target_combo="Combo",
    target_ac="AC",
    target_hc="HC",
    target_tss="TSS",
    target_tsd="TSD",
    target_tst="TST",
    target_tsq="TS?",
    target_tspin="T-Spin",
    target_techrash="Techrash",
    target_wave="Wave",

    -- About-Game
    pause="Pause",

    goal_reached="Goal Reached",

    -- Widget texts
    button_back="Back",

    simulation_title="Simulations",
    graph_brik_title="M-Graph", -- TRASLATING NOTE: from "Knowledge Graph" (AI domain)
    settings_title="Settings",

    setting_softdropSkipAsd="Skip Drop Delay",
    setting_shakeness="Shakiness",
    setting_hitWavePower="Hitwave Power",

    setting_mainVol="Main Volume",
    setting_bgm="BGM",
    setting_sfx="SFX",
    setting_vib="VIB",
    setting_handling="Handling…",
    setting_keymapping="Key mappings…",
    setting_enableTouching="Enable touch control",
    setting_touching="Touch controls…",
    setting_test="Test",
    setting_tryTestInGame="Cannot test during game",
    setting_tryApplyAudioInGame="Cannot apply during game",

    setting_sysCursor="External cursor",
    setting_clickFX="Click FX",
    setting_power="Terminal State",
    setting_clean="VRAM Boost",
    setting_fullscreen="Fullscreen",
    setting_portrait="Portrait",
    setting_autoMute="Mute when idle",
    setting_showTouch="Show touches",

    setting_maxTPS="Max TPS",
    setting_updateRate="Update Rate",
    setting_renderRate="Render Rate",
    setting_stability="Tick Stability",
    setting_msaa="MSAA",
    setting_fmod_maxChannel="Max Channel",
    setting_fmod_DSPBufferCount="DSPBufferCount",
    setting_fmod_DSPBufferLength="DSPBufferLength",
    setting_apply="Apply",

    setting_discord="Discord Rich Presence",

    setting_hint_asd="Auto Shift Delay",-- Add translation with \n[second line]
    setting_hint_asp="Auto Shift Period",-- Add translation with \n[second line]
    setting_hint_adp="Auto Drop Period",-- Add translation with \n[second line]
    setting_hint_ash="Auto Shift Halt",-- Add translation with \n[second line]
    setting_hint_stability="Stabler tick interval but higher CPU usage\nUse minimal value that can keep TPS stable",

    lang_note="The original languages are Chinese & English.\nAll translations are contributed by volunteers and it may not be 100% accurate\nThere are some terms not translated directly, please check Zictionary for more information",

    keyset_title="Keybinds",
    keyset_brik_moveLeft=   "Move Left",
    keyset_brik_moveRight=  "Move Right",
    keyset_brik_rotateCW=   "Rotate CW",
    keyset_brik_rotateCCW=  "Rotate CCW",
    keyset_brik_rotate180=  "Rotate 180",
    keyset_brik_softDrop=   "Soft Drop",
    keyset_brik_hardDrop=   "Hard Drop",
    keyset_brik_holdPiece=  "Hold Piece",
    keyset_brik_skip=       "Skip",

    keyset_gela_moveLeft=   "Move Left",
    keyset_gela_moveRight=  "Move Right",
    keyset_gela_rotateCW=   "Rotate CW",
    keyset_gela_rotateCCW=  "Rotate CCW",
    keyset_gela_rotate180=  "Rotate180",
    keyset_gela_softDrop=   "Soft Drop",
    keyset_gela_hardDrop=   "Hard Drop",
    keyset_gela_skip=       "Skip",

    keyset_acry_swapLeft=    "Swap Left",
    keyset_acry_swapRight=   "Swap Right",
    keyset_acry_swapUp=      "Swap Up",
    keyset_acry_swapDown=    "Swap Down",
    keyset_acry_twistCW=     "Rotate CW",
    keyset_acry_twistCCW=    "Rotate CCW",
    keyset_acry_twist180=    "Rotate180",
    keyset_acry_moveLeft=    "Cursor Left",
    keyset_acry_moveRight=   "Cursor Right",
    keyset_acry_moveUp=      "Cursor Up",
    keyset_acry_moveDown=    "Cursor Down",
    keyset_acry_skip=        "Skip",

    keyset_func1= "Function 1",
    keyset_func2= "Function 2",
    keyset_func3= "Function 3",
    keyset_func4= "Function 4",
    keyset_func5= "Function 5",

    keyset_sys_view=    "View",
    keyset_sys_restart= "Restart",
    keyset_sys_chat=    "Chat",
    keyset_sys_back=    "Menu back",
    keyset_sys_quit=    "End game",
    keyset_sys_setting= "Setting",
    keyset_sys_help=    "Quick Help",
    keyset_sys_up=      "Up",
    keyset_sys_down=    "Down",
    keyset_sys_left=    "Left",
    keyset_sys_right=   "Right",
    keyset_sys_select=  "Select",

    keyset_pressKey="Press a key",
    keyset_deleted= "*Deleted*",
    keyset_info=    "[Esc]: cancel\n[Backspace]: delete\n[Double Esc]: set to Esc",

    stick2_switch="2-way joystick",
    stick4_switch="4-way joystick",
    setting_touch_button="Add/Remove button",
    setting_touch_buttonSize="Button size",
    setting_touch_iconSize="Icon size",
    setting_touch_buttonShape="Change button shape",
    setting_touch_stickSize="Stick length",
    setting_touch_ballSize="Stick size",

    main_in_dig="Dig",
    main_in_sprint="40 Lines",
    main_in_marathon="Marathon",
    main_in_tutorial="Tutorial",
    main_in_sandbox="Sandbox",
    main_in_settings="Settings",

    main_out_settings="Settings",
    main_out_stat="Statistics",
    main_out_dict="Dictionary",
    main_out_lang="Language",
    main_out_about="System info",
    main_out_single="Single",
    main_out_multi="Multiple",

    musicroom_title="Musicroom",
    musicroom_richloop="Rich Loop",
    musicroom_fullband="Full Band",
    musicroom_section='Chorus',
    musicroom_autoplay="Auto Change",

    about_title="About",
    about_module="Modules:",
    about_toolchain="Toolchain:",
    about_peopleLost="You lost $1 !",

    -- Mode name
    exteriorModeInfo={ -- TRASLATING NOTE: Unnecessary to be accurate, try to quote some short proverbs in your language
        sprint=           {"Sprint","Speed is all we need"},
        sequence=         {"Sequence","Face strange piece sequences"},
        invis=            {"Invis","Pieces go invisible after falling"},
        spin=             {"Spin","Build special terrains"},
        marathon=         {"Marathon","Fight against increasing gravity"},
        allclear=         {"All Clear","Controllable All-Clear is possible"},
        combo=            {"Combo","Everyone loves combo"},
        hypersonic=       {"Hypersonic","Break the limit of gravity"},
        dig=              {"Dig","Deal with neat garbage lines"},
        excavate=         {"Excavate","Deal with complex garbage lines"},
        backfire=         {"Backfire","Attacks out, garbages in"},
        drill=            {"Drill","Deal with standard garbage lines"},
        survivor=         {"Survivor","Survive under pressure"},

        chain=            {"Chain","Connect same color to clear"},
        action=           {"Action","Use both keyboard & mouse"},
    },

    -- Submode Task Texts
    modeTask_unknown_title="???",
    modeTask_unknown_desc="??????",

    modeTask_spin_piece_title="Piece",
    modeTask_spin_piece_desc="Clear a Spin Single",
    modeTask_spin_column_title="Column",
    modeTask_spin_column_desc="Clear a Spin Double",

    modeTask_sequence_flood_title="Flood",
    modeTask_sequence_flood_desc="Clear with S or Z",
    modeTask_sequence_drought_title="Drought",
    modeTask_sequence_drought_desc="Clear with J or L",
    modeTask_sequence_saw_title="Saw",
    modeTask_sequence_saw_desc="Clear with T",
    modeTask_sequence_rect_title="Rect",
    modeTask_sequence_rect_desc="Clear with O",
    modeTask_sequence_rain_title="Rain",
    modeTask_sequence_rain_desc="Clear with I",
    modeTask_sequence_mph_title="MPH",
    modeTask_sequence_mph_desc="Any clear in 4 pieces",
    modeTask_sequence_pento_title="Pento",
    modeTask_sequence_pento_desc="Clear with a Pento",
    modeTask_sequence_unknown_desc="Clear with a ???",

    modeTask_invis_haunted_title="Haunted",
    modeTask_invis_haunted_desc="Clear 4 lines",
    modeTask_invis_hidden_title="Hidden",
    modeTask_invis_hidden_desc="Clear a Techrash",

    modeTask_hypersonic_low_title="Low",
    modeTask_hypersonic_low_desc="Clear 4 lines",
    modeTask_hypersonic_high_title="High",
    modeTask_hypersonic_high_desc="Clear a Techrash",
    modeTask_hypersonic_hidden_title="Hidden",
    modeTask_hypersonic_hidden_desc="Techrash in 6s",
    modeTask_hypersonic_titanium_title="Titanium",
    modeTask_hypersonic_titanium_desc="no-hold Techrash in 10s ",

    modeTask_excavate_shale_title="Shale",
    modeTask_excavate_shale_desc="Dig with Double-",
    modeTask_excavate_volcanics_title="Volcanics",
    modeTask_excavate_volcanics_desc="Dig with Triple+",
    modeTask_excavate_checker_title="Checker",
    modeTask_excavate_checker_desc="Dig with Split",
    modeTask_excavate_unknown_desc="Dig with ???",

    modeTask_backfire_break_title="Scattered",
    modeTask_backfire_break_desc="Clear 8 lines",
    modeTask_backfire_normal_title="Normal",
    modeTask_backfire_normal_desc="Send 6 lines in 6 lines",
    modeTask_backfire_amplify_title="Amplify",
    modeTask_backfire_amplify_desc="Send 8 lines in 4 lines",

    modeTask_survivor_scattered_title="Scattered",
    modeTask_survivor_scattered_desc="Send 8 lines",
    modeTask_survivor_power_title="Power",
    modeTask_survivor_power_desc="Send 8 lines with 1 Eff",
    modeTask_survivor_spike_title="Spike",
    modeTask_survivor_spike_desc="Send 8 lines with 2 Eff",

    -- Achievement
    ---@enum (key) Techmino.Text.Achievement
    achievementMessage={ -- TRASLATING NOTE: The tone can be lighter
        dict_shortcut="Hotkey Expert",
        exterior_spin_howDareYou="How dare you",
        exterior_excavate_notDig="What are you doing?",
        exterior_invis_superBrain="Super Brain",
        exterior_invis_rhythmMaster="To the beat", -- Keep this as it is. Original from "osu!" title music
        exterior_hypersonic_holdlessTitan="You can hold",
        interior_console="What's this?",
        language_japanese="あ?",
        musicroom_recollection="Recollection is not a song",
        musicroom_piano="Nobody Piano", -- Neta of "Everyone Piano" Software
        dial_enter="Instrument?",
        menu_fastype="You seems enjoy typing",
    },

    -- Tutorial levels
    tutorial_basic="1. The Basics",
    tutorial_sequence="2. Next & Hold",
    tutorial_stackBasic="3. Basic Stacking",
    tutorial_finesseBasic="4. Basic Finesse",
    tutorial_finessePractice="5. Finesse Practice",
    tutorial_allclearPractice="6. All Clear Practice",
    tutorial_techrashPractice="7. Techrash Practice",
    tutorial_finessePlus="8. Elegant Moves",

    tutorial_notpass="Failed",
    tutorial_pass="PASS",

    tutorial_basic_1="Welcome to Techmino!",
    tutorial_basic_2="1. The Basics",
    tutorial_basic_3="Use the left and right keys to move your current piece",
    tutorial_basic_4="Press the hard drop key to place piece, clearing filled lines",
    tutorial_basic_5="You can also rotate the piece with the rotation keys",

    tutorial_sequence_1="2. Next & Hold",
    tutorial_sequence_2="Oops, this piece doesn't seem to fit into the hole…",
    tutorial_sequence_3="…but now you can see what pieces are coming next",
    tutorial_sequence_4="Use the Hold key to adjust the order of the pieces",

    tutorial_stackBasic_1="3. Basic Stacking",
    tutorial_stackBasic_2="Try to keep the top levels \"flat\", to make the danger meter on the left low",
    tutorial_stackBasic_3="This is the usual goal for beginners",
    tutorial_stackBasic_4="Pieces are often placed \"lying down\", not \"standing up\"",
    tutorial_stackBasic_5="This ensures more choices for future pieces and avoiding making holes",

    tutorial_finesseBasic_0="4. Basic Finesse",
    tutorial_finesseBasic_0_1="“Finesse” is a way to simplify your key-pressing, which can speed you up and reduce misdrops",
    tutorial_finesseBasic_1="①Double Rotation Keys",
    tutorial_finesseBasic_1_1="Go binding both rotation keys, for 1×CCW is equivalent to 3×CW",
    tutorial_finesseBasic_1_T="180° Rotation is not mandatory here",
    tutorial_finesseBasic_1_2="Quest: Drop piece to target position with 1×rotate only",
    tutorial_finesseBasic_2="②Backtrack",
    tutorial_finesseBasic_2_1="Playfield has a width of 10, piece width is around 3 cells and spawns in the middle",
    tutorial_finesseBasic_2_2="So divide the field to three parts: L/Mid/R, moving piece to the part at first, then finetune with tapping move",
    tutorial_finesseBasic_2_3="And you only need two types of movement : \"move one cell\" (tap 1-2 times) and \"move to side\"",
    tutorial_finesseBasic_2_T="Use as smallest ASD as you can, but make it still possible to use the 2 movements explained before",
    tutorial_finesseBasic_2_4="Quest: Drop piece to target position with 2×move",
    tutorial_finesseBasic_3="③Wall-turn",
    tutorial_finesseBasic_3_1="You see, piece rotates around a specified center (white dot)",
    tutorial_finesseBasic_3_2="For piece: Z(red)/S(green)/I(cyan), CW and CCW rotation will make piece lean aside",
    tutorial_finesseBasic_3_3="Quest: Drop piece to target position with 1×move and 1×rotate",
    tutorial_finesseBasic_4_1="By combining all three techniques above",
    tutorial_finesseBasic_4_2="About 3 key-presses can move piece to any position",

    tutorial_finessePractice_1="5. Finesse Practice",
    tutorial_finessePractice_2="Minimize the number of key presses",
    tutorial_finessePractice_par="Par",

    tutorial_allclearPractice_1="6. All Clear Practice",
    tutorial_allclearPractice_2="Do as much All Clear as possible",

    tutorial_techrashPractice_1="7. Techrash Practice",
    tutorial_techrashPractice_2="Clear as much Techrashes as possible",

    tutorial_finessePlus_1="8. Elegant Moves",
    tutorial_finessePlus_2="Use as less key-pressing as possible",
}
return L
