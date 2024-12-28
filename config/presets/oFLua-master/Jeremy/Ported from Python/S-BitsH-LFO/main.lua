--S-BitsHorizontal LFO
print("BITS HORIZONTAL LFO")
require('eyesy')
lines=100
Height = of.getHeight()
Width = of.getWidth()
w2 = Width / 2
w4 = w / 4
xpos = {}
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setFrameRate(60)

    for j=1,lines+2 do
        xpos[j] = math.random(-100, Width )
    end
end
----------------------------------------------------
function update()
end
-- LFO OBJECT Sine-------------------------------------------------
function colorPickHsb( knob, name )
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

function LFOsine(x, y, o)
    local self = {} --make table
    
    self.rate = x   --rate of LFo
    self.size = y   --size of the LFO in pxls
    self.start = o  --starting number (0-359)((360 is the resolution)
    
    
    function self.update()    --the update function, this runs the LFO
       
        if(self.start == 359) --a modulo that avoids an infintely growing number
        then self.start = 0
        end
        
        self.start = self.start + self.rate  --the counter
        
        ---this is the math that converts it to a sine wave----
        x = self.start
        x = x / 360        --360 resolution converted to 0-1
        x = x * 6.283      --radians
        x = math.cos(x)    --cosine
        x = (x*0.5)+ 0.5   --scale in the positive range
        
        --than the 0-1 times the desired scale--
        return x * self.size
    end
    
    return self --OOP stuf--  
end
------------------------------------
lfo = LFOsine(1, w4 , 0)

--------------------
function draw()

    if inL[1]*3 > 1 then
        lines = (knob3 * 60) + 5
        for j=1, lines+2 do
            xpos[j] = math.random(-100,Width)
        end
    end    
    
    rate = knob3
    
    mod = lfo.update() - w4
    lfo.rate = rate
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    
    
    of.setLineWidth(Height/lines)
    space = Height / (lines+1)
    linelength = knob2 * Width
    diag = knob1 * ( (Height/5) - (Height/10) )
    
    of.setColor( fg )
    Hscope()
    
end
    
function Hscope()
    for i=0,lines do
        --define new instance of LFOsine: (rate, size, starting point)-----
        

        auDio = inL[i+1]*200
        y = i*space
        x = (xpos[i+1] + auDio)
        
        of.drawLine(x + mod , y+mod, (x+linelength)+ -mod, (y+diag) + -mod)
    end
end


----------------------------------------------------
function exit()
    print("script finished")
end