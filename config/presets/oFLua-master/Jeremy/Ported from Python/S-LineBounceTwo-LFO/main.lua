modeTitle = "S - Line Bounce Two - LFO"
print(modeTitle)
require('eyesy')
Height = of.getHeight()         --global height of screen
Width = of.getWidth()           --global width
hiHlf = Height / 2
wiHlf = Width / 2

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


------------------------------------------------------
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
-- LFO OBJECT-------------------------------------------------
function LFOtri(x, y, o)
    local locLFO = {}  -- make table
    
    locLFO.start = x or 0     -- start point
    locLFO.max = y or 1        -- max
    locLFO.step = o or 0.1       -- how big each step is
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

-- declare LFOs --
x100 = relX(100)
width100 = Width - x100

b1 = LFOtri( 0, Width, 10 )   -- make 3 LFOs
b2 = LFOtri( 0, Height, 19 )   
b3 = LFOtri( 0, Height, 2)

x50 = x100 / 2
fifteen = relX(15)
thirty = relX(30)
oneTwen = x100 / 20
ten = x100 / 10
five = x100 / 5
of.enableAntiAliasing()         -- enable aa for smooth lines
of.noFill()                     -- do not fill the shopes


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
    
    y = avG() * Width
    
    
    size1 = ( knob1 * x100 ) + 1
    size2 = ( knob2 * x50 ) + 1
    
    b1.step = ( knob3 * ten ) + 1
    b2.step = ( knob3 * five ) + 2
    b3.step = ( knob3 * ten ) + 1
   
    
    posx1 = b1.update()
    posx2 = b2.update()
    
    width = ( knob2 * 30) + 1
    
    rise = b3.update() + 1
    
    of.setLineWidth(width)
    of.pushMatrix()
        of.drawLine( posx1, rise+y, posx1, (rise/2)+y )
        of.drawLine( posx2, rise+y, posx2, (rise+2)*y )
    of.popMatrix()
end
-- EXIT  --------------------------------------------------

function exit()
    of.disableAntiAliasing()         -- disable aa for smooth lines
    print("script finished")
end