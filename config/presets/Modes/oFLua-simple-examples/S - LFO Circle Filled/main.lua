-- S - LFO Circle Filled
require("eyesy")                        -- include the eyesy library
modeTitle = "S - LFO Circle Filled"    -- name the mode
print(modeTitle)                        -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height

---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    bg = of.Color()
    fg = of.Color()
    lfo1 = LFOTable(1,1,0,1)
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    colorPickHSB( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
                                 
    of.setCircleResolution(100)
    maxSize = (knob1 * (h/2)) + 5
    lfo1.wave = math.floor(knob2 * 6) + 1
    lfo1.rate = math.pow(knob3*4,2) * 20
    mod = (lfo1.update() * maxSize ) + 2
    
    ogC = fg.getHue(fg) / 255
    
    for i = 1,11 do
        
        if (i > 5 ) then
            iMod = (12 - i) + 5
            x = (iMod-1) * (w/10)
        else
            x = (i-1) * (w/10)
            iMod = i
        end
        
        y = inL[iMod*3]
        y = y * h
        y = (h/2) + y
        
        
        colorMod = iMod / 22
        newColor = math.cos(ogC + colorMod) * 255
        
       
        fg.setHue( fg, newColor )
        of.setColor(fg)
        of.drawCircle( x, y, mod)
        fg.setHue( fg, ogC )
        
        
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
    -- return name of waveform function
    function self.getName() -- return the name of the wave as a string
        return self.title
    end
    
    return self --OOP stuf--  
end

---------------------------------------------------------------------------
--color picker
function colorPickHSB( knob, name )
    -- middle of the knob will be bright RBG, far right white, far left black
    
    k6 = (knob * 5) + 1              -- split knob into 8ths
    hue = (k6 * 255) % 255 
    kLow = math.min( knob, 0.49 ) * 2    -- the lower half of knob is 0 - 1
    kLowPow = math.pow( kLow, 2 )
    kH = math.max( knob, 0.5 ) - 0.5    
    kHigh = 1 - (kH*2)                      -- the upper half is 1 - 0
    kHighPow = math.pow( kHigh, 0.5 )
    
    bright = kLow * 255                     -- brightness is 0 - 1
    sat = kHighPow * 255                       -- saturation is 1 - 0
    
    name:setHsb( hue, sat, bright )      -- set the ofColor, defined above
end

------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end