# Tetris

## Time Taken
About 60 hours

## Overview
In this project, I reversed the game Tetris. I was able to learn a lot about the game and how it is stored. I set goals in the beginning that I wanted to accomplish. I was unable to complete some goals, but I was also able to complete some other additional goals. Many challenges were faced, and many challenges were conquered.

## Goals
- Slowing gravity
- Freezing the board (to allow free movement of falling piece)
- Choosing next piece
- Patching score
- Live board with shadow of falling piece placement
- Null Mode

## Key Technologies/Tools Used
- DOSBox-X was used to run Windows 3.11 which allowed me to run the original Tetris game
- Cheat Engine

## Challenges
My initial challenge was that the game uses dynamic memory, so everything has a different address each time the game starts. I thought this would be frustrating to deal with if I had to find variables each time, but I learned about AOB scripts and how you can use the bytes around the variable to assign the variable automatically at the start of each game. However, because of the dynamic address, I was unable to figure out how to trace the variables I found back to IDA's addresses, even if using the method of searching by bytes.

Another challenge I faced was having to learn a new coding language for the lua script to build the trainer form. This wasn't a difficult task, but just made it a little more time consuming.

One other challenge was with trying to complete some of the goals that I had set. There were a couple variables that I couldn't figure out how to properly write to and change. One example was the bytes for the board. I learned how the board was laid out (how different blocks were stored) and wanted to use that for being able to clear any line that the user chose. However, when I tried to change a byte, the byte itself would change, but the actual game would not. I searched for other places that might be writing to the board but was never able to find out the solution.

One of my last major challenges was the non-deterministic behavior that I faced. Some days, I would leave the game, and everything would be working perfectly fine. Then, when I would go to work on it later, things were broken. This inconsistency made it frustrating at times, but I think I got them all worked out.


## Results/Findings
Over the course of working on this project, I was able to find many different variables within Cheat Engine, including the y position of blocks, the next piece, lines cleared, current piece, score, rotation, and where the board was actually stored within the game. I tried to use as many variables within my project as I could.

My first goal was to be able to change the score in Tetris. I found the score variable and was able to change it. I decided to just make buttons to where you can either add 100 or 500 points to your score. The next thing I worked on was being able to set the next piece that was given to whichever the user picked. It took some time to find this variable since I didn't know what values were being stored, but I found out that each piece is assigned a number, one through seven, and I was able to write the script for changing that based on the color chosen in the dropdown. The next thing on my trainer is NULL MODE. I thought this would be a fun one to be able to add in at least one of the variables I hadn't used yet. This sets the cleared lines variable to 0 and sets the next piece to always be the Z-shaped piece, which is normally not wanted. I tried to make the score set to zero, but it didn't exactly work. It did make the score go crazy though, which I thought was a good effect for it too.

Lastly, I worked on the live grid. My goal with this was to be able to see the shadow of where the piece would drop down to. There were several times when I was playing the game that I would accidentally drop a piece just to the left or right of where I thought it was going. Building out the grid came with several challenges, but I got them figured out eventually. In doing this, I learned that as the block is falling, it is stored within the board bytes as the piece's ID number + 10. For example, red was stored as one when it had fallen, but if a red block is actively falling, it will be stored as 11 or 0xB. I used this to figure out the ghost piece and eventually did get it working. However, when I ran it with the game, it would work for about three seconds, then Cheat Engine would stop responding. I'm not sure why it didn't like that code, but once I deleted that portion, it stopped crashing. I got a screenshot of the shadow working, but then just decided to cancel that goal.

![Live Board Preview](https://i.imgur.com/jtdqBht.png)

Here is my final Tetris Toolkit:

![Trainer](https://i.imgur.com/pcSUmDL.png)

## Conclusion
My goals changed a lot with this project as I progressed through it, but I am still happy with what I was able to accomplish. It was cool to be able to watch the trainer I was building progress with more items added to it. There were many challenges faced during this project, but I was able to work through all of them and keep going with my next steps. Overall, it was a stressful, but fun project!

## Code Snippets
The lua script I used for the trainer form is in the same folder, called "tetris_trainer.lua".

## References
https://youtu.be/lN4FlZlEfb4?si=oKghmj6Bsg65u7cE
https://wiki.cheatengine.org/index.php?title=Tutorial:LuaFormGUI#Adding_Events
https://wiki.cheatengine.org/index.php?title=Main_Page