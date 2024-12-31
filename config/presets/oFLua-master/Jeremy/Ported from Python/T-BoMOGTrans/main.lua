modeTitle = "T - BoM OG Trans"

-- Global Params and various setups ------

require('eyesy')


-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    of.setFrameRate(60)
    print(modeTitle)
end
-------------------------- Feedback
w = of.getWidth()
h = of.getHeight()
myTex = of.Texture()                        -- define texture class
myPix = of.Pixels()                         -- define pixels class
myPix:allocate( w, h, of.PIXELS_RGBA )    -- allocate pixels first    
myTex:allocate( myPix )                     -- then allocate those pix to the texture
fbInit = 0
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
-- global params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
h2 = Width / 2
w2 = Height / 2
x100 = relX(100)


h10 = Width / 100
w10 = Height / 100
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4*2, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    -------------------------- draw feedback
    
    k2 = 1 - (knob2/10)                         -- knob2 sets the shrink feedback
    shrink = math.pow( k2, 0.5 )                -- do a power curve
    
    grabW = shrink * w                          -- set the width
    grabH = shrink * h                          -- set the height
    
    posX = (w - grabW) / 2                      -- center the X
    posY = (h - grabH) / 2                      -- center the Y
    xSkew = ( knob1 * (posX*2) ) - posX         -- skew the "tunnel" effect left or right
    of.setColor(
        255, 255, 255, (knob3 * 251) + 4 )      -- set transparency knob3
        
    myTex:draw( posX+xSkew, posY, grabW, grabH )-- draw the texture captured
    
    aud = avG()     -- audio trigger
    
    -- the trigger --
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    
    circle()            -- draw random circles
    
    -------------------- capture the feedback
    myTex:loadScreenData( 0, 0, w, h)
    
    trigger = false
end
-- draw random circle
function circle()
    if( trigger == true ) then
        
        if( knob4 < 0.5 ) then
            fg = fg
        elseif( knob4 >= 0.5 ) then
            x = math.random( 0, 255 )
            rand = (fg:getHue() + x) % 255
            fg:setHue( rand )
        end
        
        x = math.random( 0, Width )
        y = math.random( 0, Height )
        
        radius = x100 + 1
        of.setColor( fg )
        of.drawCircle( x, y, radius)
        
    end
end 

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end