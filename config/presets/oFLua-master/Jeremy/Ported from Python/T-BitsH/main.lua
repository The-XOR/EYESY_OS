modeTitle = "T - Bits Horizontal"

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

-- X Points fill table --
function xPs( xMin, xMax, amt )
    tab = {}
    for i = 1, amt do
        tab[i] = math.random( xMin, xMax )
    end
    return tab
end
-- Displace x Points --
function dis( name, d, amt )
    tab = {}
    for i = 1, amt do
        tab[i] = name[i] + d
    end
    return tab
end

    
-- global params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
wiHlf = Width / 2
hiHlf = Height / 2
min10 = Width / 10
y100 = relY(100)
x10 = relX(10)
x300 = relX(300)
x20 = relX(20)
lineLength = x300 + 1
trigger = false
lineAmt = math.floor( y100 ) + 2 -- max lines
lineW = Height / lineAmt
displace = x10

xpos = {}
xpos1 = {}
xpos = xPs( -min10, Width, lineAmt )
xpos1 = dis( xpos, displace, lineAmt)
-- draw shadow lines--
function shadow( name, i)
    
    x = name[i] + lineLength
    y = ( i * lineW ) + ( (lineW/2) - 1 )
    of.drawLine( name[i], y + displace, x, y + displace )
    
end

-- draw lines --
function lines( name, i ) 
    x = name[i] + lineLength
    y = ( i * lineW ) + ( (lineW/2) - 1 )
    of.drawLine( name[i], y, x, y  )
end

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
of.noFill()
function draw()
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    aud = avG()
    
    -- background relative shadow --
    c = of.getBackgroundColor()
    shadowColor = c * (1 - knob3)
    
   
    lineW = Height / lineAmt
    of.setLineWidth( lineW )
    lineLength = (knob2 * x300) + 1
    
    
    minus = ( knob3 * 0.5 ) + 0.5
    
    
    -- the trigger --
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        lineAmt = math.floor( knob1 * y100 ) + 2
        xpos = xPs( -min10, Width, lineAmt )
        xpos1 = dis( xpos, displace, lineAmt)
    end
    
    of.pushMatrix()
        of.setColor( shadowColor )
        for i = 1, lineAmt do
            shadow( xpos1, i )
        end
        of.setColor( fg )       -- knob4 color table
        for i = 1, lineAmt do
            lines( xpos, i )
        end
    
    of.popMatrix()
    
    trigger = false
end
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end