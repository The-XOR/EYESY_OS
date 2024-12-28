modeTitle = "T - Density Squares"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
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
-- amplitude average of audio buffer --
function avG()  
    a = 0
    for i = 1, 100 do
        aud = math.abs( inL[i])
        a = a + aud
    end
    x = a / 100
    if( x <= 0.001 ) then
        x = 0
    else
        x = x
    end
    return  x
end  
    
-- global params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
wiHlf = Width / 2
hiHlf = Height / 2
sizeScale = relX(200)
dScale = relX(100)

-- random points function --
function randomPoints( number, xMin, xMax, yMin, yMax )
    tab = {}
    for i = 1, number do
        tab[i] = { math.random( xMin, xMax ), math.random( yMin, yMax ) }
    end
    return tab
end
-- make a list
pList = {}
pList = randomPoints( 100, -100, Width+100, -100, Height+100 )

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
function draw()
   
----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )               -- set fg color
    
    aud = avG()
    

    -- Knobs
    size = ( knob1 * sizeScale ) + 1
    xDensity = ( knob2 * wiHlf ) + 20
    yDensity = ( knob2 * hiHlf ) + 20
    fill = knob3 * 4

    -- the trigger --
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        pList = randomPoints( 
            dScale,
            -dScale + xDensity,
            Width + (dScale - ( xDensity+10 ) ),
            -dScale + yDensity,
            Height + (dScale - ( yDensity+10 ) )
        )
    end
    
    of.pushMatrix()
        rectangles()   
    of.popMatrix()
    
    trigger = false
end -- end draw loop

-- draw random circle function
function rectangles()
    halfSize = size / 2
    for i = 1, 30 do
        of.drawRectangle(
            pList[i][1] - halfSize,
            pList[i][2] - halfSize,
            size,
            size
        )
    end 
end
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end