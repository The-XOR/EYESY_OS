modeTitle = "S - Perspective Lines LFO"
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
-- UPDATE --------------------------------------------------
function update()
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
-- LFO OBJECT-------------------------------------------------
function LFOtri(x, y, o)
    local locLFO = {}  -- make table
    
    locLFO.start = x      -- start point
    locLFO.max = y        -- max
    locLFO.step = o       -- how big each step is
    locLFO.current = 0    -- start of the count
    locLFO.direction = 1  -- direction of triangle wave LFO
    
    function locLFO.update()    --the update function, this runs the LFO
        
    -- when it gets to the top, flip direction
        
        if(locLFO.current >= locLFO.max)
        then locLFO.direction = -1
             locLFO.current = locLFO.max -- in case it steps above max
        end
    -- when it gets to the bottom, flip direction
        
        if(locLFO.current <= locLFO.start)
        then locLFO.direction = 1
             locLFO.current = locLFO.start -- in case it steps below min
        end
        
    -- the counter
        locLFO.current = locLFO.current + (locLFO.step * locLFO.direction)
        
        return locLFO.current -- return the LFO steps
       
    end
    
    return locLFO --OOP stuf--  
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
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
hiHlf = Height / 2
wiHlf = Width / 2
xmover = LFOtri( 0, Width, wiHlf )
ymover = LFOtri( 0, Height, 1 )
last_point = { 0, hiHlf }
w50 = Width / 50
w120 = Width / 120 
x2 = relX(2)
-- draw function --
function line(i, sel)
    colTab = {}
    colTab = colorMode( i*modd, sel)
    y1 = (inL[ (i%100)+1 ] * hiHlf) + hiHlf
    x = i * w50
    
    xpos = xmover.update()
    ypos = ymover.update()
    last_point = { xpos, ypos }
    of.setColor( colTab[1], colTab[2], colTab[3] )
    of.drawCircle( x , y1, big + 3 )
    of.drawLine( last_point[1], last_point[2], x, y1)
end
    
-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    linewidth = ( knob3*39 ) + 1                --  knob1 set line width
    of.setLineWidth(linewidth)
    time = of.getElapsedTimeMillis() * 0.0008   -- Global time
    sel = math.floor( knob4*7 )  + 1
    modd = knob3 * 2
    big = knob3 * w120
    
    speEd = knob1 * 0.5
    xmover.step = speEd
    ymover.step = speEd
    
    
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