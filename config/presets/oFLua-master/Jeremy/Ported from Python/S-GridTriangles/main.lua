modeTitle = "S - Grid Triangles"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
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

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
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
-- Grid Blueprint Function, fill a table with grid points --
function gridBlu(w, h)
    local x8 = w/8
    local y5 = h/5
    local tab = {}
    
    
    for i = 0, 5 do                     -- for loops to make the shapes
        for j = 0, 8 do
            xyTab = {0,0}
            x = j * x8 
            y = i * y5 
            
            xNum = i * 9                   -- math to get 0 - 40
            v = (xNum + j) + 1
            
            xyTab[1] = x
            xyTab[2] = y
            
            tab[ v ] = xyTab
            
        end
    end
    return tab
end
-- Draw the Triangles --
function tris()
     for i = 1, 54 do                     -- for loops to make the shapes
        x = points[i][1]
        y = points[i][2]
        aud = inL[ i ] * relX(100) 
        if( (i%2) == 1 ) then       -- odd/even logic for the offset
            x = x + xoffset
            y = y + yoffset
        end 
        a = x - (xw/2)
        b = (y+y5) + (yw/2)
        
        c = x + x16
        d = y - (yw/2)
        
        e = (x+x8) + (xw/2)
        f = (y+y5) + (yw/2)
        
        of.drawTriangle(a-aud, b+aud, c, d-aud, e+aud, f+aud )
    end
end
-- Global Params for Grid Polygons --
x8 = Width / 8
y5 = Height / 5
x16 = x8 / 2
hund = relX(100)
points = {}
points = gridBlu(Width, Height)

-- DRAW LOOP ------------------

function draw()
   ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    xoffset = knob1 * x8
    yoffset = knob2 * y5
    widthx = ( knob3 * (x8-3) ) - x8
    widthy = ( knob3 * (y5-3) ) - y5
    xw = widthx + 3
    yw = widthy + 3

    of.pushMatrix()
    of.noFill()                         -- no fill for the triangles
    of.setLineWidth( 3 )
    of.setColor( fg )                   -- set color with knob4
        tris()
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end