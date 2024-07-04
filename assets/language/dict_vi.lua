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
… Khoan, chờ khoảng chừng 2 giây!
Bạn vừa nhấn phím tắt à? Ngon lành cành đào rồi đây

# setting_out
@ title Cài đặt
Đây là trang Cài đặt.
Bạn có thể chỉnh một đống thứ ở đây!

# noobGuide
@ title Xin chào!
@ contentSize 25
Cảm ơn bạn đã tải và chơi Techmino!
Đây là một vài đề xuất mà bạn nên làm theo khi chơi. Tuy những đề xuất này được xếp thành nhóm, bạn vẫn nên làm cả ba nhóm cùng lúc thay vì làm từng cái một.

A. Stacking (Xếp gạch)
    A1. Suy nghĩ kỹ trước khi đặt gạch. Chưa vừa ý? Suy nghĩ thêm lần nữa.
    A2. Xếp gạch càng phẳng càng tốt để bạn có thể ra quyết định đặt gạch dễ dàng hơn.
    A3. Lên kế hoạch trước cách xếp, hãy tận dụng tối đa NEXT và HOLD để giữ được thế đẹp. 
~~
B. Efficiency & Speed (Hiệu quả & Tốc độ)
    B1. Trước mỗi lần đặt gạch, hãy suy nghĩ xem bạn sẽ đặt gạch ở đâu? Bấm những phím nào để gạch tới chỗ đó và đứng đúng tư thế? Thay vì dựa dẫm vào gạch ma quá nhiều
    B2. Nên sử dụng 2 (hoặc 3, tùy game) phím xoay thay vì nhấn 1 phím xoay liên tục trong thời gian dài.
    B3. Đừng lo lắng về tốc độ khi bạn mới tập chơi Finesse, đây là chuyện bình thường. Hơn nữa bạn có thể tập chơi nhanh hơn một khi bạn đã quen tay — việc này không khó đâu!
~~
C. Practice (Luyện tập)
    C1. Hoàn thành chế độ "40 hàng"
    C2. Hoàn thành chế độ "40 hàng" mà không dùng HOLD
    C3. Hoàn thành chế độ "40 hàng" mà chỉ được làm Techrash.
    C4. Hoàn thành chế độ "40 hàng" mà chỉ được làm Techrash và không được dùng HOLD

Nhóm C rất linh động, bạn có thể điều chỉnh độ khó dựa trên tình hình/điều kiện của bạn (ví dụ như "không làm bạn chơi quá chậm")
~~
Sau khi bạn hoàn thành hết nhóm C, hãy tiếp tục luyện tập nhóm A, đây là một kỹ năng RẤT quan trọng trong bất kỳ tựa game xếp gạch nào; và bạn sẽ có thể dần dần làm chủ bất kỳ chế độ nào, lúc đó chỉ cần nhìn lướt qua NEXT là đủ rồi.

# keybinding 
@ title Bố cục phím
@ titleFull Lời khuyên về việc làm bố cục phím
@ contentSize 25
Dưới đây là vài lời khuyên hữu ích khi bạn đang chỉnh sửa bố cục phím

1.  Một ngón tay chỉ nên thực hiện một chức năng khác nhau. Ví dụ như: 1 ngón cho sang trái, 1 ngón cho sang phải, 1 ngón cho phím xoay phải, 1 ngón cho rơi mạnh
~~
2.  Trừ khi bạn tự tin với ngót út của mình, thì không nên để ngón tay này làm bất kì việc hết! Ngoài ra, nên xài ngón trỏ và ngón giữa vì hai ngón này là nhanh nhẹn nhất, nhưng bạn cũng có thể thoải mái tìm hiểu xem các ngón tay của mình nhanh chậm thế nào, mạnh yếu ra sao.
~~
3.  Không nhất thiết phải sao chép bố cục phím của người khác, vì không ai giống ai. Thay vào đó hãy chỉnh theo cách của bạn, miễn là bạn chơi thoải mái là được.

# handling
@ title Xử lý gạch
@ titleFull Mẹo khi xử lý gạch
@ contentSize 25
Những yếu tố ảnh hưởng tới việc xử lý gạch của bạn:

