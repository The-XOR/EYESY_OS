modeTitle = "S - Line Bounce Four - LFO"
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
-- Audio Math --
function auDi(x)
    y = ( inL[x] * hiHlf ) + hiHlf
    return y
end
-- declare LFOs --
x100 = relX(100)
width100 = Width - x100

b1 = LFOtri( x100, width100, 10 )   -- make an triangle LFO named fanner
b2 = LFOtri( x100, width100, 19 )  -- named pointer
b3 = LFOtri( 0, hiHlf, 2)
b4 = LFOtri( hiHlf, Height, 2)
x50 = x100 / 2
fifteen = relX(15)
thirty = relX(30)
oneTwen = x100 / 20
hi4 = Height / 4
hi75 = Height * 0.75
of.enableAntiAliasing()         -- enable aa for smooth lines
of.noFill()                     -- do not fill the shopes
of.setLineWidth(1)


-- DRAW LOOP ------------------
function draw()    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )               -- set the fg color
    
    y = inL[50] * hiHlf
    
    size1 = ( knob1 * x100 ) + 1
    size2 = ( knob2 * x50 ) + 1
    
    b1.step = ( knob3 * fifteen ) + 5
    b2.step = ( knob3 * thirty ) + 5
    step3_4 = ( knob3 * oneTwen ) + 2
    b3.step = step3_4
    b4.step = step3_4
    
    posx1 = b1.update()
    posx2 = b2.update()
    posy1 = b3.update()
    posy2 = b4.update()
    
    of.pushMatrix()
        of.drawLine( 0, posy1, Width, posy1)
        of.drawLine( 0, posy2, Width, posy2)
        of.drawLine( posx1, hi4 - y, posx1, hiHlf)
        of.drawLine( posx2, hiHlf, posx2, hi75 + y)
    of.popMatrix()
end
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end