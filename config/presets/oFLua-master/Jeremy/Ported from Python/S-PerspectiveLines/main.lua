modeTitle = "S - Perspective Lines"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
end
-- UPDATE --------------------------------------------------
function update()
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

-- Conversion Functions--
function relY(x)
    num = x or 1
    converted = (x * of.getHeight() ) / 720
    return converted
end
function relX(x)
    num = x or 1
    converted = (x * of.getWidth() ) / 1280
    return converted
end

-- Global Params for Grid Polygons --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
hiHlf = Height / 2
wiHlf = Width / 2
last_point = { 0, hiHlf }
w48 = Width / 48
x19 = relX(19)
-- draw function --
function line(i, sel)
    y1 = (inL[ (i%100)+1 ] * hiHlf) + hiHlf
    x = i * w48
    last_point = { k1, k2 }
    of.drawCircle( x, y1, big + 3 )
    of.drawLine( last_point[1], last_point[2], x, y1)
end
    
-- DRAW LOOP ------------------

function draw()
   ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )               -- set fg color
    k1 = knob1 * Width
    k2 = knob2 * Height
    big = knob3 * x19
    
    of.setLineWidth( big + 1 )
    
    of.pushMatrix()
        
        for y = 0, 50 do
            line(y,sel)
        end
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end