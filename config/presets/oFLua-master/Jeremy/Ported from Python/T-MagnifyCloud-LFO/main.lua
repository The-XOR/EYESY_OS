modeTitle = "T - Magnify Cloud - LFO"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')

-- SETUP --------------------------------
function setup()
    of.setWindowTitle( modeTitle )
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
-- LFO OOP --
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
-- global params --
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2 
heightHalf = Height / 2
x20 = relX(20)
x30 = relX(30)
denser = LFOtri( 1, heightHalf, 10 )
pos = {}
for i = 1, 12 do
    pos[i] = { math.random( widthHalf, widthHalf + 2),
                math.random( heightHalf, heightHalf + 2) 
            }
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
    of.setColor( fg )
    
    aud = avG()
    
    ballAmount = math.floor( knob2 * 10 ) + 1
    denser.step = knob3 * 12
    
    xDensity = denser.update() * 2
    yDensity = denser.update()
    dense30 = ( denser.update() / x30 ) + 1
    size = math.abs( (knob1 * x20) * dense30 )
    
    -- the trigger --
    if( avG() >= 0.08 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        x1 = math.abs( widthHalf - xDensity )
        y1 = math.abs( (widthHalf+2) + xDensity + 10 ) 
        x2 = math.abs (heightHalf - yDensity )
        y2 = math.abs( (heightHalf+2) + yDensity + 10 ) 
           
        for i = 1, 12 do    
            pos[i] = { math.random( x1, y1),
                     math.random( x2, y2)
                    }
        end
    end
    
    
    for i = 1, ballAmount do
        of.drawCircle( pos[i][1], pos[i][2], size )
    end
    
    trigger = false
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end