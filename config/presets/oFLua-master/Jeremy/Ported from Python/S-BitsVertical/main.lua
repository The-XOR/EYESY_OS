--S-BitsVertical
print("S - Bits Vertical")
require('eyesy')
lines=100
Height = of.getHeight()
Width = of.getWidth()
ypos = {}
----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setFrameRate(60)
    for j=1,lines+2 do
        ypos[j] = math.random(-100,Height)
    end
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
    
    if inL[1]*3 > 1 then
        lines = knob3*60+5
        for j=1,lines+2 do
            ypos[j] = math.random(-100,Height)
        end
    end    
    
    of.setLineWidth(Width/lines)
    space = Width/(lines+1)
    linelength = knob2*Height*3/4+5
    diag = knob1*Width/5-Width/10
    of.pushMatrix()
        of.translate(Width/2,0,0)
        of.translate(-Width/2,0,0)
        Hscope()
    of.popMatrix()
end
    
function Hscope()
    for i=1,lines do
        auDio = inL[i]*200
        y = ypos[i]+auDio
        x = i*space
        
        of.drawLine(x,y,x+diag,y+linelength)
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end