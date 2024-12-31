--S-GridCircles-Filled
print("S-GridCircles-Filled")
require('eyesy')

Height = of.getHeight()
Width = of.getWidth()
h3 = Height / 3
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
colorChange = of.Color()    -- define color class for modulating color
----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setFrameRate(60)
end

----------------------------------------------------
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

------------------- The Draw Loop ---------------------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color  
    
    CircleGrid()
end

------------------------------------------------------    
function CircleGrid()
    x8 = Width/8
    y5 = Height/5
    
    for i=1,7 do
        xoffset = knob1*x8
        yoffset = knob2*y5
        
        for j=1,10 do
            x = j*x8-x8
            y = i*y5-y5
            rad = math.abs( inL[ j+i ] * h3 )
            restRad = knob3*Height/20+1
            modColor = i * 0.25
            colorChange = fg
            colorChange:setHue( fg:getHue() + modColor )
            of.setColor( colorChange )
            if (i%2) == 1 then 
                x = j*(x8)-(x8)+xoffset
            end 
            if (j%2) == 1 then 
                y = i*(y5)-(y5)+yoffset
            end
            of.drawCircle(x, y, rad+restRad)
        end

    end
end
----------------------------------------------------
function exit()
    print("script finished")
end