(1) Độ trễ đầu vào, có thể là do cấu hình, thông số hoặc tình trạng của thiết bị. Khởi động lại trò chơi, bảo dưỡng, sửa chữa hoặc thay đổi thiết bị của bạn có thể khắc phục vấn đề này.
~~
(2) Trò chơi không ổn định hoặc thiết kế quá sơ sài và nhiều lỗi. Có thể giảm tình trạng này bằng cách chỉnh sửa cài đặt hiệu ứng để ở mức thấp.
~~
(3) Cái gì cũng có mục đích của nó, ngay cả thiết kế cũng vậy. Việc làm quen với chúng có thể giúp bạn.
~~
(4) Cài đặt thông số xử lý gạch không phù hợp (ví dụ: DAS, ARR, SDARR,…). Thay đổi cài đặt.
~~
(5) Tư thế chơi không hợp lý, có thể gây ra bất tiện trong những thời điểm quan trọng. Nên tìm tư thế chơi phù hợp sao cho thuận tiện khi chơi.
~~
(6) Thao tác không quen sau khi đổi vị trí phím hay thay đổi sang thiết bị mới. Tập làm quen với chúng hoặc thay đổi cài đặt có thể hữu ích.
~~
(7) Mỏi cơ, chuột rút,… làm cho việc phản ứng và phối hợp tay khó khăn hơn. Hãy nghỉ ngơi và trở lại sau một hoặc vài ngày.

# piece_shape
@ title Những viên gạch
@ titleFull Tetromino
Trong các trò xếp gạch, các viên gạch là những khối có 4 ô liên kết với nhau

Mỗi trò xếp gạch đều có tổng cộng có bảy viên gạch khác nhau. Chúng được đặt tên theo chữ cái trong bảng chữ cái giống với hình dáng của chúng. Đó là Z, S, J, L, T, O, I.

# piece_color
@ title Màu của gạch
@ titleFull Màu của Tetromino
Thông thường, các viên gạch có cùng hình dáng sẽ có cùng màu. Nó sẽ giúp bạn dễ dàng phân biệt và nhớ chúng lâu hơn

# piece_direction
@ title Hướng của viên gạch
@ titleFull Hướng của Tetromino
@ contentSize 25
Thông thường, tetromino sẽ được sinh ra với hướng xoay nhất định (Nói cách khác: hệ thống xoay sẽ quyết định hướng gạch mặc định khi sinh ra, gạch có cùng hình dạng sẽ được sinh ra với cùng hướng xoay). Với một số hệ thống xoay, hướng xoay của gạch sẽ ảnh hưởng đến việc "đá" gạch

Có vài cách để nói về hướng của tetromino. Các kí tự chủ yếu được dùng là "0", "L", "R", "2"

Trong đó:
0 - Hướng mặc định của hệ thống xoay
L - Xoay trái (xoay ngược chiều)
R - Xoay phải (xoay cùng chiều)
2 - Lật dọc   (xoay 180 độ/xoay trái hoặc phải hai lần)

# next
@ title Next (Kế/Tiếp)
Hiện nhưng viên gạch sẽ lần lượt rơi xuống. Có thể sử dụng ô này để lên kế hoạch trước cách xếp một cách tốt hơn. 

# hold
@ title Hold (Giữ)
Lưu gạch hiện tại để dùng lại sau và lấy gạch đang giữ ra dùng (hoặc là lấy gạch tiếp theo, nếu chưa giữ gạch nào trước đó). Cho phép bạn đổi thứ tự gạch sẽ xuất hiện. Có thể dùng một cách chiến lược, hay đơn giản hơn là thử gạch khác nếu gạch hiện tại không có chỗ đặt lý tưởng.

# clear
@ title Xóa 1/2/3/4 hàng
@ titleFull Single, Double, Triple và Techrash
Đề cập tới số hàng bạn xóa sau khi bạn đặt gạch

Single = Xóa 1 hàng.
Double = Xóa 2 hàng.
Triple = Xóa 3 hàng.
Techrash = Xóa 4 hàng.

# clear_big
@ title Xóa >4 hàng?
@ titleFull Có thể xóa hơn 4 hàng không?
Mặc dù thông thường, bạn chỉ có thể xóa 4 hàng cùng một lúc (Techrash), nhưng có những chế độ với các quy tắc đặc biệt cho phép bạn xóa nhiều hàng hơn cùng một lúc. Ví dụ: xóa 5 hàng được gọi là Pentacrash và xóa 6 hàng được gọi là Hexacrash.

