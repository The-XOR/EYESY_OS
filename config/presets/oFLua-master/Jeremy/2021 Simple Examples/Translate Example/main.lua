-- Translate Experiment
require("eyesy")                    -- include the eyesy library
modeTitle = "Translate Experiment"  -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
w8 = w/8
h8 = h/8
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
   
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    --set color and fill
    of.setColor(255)
    of.noFill()
    -- use push/pop matrix and translate to change positions of the entire matrix, 
    -- this allows for easy shortcuts when coding
    ---------------------------------------------------------------------------------------------
    -- here we push the original matrix (0,0), then translate to desired position, draw and if we
    -- want to draw again, we pop(recall the original (0,0) ) and transalte,draw again.
    of.pushMatrix()             --'push' here means save
    
    of.drawRectangle( 0, 0, w8, h8) --draw the rectangle
    of.drawBitmapString("original matrix position", 0, 12)  --label
    
    of.translate( w/2, 0 )    --move to the center
    of.drawRectangle( 0, 0, w8, h8) --draw the rectangle
    of.drawBitmapString("2nd matrix position", 0, 12)  --label
    of.popMatrix()              --'pop' here means recall. recall the last pushed matrix
    of.pushMatrix()             --'push' here means save
    
    of.translate( w/4, 0 )      --move to the center left
    of.drawRectangle( 0, 0, w8, h8) --draw the rectangle
    of.drawBitmapString("3rd matrix position", 0, 12)  --label
    
    of.popMatrix()          --return 0,0 matrix for next part
    of.pushMatrix()
    ---------------------------------------------------------------------------------------------
    --here we use a chained style of using push/pop and translate
    of.translate(-w8,h/2)     -- move the y position to the center, and on w8 step back
    
    for i = 0, 7 do             --make a for loop 8 times (0-7)
        of.translate(knob1*w8, (knob2*80) - 40 )
        of.drawRectangle( 0, 0, w8, h8) --draw the rectangle
        of.drawBitmapString( i+1 .. "matrix position", 0, 12)  --label
    end
    of.popMatrix()
end

---------------------------------------------------------------------------
--draw a circle
function circle( xPos, yPos, maxRad, level, xDir, yDir)
    of.drawCircle( xPos, yPos, maxRad)
    if(level > 1) then
        level = level - 1
        circle( xPos/xDir, yPos/yDir, maxRad/1.15, level, xDir, yDir )
    end
end
------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end