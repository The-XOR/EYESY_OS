modeTitle = "T - Origami Triangles"

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

-- global params --
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2
heightHalf = Height / 2
x600 = relX(600)
pointz = { {widthHalf,heightHalf}, {Width/3, Height / 3}, {Width,Height/4} }


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
    
    posx = knob1 * Width
    posy = knob2 * Height
    density = knob3 * x600
    aud = avG()
    
    -- the trigger --
    if( avG() >= 0.08 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        randBri = math.random( 10, 255 )
        clipped = randBri % 255
        fg:setBrightness( fg:getBrightness() + randBri )
        
        
        --randColor = math.random( 15, 100 ) * .01
        --superColor = { 200 * randColor, 110 * randColor, 255 * randColor }
        x = math.random( 1, 3 ) 
        pointz[x] = { math.random( posx - density, posx + density + 10 ),
                    math.random( posy - density, posy + density + 10 )
                }
    end
    of.setColor( fg )
    of.pushMatrix()
    of.beginShape()
        for i = 1, 3 do   
            of.vertex( pointz[i][1], pointz[i][2])
        end
    of.endShape()
    of.popMatrix()
        
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end