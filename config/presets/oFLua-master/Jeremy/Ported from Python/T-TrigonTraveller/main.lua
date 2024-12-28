modeTitle = "T - Trigon Traveller"

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
-- Function for the sine loop used in the colorMode function ---
function sin(iter, scale)
    local x = iter
    local y = scale
    sine1 = math.sin( (x * y) + time )      -- requires the global time
    sine2 = (sine1 * 127) + 127
    return sine2 
end
-- Color Mode function --
function colorMode(iter, selec)
    local x = iter
    local y = math.floor(selec)     -- 1 - 8 range
    local tab = {}
    if( y == 1 ) then
        tab = { sin(x, 0.1), sin(x, 0.01), sin(x, 0.001) }
    elseif( y == 2 ) then
        tab = { sin(x, 0.1), 42, 75 }
    elseif( y == 3) then
        tab = { 75, sin(x, 0.1), 42 }
    elseif( y == 4) then
        tab = { 42, 75, sin(x, 0.1) }
    elseif( y == 5) then
        tab = { sin(x, 0.1), 255, 127 }
    elseif( y == 6) then
        tab = { 255, sin(x, 0.1), 127}
    elseif( y == 7) then
        tab = { 205, 200, sin(x, 0.1) }
    elseif( y == 8) then
        tab = { sin(x, 0.1), sin(x, 0.1), sin(x, 0.1) }
    end

    return tab
end
-- global params --
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2
heightHalf = Height / 2
trot = 0
xMove = 0
yMove = 0
xSpeed = 3.1
ySpeed = 3.1
xAdder = xSpeed
yAdder = ySpeed
p100 = relX(100) 
p200 = relX(200)
p400 = relX(400)  
a = 0
b = 0
c = 0
d = 0
myRect = of.Rectangle( 0, 0, p200, p400)
myRect:setFromCenter( widthHalf, heightHalf, p200, p400 )
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    time = of.getElapsedTimeMillis() * 0.0008                   -- Global time
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    aud = avG()
    xSpeed = (knob1 * 5) 
    ySpeed = (knob2 * 5) 
    rotateRate = 15 - ( knob3 * 30 )  
    sel = math.floor( knob4 * 7 ) + 1
    
    -- the trigger --
    if( avG() >= 0.08 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        if( trot >= 360 ) then
            trot = 0
        else
            trot = trot + rotateRate
        end
    end

    if( myRect:getLeft() <= 0 ) then
        xAdder = xSpeed
    elseif( myRect:getRight() >= Width ) then
        xAdder = -xSpeed
    elseif( myRect:getTop() <= 0 ) then
        yAdder = ySpeed
    elseif( myRect:getBottom() >= Height ) then
        yAdder = -ySpeed
    end
    xMove = xMove + xAdder
    yMove = yMove + yAdder
    
    for i = 1, 2 do
        colorTab = colorMode( i, sel )
        --of.setColor( 255 )
        of.rotateDeg( trot, widthHalf, heightHalf, 0 )
        --of.drawRectangle( myRect )
        myRect:setFromCenter( widthHalf, heightHalf, p200, p400 )
        of.setColor( colorTab[1], colorTab[2], colorTab[3] )
        
        a = myRect:getLeft() + xMove
        b = myRect:getTop() + yMove
        c = myRect:getRight() + xMove
        d = myRect:getBottom() + yMove
        w = myRect:getWidth()
        
        of.drawTriangle( a, d, 
                    a + w/2, b, 
                    c, d 
                )
    end
    
    if( a <= 0 ) then
        xAdder = xSpeed
    elseif( c >= Width ) then
        xAdder = -xSpeed
    elseif( b <= 0 ) then
        yAdder = ySpeed
    elseif( d >= Height ) then
        yAdder = -ySpeed
    end
    xMove = xMove + xAdder
    yMove = yMove + yAdder
    
    
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end