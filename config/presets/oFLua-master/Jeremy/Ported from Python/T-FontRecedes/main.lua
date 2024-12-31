modeTitle = "T - Font Recedes"

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
fadeColor = of.Color()      -- define class for color fade 
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
-- provisional color picker --
function color4( knob )
    tab = {}
    k = knob * 255
    tab[1] = k
    tab[2] = 255
    tab[3] = 255
    return tab
end
-- global params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
wiHlf = Width / 2
hiHlf = Height / 2
x20 = relX(40)
xPos = wiHlf
yPos = hiHlf
isSomethingThere = false
trigger = false
activeSize = 1
activeColor = 1

randomAscii = string.char( math.random(5, 127) ) .. string.char( math.random(5, 127) )
-- create font class and load font --
font = of.TrueTypeFont()
font:load( "font.ttf", 180, true, true, true, 10, 64 )
-- make a function for receding text --
function recede( theSize, theString, theFont, x, y )
    of.pushMatrix()
        of.translate( x, y )
        of.scale( theSize )
        of.translate( -x, -y )
        
        wow = theFont:getStringBoundingBox( theString, 0, 0 )
        xCorrect = wow:getWidth() / 2
        yCorrect = wow:getHeight() / 2
        
        font:drawString( theString, x - xCorrect, y + yCorrect ) 
    of.popMatrix()
end

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    aud = avG()
    
    sizeTime =  knob1 * 0.01
    colorTime = knob2 * 0.05
    startSize = knob3 * x20 
   
    
    -- the trigger --
    if( avG() >= 0.08 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        isThereSomethingThere = true
        --random x y points
        xPos = math.random( 0, Width )
        yPos = math.random( 0, Height )
        
        -- random Ascii generation
        randomAscii = string.char( math.random(45, 127) ) .. string.char( math.random(45, 127) )
        -- define begining size
        activeColor = 1
        activeSize = 1
    end
    
    if( isThereSomethingThere == true ) then
        
        -- if statements to stop the fade or do the fade
        if( activeSize < 0 ) then
            activeSize = 0.001
        else
            activeSize = activeSize - sizeTime
        end
        if( activeColor < 0 ) then
            activeColor = 0
        else
            activeColor = activeColor - colorTime
        end
        -- set color
        
        powCol = math.pow( activeColor, 0.5 )
        powSize = math.pow( activeSize, 2 ) * startSize
        
        transP = activeColor * 255           
        of.setColor( fg, transP )
        recede( activeSize, randomAscii, font, xPos, yPos )
        
        if( activeSize <= 0.001 and activeColor <= 0.001 ) then
            isThereSomethingThere = false
        end
        
    end     
    
    
        
    trigger = false
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end