# b2b
@ title Back to Back
@ titleFull Back to Back (BtB, B2B)
Đề cập tới việc thực hiện một trong hai kiểu xóa đặc biệt (Techrash và dùng -spin để xóa hàng - ví dụ như "-spin Đôi") ít nhất 2 lần, và không bị ngắt quãng bằng việc xóa 1-2-3 hàng thông thường.

~~6
Một vài game nếu có bản dịch tiếng Việt thì có thể dịch từ "Back-to-Back" thành từ "Liên tiếp"
Ví dụ trong Tetra Legend, nếu bạn làm Techrash - Back to Back thì bạn sẽ thấy dòng chữ "Bốn (Liên tiếp)".

# all_clear
@ title Perfect Clear
@ titleFull Perfect Clear (PC)
Tên khác: All Clear (AC).
Xóa sạch toàn bộ gạch ở trong bảng.

# half_clear
@ title Half Clear
@ titleFull Half Clear (HC)
Một biến thể của All Clear, Half Clear chính là All Clear "nhưng vẫn còn gạch ở dưới hàng vừa xóa"
Trong trường hợp đặc biệt, nếu xóa một hàng, thì trẻn bảng không được còn gạch do người chơi đặt.

# rotation_system
@ title Hệ thống xoay gạch
@ titleFull Rotation System (Hệ thống xoay gạch)
Khi xoay gạch, nếu gạch đó chồng chéo lên gạch khác hoặc là đụng tường, trò chơi sẽ kiểm tra lần lượt các vị trí liền kề để xem gạch có thể đặt ở vị trí nào xung quanh hay không. Điều này giúp cho gạch ít có khả năng bị kẹt (hoặc là không xoay được).

Một hệ thống xác định những vị trí để kiểm tra gạch có xoay được hay không khi xoay gạch chính là rotation system (hệ thống xoay). Và quá trình kiểm tra các vị trí này được gọi là "wall-kicking" ('đá' tường), vì có vẻ như gạch đá ra khỏi tường khi xoay gạch; và các vị trí đá thường sẽ được lưu trữ ở trong một cái bảng gọi là "wall-kick table" (có thể hiểu là: "bảng các vị trí sau khi gạch 'đá' tường").

~~6
Ghi chú: Trong tiếng Việt, từ "xoay" đồng nghĩa với từ "quay", bạn có thể gọi Rotation System là "Hệ thống quay gạch" - tùy vào ý thích của bạn.

# spin
@ title Spin
--
-- Do not translate "Spin" into "Quay" or "Xoay" because it can be confused!
--
Đôi khi bạn có thể xoay gạch để di chuyển tới một vị trí mà thông thường sẽ không tiếp cận được. Hành động này được gọi là "Spin".

~~3

CHÚ Ý: Đừng nhầm lẫn với Rotate - Xoay, mặc dù nhìn lướt qua bạn sẽ thấy cả hai từ có nghĩa tương đương nhau.

~~3
Tùy thuộc vào gạch bạn sử dụng để xoay mà hành động này sẽ được gọi với các tên khác nhau. Ví dụ: "Z-spin", "S-spin", v.v.

Đôi khi việc spin gạch không đáp ứng đủ các điều kiện nhất định thì sẽ nhận được tiền tố "Mini" vào trong tên. Ví dụ: "Mini Z-spin". Thường thì Mini-spin sẽ gửi ít hàng rác hơn và nhận được ít điểm hơn so với spin thông thường.

~~
Khi bạn xóa được hàng bằng cách sử dụng Spin, bạn vừa dùng Spin để xóa hàng.

Khi đó, bạn sẽ nhìn thấy được dòng chữ "-spin Single"/"-spin Double"/"-spin Triple" (-spin Đơn/-spin Đôi/-spin Tam) khi bạn xóa được 1/2/3 hàng bằng spin.

# all_spin
@ title All Spin
Một quy tắc trong đó khi dùng Spin nào để xóa hàng đều có thể gửi thêm hàng rác (hoặc nhận thêm điểm) so với xóa thông thường. 
Quy tắc này đối lập với quy tắc "Chỉ dùng T-spin" (T-spin only) khi mà chỉ được dùng T-spin để xóa hàng để gửi thêm hàng rác (hoặc nhận thêm điểm).

