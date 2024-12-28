modeTitle = "S - Square Shadows"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
hiHlf = Height / 2
wiHlf = Width / 2
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class


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
        tab = { sin(x, 0.1), sin(x, 0.05), sin(x, 0.1) }
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
        tab = { sin(x*50*time, 0.1), 0 , 0 }
    elseif( y == 8) then
        tab = { sin(x, 0.1), sin(x, 0.1), sin(x, 0.01) }
    end

    return tab
end

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

-- Variables --
x29 = relY(29) + 5
x125 = relX(125) + 1
x25 = relX(25)

function shadow( i )
    k2 = knob2*Width
    i4 = i * 4
    audi = inL[ ( i4%100 ) + 1 ]
    aud = audi * Height
    x = k2 + aud
    y = i * x29
    squaresize = knob1 * x125
    xMod = math.sin( knob3 * 6.28 ) * x25
    yMod = math.cos( knob3 * 6.28 ) * x25
    of.setLineWidth( squaresize )
    of.setColor(0)
    
    of.drawLine( x + xMod, y + yMod, x + xMod, (y+squaresize) + yMod )
end

function colorSquares( i )
    tab = {}
    k2 = knob2*Width
    i4 = i * 4
    audi = inL[ ( i4%100 ) + 1 ]
    aud = audi * Height
    x = k2 + aud
    y = i * x29
    squaresize = knob1 * x125
    
    sel = math.floor( knob4 * 7 ) + 1
    tab = colorMode( i, sel )
    of.setColor( tab[1], tab[2], tab[3] )
    of.drawLine( x, y, x, y+squaresize )
end
-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    time = of.getElapsedTimeMillis() * 0.0008   -- Global time


    of.pushMatrix()
        for i = 0, 25 do
            shadow( i )
        end
        for i = 0, 25 do 
            colorSquares( i )
        end
    of.popMatrix()
        

end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end