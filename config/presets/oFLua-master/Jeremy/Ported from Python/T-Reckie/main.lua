modeTitle = "T - Reckie"

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
size100 = relX(100)
xhalf = widthHalf
yhalf = heightHalf
x50 = relX(50)
x25 = x50 / 2
sizeX = ( (knob1 * 2) * size100 ) - size100
sizeY = ( (knob2 * 2) * size100 ) - size100
myRect = of.Rectangle( widthHalf-(sizeX/2), heightHalf-(sizeY/2), sizeX, sizeY )
myScreen = of.Rectangle( 0, 0, Width, Height)
x = myRect:getCenter()

print( x[1] )

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    aud = avG()
    of.setColor( fg )
    sizeX = ( (knob1 * 2) * size100 ) - size100
    sizeY = ( (knob2 * 2) * size100 ) - size100
    myRect:setSize( sizeX, sizeY )
    -- the trigger --
    if( avG() >= 0.08 ) then
        trigger = true
    else
        trigger = false
    end
    
    -- get current coordinates
    x = myRect:getWidth()
    y = myRect:getHeight()
    
    
    if( trigger == true ) then
        
        set = math.random( 1, 8 )
        
        if( set == 1 ) then -- up
            myRect:translateY( -y )
        elseif( set == 2 ) then -- up right
            myRect:translateX( x )
            myRect:translateY( -y )
        elseif( set == 3 ) then -- up left
            myRect:translateX( -x )
            myRect:translateY( -y )
        elseif( set == 4 ) then -- left
            myRect:translateX( -x )
        elseif( set == 5 ) then -- right
            myRect:translateX( x ) 
        elseif( set == 6 ) then -- down right
            myRect:translateY( y )
            myRect:translateX( x )
        elseif( set == 7 ) then -- down
            myRect:translateY( y )
        elseif( set == 8 ) then -- down left
            myRect:translateY( y )
            myRect:translateX( -x )
        end    
    end
    rectCenter = myRect:getCenter()
    screenCenter = myScreen:getCenter() 
   
    if( rectCenter[1] <= 0 ) or
        ( rectCenter[1] >= Width ) or
        ( rectCenter[2] <= 0 ) or
        ( rectCenter[2] >= Height )
    then
        myRect:setFromCenter( myScreen:getCenter(), sizeX, sizeY )
    end
        
    of.drawRectangle( myRect )

end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end