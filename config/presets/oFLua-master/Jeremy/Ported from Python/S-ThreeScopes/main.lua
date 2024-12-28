modeTitle = "S - Three Scopes"
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
y3 = Height / 3
y2_3 = (Height*2) / 3
step16 = relX(16)
wid = relX(42)
steppy = knob1 * step16
leftPoint = knob2 * Height
lineWidth = (knob3 * wid) + 1
screenDiv = Width / 60

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
-- DRAW LOOP ------------------

function draw()
  ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )
    
    of.setLineWidth( lineWidth )
    
    steppy = knob1 * step16
    leftPoint = knob2 * Height
    lineWidth = (knob3 * 39) + 1
    
    of.pushMatrix()
    for i = 0, 30 do
        aud = inL[ (i%100)+1 ] * Height + 1
        ay0 = y3 + leftPoint - (steppy * i)
        ay1 = ay0 + aud
        ax = i * screenDiv
    
        of.drawLine( ax, ay1, ax, ay0)
    end
    for i = 30, 60 do
        aud = inL[ (i%100)+1 ] * Height + 1
        i30 = i - 30
        ay0 = y3 + leftPoint - (steppy * i30 )
        ay1 = ay0 + aud
        ax = i30 * screenDiv
    
        of.drawLine( ax, ay1, ax, ay0)
    end
    for i = 60, 94 do
        aud = inL[ (i%100)+1 ] * hiHlf + 1
        ay0 = hiHlf
        ay1 = ay0 + aud
        ax = (i-30) * screenDiv

        of.drawLine( ax, ay1, ax, ay0)
    end
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end