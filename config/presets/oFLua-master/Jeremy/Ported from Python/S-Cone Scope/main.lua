-- S-ConeScope
print("S-ConeScope")
require('eyesy')
Height = of.getHeight()
Width = of.getWidth()
w2 = Width / 2
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
newColor = of.Color()       -- define a color class for a relative color
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
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setFrameRate(60)
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

    
    lineWidth = (knob3 * w2) + 1 
    
    
    Cscope()
    
end
    
function Cscope()
    lines = 50
    space = Height / lines
    lW2 = lineWidth / 2
    for i = 0, lines do
        soundwidth = inL[ i + 1 ] * Width
        xPos = knob1 * Width        -- set x position
        xSound = xPos + soundwidth  -- modulate with sound, x direction
        x = xSound - lW2
        y = i * space               -- get height
        length = math.max( knob2 * space, 1)    -- set length, with 1 minimum
        newColor = fg
        
        newColor:setHue( fg:getHue() + (i/20)  )
        of.setColor( newColor )
        of.drawRectangle( x, y, lineWidth, length )
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end