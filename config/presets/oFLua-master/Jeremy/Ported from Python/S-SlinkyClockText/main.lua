modeTitle = "S - Slinky Clock Text"
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
-- Global Params for Grid Polygons --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
hiHlf = Height / 2
wiHlf = Width / 2
x3four = Width * 0.75
lfo1 = LFOtri( -x3four, x3four, 1 )
--lfo2 = LFOtri( 0, 1 , .001 )
x100 = relX(100)
font = of.TrueTypeFont()
font:load( "font.ttf", 68 )
textpos = { 0, 0 }

x5 = relX(5)
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

function type(i)
    lfoUp = lfo1.update() 
    aud = avG() * Width  
    y = i * 7
    -- far left and fer right of knob custom color warp
    if( knob4 >= 0.91 ) then
        red = sin( y, 0.1 )
        gr = sin( y, 0.05 )
        blu = sin( y, 0.01 )
        of.setColor( red, gr, blu)
    elseif( knob4 <= 0.09 ) then
        red = sin( y, 0.1 )
        gr = sin( y, 0.1 )
        blu = sin( y, 0.1 )
        of.setColor( red, gr, blu)
    else
        of.setColor( fg )   -- knob4 color
    end
    R = 1
    R = ( R + aud ) * (i / 2)
    nCentX = math.sin( cycle * 6.28 ) * ( wiHlf * -knob3 )
    nCentY = math.cos( cycle * 6.28 ) * ( hiHlf * knob3 )
    
    r2 = R * math.cos( lfoUp * 6.28 ) 
    x = r2 + wiHlf
    y = r2 + hiHlf
    
    font:drawString( "88888888", x+nCentX, y+nCentY )
    
end
  
-- DRAW LOOP ------------------

function draw()
    
----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    time = of.getElapsedTimeMillis() * 0.0008           -- Global time
    
    size = ( knob1 * x100 ) + 5    
    lfo1.step = ( knob2 * x5 ) + 0.01
    cycle = ( knob2*time ) % 1
    if( knob2 == 0 ) then
        cycle = 0
    end
    
    
    
    width = math.floor( knob2 * relX(15) ) + 1
    of.setLineWidth( width )
    
    
    
    -- the for loop, create 6 copies---
    of.pushMatrix()
        for i = 0, 6 do
            type(i)
        end
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end