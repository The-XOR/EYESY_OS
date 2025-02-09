--S-Concentric
print("S - Concentric")
require('eyesy')

Height = of.getHeight()
Width = of.getWidth()
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

    of.pushMatrix()
        CircleStack()
    of.popMatrix()
end

function CircleStack()
    local circles = 10
    local x = knob1*Width
    local y = knob2*Height    
    for i=1,circles do
        x = x+i/8
        z = -knob3*500*i
        R = glm.abs(inL[i]*Height)/2+100
        Colmod = i
        fg:setHue( fg:getHue() + (Colmod*0.6) )
        of.setColor( fg )
        of.drawCircle(x,y,z,R)
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end