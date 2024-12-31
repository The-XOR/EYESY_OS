--S-CircleScopeConnected
print("S - Circle Scope Connected")
require('eyesy')
lx=0
ly=0
count = 0
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
    of.setColor( fg )               -- set the fg color
    
    count = count+1
    of.fill()
    
    of.setLineWidth(knob3*30+1)
    of.pushMatrix()
        of.translate(Width/2,0,0)
        of.translate(-Width/2,0,0)
        circlescope()
    of.popMatrix()
end
    
function circlescope()
    local circles = 120
    local space = Width/circles
    
    for i=1,circles do
        cRad = knob2*60
        R = knob1*Width/2-Width/4 + inL[i]*Height
        x = R * math.cos((i /  120.) * 6.28) + Width/2
        y = R * math.sin((i /  120.) * 6.28) + Height/2
        
        of.drawSphere(x,y,cRad)
        of.drawLine(x,y,lx,ly)
        lx = x
        ly = y
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end