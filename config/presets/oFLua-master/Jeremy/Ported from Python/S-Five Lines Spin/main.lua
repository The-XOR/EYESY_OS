--S-FiveLinesSpin
print("Hello World!")
require('eyesy')

Height = of.getHeight()
Width = of.getWidth()
count = 0
----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setFrameRate(60)
end
--------------------------------------------------
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
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

----------------------------------------------------
function update()
end
----------------------------------------------------
function draw()
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    of.setLineWidth( knob3*30 + 1)
    
    speed = knob1*Width/60
    count = count+speed
    peak = 0
    of.pushMatrix()
        LinesRot()
    of.popMatrix()
end
    
function LinesRot()
    lines=5
    for i=1,lines do
        peak = glm.abs(inL[i]*Height)
        R = knob2*peak+20
        x = R * math.cos((count /  1000.) * 6.28) + (Width/2) + i*Width/lines-2*Width/lines
        y = R * math.sin((count /  1000.) * 6.28) + (Height/2) 
        fg:setHue( fg:getHue() + (i*5) )
        of.setColor( fg )
        
        of.drawLine(i*Width/lines+Width/10-Width/lines, Height/2, x-Width/lines, y)
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end