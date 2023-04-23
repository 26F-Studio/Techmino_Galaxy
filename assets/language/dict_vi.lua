--[[
    Comment from Squishy (SweetSea-ButImNotSweet) (sea)
    For anyone who are editing the file, please notice:
        1. If you want to make footnotes, please use superscripts and make a line with the thickness is 6
           Then you can add footnotes after is
        2. Always use right format and follow MrZ's guide

    Format guide:
        #internal_id
        @property value
        Content isn't prefixed with anything
        and can span multiple lines.

        -- You can comment anything here and don't worry, it will not create any meaningless empty line

        Having empty lines in the text is also fine, and the empty lines will be preserved.
        
        -- To make border line
        ~~ thickness
        -- Example: ~~5

    Here is some superscript you may want to use
    ¹   ²   ³   ⁴   ⁵   ⁶   ⁷   ⁸   ⁹   ⁰
]]

--[[
    Comment from MrZ
    Translation guideline:
    1.  You can switch orders of entries, and this doesn't affect what is shown
        in game. However, it's not recommended to change the order so that it's
        easier to find the entry you or someone else wants to edit
    2.  For "about" and "guide" type entries, keep the "you" if original text
        does so. Make it feel like you are talking directly to the player.
    3.  For "terms" and "technique" type entries, avoid vocabulary that "feel
        obvious like joking", "directly refers to a player", eg "the player" or
        "the game". Try to avoid these by rephrasing your sentence.
    4.  Keep this comment at the top of the file too, translated, so that other
        translators can see and translate this too
]]

