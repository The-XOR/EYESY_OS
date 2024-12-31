--S-BigCityScroll
print("S - BigCityScroll")
require('eyesy')

Height = of.getHeight()
Width = of.getWidth()
lastPoint = glm.vec2(240,160)
y1 = 120
y0 = 100
x = 160
block = 25
----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setFrameRate(60)
end
----------------------------------------------------
function update()
end
--------------------------------------------------
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
newColor = of.Color()       -- define for color mod
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
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    of.setLineWidth(block)
    audioraty = 100
    audioratx = 150
    speedrat = ((20*Width)/1280)
    speed = knob1 * 2 * speedrat - speedrat
    x = x + speed
    if x >= Width then
        x = 0
    end
    if 0 > x then
        x = Width
    end
    of.pushMatrix()
        City()
    of.popMatrix()
end
    
function City()
    yspot = knob2 * Height
    for i=1,20 do
        block = glm.abs(50*inL[i*3])+1
        boxW = block/((10*i)/200)+knob3*i*block
        boxH = (-block*i*i/20 - i*10)*4/5
        y1 = yspot
        buildOff = boxW/2+inL[i]*Width/2
        newColor = fg
        
        newColor:setHue( fg:getHue() + (i/20)  )
        of.setColor( newColor )
        
        
        of.drawRectangle(x-buildOff,y1,boxW,boxH)
        y1 = y0
    end    
end
----------------------------------------------------
function exit()
    print("script finished")
end