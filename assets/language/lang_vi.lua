--[[
    If you want to contribute translations, play and unlock "Exterior" chapter first
    Try keeping all language files have same line count, will make translators easier to find what's missing
    You can check if there are missing strings by "Ctrl + [Pick a Language]"
    Don't ignore the "TRASLATING NOTE" mark, it's necessary to be accurate because there's lore and memes
    Ask MrZ for more information if you cannot fully understand the text, don't worry about disturbing me!
]]
return {
    -- Info
    sureText={
        back="Nhấn lần nữa để trở về",
        quit="Nhấn lần nữa để thoát",
        reset="Nhấn lần nữa để đặt lại",
        enter="Nhấn lần nữa để vào",
    },
    setting_needRestart="Hãy khởi động lại để cài đặt bạn vừa chỉnh có hiệu lực",
    noMode="Không thể tải chế độ '$1': $2",
    interior_crash="Bạn chơi quá hay, hộp cát không thể xử lý được nên nó đã bị crash", -- Thanks User670 for suggesting me this alternative
    booting_changed="Phát hiện tệp boot hiện tại bị hỏng, đã thay thế bằng file dự phòng!",
    musicroom_lowVolume="Vặn âm lượng nhạc nền lên đi! (Ở dưới góc phải màn hình đấy!)",
    bgm_collected="Nhạc nền mới: $1",
    autoGC="[TRÌNH DỌN RÁC TỰ ĐỘNG] Thanh RAM đang đầy!",
    batteryWarn={
        "Gặp lại bạn sau nhé!",
        "Sắp hết pin rồi, coi chừng popup nó nhảy tùm lum kìa!",
        "Ựa, pin gần cạn rồi, bạn nên đi sạc đi!",
        "Pin cạn rồi trời ơi! Máy sẽ sập nguồn trong vài giây nữa!"
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

    clearLines="$1 Hàng",

    combo_small="$1 Combo",
    combo_large="$1 Combo!",
    mega_combo="MEGACMB",

    charge="CHG",
    spin="$1-spin",

    allClear="ALL CLEAR",
    halfClear="Half Clear",

    target_piece="Gạch",
    target_line="Hàng",
    target_key="Lần bấm nút",
    target_time="T.gian",
    target_score="Điểm",
    target_combo="Combo",
    target_ac="AC",
    target_hc="HC",
    target_tss="TSS",
    target_tsd="TSD",
    target_tst="TST",
    target_tsq="TS?",
    target_tspin="T-Spin",
    target_techrash="Techrash",
    target_wave="Đợt tấn công",

    -- About-Game
    pause="Đã tạm dừng",

    goal_reached="Đã hoàn thành mục tiêu!",

    -- Widget texts
    button_back="Trở về",

    simulation_title="Trình giả lập",
    graph_brik_title="M-Graph",   -- from "Knowledge Graph" (AI domain), it used to be translated to "M-Graph (Bản đồ Mino)" and "M-Graph (Đồ thị Mino)"
    settings_title="Cài đặt",

    setting_hint_asd="Auto Shift Delay\nThời gian gạch cần chờ để xác nhận có tự động di chuyển hay không",    -- Add translation with \n[second line]
    setting_hint_asp="Auto Shift Period\nTốc độ tự di chuyển của gạch (tính bằng ms/ô)",   -- Add translation with \n[second line]
    setting_hint_adp="Auto Drop Period\nTốc độ tự thả nhẹ của gạch (tính bằng ms/ô)",    -- Add translation with \n[second line]
    setting_hint_ash="Auto Shift Halt\nNên hoãn IMS khoảng thời gian bao lâu\ntính từ khi gạch mới xuất hiện",     -- Add translation with \n[second line]
    setting_softdropSkipAsd="Bỏ qua Drop Delay (thời gian gạch cần chờ\nđể xác nhận có tự thả rơi hay không)",
    setting_shakeness="Độ lắc bảng",
    setting_hitWavePower="Hitwave Power",

    setting_mainVol="Âm lượng tổng",
    setting_bgm="Nhạc nền",
    setting_sfx="Hiệu ứng",
    setting_vib="Rung",
    setting_handling="Handling…",
    setting_keymapping="Cài đặt phím…",
    setting_enableTouching="Điều khiển bằng cảm ứng",
    setting_touching="Bố cục các nút…",
    setting_test="Thử phím",
    setting_tryTestInGame="Không thể thử phím khi đang ở trong game",
    setting_tryApplyAudioInGame="Không thể áp dụng lại cài đặt khi đang ở trong game",

    setting_sysCursor="Sử dụng trỏ chuột hệ thống",
    setting_clickFX="Hiệu ứng nhấp chuột",
    setting_power="Trạng thái cuối cùng",   -- Ok I searched StackOverflow and asked Bing AI for this (ChatGPT was busy that time)
    setting_clean="Tăng tốc độ VRAM",
    setting_fullscreen="Toàn màn hình",
    setting_portrait="Màn hình hướng dọc",
    setting_autoMute="Tắt tiếng khi ở ngoài game",
    setting_showTouch="Hiện vị trí vừa chạm",

    setting_maxTPS="FPS tối đa",
    setting_updateRate="Tần suất chạy logic",
    setting_renderRate="Tần suất vẽ khung hình",
    setting_msaa="MSAA - Khử răng cưa",
    setting_fmod_maxChannel="Số kênh âm thanh tối đa",
    setting_fmod_DSPBufferCount="Số lượng bộ đệm âm thanh",
    setting_fmod_DSPBufferLength="Độ dài bộ đệm âm thanh",
    setting_apply="Áp dụng",

    lang_note="Tiếng Trung giản thể là ngôn ngữ gốc của game này. Bản dịch này được dịch từ bản tiếng Anh\nCác bản dịch được các tình nguyện viên đóng góp và chúng có thể không chính xác 100%\nCó một số thuật ngữ không được dịch trực tiếp trong game. Vui lòng tra Zictionary để tìm hiểu thêm",

    -- GHI CHÚ: Viết hoa các từ chỉ hướng!
    keyset_title=           "Bố cục phím",
    keyset_brik_moveLeft=   "Sang Trái",
    keyset_brik_moveRight=  "Sang Phải",
    keyset_brik_rotateCW=   "Xoay Phải",
    keyset_brik_rotateCCW=  "Xoay Trái",
    keyset_brik_rotate180=  "Xoay 180",
    keyset_brik_softDrop=   "Rơi Nhẹ",
    keyset_brik_hardDrop=   "Rơi Mạnh",
    keyset_brik_holdPiece=  "Giữ gạch",
    keyset_brik_skip=       "Bỏ qua",

    keyset_gela_moveLeft=   "Sang Trái",
    keyset_gela_moveRight=  "Sang Phải",
    keyset_gela_rotateCW=   "Xoay Phải",
    keyset_gela_rotateCCW=  "Xoay Trái",
    keyset_gela_rotate180=  "Xoay 180",
    keyset_gela_softDrop=   "Thả Nhẹ",
    keyset_gela_hardDrop=   "Thả Mạnh",
    keyset_gela_skip=       "Bỏ qua",

    keyset_acry_swapLeft=    "Vuốt Trái",
    keyset_acry_swapRight=   "Vuốt Phải",
    keyset_acry_swapUp=      "Vuốt Lên",
    keyset_acry_swapDown=    "Vuốt Xuống",
    keyset_acry_twistCW=     "Xoay Phải",
    keyset_acry_twistCCW=    "Xoay Trái",
    keyset_acry_twist180=    "Xoay 180",
    keyset_acry_moveLeft=    "Sang trái",
    keyset_acry_moveRight=   "Sang phải",
    keyset_acry_moveUp=      "Đi Lên",
    keyset_acry_moveDown=    "Đi Xuống",
    keyset_acry_skip=       "Bỏ qua",

    keyset_func1= "Chức năng 1",
    keyset_func2= "Chức năng 2",
    keyset_func3= "Chức năng 3",
    keyset_func4= "Chức năng 4",
    keyset_func5= "Chức năng 5",

    keyset_sys_view=    "Phóng to/nhỏ bảng",
    keyset_sys_restart= "Chơi lại",
    keyset_sys_chat=    "Trò chuyện",
    keyset_sys_back=    "Trở về",
    keyset_sys_quit=    "DỪNG game",
    keyset_sys_setting= "Vào Cài đặt",
    keyset_sys_help=    "Mở Trợ giúp nhanh",
    keyset_sys_up=      "Lên",
    keyset_sys_down=    "Xuống",
    keyset_sys_left=    "Trái",
    keyset_sys_right=   "Phải",
    keyset_sys_select=  "Lựa chọn",

    keyset_pressKey="Hãy nhấn một phím",
    keyset_deleted= "*XÓA PHÍM!*",
    keyset_info=    "[Esc]: Huỷ\t[Backspace]: Xóa\nNhấn [ESC] hai lần: gán phím Esc",

    stick2_switch="Cần điều khiển\n2 hướng",
    stick4_switch="Cần điều khiển\n4 hướng",
    setting_touch_button="Thêm/Xóa phím",
    setting_touch_buttonSize="Kích thước phím",
    setting_touch_iconSize="Kích thước biểu tượng",
    setting_touch_buttonShape="Đổi hình dạng phím",
    setting_touch_stickSize="Chiều dài",
    setting_touch_ballSize="Kích thước",

    main_in_dig="Tập đào rác",
    main_in_sprint="40 hàng",
    main_in_marathon="Marathon",
    main_in_tutorial="Hướng dẫn chơi",
    main_in_sandbox="Hộp cát",
    main_in_settings="Cài đặt",

    main_out_settings="Cài đặt",
    main_out_stat="Thành tích",
    main_out_dict="Từ điển",
    main_out_lang="Ngôn ngữ",
    main_out_about="Thông tin hệ thống",
    main_out_single="Chơi đơn",
    main_out_multi="Chơi qua mạng", -- can be translated to "Nhiều người chơi"

    musicroom_title="Phòng nhạc",
    musicroom_richloop="Rich Loop",
    musicroom_fullband="Chơi tất cả nhạc cụ", -- Alt: "Mở full beat", "Nghe full beat" (UPDATE: Don't need to make it shorter)
    musicroom_section='Chế độ điệp khúc',
    musicroom_autoplay="Tự động đổi bài",

    about_title="Giới thiệu",
    about_module="Module:",
    about_toolchain="Toolchain:",
    about_peopleLost="Bạn vừa bỏ qua $1!",

    -- Mode name
    exteriorModeInfo={ -- TRASLATING NOTE: Unnecessary to be accurate, try to quote some short proverbs in your language
        sprint=           {"Sprint"    ,"Tốc độ là TRÊN HẾT!"},
        sequence=         {"Sequence"  ,"Sẵn sàng cho những chuỗi gạch quái gở chưa nào?"},
        invis=            {"Invis"     ,"Như biến mất trong hư vô..."},
        spin=             {"Spin"      ,"Quay đều, quay đều, quay đều..."},
        marathon=         {"Marathon"  ,"Đối đầu với tốc độ tăng dần"},
        allclear=         {"All Clear" ,"\"Thuốc nổ\" trong game nào đó vẫn chưa bằng cái này đâu!"},
        combo=            {"Combo"     ,"Ai ai cũng thích combo,\nnhà nhà đều yêu combo!"},
        hypersonic=       {"Hypersonic","Khi trọng lực biến thành nam châm..."},
        dig=              {"Dig"       ,"Những hàng rác gọn gàng đang chờ bạn xóa kìa!"},
        excavate=         {"Excavate"  ,"Đống rác này khó xơi hơn. Bạn xử chúng được không?"},
        backfire=         {"Backfire"  ,"Ăn miếng trả miếng, nhưng là phiên bản một mình"},
        drill=            {"Drill"     ,"Tới giờ xử lý những hàng rác \"chuẩn không cần chỉnh\" nào!"},
        survivor=         {"Survivor"  ,"Hãy sống sót dưới làn \"mưa bom bão đạn\" từ kẻ địch!"},

        chain=            {"Chain"     ,"Hãy xâu một chuỗi cùng màu để xóa chúng!"},
        action=           {"Action"    ,"Hãy chơi mode này bằng cách dùng bàn phím và chuột nha!"},
    },

    -- Submode Task Texts
    modeTask_unknown_title="???",
    modeTask_unknown_desc="??????",

    modeTask_spin_piece_title="Piece",
    modeTask_spin_piece_desc="Làm một T-spin Đơn",
    modeTask_spin_column_title="Column",
    modeTask_spin_column_desc="Làm hai T-spin Đôi",

    modeTask_sequence_flood_title="Flood",
    modeTask_sequence_flood_desc="Xóa hàng bằng\ncục Z hoặc cục S",
    modeTask_sequence_drought_title="Drought",
    modeTask_sequence_drought_desc="Xóa hàng bằng\ncục J hay cục L",
    modeTask_sequence_saw_title="Saw",
    modeTask_sequence_saw_desc="Xóa hàng bằng cục T",
    modeTask_sequence_rect_title="Rect",
    modeTask_sequence_rect_desc="Xóa hàng bằng cục O",
    modeTask_sequence_rain_title="Rain",
    modeTask_sequence_rain_desc="Xóa hàng bằng cục I",
    modeTask_sequence_mph_title="MPH",
    modeTask_sequence_mph_desc="Xóa một hàng\nchỉ với 4 gạch.",
    modeTask_sequence_pento_title="Pento",
    modeTask_sequence_pento_desc="Xóa hàng bằng\nmột Pento (gạch 5 ô)",
    modeTask_sequence_unknown_desc="Xóa hàng bằng ???",

    modeTask_invis_haunted_title="Haunted",
    modeTask_invis_haunted_desc="Xóa 4 hàng (riêng lẻ)",
    modeTask_invis_hidden_title="Hidden",
    modeTask_invis_hidden_desc="Làm một Techrash",

    modeTask_hypersonic_low_title="Low",
    modeTask_hypersonic_low_desc="Xóa 4 hàng",
    modeTask_hypersonic_high_title="High",
    modeTask_hypersonic_high_desc="Làm Techrash",
    modeTask_hypersonic_hidden_title="Hidden",
    modeTask_hypersonic_hidden_desc="Làm Techrash\nchỉ trong 6s",
    modeTask_hypersonic_titanium_title="Titanium",
    modeTask_hypersonic_titanium_desc="Làm Techrash + ko Giữ\nchỉ trong 8s",

    modeTask_excavate_shale_title="Shale",
    modeTask_excavate_shale_desc="Đào khi\nSingle hay Double",
    modeTask_excavate_volcanics_title="Volcanics",
    modeTask_excavate_volcanics_desc="Đào khi\nTriple hay Techrash ",
    modeTask_excavate_checker_title="Checker",
    modeTask_excavate_checker_desc="Đào khi Split",
    modeTask_excavate_unknown_desc="Đào khi ???",

    modeTask_backfire_break_title="Scattered",
    modeTask_backfire_break_desc="Xóa 8 hàng",
    modeTask_backfire_normal_title="Normal",
    modeTask_backfire_normal_desc="Gửi 7 hàng trong 6 hàng",
    modeTask_backfire_amplify_title="Amplify",
    modeTask_backfire_amplify_desc="Gửi 8 hàng trong 4 hàng",

    modeTask_survivor_scattered_title="Scattered",
    modeTask_survivor_scattered_desc="Gửi 8 hàng",
    modeTask_survivor_power_title="Power",
    modeTask_survivor_power_desc="Gửi 8 hàng với 1 Eff",
    modeTask_survivor_spike_title="Spike",
    modeTask_survivor_spike_desc="Gửi 8 hàng với 2 Eff",

    -- Achievement
    ---@enum (key) Techmino.Text.Achievement
    achievementMessage={
        dict_shortcut="Chuyên gia Phím tắt",
        exterior_spin_howDareYou="Sao ngươi dám?",
        exterior_excavate_notDig="Mày đang làm gì đấy?",
        exterior_invis_superBrain="Siêu Trí tuệ Việt Nam!",
        exterior_invis_rhythmMaster="To the beat!", -- Keep this as it is. Original from "osu!" title music
        exterior_hypersonic_holdlessTitan="Nút Giữ: \"Bạn đang quên sự tồn tại của mình à? (sob)\"",
        language_japanese="あ? (a?)",
        interior_console="Cái thứ quái đản này là gì thế?",
        musicroom_recollection="Không có bài hát nào tên là \"Hồi tưởng\" cả!",
        musicroom_piano="Anh hẹn em piano\nChúng ta cùng piano!", -- Pickleball troll? XD
        dial_enter="Nhạc... nhạc cụ?",
        menu_fastype="Ông thích đánh máy lắm à?",
    },
    -- Level
    tutorial_basic="1. Những thứ cơ bản",
    tutorial_sequence="2. Next & Hold",
    tutorial_stackBasic="3. Cách xếp gạch cơ bản",
    tutorial_finesseBasic="4. Cách đ.khiển gạch nhanh nhất",
    tutorial_finessePractice="5. Luyện tập đ.khiển gạch",
    tutorial_allclearPractice="6. Luyện tập làm All Clear",
    tutorial_techrashPractice="7. Luyện tập làm Techrash",
    tutorial_finessePlus="8. Cách đ.khiển gạch một cách thoăn thoắt",

    tutorial_pass="HOÀN THÀNH!", -- Completed (Pass)
    tutorial_notpass="Trượt rồi…",

    tutorial_basic_1="Chào mừng bạn tới Techmino!",
    tutorial_basic_2="1. Những thứ cơ bản",
    tutorial_basic_3="Hãy dùng hai phím \"Sang Trái\" và \"Sang Phải\" để điều khiển gạch đang rơi.",
    tutorial_basic_4="sau đó dùng phím \"Rơi Mạnh\" để đặt gạch lên lên mặt đất.",
    tutorial_basic_5="Bạn cũng có thể xoay gạch bằng cách nhấn các nút xoay.",

    tutorial_sequence_1="2. Next & Hold",
    tutorial_sequence_2="Trời ạ, cái gạch này không lọt khít với cái hố rồi…",
    tutorial_sequence_3="Bây giờ bạn có thể nhìn thấy những gạch nào chuẩn bị rơi theo lần lượt.",
    tutorial_sequence_4="Hãy dùng phím \"Giữ gạch\" để điều chỉnh thứ tự của các gạch.",

    tutorial_stackBasic_1="3. Cách xếp gạch cơ bản",
    tutorial_stackBasic_2="Hãy xếp gạch làm sao để tầng trên cùng \"phẳng\", để giữ cho đồng hồ nguy hiểm ở bên trái ở mức thấp",
    tutorial_stackBasic_3="Đây thường là mục tiêu của những người mới chơi",
    tutorial_stackBasic_4="Gạch nên được để \"nằm xuống\", chứ đừng \"đứng lên\"",
    tutorial_stackBasic_5="Để đảm bảo bạn có nhiều lựa chọn cho những gạch sau đó và tránh tạo ra lỗ",

    tutorial_finesseBasic_0="4. Cách điều khiển gạch nhanh nhất",
    tutorial_finesseBasic_0_1="“Finesse” là một phương pháp điều khiển gạch nhanh nhất nhưng vẫn cho phép giảm khả năng misdrop.",
    tutorial_finesseBasic_1="① 2 phím xoay",
    tutorial_finesseBasic_1_1="Hãy đi gán 2 phím cho xoay trái và xoay phải đã, bởi [Xoay Trái] × 1 = [Xoay Phải] × 3",
    tutorial_finesseBasic_1_T="Tạm thời ở đây bạn chưa cần phải gán phím cho xoay 180°",
    tutorial_finesseBasic_1_2="NHIỆM VỤ: Thả gạch vào vị trí yêu cầu CHỈ VỚI 1 LẦN XOAY!",
    tutorial_finesseBasic_2="② Backtrack (Đi rồi quay về)",
    tutorial_finesseBasic_2_1="Bảng rộng 10 ô, gạch rộng khoảng 3 ô và luôn xuất hiện ở giữa, nên chia bảng thành 3 phần: Trái - Giữa - Phải",
    tutorial_finesseBasic_2_2="Di chuyển gạch tới phần bảng của nơi cần đặt trước, sau đó điều chỉnh lại bằng cách di chuyển theo từng ô lẻ",
    tutorial_finesseBasic_2_3="Và bạn chỉ cần 2 kiểu di chuyển: \"bước 1 ô\" (nhấn 1-2 lần) and \"dịch chuyển tới mặt bên\"",
    tutorial_finesseBasic_2_T="Hãy cài ASD nhỏ nhất có thể, nhưng hãy đảm bảo BẠN VẪN DÙNG ĐƯỢC cả 2 kiểu di chuyển trên",
    tutorial_finesseBasic_2_4="NHIỆM VỤ: Thả gạch vào vị trí yêu cầu CHỈ VỚI 2 LẦN DI CHUYỂN",
    tutorial_finesseBasic_3="③ Wall-turn (Đạp vào tường)",
    tutorial_finesseBasic_3_1="Bạn thấy đấy, gạch luôn luôn xoay quanh một cái chấm tròn trắng",
    tutorial_finesseBasic_3_2="Với gạch Z (đỏ), S (xanh) và I (lam), xoay trái hay phải cũng sẽ làm cho gạch \"nghiêng\" theo một bên",
    tutorial_finesseBasic_3_3="NHIỆM VỤ: Thả gạch vào vị trí yêu cầu CHỈ VỚI 1 LẦN XOAY VÀ 1 LẦN DI CHUYỂN",
    tutorial_finesseBasic_4_1="Bằng cách kết hợp cả 3 kĩ thuật trên",
    tutorial_finesseBasic_4_2="Bất kì chuỗi phím với 3 lần bấm tối đa cũng có thể di chuyển gạch theo ý bạn muốn.",

    tutorial_finessePractice_1="5. Luyện tập điều khiển gạch",
    tutorial_finessePractice_2="Hãy dùng ít lần bấm nhất có thể",
    tutorial_finessePractice_par="Lần bấm tối đa",

    tutorial_allclearPractice_1="6. Luyện tập All Clear",
    tutorial_allclearPractice_2="Làm càng nhiều All Clear càng tốt",

    tutorial_techrashPractice_1="7. Techrash Practice",
    tutorial_techrashPractice_2="Làm càng nhiều Techrash càng tốt",

    tutorial_finessePlus_1="8. Elegant Moves",
    tutorial_finessePlus_2="Hãy chơi mà dùng ít lần bấm nhất có thể",
}

-- Moved the credit to the last for easier edit
-- This translation originally made by Sea (C6H12O6+NaCl+H2O)
-- Special thanks to Shard Nguyễn, Nguyễn "Cuốc" Hiếu, User670, Lê Duy Quang for advices, suggestions in both game and Zictionary
-- Thanks to Escape the Martix (tadcouq) for doing minor changes for translation