-- S-FloatingBall
print("S-FloatingBall")
require('eyesy')
Height = of.getHeight()
Width = of.getWidth()
count = 0
x = 0
y = 0
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
    
    CircleStack()
    
end

function CircleStack()
    local speedmod = Width/60
    local circles = 20
    for i = 0, circles do
        R = glm.abs(inL[i+1]*Height)/2+10
        if( inL[i+1] * 3 > 1 ) then
            y = 4 * glm.abs( inL[ i+1 ] * Height) 
        end
        z = (i*y) * (knob3/10)
        Colmod = i
        fg:setHue( fg:getHue() + (i*0.1) )
        of.setColor( fg )
        of.drawCircle(x,y,z,R)
    end
    y = knob2 * Height
    if y <= 0 + R then
        y = 0 + R
    end
    speed = knob1 *2* speedmod - speedmod
    x = x + speed
    if x >= Width + R then
        x = 0-R
    end
    if (0-R) > x then
        x = Width + R
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end