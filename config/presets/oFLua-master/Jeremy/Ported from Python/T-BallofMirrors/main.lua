modeTitle = "T - Ball of Mirrors"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
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
--------------------------------------------------------- feedback
w = of.getWidth()
h = of.getHeight()
myTex = of.Texture()                        -- define texture class
myPix = of.Pixels()                         -- define pixels class
myPix:allocate( w, h, of.PIXELS_RGBA )      -- allocate pixels first    
myTex:allocate( myPix )                     -- then allocate those pix to the texture

-- globsal params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
hiHlf = Height / 2
wiHlf = Width / 2
cScale = relX(50)
circTab = {}




-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
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

    k1 = knob1 * 255
    k2 = knob2 * Height
    k3 = (knob3 * hiHlf) + 1
    aud = avG()
    
    -------------------------- draw feedback
    of.setColor(255, 255,255, k1)          -- slight transparency
    myTex:draw( 0, 0, w, h )                -- draw the texture captured

    if( aud >= 0.01 ) then
        circTab = { 
        math.random( 0, 255 ),
        math.random( 0, 255 ),
        math.random( 0, 255 ),
        math.random( 0, Width),
        math.random( 0, Height)
        }   
        of.pushMatrix()
            of.setColor( circTab[1], circTab[2], circTab[3] )
            of.drawCircle( circTab[4], circTab[5], cScale )
        of.popMatrix()
    end
    
    -------------------- capture the feedback
    myTex:loadScreenData( 0, 0, w, h )          -- capture entire screen 
    

    
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end