modeTitle = "S - Mirror Grid Inverse"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
hiHlf = Height / 2
wiHlf = Width / 2
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
end
-- UPDATE --------------------------------------------------
function update()
end
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
-- Function for sine color warp ---
function sin(iter, scale)
    local x = iter
    local y = scale
    sine1 = math.sin( (x * y) + time )      -- requires the global time
    sine2 = (sine1 * 127) + 127
    return sine2 
end
-- Function Color Mode --
function colorMode(iter, selec)
    local x1 = iter or 0
    local x = x1 % 255
    local y = selec or 1     -- 1 - 8 range
    local tab = {255,255,255}
    if( y == 1 ) then
        tab = { sin(x, 0.1), sin(x, 0.05), sin(x, 0.1) }
    elseif( y == 2 ) then
        tab = { sin(x, 0.1), 42, 75 }
    elseif( y == 3) then
        tab = { 75, sin(x, 0.1), 42 }
    elseif( y == 4) then
        tab = { 42, 75, sin(x, 0.1) }
    elseif( y == 5) then
        tab = { sin(x, 0.1), 255, 127 }
    elseif( y == 6) then
        tab = { 255, sin(x, 0.1), 127}
    elseif( y == 7) then
        tab = { sin(x, 0.1), 0 , 0 }
    elseif( y == 8) then
        tab = { sin(x, 0.1), sin(x, 0.1), sin(x, 0.01) }
    end

    return tab
end

-- Global Params for Grid Polygons --
w4 = Width / 4
last_point = { w4, 0 }
last_point1 = { w4, 0 }
ten = relX(10)
y72 = relY(72)
x180 = relX(180)

-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    --colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 


    time = of.getElapsedTimeMillis() * 0.0008   -- Global time

    linewidth = (knob1 * 30) + 1
    of.setLineWidth(linewidth)
    lines = (knob2 * 40) + 4
    
    spaceW = math.floor( Width / (lines-2) )
    spaceH = math.floor( Height / (lines-2) )
    recsize = (knob3*ten) * 2
    sel = math.floor( (knob4*7) + 1 )
    
    of.pushMatrix()
    for j = 0, lines do
        local tabi = {0,255,0}
        tabi = colorMode(j, sel)
        
        of.setColor( tabi[1], tabi[2], tabi[3] )
        of.drawLine( -1, j*spaceH, Width, j*spaceH)
    end
    
    for m = 0, lines do
        x = math.floor( m * spaceW )
        y = 0
        auDio = inL[m+1] * Height
        local tabi = {0,0,0}
        tabi = colorMode(m, sel)
        of.setColor( tabi[1], tabi[2], tabi[3] )
        of.drawLine( x, y, x, hiHlf - auDio )
        if( recsize >= 1) then
            of.drawRectangle( x-(recsize/2), hiHlf-auDio, recsize, recsize )
        end
    end
    for i = 0, lines do
        x = math.floor(i*spaceW)
        y = hiHlf
        imod = (i+50) % 100
        auDio = inL[imod+1] * Height
        auD = y-auDio
        of.noFill()
        local tabi = {0,0,0}
        tabi = colorMode(i, sel)
        of.setColor( tabi[1], tabi[2], tabi[3] )
        of.drawLine( x, Width, x, auD )
        if( recsize >= 1 and auD > y) then
            of.fill()
            of.drawRectangle( x-(recsize/2), auD-recsize, recsize, recsize )
        end
        
    end
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end