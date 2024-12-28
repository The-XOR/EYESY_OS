modeTitle = "S-Sound Jaws AG"
print(modeTitle)
require('eyesy')

w = of.getWidth()
h = of.getHeight()
w2 = w / 2
h2 = h / 2


-- SETUP --------------------------------
function setup()
    of.setWindowTitle("knobs example")
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
---------------------- custom draw functions -----
function topTeeth( amount, clench )
    space = w / amount
    for i = 0, amount do
        x = i * space
        aud = inL[ (i%100) + 1 ] 
        yRange = h - clench
        audio = aud * yRange
        y = clench + audio
        bottom = 0
        gap = space*0.98
        center = (space - gap) / 2 
        fg:setHue( fg:getHue() + (i/colorWarp) )
        of.setColor( fg )
        of.drawRectangle( x + center, bottom, space*0.98, y )
    end
end
function bottomTeeth( amount, clench )
    space = w / amount
    for i = 0, amount do
        x = i * space
        aud = inL[ (i%100) + 1 ] 
        yRange = h - clench
        audio = aud * yRange
        y = clench + audio
        bottom = h
        gap = space*0.98
        center = (space - gap) / 2 
        fg:setHue( fg:getHue() + (i/colorWarp) )
        of.setColor( fg )
        of.drawRectangle( x + center, bottom, space*0.98, -y )
    end
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
    of.setColor( fg )               -- set the fg color
    
    teethAmt = math.floor(knob1 * 35) + 1 
    teethClamp = knob2 * h2
    colorWarp = knob3 * 50 + 1
    
    topTeeth( teethAmt, teethClamp )
    bottomTeeth( teethAmt, teethClamp )
    
end

----------------------------------------------------
function exit()
    print("script finished")
end