# combo
@ title Combo
Xóa nhiều hàng liên tiếp mà không có gạch nào không xóa hàng!

# combo_setup
@ title Combo Setup
Để dễ dàng thực hiện combo, có một kỹ thuật phổ biến đó là xếp chồng gạch tạo thành một bức tường cao với một cái "hố" rộng từ 2 đến 4 cột, sau đó thả gạch vào "hố" để xóa nhiều hàng liên tiếp.

# spike
@ title Spike
Đề cập tới việc liên tục gửi rất nhiều rác trong một khoảng thời gian ngắn.
Lưu ý: hầu hết trò chơi sẽ tính spike nếu gửi hơn 10 hàng rác cùng một lúc

# drop_speed
@ title Tốc độ thả rơi
@ titleFull Drop Speed (Tốc độ thả rơi): PPS, BPM, LPM
@ titleSize 40
Có vài cách để đo tốc độ bạn thả gạch:

PPS viết tắt của Pieces per Second (Số gạch/giây).
~~
BPM viết tắt của Blocks per Minute (Số gạch/phút). Còn được biết đến với một tên khác là PPM, P là viết tắt của Pieces (gạch).
~~
LPM viết tắt của Lines per Minute (Số hàng/phút).
Có hai cách để tính số hàng ở đây:
    1. Dùng số hàng đã xóa.
    2. Đổi từ số gạch đã thả. Việc này giúp cho việc tính số hàng ít bị ảnh hưởng từ yếu tố bên ngoài: ví dụ như các hàng rác.

# key_speed
@ title Tốc độ hành động
@ titleFull Action Speed (Tốc độ hành động): KPS, KPM
@ titleSize 40
Có vài cách để đo tốc độ bạn nhấn phím.

KPS viết tắt của Keys per Second (Số phím/giây).
KPM viết tắt của Keys per Minute (Số phím/phút).

# attack_power
@ title Khả năng tấn công
@ titleFull Attack Power (Tấn công): APM, APL
Có vài cách để đo khả năng tấn công trong chế độ nhiều người chơi.

APM viết tắt của Attack per Minute (hàng gửi/phút).
APL viết tắt của Attack per Line (Số hàng gửi/Số hàng xóa). Đôi lúc còn được gọi là "Efficiency" (Độ hiệu quả).

# das_arr
@ title DAS và ARR
DAS viết tắt của Delayed Auto Shift, và ARR viết tắt của Auto Repeat Rate. Gạch sẽ bắt đầu di chuyển khi bạn giữ một phím di chuyển để di chuyển gạch sang một bên tương ứng.

~~
Tưởng tượng bạn đang ở trong trình chỉnh sửa văn bản (hay là bất cứ nơi nào bạn có thể gõ văn bản), và nhấn giữ một phím chữ cái nào đó. Một chữ cái đầu tiên xuất hiện, rồi nhiều chữ cái sau đó nhanh chóng xuất hiện theo.
Giải thích:
    Sau khi chữ cái thứ nhất xuất hiện, máy tính chờ một khoảng thời gian - khoảng đó là DAS - rồi hiện chữ cái thứ hai.
    Chữ cái thứ hai xuất hiện, máy tính chờ tiếp một khoảng thời gian nhưng lần này ngắn hơn - khoảng này là ARR - rồi hiện chữ cái thứ ba.
    Chữ cái thứ ba xuất hiện, máy tính tiếp tục chờ tiếp một khoảng thời gian ngắn - ARR - rồi hiện chữ cái thứ tư.
    Cứ tiếp tục như vậy cho tới khi bạn nhả tay ra.

Hoặc là bạn cũng có thể nhìn vào cột biểu diễn thời gian ở bên dưới cho dễ hình dung
<-\--\--DAS-\--\--><-ARR-><-ARR-><-ARR-><-ARR-><-ARR->…

~~
Trên thực tế, để tối ưu hóa tốc độ, nhiều người chơi thường sẽ chỉnh DAS ngắn nhất có thể và ARR gần bằng 0; việc này giúp cho họ cho rút ngắn được thời gian di chuyển, trong khi vẫn có thể điều khiển được gạch theo ý họ muốn.

# misaction
@ title Mis-Action
Làm một hành động nào đó nhưng bị lỗi/sai sót. Có 2 kiểu: mis-drop (thả gạch nhầm chỗ) và mis-hold (vô tình giữ/đổi gạch)