return [[
# aboutDict
@ title T.tin về Zictionary
@ titleFull Thông tin về Zictionary
Zictionary sẽ dạy cho bạn mọi thứ về xếp gạch

# aboutDict_hidden
@ title Cái gì đây?
Nó sẽ dạy cho bạn mọi thứ về xếp gạch.
... Khoan, chờ khoảng chừng 2 giây!
Bạn vừa nhấn phím tắt à? Ngon lành cành đào rồi đây

# setting_out
@ title Cài đặt
Đây là trang Cài đặt.
Bạn có thể chỉnh một đống thứ ở đây!

# noobGuide
@ title Xin chào
@ contentSize 20
Cảm ơn bạn đã tải và chơi Techmino!
... Hả? Đây là lần đầu bạn chơi game xếp gạch á? Nếu vậy thì...
Đây là một vài thứ mà bạn nên làm mỗi khi chơi, chúng được sắp xếp thành một nhóm. Tuy xếp thành nhóm, bạn vẫn nên làm cả ba nhóm cùng lúc thay vì làm từng cái một.

A. Stacking (Xếp gạch)
    A1. Suy nghĩ kỹ trước khi đặt gạch. Chưa vừa ý? Suy nghĩ thêm lần nữa.
    A2. Hãy xếp gạch càng phẳng càng tốt để bạn có thể ra quyết định đặt gạch dễ dàng hơn.
    A3. Lên kế hoạc trước cách xếp, hãy tận dụng tối đa NEXT và HOLD để giữ được thể đẹp. 
~~
B. Efficiency & Speed (Hiệu quả & Tốc độ)
    B1. Trước mỗi lần đặt gạch, hãy suy nghĩ xem bạn sẽ đặt gạch ở đâu? Bấm những phím nào để gạch tới chỗ đó và đứng đúng tư thế? Thay vì dựa dẫm vào gạch ma quá nhiều
    B2. Nên sử dụng 2 (hoặc 3, tùy game) phím xoay thay vì nhấn 1 phím xoay liên tục trong thời gian dài. Bởi vì làm như vậy trong thời gian dài sẽ làm bạn chậm và làm cho bạn dễ rơi vào trạng thái bị động
    B3. Đừng lo lắng về tốc độ khi bạn mới tập chơi Finesse, đây là chuyện bình thường. Hơn nữa bạn có thể tập chơi nhanh hơn một khi bạn đã quen tay — việc này không khó đâu!
~~
C. Practice (Luyện tập)
    C1. Hoàn thành chế độ "40 hàng"
    C2. Hoàn thành chế độ "40 hàng" mà không dùng HOLD
    C3. Hoàn thành chế độ "40 hàng" mà chỉ được làm Techrash.
    C4. Hoàn thành chế độ "40 hàng" mà chỉ được làm Techrash và không được dùng HOLD

Nhóm C rất linh động, bạn có thể điều chỉnh độ khó dựa trên tình hình/điều kiện của bạn (ví dụ như "không làm bạn chơi quá chậm")
~~
Sau khi bạn hoàn thành hết nhóm C, hãy tiếp tục luyện tập nhóm A, đây là một kỹ năng tối quan trọng trong bất kỳ tựa game xếp gạch nào; và bạn sẽ có thể dần dần làm chủ bất kỳ chế độ nào, lúc đó chỉ cần nhìn lướt qua NEXT là đủ rồi.

# keybinding
@ title Gán phím
@ titleFull Lời khuyên cho việc Gán phím
@ contentSize 20
Dưới đây là vài lời khuyên hữu ích khi bạn gán phím

1.  Một ngón tay chỉ nên thực hiện một chức năng khác nhau. Ví dụ như: 1 ngón cho sang trái, 1 ngón cho sang phải, 1 ngón cho phím xoay phải, 1 ngón cho rơi mạnh
~~
2.  Trừ khi bạn tự tin với ngót út của mình, thì không nên để ngóm tay này làm bất kì chức năng nào! Hơn hơn hết, nên xài ngón trỏ và ngón giữa vì hai ngón này là nhanh nhẹn nhất, nhưng bạn cũng có thể thoải mái tìm hiểu xem các ngón tay của mình nhanh chậm thế nào, mạnh yếu ra sao.
~~
3.  Không nhất thiết phải sao chép cấu hình phím của người khác, vì không ai giống ai. Thay vào đó hãy chỉnh theo cách của bạn, miễn là bạn chơi thoải nái là được.

# handling
@ title Handling
@ titleFull Mẹo khi xử lý gạch
@ contentSize 25
Những yếu tố ảnh hưởng tới việc xếp gạch của bạn:
(1) Input delay, which could be affected by device configuration or condition. Restart the game or change your device can probably fix it.
(2) Unstable programming or faulty designs. It could be alleviated by lowering the effect settings.
(3) Designed on purpose. Adaptation might help.
(4) Improper parameter setting. Change the settings.
(5) Improper play posture. It’s not convenient to use force. Change your posture.
(6) Not being used to the operation after changing the key position or changing the device. Getting used to it or changing the settings might help.
(7) Muscle fatigue, response, and decreases in coordination abilities. Have some rest and come back later or in a few days.

# piece_shape
@ title Những miếng gạch
Trong các trò xếp gạch, các viên gạch là những khối có 4 ô liên kết với nhau

Mỗi trò xếp gạch đều có tổng cộng có bảy viên gạch khác nhau. Chúng được đặt tên theo chữ cái trong bảng chữ cái giống với hình dáng của chúng. Đó là Z, S, J, L, T, O

# piece_color
@ title Màu của gạch
Thông thường, các viên gạch có cùng hình dáng sẽ cùng có màu. Nó sẽ giúp bạn phân biệt dễ dàng phân biệt chúng và nhớ lâu hơn

# piece_direction
@ title Pieces' Directions
@ titleFull Tetrominos' Directions
Usually, tetrominos spawn with a consistent rotation state (in other words, it won't spawn in one direction sometimes but in another direction some other times). Some rotation systems also take a tetromino's direction into account when deciding what direction to kick the tetromino.

# next
@ title Next
Hiển thị nhưng viên gạch sẽ lần lượt rơi xuống. Có thể sử dụng ô này để lên kế hoạch trước cách xếp một cách tốt hơn. 

# hold
@ title Hold
Lưu gạch hiện tại để dùng lại sau và lấy gạch đang giữ ra dùng (hoặc là lấy gạch tiếp theo, nếu chưa giữ gạch nào trước đó). Cho phép bạn đổi thứ tự gạch sẽ xuất hiện. Có thể dùng một cách chiến lược, hay đơn giản hơn là thử gạch khác nếu gạch hiện tại không có chỗ đặt lý tưởng.

# clear
@ title Xóa mấy hàng?
@ titleFull Single, Double, Triple và Techrash
Đề cập tới số hàng bạn xóa sau khi bạn đặt gạch

Single = Xóa 1 hàng.
Double = Xóa 2 hàng.
Triple = Xóa 3 hàng.
Techrash = Xóa 4 hàng.

# clear_big
@ title Bigger Line Clears
@ titleFull Line Clears Beyond Techrashes
While normally you can only clear 4 lines at a time (Techrash), there are modes with special rules that enable you to clear more lines at once. For example, clearing 5 lines is called Pentacrash, and clearing 6 lines is called Hexacrash.

# b2b
@ title Back to Back
@ titleFull Back to Back (BtB, B2B)
Refers to making at least two special line clears (usually this refers to Techrashes and Spin line clears) without making regular line clears in between.

# all_clear
@ title All Clear
@ titleFull All Clear (AC)
Tên khác Perfect Clear (PC).
Xóa sạch toàn bộ gạch ở trong bảng.

# half_clear
@ title Half Clear
@ titleFull Half Clear (HC)
An extension to All Clear, refers to All Clears "with remaining blocks below the cleared lines."
As a special case, if the line clear is a Single, then there cannot be player-placed blocks remaining.

# rotation_system
@ title Rotation Systems
When rotating a piece, if it results in the piece overlapping with existing blocks or the wall/floor, the game may test adjacent positions to see if they are available. This makes it less likely for a rotation to fail and get stuck.

A system that defines what positions gets checked during a rotation is called a rotation system. The process of checking these positions is often called "wall-kicking", since it looks like a piece kicks off a wall during the rotation; and offsets are often stored in a table called "wall-kick table".

# spin
@ title Spin
Sometimes it is possible to use a rotation to move a piece into a position that is unreachable otherwise. This action is called a Spin, and depending on the piece used, it would be called things like "Z-spin", "J-Spin" etc.

A spin resulting in a line clear is a Spin line clear, such as a Z-Spin Single.

Sometimes, certain spin moves that fail to satisfy certain conditions get the "Mini" prefix, like a "Mini Z-Spin". Mini spins get less bonus compared to regular spins.

# all_spin
@ title All Spin
A type of rule in which all pieces can receive bonuses when performing a spin. This is in contract to "T-Spin Only", where only the T piece can receive bonus when performing a spin.

# combo
@ title Combo
Refers to consecutive pieces all resulting in a line clear, without pieces that don't clear lines in between.

# combo_setup
@ title Combo Setups
In order to more easily perform combos, a common technique is to build a tall stack with a 2-column to 4-column wide well, then drop pieces into the well.

# spike
@ title Spike
Refers to sending a lot of attack in a short period of time.

# drop_speed
@ title Drop Speed
@ titleFull Drop Speed: PPS, BPM, LPM
There are a few ways to measure how fast you drop pieces.

PPS refers to Pieces per Second.
BPM refers to Blocks per Minute. Also known as PPM, P for Pieces.
LPM refers to Lines per Minute. There are two ways to calculate this "lines" here, one is to use literal lines cleared, two is to convert from how many pieces you dropped. The latter makes it less sensitive to external factors like garbage lines.

# key_speed
@ title Action Speed
@ titleFull Action Speed: KPS, KPM
There are a few ways to measure how fast you press buttons.

KPS refers to Keys per Second.
KPM refers to Keys per Minute.

# attack_power
@ title Attack Power
@ titleFull Attack Power: APM, APL
There are a few ways to measure your attack output in multiplayer.

APM refers to Attack per Minute.
APL refers to Attack per Line. Sometimes also called "Efficiency".

# das_arr
@ title DAS and ARR
DAS stands for Delayed Auto Shift, and ARR stands for Auto Repeat Rate. The come into play when you hold a direction key to move a piece sideways.

Imagine you are in a text editor, and you hold down a letter key. A letter appears first, and after a little pause, more letters begin to appear quickly. The little pause is DAS, and the rate at which the letters appear quickly is ARR.

A skilled player would tune DAS to be as short as possible while still being able to distinguish between single taps and holds, and tune ARR as close to zero as possible. This gives them the highest potential for speed.

# misaction
@ title Mis-Action
Làm một hành động nào đó nhưng bị lỗi/sai sót. Có 2 kiểu: mis-drop (thả gạch nhầm chỗ/sai thời điểm) và mis-hold (vô tình giữ/đổi gạch)

# gravity
@ title Falling Speed
The speed at which pieces naturally fall when you don't press any buttons.

When falling is relatively slow, the speed is usually described as "X blocks per second" or "one block every X seconds".

When it gets fast, the commonly used unit is G, referring to how many blocks the block falls per frame. For example, 1G refers to 1 block per frame, or 60 blocks per second, assuming a frame rate of 60fps. This speed means the piece falls to the bottom in about a third of a second.

# 20g
@ title 20G
Tốc độ nhanh nhất trong các trò xếp gạch hiện đại. Trong các chế độ xài tốc độ 20G, các viên gạch thay vì rơi từ từ, nó sẽ xuất hiện ngay lập tức ở đáy bảng. Việc này đôi khi sẽ làm bạn không thể di chuyển được theo phương ngang như ý bạn muốn; bởi vì gạch đôi khi cũng không thể leo qua chỗ lồi lõm hoặc ra khỏi hố sâu. Bạn có thể tìm hiểu thêm về đơn vị "G" trong mục "Tốc độ rơi"

#lock_delay
@title Lockdown Delay
The time between "piece touches the The time between "piece touches the floor" and "piece locking and cannot be moved".

This can usually be reset by actions like moving and rotating, giving the player more reaction time even with a fast falling speed.

# spawn_delay
@ title Spawn Delay
Time between one piece locking down and the next piece appearing.

# clear_delay
@ title Line Clear Delay
Time that the line clear animation lasts.

# death_delay
@ title Death Delay
When a piece spawns overlapping an existing block, it will suffocate. After a short delay without addressing the overlap, it will lockdown and trigger a game over.

# death_condition
@ title Game Over
@ titleFull Game Over Conditions
There are different conditions games use to declare a game over. Usually, one or many of the following conditions are used:

1. Newly spawned piece overlaps with an existing block ("Block Out").
2. A piece locks entirely above the skyline ("Lock Out").
3. The total height of the field exceeds a certain limit ("Top Out").

# bag7_sequence
@ title Bag-7 Sequence
A common way to randomly generate a piece sequence, where every 7 pieces in the sequence consists of one of each of the 7 different tetrominoes. This is effective at avoiding situations where a piece doesn't come for a long time ("drought") or appears a lot ("flood").

# his_sequence
@ title His Sequence
A way to randomly generate a piece sequence. It keeps track of the recent few pieces generated, and if the next piece is the same as one of the recent pieces, it will reroll until it rolls a piece that did not appear recently or until a reroll limit is reached.

His generator is an improvement over generating the sequence completely randomly, and greatly reduces the chances that a drought or flood happens.

# half_invis
@ title Half Invis
A rule where pieces fade away after a few seconds after landing.

# full_invis
@ title Full Invis
A rule where pieces instantly goes invisible upon locking down.

# deepdrop
@ title Deep Drop
A rule where pieces can drop down through existing blocks into an opening.

This is more often used when experimenting, as it allows pieces to reach any opening that can hold the piece, without having to worry about rotation system.

# cascade
@ title Gravity
A rule where floating or otherwise disconnected blocks may fall down after clearing a line. This can create chains of line clears known as "Cascade".

"Cascade" is often used to refer the rule itself, due to the potetial confusion between "gravity" and "falling speed".

#mph
@ title MPH 
@ titleFull Memoryless, Previewless, Holdless
A combination of rules: memoryless (pure random piece sequence), previewless (no Next queue), and holdless (no Hold queue).

# multi_rotation
@ title Rotation buttons
@ titleFull Using two or three rotation buttons
Using both CW and CCW rotation buttons can reduce button presses by replacing three rotations of one direction with one rotation in the other direction. It is also a key technique in Finesse.

Using three rotation buttons including a 180-degree rotation button can further reduce button presses, but is less effective at improving your playing, and is not always available depending on the game.

# finesse
@ title Finesse
A technique where you move a piece to a target position using the least number of button presses, saving time and potential to make mistakes.

Usually Finesse only deals with situations where you can directly drop the piece from high up, and does not consider situations where you need to tuck (soft drop then move) or spin.

# hypertap
@ title Hypertap
@ titleFull Hypertap (Nhấn liên tục)
Đề cập tới một kỹ năng là khi bạn rung tay liên tục để nhấn liên tục làm tốc độ di chuyển nhanh hơn

Bây giờ các trò xếp gạch có DAS thấp hơn nhiều so với xếp gạch ngày xưa rồi nên bạn không cần phải Hypertap đâu, nhấn giữ là đủ rồi. Nhưng nếu bạn chơi xếp gạch cổ điển (Classic Tetris) thì cứ dùng đi.

# 26f_studio
@ title 26F Studio
Một nhóm
]]