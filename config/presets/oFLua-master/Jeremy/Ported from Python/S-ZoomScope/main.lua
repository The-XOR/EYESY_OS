modeTitle = "S - Zoom Scope"
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
-- globsal params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
hiHlf = Height / 2
wiHlf = Width / 2
x2 = relX(2)
if( x2 <= 1 ) then
    x2 = 1
end
x5 = relX(5)



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

-- UPDATE --------------------------------------------------
function update()
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
-- darw cirlce line --
function seg(i, sel)
    tab = {}
    s1 = inL[ (i%100) + 1 ] * hiHlf + 2
    xs = Width / (f - 4)
    tab = colorMode(i,sel)
    of.setColor( tab[1], tab[2], tab[3] )
    ix = i * xs

    of.drawCircle( ix + offx, offy + s1, x5, 0 )
    of.drawLine( ix + offx, offy, ix + offx, s1 + offy)
end
-- DRAW LOOP ------------------
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    of.setLineWidth( x2 )
    f = (knob1 * 94) + 6
    sel = math.floor( knob4*7 ) + 1
    time = of.getElapsedTimeMillis() * 0.0008           -- Global time
    offx = ( knob2 * Width ) - wiHlf 
    offy = knob3 * Height


    of.pushMatrix()
        for i = 0, f do
            seg(i,sel)
        end
    
    
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end