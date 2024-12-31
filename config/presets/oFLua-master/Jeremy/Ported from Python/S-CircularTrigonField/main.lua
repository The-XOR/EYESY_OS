--S-CircularTrigonField
print("S - Circular Trigon Field")
require('eyesy')


Height = of.getHeight()
Width = of.getWidth()

----------------------------------------------------
function setup()
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
    time = of.getElapsedTimeMillis() * 0.001
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )
    
    of.setLineWidth(2)
    of.pushMatrix()
        of.translate(Width/2,0,0)
        of.translate(-Width/2,0,0)
        circlescope()
    of.popMatrix()
end

function circlescope()
    local circles = 60
    local space = Width/circles
    for i=1,circles do
        v2mod = knob2*195+5
        v3mod = knob3*195+5
        xran = math.random(0,Height/20)
        R = knob1*Width/2-Width/4 + inL[i]*500
        x = R * math.cos((i /  60.) * 6.28) + Width/2
        y = (R * math.sin((i /  60.) * 6.28) + Height/2)
        
        
        if i%2 == 1 then
            of.fill()
            of.drawTriangle(x,y,x+v2mod+xran,y-v2mod+xran,x+v3mod,y+v3mod)
        else
            of.noFill()
            fg:setHue( (fg:getHue() + (time/30) ) % 255 )
            of.setColor( fg )
            of.drawTriangle(x,y,x+v2mod+xran,y-v2mod+xran,x+v3mod,y+v3mod)
        end
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end