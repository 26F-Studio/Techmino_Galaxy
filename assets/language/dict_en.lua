--[[
Format instruction:
# [entry]      Entry ID, leave it as it is
@ title        Title (Required), multiple titles will be treated as multi-line title (only show first line in the list)
@ titleFull    Full title (Optional), displayed at the item page, default to be same as title, multiple titles also treated as multi-line title
@ titleSize    Font size of title (Optional), default to 50, will be rounded to multipl of 5
@ contentSize  Font size of content (Optional), default to 30, also auto rounded
@ link         Extern link (Optional)
Text, text text text
Text, text text text
……(Any number of lines)

You can add "-- Comment" at the end of any line, if the whole line is comment, it will not be displayed
If a line start with "~~", it will be treated as a separator. At least two "~" are required, and you can add a number after "~" to specify the thickness of the separator, default to 1
When there is format error, the game will show the error message at the top left corner when you open the dictionary. (the line number does not include the lines of this instruction)

Translation notes:
    1. This file can only affect the text content of the entries. Changing the order of the entries will not affect their final order in the dictionary, so it is not recommended to adjust the order
    2. In entries of menu introduction/tutorial type, TRY KEEPING the "you" (player) as the subject to create a sense of dialogue
    3. In entries of terminology/skill type, try to keep the description serious, AVOID USING words like "game" that obviously have an entertainment meaning in current language environment, or pronouns like "player" that directly refer to the player (you can avoid them by omitting and changing the sentence structure, as long as it does not affect the meaning)
    4. Please translate all the above instructions and put them in the same position for other translators to translate into other languages more easily
]]

return [[
# aboutDict
@ title About This
Help you learn everything around here.

# setting_out
@ title Setting
The setting page.
You can change a bunch of settings here.

# noobGuide
@ title Welcome Newcomers
@ contentSize 20
These are sets of missions that you need to accomplish. When there is order within each set, we recommend you to do all three sets of tasks simultaneously instead of one by one.
~~11
A. Stacking

A1. Think twice before you place your block. If your first decision doesn’t seem to fit well, think again.
A2. Keep your terrain flat since it allows more possibilities for different blocks.
A3. When hold allowed, thinking more about sequences to arrange the pieces in your hand, the held one, plus the previews. In order to have flat terrain for longer time.
~~
B. Efficiency & Speed

B1. Don’t count on ghost pieces. Think, with your brain, where this piece would land and what keys you should press. Do it only when you are ready.
B2. Use both of the rotation keys. Don’t just use one and press it many times when you can press the other one just once.
B3. Don’t worry too much about your speed when you start learning Finesse. Keep your move accurate, and then it is not hard to improve your speed once you have mastered it.
~~
C. Stacking

C1. Stably finish 40L without topping out.
C2. Stably finish 40L with no Hold without topping out.
C3. Stably finish 40L with all Techrashes.
C4. Stably finish 40L with all Techrashes and no Hold.
~~
Set C is more flexible, and you can adjust the difficulties based on your own conditions (like what does “stably” means to you).

When you finish all the tasks in set C, keep practicing A1. This is the fundamental skill in any stacker game, and you can master practically any mode when you can just scan through the Next sequence easily.

# 26f_studio
@ title 26F Studio
@ contentSize 26
@ link http://studio26f.org
A group
]]
