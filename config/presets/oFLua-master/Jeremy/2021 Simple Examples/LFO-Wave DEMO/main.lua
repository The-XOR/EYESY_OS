-- LFO - WAVE - DEMO
require("eyesy")                    -- include the eyesy library
modeTitle = "LFO - WAVE - DEMO"     -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
countLFO = 0                        -- LFO counter
stepLFO = 1                         -- LFO step speed

---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    lfoArray = {}
    for i = 1, 7 do
        lfoArray[i] = LFOTable(1, h, 0, i)
    end
end
---------------------------------------------------------------------------
-- update function part of main loop
function update()
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    
    -- set LFO rates
    local wow = knob1*10
    for i = 1, 7 do
        lfoArray[i].rate = wow
    end
    
    
    
    of.setColor(100, knob4*255, knob5*255)  -- use knob3,4,5 to change color of rectangle (R,G,B)
    
    for i = 0, 6 do
        x = (i*295) + 75
        -- run the lfos
        y = lfoArray[i+1].update()
        -- get names of waves
        s = lfoArray[i+1].getName()
        
        -- draw the rectangles
        of.pushMatrix()                         -- save current matrix position
        of.drawBitmapString( s, x-75, h/2)      -- draw the string
        of.translate( x, y )                    -- move matrix position
        of.drawPlane( 150, 150 )                -- draw a 3d plane, resize with the recSize variable
        of.popMatrix()                          -- revert to saved matrix
    end
end
---------------------------------------------------------------------------
--lfo OOP object
function LFOTable(x, y, o, z)
    local self = {}     --make table
    
    self.rate = x       --rate of LFO
    self.size = y       --size of the LFO in pxls
    self.count = o      --starting number (0-359)((360 is the resolution)
    self.wave = z       --waveform selection
    self.random = 0     --random number
    self.compare = 0    --variable to compare count
    self.title = "none" --variable for title
    function self.update()    --the update function, this runs the LFO
        --0-359 loop
        if(self.count >= 359) then 
            self.count = 0
        end
        
        
        self.count = self.count + self.rate  --the counter
        
        --sine wave
        if( self.wave == 1 ) then
            x = self.count      --phase count
            x = x / 360         --360 resolution converted to 0-1
            x = x * 6.283       --radians
            x = math.sin(x)     --sine
            x = (x/2)+ 0.5      --scale in the positive range
            self.title = "sine"
        end
        
        --square wave
        if( self.wave == 2 ) then
            x = (self.count+20) % 360      --phase count
            
            x = x / 360         --360 resolution converted to 0-1
            x = x * 6.283       --radians
            x = math.cos(x)     --cosine
            x = x * 2           --scale up
            x = math.max( 0, x) --clip -1
            x = math.min( 1, x) --clip 1
            self.title = "square"
        end
        
        -- triangle wave
        if( self.wave == 3 ) then
            x = self.count       --phase count
            
            if( x <= 179 ) then
                x = x / 180
            else
                x = x - 179
                x = x / 180
                x = 1 - x
            end
            self.title = "triangle"
        end
        
        --stepped pyramid
        if( self.wave == 4 ) then
            x = self.count / 360
            x = math.floor( (x * 20) + 0.499999)
            if( x <= 9 ) then
                x = x / 10
            else
                x = x - 10
                x = x / 10
                x = 1 - x
            end
            self.title = "stepped"
            
        end
        
        --saw
        if( self.wave == 5 ) then
            x = self.count      --phase count
            if( x <= 349 ) then
                x = x / 349
            else
                x = x - 350
                x = x / 10
                x = 1 - x
            end
            self.title = "saw"
        end
        
        --random
        if( self.wave == 6 ) then
            y = self.count % 180
            
            if( y < self.compare ) then
                self.random = math.random( 0, 359 )
            end
            
            x = self.random
            
            x = x / 360
            
            self.compare = y
            self.title = "random"
        end    
        
        --random triangle
        
        if( self.wave == 7 ) then
            y = self.count % 180
            if( y < self.compare) then
                self.random = math.random( 0, 359 )
            end
            
            x = (self.count + self.random) % 360
            
            if( x <= 179 ) then
                x = x / 180
            else
                x = x - 179
                x = x / 180
                x = 1 - x
            end
            self.compare = y
            self.title = "random + triangle"
        end    
        
        
        --than the 0-1 times the self.size, arguemnt Y
        return x * self.size
    end
    function self.getName() -- return the name of the wave as a string
        return self.title
    end
    return self --OOP stuf--  
end

------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end