-- S - Grid Polygons Filled------
-- Global Params and various setups ------
print("Grid Polygons Filled")
require('eyesy')

Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width

-- SETUP --------------------------------
function setup()
    of.setWindowTitle("Grid Polygons Filled")
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

-- fill table functions --
function fillTabRand(x, a, b, y, z )
    local tab = {}      -- local table 
    points = x or 1     -- amount of x,y points for each table slot
    xrange = a or 0       -- x range
    yrange = b or 0       -- y range
    targetTable = y     -- name of table to save points to
    slot = z or 1       -- slot number to save to in target table
    
    for i = 1, points do
        xyTab = {}
        xyTab[1] = ( math.random(0, xrange) ) - (xrange/2) -- x point for vertex pair
        xyTab[2] = ( math.random(0, yrange) ) - (yrange/2)-- y point for vertex pair
        tab[i] = xyTab                     -- xy table within shape table
    end
    
    targetTable[slot] = tab
end
function bugPoly(x, y, o, num, a)
    xpos = x or 1       -- x center position  
    ypos = y or 1       -- y center position
    tab = o         -- name of table
    slot = num or 1     -- slot number of table
    audio = a           -- audio in
    of.beginShape()
        for i = 1, 6 do
            wackX = (i%3) - 1
            wackY = ( (i+1) % 3 ) - 1
            --wackX = math.random(0,2) - 1
            --wackY = math.random(0,2) - 1
            of.vertex( (tab[slot][i][1] + xpos) + (audio*wackX), (tab[slot][i][2] + ypos) + (audio*wackY))
        end   
    of.endShape()
end

    

-- Global Params for Grid Polygons --
x8 = math.floor( (Width / 8) + 0.5 )
y5 = math.floor( (Height / 5) + 0.5 )

ten = relX(10)
hten = ten / 2
hundert = relX(100)
pList =  {}             -- global table of points for the vertexes
for i = 1, 80 do        -- fill pList for set-up. first time
    fillTabRand(6, x8, y5, pList, i)
end
-- DRAW LOOP ------------------

function draw()
     ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    xoffset = math.floor( (knob1 * x8) + 0.5)
    yoffset = math.floor( (knob2 * y5) + 0.5)
    
    w = (knob3*4) + 1
    avg = avG()
    
    -- if there is a trigger remix the random points --
    if( avg >= 0.1 ) then
        for i = 1, 80 do        -- fill pList with new random points
            fillTabRand(6, x8, y5, pList, i)
         end
    end

    of.pushMatrix()
    --of.noFill()                           -- fill the polygons
    of.setColor( fg )
    of.setLineWidth(1)
    
        for i = 0, 7 do                     -- 8 rows
            
            for j = 1, 9 do                 -- 10 columns
                x = (j * x8) - (x8/2)           
                y = (i * y5) + (y5/2)
                rx = math.floor( x + 0.5 )  -- x placement rounded
                ry = math.floor( y + 0.5 )  -- y placement rounded
                xNum = i * 10               -- math to get 0 - 80
                v = xNum + j
                
                rad = inL[ v ] * hundert    -- audio math
                
                if( (i%2) == 1 ) then       -- odd/even logic for the offset
                    rx = rx + xoffset
                end
                if( (j%2) == 1 ) then
                    ry = ry + yoffset
                end
                
                bugPoly(rx, ry, pList, v, rad)  -- the draw function
            end
        end 
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end