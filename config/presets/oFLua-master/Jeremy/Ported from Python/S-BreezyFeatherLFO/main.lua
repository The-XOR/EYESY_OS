-- S - Breezy Feather LFO  ------ lolll
print("S - Breezy Feather LFO")
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width


-- SETUP --------------------------------
function setup()
    of.setWindowTitle("S - Breezy Feather LFO")
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

-- Define new LFOS ----------

yposr = LFOtri(-100,830,10)
tris = LFOtri(2,70,1)

-- DRAW LOOP ------------------

function draw()
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )               -- set the fg color
    yposr.max = Height
    tris.max = ( (60 * Width) / 1280)
    
    tris.step = knob1
    triangles = tris.update() -- +2
    space = Width / triangles
    offY =  ((knob3*2) - 1 ) * (space * 4) 
    offset = math.floor( offY + 0.5)
   
    yposr.step = knob2 * 8
    y = yposr.update()
    
    of.pushMatrix()
        drawTris()
    of.popMatrix()
end

function drawTris()  --function to draw the triangles
        for i = 0, triangles do -- draw the triangles
            
            auDio = inL[i+1] * (Width)
           
            ax = i * space
            of.drawTriangle( ax, y, 0, ax + math.floor( ((space/2)+offset)+ 0.5), auDio + y, 0, ax + space, y+space, 0)
        end
end
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end