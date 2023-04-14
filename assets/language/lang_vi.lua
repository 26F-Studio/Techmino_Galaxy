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
    booting_changed="Đã thay đổi chương trình boot",
    musicroom_lowVolume="Vặn âm lượng nhạc nền lên đi bạn ơi! (Ở dưới góc phải màn hình đấy!)",

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

    combo_small="$1 Combo",
    combo_large="$1 Combo!",
    mega_combo="MEGACMB",

    b2b="B2B",
    spin="$1-spin",
    tuck="Tuck",

    allClear="ALL CLEAR",
    halfClear="Half Clear",

    -- About-Game
    pause="Đã tạm dừng",

    keyset_pressKey="Hãy nhấn một phím",
    keyset_deleted= "*Xóa rồi nhé*",
    keyset_info=    "[Esc]: Huỷ\t[Backspace]: Xóa\nNhấn đúp [Esc]: gán phím Esc",

    -- Widget texts
    button_back="Trở về",

    title_simulation="Trình giả lập",
    title_graph_mino="M-Graph (Đồ thị Mino)",   -- from "Knowledge Graph" (AI domain) -- it used to be translated to "M-Graph (Bản đồ Mino)"
    title_settings="Cài đặt",

    setting_das="DAS",
    setting_arr="ARR",
    setting_sdarr="SDARR",
    setting_dasHalt="DAS halt",
    setting_hdLockA="Auto hard-drop lock",
    setting_hdLockM="Manual hard-drop lock",
    setting_shakeness="Độ lắc bảng",
    setting_hitWavePower="Hitwave Power",

    setting_mainVol="Âm lượng tổng",
    setting_bgm="Nhạc nền (BGM)",
    setting_sfx="Hiệu ứng (SFX)",
    setting_vib="Rung (VIB)",
    setting_handling="Handling…",
    setting_keymapping="Cài đặt phím…",
    setting_enableTouching="Điều khiển bằng cảm ứng",
    setting_touching="Bố cục các nút…",
    setting_test="Thử phím",

    setting_sysCursor="Trỏ chuột hệ thống",
    setting_clickFX="Hiệu ứng nhấp chuột",
    setting_power="Trạng thái cuối cùng",   -- Ok I searched StackOverflow and asked Bing AI for this (ChatGPT was busy that time)
    setting_clean="VRAM Boost",
    setting_fullscreen="Toàn màn hình",
    setting_portrait="Màn hình hướng dọc",
    setting_autoMute="Tắt tiếng khi mở cửa số khác",
    setting_showTouch="Hiện vị trí vừa nhấn",

    setting_maxFPS="FPS tối đa",
    setting_updRate="Tần suất cập nhậ vt",
    setting_drawRate="Tuần suất vẽ",
    setting_msaa="MSAA - Khử răng cưa",

    lang_note="Bản tiếng Trung (Giản thể) (简体中文) là bản gốc của game. Bản dịch này được dịch từ bản tiếng Anh (English)\nCác bản dịch được các tình nguyện viên đóng góp và chúng có thể không chính xác 100%\nCó một số thuật ngữ không được dịch trực tiếp trong game. Vui lòng tra Zictionary để tìm hiểu thêm",
            -- Chinese (Simplified Han) version is the original version of the game. This translation (Vietnamese) is translated from English\nAll translations are contributed by volunteers and it may not accurate 100%\nThere are some terms are not translated directly in the game. Please check Zictionary for more information.
            --                                                                                                                                                                                             |---------------------------------------------------------------------------------------------------------| <-- only appear in Vietnamese

    -- GHI CHÚ: Viết hoa các từ "Trái", "Phải", "Lên", "Xuống"
    title_keyset="Gán phím",
    keyset_mino_moveLeft=   "Sang Trái",
    keyset_mino_moveRight=  "Sang Phải",
    keyset_mino_rotateCW=   "Twist (Xoay) Phải",
    keyset_mino_rotateCCW=  "Twist (Xoay) Trái",
    keyset_mino_rotate180=  "Twist (Xoay) 180",
    keyset_mino_softDrop=   "Thả Nhẹ/Xuống 1 ô",      -- I don't know which one should I use
    keyset_mino_hardDrop=   "Thả Mạnh/Đặt gạch ngay",   -- so does to it
    keyset_mino_holdPiece=  "Giữ gạch",

    keyset_puyo_moveLeft=   "Sang Trái",
    keyset_puyo_moveRight=  "Sang Phải",
    keyset_puyo_rotateCW=   "Xoay Phải",
    keyset_puyo_rotateCCW=  "Xoay Trái",
    keyset_puyo_rotate180=  "Xoay 180",
    keyset_puyo_softDrop=   "Thả Nhẹ",
    keyset_puyo_hardDrop=   "Đặt Mạnh",

    keyset_gem_swapLeft=    "Vuốt sang Trái",
    keyset_gem_swapRight=   "Vuốt sang Phải",
    keyset_gem_swapUp=      "Vuốt Lên",
    keyset_gem_swapDown=    "Vuốt Xuống",
    keyset_gem_twistCW=     "Xoay Phải",
    keyset_gem_twistCCW=    "Xoay Trái",
    keyset_gem_twist180=    "Xoay 180",
    keyset_gem_moveLeft=    "Cursor Left",
    keyset_gem_moveRight=   "Cursor Right",
    keyset_gem_moveUp=      "Cursor Up",
    keyset_gem_moveDown=    "Cursor Down",

    keyset_func1= "Chức năng 1 (F1)",
    keyset_func2= "Chức năng 2 (F2)",
    keyset_func3= "Chức năng 3 (F3)",
    keyset_func4= "Chức năng 4 (F4)",
    keyset_func5= "Chức năng 5 (F5)",
    keyset_func6= "Chức năng 6 (F6)",

    keyset_sys_view=    "Đổi view (Gần/Xa)",
    keyset_sys_restart= "Chơi lại",
    keyset_sys_back=    "Trở về",
    keyset_sys_quit=    "DỪNG game",
    keyset_sys_setting= "Vào Cài đặt",
    keyset_sys_help=    "Mở Trợ giúp nhanh",
    keyset_sys_chat=    "Trò chuyện",
    keyset_sys_up=      "Lên",
    keyset_sys_down=    "Xuống",
    keyset_sys_left=    "Trái",
    keyset_sys_right=   "Phải",
    keyset_sys_select=  "Lựa chọn",

    stick2_switch="Cần điều khiển\n2 hướng",
    stick4_switch="Cần điều khiển\n4 hướng",
    setting_touch_button="Thêm/Xóa phím",
    setting_touch_buttonSize="Kích thước phím",
    settinh_touch_buttonShape="Đổi hình dạng phím",
    setting_touch_stickSize="Chiều dài",
    setting_touch_ballSize="Kích thước",

    main_in_dig="Tập đào rác",
    main_in_sprint="40 hàng",
    main_in_marathon="Marathon",
    main_in_tutorial="Hướng dẫn (Tutorial)",
    main_in_sandbox="Sandbox (Hộp cát)",
    main_in_settings="Cài đặt",

    main_out_settings="Cài đặt",
    main_out_stat="Thành tích",
    main_out_dict="Từ điển",
    main_out_lang="Ngôn ngữ",
    main_out_about="Thông tin hệ thống",
    main_out_single="Chơi đơn",
    main_out_multi="Chơi qua mạng",

    title_musicroom="Phòng nhạc",
    musicroom_fullband="Chơi tất cả nhạc cụ", -- Alt: "Mở full beat", "Nghe full beat"
    musicroom_autoplay="Tự động đổi bài",

    about_title="Giới thiệu",
    about_love="Z-UI được chạy bằng LÖVE",
    about_module="Modules:",
    about_toolchain="Toolchain:",
    about_peopleLost="Bạn vừa đánh rơi $1 !",

    -- Mode name
    exteriorModeInfo={
        marathon=              {"Marathon","Xóa 200 hàng nhưng tốc độ sẽ tăng dần!"},
        techrash_easy=         {"Chỉ làm Techrash - Dễ","Cố làm nhiều Techrash nhất có thể"},
        techrash_hard=         {"Chỉ làm Techrash - Khó","Cố làm nhiều Techrash nhất có thể, nhưng đừng có làm cùng chung một vị trí quá nhiều lần!"},
        hypersonic_lo=         {"Hypersonic LO","Hypersonic\n\"Xin chào mọi người!\nEm đang tập chơi 20G.\""},
        hypersonic_hi=         {"Hypersonic HI","Hypersonic\nThử thách \"khó nuốt\""},
        hypersonic_ti=         {"Hypersonic TI","Hypersonic\nVelocital Trepidation\n(Không nhanh như Level 15 đâu, mà nó nhanh tới mức đáng sợ!)"},
        hypersonic_hd=         {"Hypersonic HD","Hypersonic (nhưng mà gạch sẽ biến mất sau một khoảng thời gian!)"},
        combo_practice=        {"Tập làm combo","Hãy tập làm mấy combo liên tiếp đi!"},
        tsd_practice=          {"Tập làm TSD","Hãy tập xóa thêm mấy cái T-spin Double đi"},
        tsd_easy=              {"Chỉ làm TSD - Dễ","Hãy cố làm nhiều combo TSD nhất có thể (không được dùng kiểu clear khác!)"},
        tsd_hard=              {"Chỉ làm TSD - Khó","Hãy cố làm nhiều combo TSD nhất có thể, nhưng đừng có làm cùng chung một vị trí quá nhiều lần!"},
        pc_easy=               {"Tập làm PC - Dễ","Tập làm Perfect Clear với mẫu đã dựng sẵn"},
        pc_hard=               {"Tập làm PC - Khó","Tập làm PC với mẫu đã dựng sẵn, nhưng phức tạp hơn"},
        pc_challenge=          {"Chỉ làm PC","Cố làm nhiều PC nhất có thể"},
        dig_practice=          {"Tập đào rác","Tập dọn một ít hàng rác"},
        dig_40=                {"Đào 40 hàng","Dọn 40 hàng rác ngẫu nhiên"},
        dig_100=               {"Đào 100 hàng","Dọn 100 hàng rác ngẫu nhiên"},
        dig_400=               {"Đào 400 hàng","Dọn 400 hàng rác ngẫu nhiên"},
        dig_shale=             {"Đào \"đá phiến\"","(Dig Shale)\n\nDọn một số lượng hàng rác ngẫu nhiên nhưng được xếp thành từng lớp"},
        dig_volcanics=         {"Đào núi lửa","(Dig Volcanics)\n\nDọn một số lượng hàng rác nhưng chúng khá là phức tạp"},
        dig_checker=           {"Đào bàn cờ","(Dig Checker)\n\nDọn 10 hàng rác nhưng chúng được xếp như bàn cờ vua!"},
        survivor_cheese=       {"Sống sót - Phô mai","Cố sống sót dưới những cuộc tấn công của phô mai"},    -- Based on a joke in Vietnam Tetris Community
        survivor_b2b=          {"Sống sót - B2B","Cố sống sót dưới những cuộc tấn công ác liệt của Back-to-back"},
        survivor_spike=        {"Sống sót - Spike","Cố sống sót dưới các cuộc tấn công kinh hoàng"},

        -- Will revert back to "Xóa 100 nhận 100" (alt: "Xóa 100 nhận rác")
        -- when all modes have icons
        backfire_100=          {"Ăn đòn phản","Xóa 100 hàng nhưng bạn sẽ bị bón hành bởi rác do chính bạn tạo ra!"},
        -- This one is "Xóa 100 nhận 2X"
        backfire_amplify_100=  {"Ăn đòn phản đôi","Xóa 100 hàng, cũng bị ăn rác do chính mình tạo ra, lượng rác trả lại hơi bị nhiều đấy nhé!"},
        -- This one is "Xóa 100 nhận Phô mai"
        backfire_cheese_100=   {"Ăn đòn phản - Phô mai","Xóa 100 hàng, cũng bị ăn rác do chính mình tạo ra, nhưng lần này bị bón hành kiểu phô mai"},

        sprint_40=             {"40 hàng","Xóa 40 hàng càng nhanh càng tốt\nĐơn giản vậy thôi"},
        sprint_10=             {"10 hàng","Chỉ cần 10 hàng mà thôi!"},
        sprint_obstacle_20=    {"20 điểm - VCNV","(Vượt chướng ngại vật)\n\nBây giờ là vòng thi \"Vượt chướng ngại vật\"!\n\nCác thí sinh sẽ cùng nhau đi tìm một \"ẩn số\" gồm có 20 \"chữ cái\""},  --ref from "Đường lên đỉnh Olympia"
        sprint_200=            {"200 hàng","Xóa 200 hàng\n\n(Nhớ để ý kẻo mỏi tay)"},
        sprint_1000=           {"1000 hàng","Xóa 1000 hàng\n\n(Chỉ mong tay bạn không bị rã rời)"},
        sprint_drought_40=     {"40 hàng - Drought","Xóa 40 hàng…\nỦa mà khoan, nãy giờ chơi sao không thấy gạch I rơi???"},
        sprint_flood_40=       {"40 hàng - Flood","Xóa 40 hàng, nhưng khoan…\nSao nhiều gạch S với Z dữ vậy!?"},
        sprint_penta_40=       {"40 hàng - Penta","Xóa 40 hàng, nhưng lần này với gạch 5 ô (pentominoes)"},
        sprint_sym_40=         {"40 hàng - Sym","Xóa 40 hàng, nhưng bạn phải chơi theo kiểu đối xứng!"},
        sprint_mph_40=         {"40 hàng - MPH","Xóa 40 hàng, nhưng không có NEXT và HOLD!"},
        sprint_delay_20=       {"20 hàng - Delay","Xóa 20 hàng, nhưng mà nó tự dưng lag kinh khủng khiếp!"},
        sprint_wind_40=        {"40 hàng - Wind","Xóa 40 hàng, nhưng mà bạn đang chơi dưới cơn gió rất mạnh!\n(Có khi là cơn bão)"},
        sprint_lock_20=        {"20 hàng - Lock","Xóa 20 hàng, nhưng bạn không thể xoay"},
        sprint_fix_20=         {"20 hàng - Fix","Xóa 20 hàng, nhưng bạn không thể di chuyển"},
        sprint_hide_40=        {"40 hàng - Hide","Xóa 40 hàng, nhưng toàn bộ gạch ở trên bảng sẽ dần trong suốt theo thời gian"},
        sprint_invis_40=       {"40 hàng - Invis","Xóa 40 hàng, nhưng bạn sẽ không thể nhìn thấy toàn bộ gạch mình đã đặt"},
        sprint_blind_40=       {"40 hàng - Blind","Xóa 40 hàng, nhưng đó là khi bạn đang bị bịt mắt"},
        sprint_big_80=         {"80 hàng - Big","Xóa 80 hàng nhưng gạch toàn loại cỡ khủng"},
        sprint_small_20=       {"20 hàng - Small","Xóa 20 hàng, nhưng gạch toàn loại bé tí teo"},
        sprint_low_40=         {"40 hàng - Low","Xóa 40 hàng, nhưng cái \"trần\" bảng thấp hơn bình thường"},
        sprint_flip_40=        {"40 hàng - Flip","Xóa 40 hàng, nhưng cái bảng sẽ bị lật ngược sau mỗi lần bạn đặt gạch\n\nYou spin me right round, baby right round like a record, baby right round right round"},
        sprint_dizzy_40=       {"40 hàng - Dizzy","Xóa 40 hàng nhưng có gì đó không đúng với bộ điều khiển ở đây."},
        sprint_float_40=       {"40 hàng - Float","Xóa 40 hàng nhưng không có trọng lực (trôi nổi bồng bềnh như đám mây vậy ấy)"},
        sprint_randctrl_40=    {"40 hàng - Random","Xóa 40 hàng nhưng bộ điều khiển của bạn sẽ tự dưng kẹt ở đâu đó một cách bất ngờ!"},
    },

    -- Level
    tutorial_basic="Những thứ cơ bản",
    tutorial_sequence="Next & Hold",
    tutorial_stackBasic="Xếp gạch sao cho đúng?",
    tutorial_twoRotatingKey="Xoay cả 2 hướng",
    -- tutorial_piece="Hình dạng của\ncác viên gạch",
    tutorial_piece = "[Chưa hoàn thành]", -- [Unfinished] | Waiting for actual game
    tutorial_rotating="Tập xoay gạch",

    tutorial_pass="HOÀN THÀNH!", -- Completed (Pass)
    tutorial_notpass="Tạch rồi…", -- Fun fact: "Tạch" is the keyboard sound, don't make any keyboard sounds to who are preapring the test (or WYSI)

    tutorial_basic_1="Chào mừng bạn tới Techmino!",
    tutorial_basic_2="1. Những thứ cơ bản",
    tutorial_basic_3="Hãy dùng hai phím \"Sang Trái\" và \"Sang Phải\" để điều khiển gạch đang rơi.",
    tutorial_basic_4="sau đó dùng phím \"Thả Mạnh/Đặt gạch ngay\" để đặt gạch lên trên mặt bảng.",
    tutorial_basic_5="Bạn cũng có thể xoay gạch bằng cách nhấn các nút xoay.",

    tutorial_sequence_1="2. Next & Hold",
    tutorial_sequence_2="Trời ạ, cái gạch này không lọt khít với cái hố rồi…",
    tutorial_sequence_3="Bây giờ bạn có thể nhìn thấy những gạch nào chuẩn bị rơi theo lần lượt. ",
    tutorial_sequence_4="Hãy dùng phím \"Giữ gạch\" để điều chỉnh thứ tự của các gạch.",

    -- Waiting for the actual game
    tutorial_piece_1="3. Hình dạng của các viên gạch",
    tutorial_piece_2="Có 7 gạch tetromino (gạch 4 ô)",
    tutorial_piece_3="Chúng được đặt tên theo các chữ cái sau: Z, S, J, L, T, O, I.",

    tutorial_stackBasic_1="4. Xếp gạch sao cho đúng?",
    tutorial_stackBasic_m1="Hãy tập trung vào màn hình và làm theo hướng dẫn nè!",
    tutorial_stackBasic_m2="Lúc đầu, hãy giữ cho bề mặt ở phía trên phẳng nhất có thể",
    tutorial_stackBasic_m3="Các cục gạch sẽ được đặt ở tư thế nằm, chứ không phải là tư thế đứng",
    tutorial_stackBasic_m4="Bề mặt ở trên nếu phẳng thì dễ dàng để đặt gạch hơn, và cố gắng đừng tạo ra bất kì cái hố nào",
    tutorial_stackBasic_m5="Bạn thường được thưởng nhiều hơn khi xóa bốn hàng cùng một lúc, hãy thử làm một cái đi",
    tutorial_stackBasic_m6="Thử làm Techrash bằng cách dùng những cục gạch cuối cùng này mà không cần hướng dẫn đi",

    tutorial_twoRotatingKey_1="5. Xoay cả 2 hướng",
    tutorial_twoRotatingKey_m1="Hãy tập trung và làm theo hướng dẫn, nhưng hãy cố gắng xoay gạch ít lần nhất có thể",
    tutorial_twoRotatingKey_m2="Nếu bạn có thể xoay trái, thì đừng có xoay phải 3 lần!",
    tutorial_twoRotatingKey_m3="Không những tốn công sức và t.gian, bạn còn dễ bị \"ngụm củ tỏi\"",
    tutorial_twoRotatingKey_m4="Bây giờ bạn có thể tự quyết định vị trí đặt thả gạch rồi, không cần phải dựa vào gợi ý nữa",
    tutorial_twoRotatingKey_unnecessaryRotation="XOAY QUÁ NHIỀU!",

    tutorial_rotating_1="6. Tập xoay gạch",
    tutorial_rotating_2="Hãy xoay gạch ở trên sao cho giống với gạch ở dưới.",
}

-- Moved the credit to the last for easier edit
-- This translation originally made by Sea (C6H12O6+NaCl+H2O)
-- Special thanks to Shard Nguyễn, Nguyễn "Cuốc" Hiếu, User670 for advices