modeTitle = "S - Two Scopes"
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
w100 = relY(100)
y48 = Height / 48

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

-- DRAW LOOP ------------------

function draw()
    
----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    lW = (knob3 * y48) + 1
    of.setLineWidth( lW )
    k1 = knob1 * Width
    k2 = knob2 * Width
    time = of.getElapsedTimeMillis() * 0.0008           -- Global time

    of.pushMatrix()
    for i = 0, 50 do
        x0 = k1
        aud = inL[ (i%100)+1 ] * Height + 2
        y = i * y48
        if( knob4 >= 1 ) then
            of.setColor(
                sin( 0.1, i),
                sin( 0.05, i),
                sin( 0.01, i)
            )
        else
            of.setColor( fg )   -- knob4 color
        end
        of.drawLine( x0, y, x0+aud, y)
    end
    for i = 50, 100 do
        x0 = k2
        aud = inL[ (i%100)+1 ] * Height + 2
        y = (i-50) * y48
        if( knob4 >= 1 ) then
            of.setColor(
                sin( 0.1, i),
                sin( 0.05, i),
                sin( 0.01, i)
            )
        else
            of.setColor( fg )   -- knob4 color
        end
        of.drawLine( x0, y, x0+aud, y)
    end
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end