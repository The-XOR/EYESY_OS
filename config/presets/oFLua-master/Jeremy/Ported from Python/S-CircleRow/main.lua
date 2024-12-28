--S-CircleRow
print("S - Circle Row")
require('eyesy')


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
    count = count + 1
  
      ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    of.translate(0,0,Width/4-Width*knob4)
    of.pushMatrix()
        of.translate(Width/2,0,0)
        of.rotateYDeg(knob3*180)
        of.translate(-Width/2,0,0)
        circlerow()
    of.popMatrix()
    
end

    
function circlerow()
    local circles = knob1*100 + 1
    local space = of.getWidth()/circles
    
    for i=1,circles do
        R = inL[i]*100 + 10
        x = i*(space) - space/2
        y = knob2*of.getHeight()
        z = R
        fg:setHue( fg:getHue() + (i/100) )
        of.setColor( fg )
        of.drawSphere(x,y,z,R)
    end
end

----------------------------------------------------
function exit()
    print("script finished")
end