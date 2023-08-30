--[[
Comment from User670
Yes I did this kind of stupid thing again, this time within Lua, no more
Python needed lol (I can always replace this with vanilla Lua table...)

Format guide

#internal_id
@property value
Content isn't prefixed with anything
and can span multiple lines.

Having empty lines in the text is also fine, and the empty lines will be preserved.

There is no line continuation for now, so you have to use long lines in the source code for long paragraphs.
]]

--[[
Comment from MrZ

Translation guideline:
1. You can switch orders of entries, and this doesn't affect what is shown
   in game. However, it's not recommended to change the order so that it's
   easier to find the entry you or someone else wants to edit
2. For "about" and "guide" type entries, keep the "you" if original text
   does so. Make it feel like you are talking directly to the player.
3. For "terms" and "technique" type entries, avoid vocabulary that "feel
   obvious like joking", "directly refers to a player", eg "the player" or
   "the game". Try to avoid these by rephrasing your sentence.
4. Keep this comment at the top of the file too, translated, so that other
   translators can see and translate this too
]]

local dict_field_metadata={
    title="string",
    titleFull="string",
    titleSize="int",
    content="string",
    contentSize="int",
    link="string"
}

local dict_string=[[
#aboutDict
@title About This
@titleFull About ZDictionary
Here's something that helps you nagivate the game!

#aboutDict_hidden
@title About This?
@titleFull About ZDictionary?
Here's something that helps you navigate the game!
... Wait. Did you open this with a hotkey? Nice to know you can do that!

#setting_out
@title Settings
The Settings menu is where you adjust, well, various settings.

#noobGuide
@title Welcome!
@titleFull Welcome to Techmino!
These are sets of missions that you need to accomplish. When there is order within each set, we recommend you to do all three sets of tasks simultaneously instead of one by one. 

A. Stacking
	A1. Think twice before you place your block. If your first decision doesn’t seem to fit well, think again.
	A2. Keep your terrain flat since it allows more possibilities for different blocks.
B. Efficiency & Speed
	B1. Don’t count on ghost pieces. Think, with your brain, where this piece would land and what keys you should press. Do it only when you are ready. 
	B2. Use both of the rotation keys. Don’t just use one and press it many times when you can press the other one just once. 
	B3. Don’t worry too much about your speed when you start learning Finesse. Keep your move accurate, and then it is not hard to improve your speed once you have mastered it. 
C. Stacking
	C1. Finish 40L without topping out. 
	C2. Finish 40L with no Hold without losing too much speed. 
	C3. Finish 40L with all Techrashes without losing too much speed. 
	C4. Finish 40L with all Techrashes and no Hold without losing too much speed. 

Set C is more flexible, and you can adjust the difficulties based on your own conditions (like what does “without losing too much speed” means to you). 

When you finish all the tasks in set C, keep practicing A1. This is the fundamental skill in any Tetris game, and you can master practically any mode when you can just scan through the Next sequence easily.

#keybinding
@title Keybinds
@titleFull Keybinds Suggestions
Here're some general principles for configuring your controls.

1. Avoid assigning one finger to multiple keys that you might want to press together - for example, you won't typically need to press the multiple rotation buttons together. Try assigning other buttons to one finger each.
2. Unless you are confident with your pinky, probably avoid assigning it a button. Usually the pointer finger and middle finger are the most agile, but feel free to see how your own fingers perform.
3. No need to copy someone else's key config. Every person is different; as long as you keep these ideas in mind, using a different key config should have minimal impact on your skills.

#handling
@title Handling
@titleFull Handling Suggestions
Several main factors that may affect handling:
(1) Input delay, which could be affected by device configuration or condition. Restart the game or change your device can probably fix it.
(2) Unstable programming or faulty designs. It could be alleviated by lowering the effect settings.
(3) Designed on purpose. Adaptation might help.
(4) Improper parameter setting. Change the settings.
(5) Improper play posture. It’s not convenient to use force. Change your posture.
(6) Not being used to the operation after changing the key position or changing the device. Getting used to it or changing the settings might help.
(7) Muscle fatigue, response, and decreases in coordination abilities. Have some rest and come back later or in a few days.

#piece_shape
@title Pieces' Shapes
@titleFull Tetrominos' Shapes
In standard Tetris games, all the blocks used are tetrominos, i.e., Blocks that are linked by four minoes side-by-side.

There are seven kinds of tetrominos in total when allowing rotations and disallowing reflections. These tetrominos are named by the letter in the alphabet that they resemble. They are Z, S, J, L, T, O, and I. See the “Shape & Name” entry for more information.

#piece_color
@title Pieces' Colors
@titleFull Tetrominos' Colors
Usually, tetrominos with the same shape are given the same color. This helps you to distinguish and remember the tetrominoes easier.

#piece_direction
@title Pieces' Directions
@titleFull Tetrominos' Directions
Usually, tetrominos spawn with a consistent rotation state (in other words, it won't spawn in one direction sometimes but in another direction some other times). Some rotation systems also take a tetromino's direction into account when deciding what direction to kick the tetromino.

There are a few ways to refer to different rotations of a tetromino. A commonly used system is "0", "R", "2", "L" - 0 refers to a tetromino's direction when it spawns, R and L (for Right and Left respectively) refer to the direction after rotating right (CW) or left (CCW) once (90 degrees), and 2 refers to the direction after rotating twice (i.e. 180 degrees).

#next
@title Next
Displays the next few pieces to come. It is an essential skill to plan ahead where to place blocks in the Next queue to improve your Tetris skill.

#hold
@title Hold
Save your current piece for later use, and take out a previously held piece (or next piece in the next queue, if no piece was held) to place instead. Enables placing pieces in a different order. Can be used strategically, or simply to try another piece when the current piece isn't ideal.

#clear
@title Line Clears
@titleFull Singles, Doubles, Triples and Techrashes
Refer to the number of lines you clear at once, after dropping a piece.

Single = clear 1 line.
Double = clear 2 lines.
Triple = clear 3 lines.
Techrash = clear 4 lines.

#clear_big
@title Bigger Line Clears
@titleFull Line Clears Beyond Techrashes
While normally you can only clear 4 lines at a time (Techrash), there are modes with special rules that enable you to clear more lines at once. For example, clearing 5 lines is called Pentacrash, and clearing 6 lines is called Hexacrash.

#b2b
@title Back to Back
@titleFull Back to Back (BtB, B2B)
Refers to making at least two special line clears (usually this refers to Techrashes and Spin line clears) without making regular line clears in between.

#all_clear
@title All Clear
@titleFull All Clear (AC)
Also known as Perfect Clear (PC).
Clear all minoes on the field.

#half_clear
@title Half Clear
@titleFull Half Clear (HC)
An extension to All Clear, refers to All Clears "with remaining blocks below the cleared lines."
As a special case, if the line clear is a Single, then there cannot be player-placed blocks remaining.

#rotation_system
@title Rotation Systems
When rotating a piece, if it results in the piece overlapping with existing blocks or the wall/floor, the game may test adjacent positions to see if they are available. This makes it less likely for a rotation to fail and get stuck.

A system that defines what positions gets checked during a rotation is called a rotation system. The process of checking these positions is often called "wall-kicking", since it looks like a piece kicks off a wall during the rotation; and offsets are often stored in a table called "wall-kick table".

#spin
@title Spin
Sometimes it is possible to use a rotation to move a piece into a position that is unreachable otherwise. This action is called a Spin, and depending on the piece used, it would be called things like "Z-spin", "J-Spin" etc.

A spin resulting in a line clear is a Spin line clear, such as a Z-Spin Single.

Sometimes, certain spin moves that fail to satisfy certain conditions get the "Mini" prefix, like a "Mini Z-Spin". Mini spins get less bonus compared to regular spins.

#all_spin
@title All Spin
A type of rule in which all pieces can receive bonuses when performing a spin. This is in contract to "T-Spin Only", where only the T piece can receive bonus when performing a spin.

#combo
@title Combo
Refers to consecutive pieces all resulting in a line clear, without pieces that don't clear lines in between.

#combo_setup
@title Combo Setups
In order to more easily perform combos, a common technique is to build a tall stack with a 2-column to 4-column wide well, then drop pieces into the well.

#spike
@title Spike
Refers to sending a lot of attack in a short period of time.

#drop_speed
@title Drop Speed
@titleFull Drop Speed: PPS, BPM, LPM
There are a few ways to measure how fast you drop pieces.

PPS refers to Pieces per Second.
BPM refers to Blocks per Minute. Also known as PPM, P for Pieces.
LPM refers to Lines per Minute. There are two ways to calculate this "lines" here, one is to use literal lines cleared, two is to convert from how many pieces you dropped. The latter makes it less sensitive to external factors like garbage lines.

#key_speed
@title Action Speed
@titleFull Action Speed: KPS, KPM
There are a few ways to measure how fast you press buttons.

KPS refers to Keys per Second.
KPM refers to Keys per Minute.

#attack_power
@title Attack Power
@titleFull Attack Power: APM, APL
There are a few ways to measure your attack output in multiplayer.

APM refers to Attack per Minute.
APL refers to Attack per Line. Sometimes also called "Efficiency".

#das_arr
@title DAS and ARR
DAS stands for Delayed Auto Shift, and ARR stands for Auto Repeat Rate. The come into play when you hold a direction key to move a piece sideways.

Imagine you are in a text editor, and you hold down a letter key. A letter appears first, and after a little pause, more letters begin to appear quickly. The little pause is DAS, and the rate at which the letters appear quickly is ARR.

A skilled player would tune DAS to be as short as possible while still being able to distinguish between single taps and holds, and tune ARR as close to zero as possible. This gives them the highest potential for speed.

#misaction
@title Mis-Action
Doing an action by mistake. There are two types, mis-drop and mis-hold.

#gravity
@title Falling Speed
The speed at which pieces naturally fall when you don't press any buttons.

When falling is relatively slow, the speed is usually described as "X blocks per second" or "one block every X seconds".

When it gets fast, the commonly used unit is G, referring to how many blocks the block falls per frame. For example, 1G refers to 1 block per frame, or 60 blocks per second, assuming a frame rate of 60fps. This speed means the piece falls to the bottom in about a third of a second.

#20g
@title 20G
@titleFull 20G (Instant Falling Speed)
Since usually the matrix is 20 blocks tall, a falling speed of 20G means a block would fall to the bottom of the matrix within one frame, effectively instantly. Thus 20G is also refers to a falling speed where the piece instantly falls to the bottom.

At such a falling speed, there is no in-between state for the fall, and it is easy to get a piece stuck in a terrain where there are bumps on the side that the piece cannot climb over.

#lock_delay
@title Lockdown Delay
The time between "piece touches the floor" and "piece locking and cannot be moved".

This can usually be reset by actions like moving and rotating, giving the player more reaction time even with a fast falling speed.

#spawn_delay
@title Spawn Delay
Time between one piece locking down and the next piece appearing.

#clear_delay
@title Line Clear Delay
Time that the line clear animation lasts.

#death_delay
@title Death Delay
When a piece spawns overlapping an existing block, it will suffocate. After a short delay without addressing the overlap, it will lockdown and trigger a game over.

#death_condition
@title Game Over
@titleFull Game Over Conditions
There are different conditions games use to declare a game over. Usually, one or many of the following conditions are used:

1. Newly spawned piece overlaps with an existing block ("Block Out").
2. A piece locks entirely above the skyline ("Lock Out").
3. The total height of the field exceeds a certain limit ("Top Out").

#bag7_sequence
@title Bag-7 Sequence
A common way to randomly generate a piece sequence, where every 7 pieces in the sequence consists of one of each of the 7 different tetrominoes. This is effective at avoiding situations where a piece doesn't come for a long time ("drought") or appears a lot ("flood").

#his_sequence
@title His Sequence
A way to randomly generate a piece sequence. It keeps track of the recent few pieces generated, and if the next piece is the same as one of the recent pieces, it will reroll until it rolls a piece that did not appear recently or until a reroll limit is reached.

His generator is an improvement over generating the sequence completely randomly, and greatly reduces the chances that a drought or flood happens.

#half_invis
@title Half Invis
A rule where pieces fade away after a few seconds after landing.

#full_invis
@title Full Invis
A rule where pieces instantly goes invisible upon locking down.

#deepdrop
@title Deep Drop
A rule where pieces can drop down through existing blocks into an opening.

This is more often used when experimenting, as it allows pieces to reach any opening that can hold the piece, without having to worry about rotation system.

#cascade
@title Gravity
A rule where floating or otherwise disconnected blocks may fall down after clearing a line. This can create chains of line clears known as "Cascade".

"Cascade" is often used to refer the rule itself, due to the potetial confusion between "gravity" and "falling speed".

#mph
@title MPH
@titleFull Memoryless, Previewless, Holdless
A combination of rules: memoryless (pure random piece sequence), previewless (no Next queue), and holdless (no Hold queue).

#multi_rotation
@title Rotation buttons
@titleFull Using two or three rotation buttons
Using both CW and CCW rotation buttons can reduce button presses by replacing three rotations of one direction with one rotation in the other direction. It is also a key technique in Finesse.

Using three rotation buttons including a 180-degree rotation button can further reduce button presses, but is less effective at improving your playing, and is not always available depending on the game.

#finesse
@title Finesse
A technique where you move a piece to a target position using the least number of button presses, saving time and potential to make mistakes.

Usually Finesse only deals with situations where you can directly drop the piece from high up, and does not consider situations where you need to tuck (soft drop then move) or spin.

#hypertap
@title Hypertapping
Quickly vibrating a finger and rapidly pressing down a button. Often used in games where DAS is very slow or otherwise unsuitable to hold down a button in order to achieve faster or more flexible movements.

#26f_studio
@title 26F Studio
An organization.
]]

local function parse_dict(ds)
    local arr=string.split(ds, "\n")
    local result={}
    --local idx=0
    local current=""
    local pv={} -- can't think of a better name. property-(and)-value
    
    local empty_lines=0
    
    for n, s in next, arr do
        if string.sub(s, 1, 1)=="#" then
            -- #id
            current=string.sub(s, 2)
            result[current]={content=""}
            empty_lines=0
        elseif string.sub(s, 1, 1)=="@" then
            -- @property value
            pv=string.split(string.sub(s,2)," ")
            if dict_field_metadata[pv[1]]=="int" then
                result[current][pv[1]]=tonumber(pv[2])
            else
                result[current][pv[1]]=table.concat(pv, " ", 2)
            end
            empty_lines=0
        elseif string.trim(s)=="" then
            -- count empty lines that potentially go into content
            empty_lines=empty_lines+1
        else
            -- assume is part of content
            if result[current]["content"]~="" then
                result[current]["content"]=result[current]["content"]..(string.rep("\n",empty_lines+1))
            end
            empty_lines=0
            result[current]["content"]=result[current]["content"]..s
        end
    end
    return result
end

return parse_dict(dict_string)