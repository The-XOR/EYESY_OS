-- S - Circle Row LFO  ------

-- Global Params and various setups ------

print("Circle Row LFO")
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width

circles = 10 -- circles global 

-- SETUP --------------------------------

function setup()
    of.setWindowTitle("Circle Row LFO")
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

--conversion functions--
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

-- Define new LFOS ----------

ypos = LFOtri(0,720,10)

-- DRAW LOOP ------------------

function draw()
    
    
   ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )
    
    ystepmod = relY(10)  --((50*Height)/720)
    circmod = relX(25)
    offsetmod = relX(55)
    ypos.step = math.floor( (knob3 * ystepmod) + 0.5)
    circles = math.floor( (knob1 * circmod) +0.5) + 1
    space = Width / circles
    offset = math.floor( (knob2 * offsetmod) + 0.5 )
    y = ypos.update()
    off2 = offset /2
    ypos.max = Height - offset
    ypos.start = 0 + offset 
    
    of.pushMatrix()
        drawCircs()
    of.popMatrix()
end

function drawCircs()  --function to draw the circles
        for i = 0, circles do -- draw the triangles
            
            auDio = (inL[i+1] * 100)
            r = auDio + offset

            ax = (i * space) + (space/2)
            
            of.drawCircle(ax, y, r)   -- draw a 2D circle
            
        end
end
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end