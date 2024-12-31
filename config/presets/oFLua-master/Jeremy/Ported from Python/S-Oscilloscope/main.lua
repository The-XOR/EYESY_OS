modeTitle = "S - Oscilloscope"
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

-- Global Params for Grid Polygons --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
hiHlf = Height / 2
wiHlf = Width / 2
w4 = Width / 4
lineLp = { 0, hiHlf }
shadLp = { 0, hiHlf }

x110 = relX(110)
a75 = relX(500)
x200 = relX(200)
x15 = relX(50) + 1
x150 = relX(150)
w50 = Width / 50
of.noFill()

-- draw function --
function line(i)
    i_1 = i
    i_2 = i + 1
    hi = knob2 * Height
    y1 = hi + ( inL[ (i_1%100)+1 ] * hiHlf)
    y2 = hi + ( inL[ (i_2%100)+1 ] * hiHlf)
    x1 = i_1 * w50
    x2 = i_2 * w50
    
    of.drawLine( x1, y1, x2, y2  )
end
function lineShadow(i)
    i_1 = i
    i_2 = i + 1
    hi = knob2 * Height
    y1 = hi + ( inL[ (i_1%100)+1 ] * hiHlf )
    y2 = hi + ( inL[ (i_2%100)+1 ] * hiHlf )
    x1 = i_1 * w50
    x2 = i_2 * w50
    of.drawLine( x1, y1-k3Pos, x2, y2-k3Pos  )
end
-- DRAW LOOP ------------------

function draw()
   
----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    k3Color = 280 - (knob3 * 255)             -- knob3 color intensity
    k3Pos = knob3 * x150                        -- and position
    linewidth = ( knob1*39 ) + 1                --  knob1 set line width
    of.setLineWidth(linewidth)
    
    of.pushMatrix()
        of.setColor( 0, 0, 0, k3Color)
        for y = 0, 50 do
            lineShadow(y)
        end
        
        of.setHexColor(colortable[glm.ceil(knob4*130+1)])
        for i = 0, 50 do
            line(i)
        end
    of.popMatrix()
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end