# gravity
@ title Tốc độ rơi
@ titleFull Tốc độ rơi (Falling speed)
Tốc độ rơi tự nhiên của viên gạch, khi mà bạn không nhấn nút nào.

Nếu tốc độ rơi đủ chậm, thì nó thường sẽ được diễn tả là "X ô trên giây" hoặc "một ô sau mỗi X giây".

Nhưng khi ở tốc độ cao, thì tốc độ sẽ dùng đơn vị G (Gravity - Trọng lực), ứng với số ô mà gạch rơi xuống sau mỗi khung hình. 

~~
Lấy ví dụ: (giả sử tốc độ khung hình hiện tại là 60FPS)
1/60G tức là 1/60 ô / 1 khung hình <-\--> 1 ô / 1 giây
1G tức là 1 ô / 1 khung hình <-\--> 60 ô / 1 giây
20G tức là 20 ô / 1 khung hình <-\--> 1200 ô / 1 giây

# 20g
@ title 20G
Tốc độ nhanh nhất trong các trò xếp gạch hiện đại. Trong các chế độ xài tốc độ 20G, các viên gạch thay vì rơi từ từ, nó sẽ xuất hiện ngay lập tức ở đáy bảng. Việc này đôi khi sẽ làm bạn không thể di chuyển được theo phương ngang như ý bạn muốn; vì gạch không thể leo qua chỗ lồi lõm hoặc ra khỏi hố sâu.
Bạn có thể tìm hiểu thêm về đơn vị "G" trong mục "Tốc độ rơi".

# lock_delay
@ title Lockdown Delay
@ titleFull Lockdown Delay (Thời gian chờ khóa gạch)
@ titleSize 45
Khoảng thời gian nằm giữa "gạch vừa chạm vào đáy bảng" và "gạch bị khóa và không thể di chuyển".

Khoảng thời gian này có thể reset nếu kịp thực hiện một hành động nào đó như di chuyển hay xóa gạch, cho phép người chơi có thêm thời gian phản ứng, ngay cả khi gạch rơi với tốc độ nhanh.

# spawn_delay
@ title Spawn Delay
@ titleFull Spawn Delay (Thời gian chờ gạch sinh ra)
Khoảng thời gian từ lúc gạch bị khóa cho tới khi gạch mới được sinh ra.

# clear_delay
@ title Line Clear Delay
@ titleFull Line Clear Delay (Thời gian chờ xóa hàng)
Thời gian để hiệu ứng xóa hàng thực hiện xong.

# death_delay
@ title Death Delay
@ titleFull Death Delay (Thời gian chờ chết)
Khi một viên gạch xuất hiện chồng lên gạch hiện có, xảy ra hiện tượng "Nghẽn gạch". Sau một khoảng thời gian mà không giải quyết được hiện tượng đó, trò chơi kết thúc.

# death_condition
@ title Trò chơi kết thúc
@ titleFull Trò chơi kết thúc khi nào?
Có những điều kiện khác nhau mà trò chơi sử dụng để xem trò chơi đã kết thúc hay chưa:

1. Gạch mới được sinh ra chồng chéo với một gạch đã đặt ("Block Out").
2. Có gạch nằm trên vùng skyline (đường chân trời) ("Lock Out").
3. Độ cao của bảng vượt quá độ cao cho phép ("Top Out").

# bag7_sequence
@ title Bag-7 Sequence
@ titleFull Bag-7 Sequence (Kiểu xáo Túi 7 gạch)
@ titleSize 40
Một trong những kiểu xáo gạch được dùng rộng rãi trong các trò xếp gạch.

Để dễ hình dung về cách hoạt động của nó, hãy tưởng tượng như thế này: Bạn có một chiếc hộp có vô số túi, và mỗi túi trong đó có đủ 7 Tetromino: Z, S, J, L, T, O, I. Lấy một túi ngẫu nhiên rồi mở nó ra, bốc 7 viên gạch một cách ngẫu nhiên mà không được nhìn túi. Thứ tự của 7 gạch vừa mang ra chính là một chuỗi gạch. Tiếp tục lấy một túi khác và thực hiện liên tục như vậy cho tới khi trò chơi kết thúc.

