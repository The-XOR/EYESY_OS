modeTitle = "T - Draws Hashmarks New"

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
-- Function for sine color warp ---
function sin(iter, scale)
    local x = iter
    local y = scale
    sine1 = math.sin( (x * y) + time )      -- requires the global time
    sine2 = (sine1 * 127) + 127
    return sine2 
end
-- color shift function --
function colorMode(iter, selec)
    local x1 = iter or 0
    local x = x1 % 255
    local y = selec or 1     -- 1 - 8 range
    local tab = {255,255,255}
    if( y == 1 ) then
        tab = { sin(x, 0.1), sin(x, 0.1), sin(x, 0.1) }
    
    elseif( y == 2 ) then
        tab = { sin(x, 0.1), 0, 45 }
    
    elseif( y == 3) then
        tab = { 255, sin(x, 0.1), 30 }
    
    elseif( y == 4) then
        
        tab = { 0, 200, sin(x, 0.1) }
   
    elseif( y == 5) then
        tab = { 0, 0, sin(x, 0.1) }
    
    elseif( y == 6) then
        tab = { 0, sin(x, 0.1), 0 }
    
    elseif( y == 7) then
        tab = { sin(x, 0.1), 0 , 0 }
    
    elseif( y == 8) then
        tab = { sin(x, 0.1), sin(x, 0.05), sin(x, 0.01) }
    end

    return tab
end

-- global params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
wiHlf = Width / 2
hiHlf = Height / 2
min200 = relX(200) --((200*xr)/1280)
min100 = relX(100)  --((100*xr)/1280)
max1000 = relX(1280)  --((1280*xr)/1280)
max700 = relY(700)  --((700*yr)/720)
ran50 = relX(50)   --((50*xr)/1280)
ran70 = relX(70)     --((70*xr)/1280)
vertLines = 20
Rwidth = 0
Rheight = 0

Rx = 0
Ry = 0
trigger = false

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
of.noFill()
function draw()
  ----------------------- Color stuff
    --colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    aud = avG()
    --of.setHexColor( colortable[glm.ceil( knob4*130+1 ) ] )      -- knob4 color table
    time = of.getElapsedTimeMillis() * 0.0008
    -- Knobs
    lines = math.floor( (knob1 * 9) + 1 ) + 90
    lineWidth = relY( ( knob2 * 7 ) + 1 ) + 1
    of.setLineWidth( lineWidth )
    k3X = (knob3 * ran50) + 2
    k3Y = (knob3 * ran70) + 8
    sel = math.floor( knob4 * 7 ) + 1
    -- color for loop --
    color = {}
    for i = 0, 1 do
        color = colorMode( i, sel )
    end
    of.setColor( color[1], color[2], color[3] )
    -- the trigger --
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        vertLines = math.random( math.floor(k3X), math.floor(k3Y) )
        Rx = math.random( -min200, max1000 )
        Ry = math.random( -min200, max700 )
        Rwidth = math.random( -min100, max1000 )
        Rheight = math.random( -min100, max1000 )
        for i = 0, vertLines do
            xpos = Rx + (i + 1) * (Rwidth / vertLines)
        end
    end
    
    of.pushMatrix()
        for i = 0, vertLines do
            
            xpos = Rx + (i + 1) * (Rwidth/vertLines)
            of.drawLine( xpos, Ry, xpos, Rheight)
        end  
        trigger = false
       
       for i = 0, lines do
            
            lineSpace = ( Height - (lines-1) ) * ( (Height-2) / 100 )
            of.drawLine( 0, (i*lineSpace)+(lineSpace/2), Width, (i*lineSpace)+(lineSpace/2) )
        end
    of.popMatrix()
    
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end