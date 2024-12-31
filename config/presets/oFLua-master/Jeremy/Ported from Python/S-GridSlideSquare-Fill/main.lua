modeTitle = "S - Grid Slide Square - Fill"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')

Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width

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
    converted = (x * Height) / 720
    return converted
end
function relX(x)
    num = x or 1
    converted = (x * Width) / 1280
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

    return (sine1 * 127) + 127
end
-- Function Color Mode --
function colorMode(iter, selec)
    local x = iter or 0
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
        tab = { 205, 200, sin(x, 0.1) }
    elseif( y == 8) then
        tab = { sin(x, 0.1), sin(x, 0.1), sin(x, 0.01) }
    end

    return tab
end
-- Global Params for Grid Polygons --
x8 = math.floor( (Width / 8) + 0.5 )
y5 = math.floor( (Height / 5) + 0.5 )

hund = relX(99)
otwen = relX(120)
three = relX(3)
eight = relX(8)
sqmover = LFOtri(-otwen, otwen, 10)     -- define the LFOtri
-- dependin on ratio if three is to small make it 1 -- 
if(three <= 0) then
    three = 1
end
-- DRAW LOOP ------------------

function draw()
    time = of.getElapsedTimeMillis() * 0.0008   -- Global time
    ----------------------- Color stuff
    --colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    sqmover.step = knob1 * three
    sqmover.max = math.floor( knob2 * otwen )
    sqmover.start = math.floor(knob2 * -otwen)
    
    xoffset = -sqmover.update()
    yoffset = sqmover.update() * 0.8

    width = (knob3 * hund) + 3
    sel = math.floor( knob4 * 7 ) + 1

    of.pushMatrix()
    --of.noFill()                       -- fill the squares
    
    for i = 0, 6 do                     -- for loops to make the squares
        for j = 0, 9 do
            rgbTab = {}                 -- table for square color 
            x = (j * x8) + (x8/2)
            y = (i * y5) - (y5/2)
            rx = math.floor( x + 0.5 )  -- x placement rounded
            ry = math.floor( y + 0.5 )  -- y placement rounded
            xNum = i * 10               -- math to get 0 - 80
            v = (xNum + j) + 1

            rad = ( inL[ v ] * (hund/2) ) + 1

            if( (i%2) == 1 ) then       -- odd/even logic for the offset
                rx = rx + xoffset
            end
            if( (j%2) == 1 ) then
                ry = ry + yoffset
            end
            
            recSz = width+rad
            
            rgbTab = colorMode( v, sel )
            of.setColor(rgbTab[1], rgbTab[2], rgbTab[3])
            of.drawRectangle(rx-(recSz/2), ry-(recSz/2), recSz, recSz)
        end
    end
    
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end