Cách xáo gạch này cho phép tránh được hai tình trạng sau:
    - Flood: tình trạng một viên gạch nào đó bị sinh ra quá nhiều trong một khoảng thời gian dài
    - Drought: tình trạng một viên gạch nào đó không được sinh ra trong một khoảng thời gian dài.

# his_sequence
@ title His Sequence
@ titleFull His Sequence (Kiểu xáo His)
Một kiểu xáo ngẫu nhiên. Kiểu xáo này sẽ nhớ một vài gạch đã được sinh ra gần nhất. Nếu gạch vừa bốc ngẫu nhiên bị trùng với bất kì miếng nào trong bộ nhớ đó, một viên gạch sẽ được bốc lại; cho tới khi: gạch vừa bốc ra không còn trùng nữa, hoặc là đã quá số lượt bốc lại.

Cách xáo này là một cải tiến lớn so với cách xáo gạch hoàn toàn ngẫu nhiên và giảm đáng kể tình trạng drought hoặc flood xảy ra.

# half_invis
@ title Half Invis
@ titleFull Half Invis (Tàng hình một phần)
Gạch sẽ biến mất sau vài giây từ lúc nó được đặt xuống.

# full_invis
@ title Full Invis
@ titleFull Full Invis (Tàng hình hoàn toàn)
Gạch sẽ biến mất ngay lập tức sau khi nó được đặt xuống.

# deepdrop
@ title Deep Drop
Một quy tắc trong đó gạch có thể chìm xuống dưới, xuyên qua cả gạch đã đặt, để xuống lố sâu hơn.

Điều này thường được sử dụng khi thử nghiệm, vì nó cho phép các viên gạch tiếp cận bất kỳ hố nào có thể chứa miếng gạch mà không cần lo lắng về hệ thống xoay.

# cascade
@ title Gravity
Một quy tắc trong đó các gạch nổi hoặc bị mất liên kết có thể rơi xuống sau khi xóa một hàng. Điều này có thể tạo ra các chuỗi xóa hàng được gọi là "Cascade".

"Cascade" (thác nước) là từ hay dùng nhiều để nói về quy tắc này, bởi vì hai từ "gravity" (trọng lực) and "falling speed" (tốc độ rơi) có thể gây nhầm lẫn với hai khái niệm khác.

# mph
@ title MPH 
@ titleFull Memoryless, Previewless, Holdless
Sự kết hợp của ba quy tắc: "Không nhớ gì" (chuỗi gạch tạo ra hoàn toàn ngẫu nhiên), "Không biết trước gạch nào sẽ tới" (không hiện NEXT), và "Không giữ được".

# multi_rotation
@ title Xoay về hướng nào?
@ titleFull Hãy dùng hai hoặc ba phím xoay
Dùng cả 2 nút xoay phải và xoay trái có thể giảm số lần nhấn nút bằng cách nhấn một nút xoay này thay vì ba lần nút xoay kia. Đây cũng là một trong những kỹ thuật quan trọng trong Finesse.

Nếu bạn có thể dùng cả 3 nút xoay: xoay trái, xoay phải và xoay 180 độ; thì có thể giảm số nút cần để xoay. Nhưng hãy lưu ý rằng sử dụng nút xoay 180 độ có thể không giúp bạn cải thiện kỹ năng chơi, vì nút này không phải ở chế độ nào hay game nào cũng có.

# finesse
@ title Finesse
@ titleFull Finesse (tạm dịch: Sự khéo léo)
Một kỹ thuật mà bạn di chuyển gạch đến vị trí bạn muốn bằng cách bấm phím với số lần nhấn phím ít nhất có thể; giúp tiết kiệm thời gian và giảm khả năng mắc lỗi di chuyển

Thông thường Finesse chỉ tính những trường hợp mà bạn có thể thả gạch từ trên cao xuống dưới, không tính những trường hợp mà cần phải tuck (rơi nhẹ rồi di chuyển) hoặc xoay gạch.

# hypertap
@ title Hypertap
@ titleFull Hypertap (Nhấn liên tục)
Đề cập tới một kỹ năng là khi bạn rung tay liên tục để nhấn liên tục làm tốc độ di chuyển nhanh hơn

Kỹ năng này được dùng nhiều trong xếp gạch cổ điển (Classic Tetris)

# 26f_studio
@ title 26F Studio
Một tổ chức
]]