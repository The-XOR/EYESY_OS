modeTitle = "S - Line Traveller"
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
--fg = of.Color()             -- define foreground color class
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
-- Function for sine color warp ---
function sin(iter, scale)
    local x = iter
    local y = scale
    sine1 = math.sin( (x * y) + time )      -- requires the global time
    sine2 = (sine1 * 127) + 127
    return sine2 
end

-- Function Color Mode --
function colorMode(iter, selec)
    local x1 = iter or 0
    local x = x1 % 255
    local y = selec or 1     -- 1 - 8 range
    local tab = {255,255,255}
    if( y == 1 ) then
        tab = { sin(x+90, 0.1), sin(x+10, 0.05), sin(x+9, 0.1) }
    elseif( y == 2 ) then
        tab = { sin(x+90, 0.1), 42, 75 }
    elseif( y == 3) then
        tab = { 75, sin(x+56, 0.1), 42 }
    elseif( y == 4) then
        tab = { 42, 75, sin(x+45, 0.1) }
    elseif( y == 5) then
        tab = { sin(x, 0.1), 255, 127 }
    elseif( y == 6) then
        tab = { 255, sin(x+50, 0.1), 127}
    elseif( y == 7) then
        tab = { sin(x+30, 0.1), 0 , 0 }
    elseif( y == 8) then
        tab = { sin(x+30, 0.1), sin(x+30, 0.1), sin(x+15, 0.01) }
    end

    return tab
end
-- global variables --
xcount = 1
ycount = hiHlf
yline = Width/8
of.enableAntiAliasing()         -- enable aa for smooth lines
of.noFill()                     -- do not fill the shopes

    
-- DRAW LOOP ------------------
function draw()  
    x = math.floor( (xcount % 100) + 1 )
    auDio = inL[x] * hiHlf

    time = of.getElapsedTimeMillis() * 0.0008   -- Global time
    ----------------------- Color stuff
    --colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 


    thick = (knob1 * yline) + 20
    xspeed = knob2 * 8
    yspeed = knob3 * 8
    sel = math.floor( (knob4 * 7) ) + 1
    of.setLineWidth( (knob1*35)+1 )
    tabby = {255,255,255}
    tabby = colorMode(xcount*0.01, sel)
        
    y1 = ( ycount-(thick/2) ) - auDio
    y2 = ( ycount+(thick/2) ) + auDio
    of.setColor( tabby[1], tabby[2], tabby[3])
    

    of.pushMatrix()
        of.drawLine( xcount, y1, xcount, y2 )
    of.popMatrix()
    
    if( xcount > Width ) then 
        xcount = 0
    end
    if( xcount < 0) then 
        xcount = Width
    end
    if( ycount > Height ) then 
        ycount = 0
    end
    if( ycount < 0) then 
        ycount = Width
    end
    xcount = xcount + xspeed
    ycount = ycount + yspeed
end
-- EXIT  --------------------------------------------------

function exit()
    of.disableAntiAliasing()         -- disable aa for smooth lines
    print("script finished")
end