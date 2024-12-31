modeTitle = "S-Binary Star"
print(modeTitle)
require('eyesy')

lines = 10
xpos = 0
XR = of.getWidth()
YR = of.getHeight()
offset = XR / 2
count = 0
width = XR / lines
xhalf = XR / 2
yhalf = YR / 2
yrange = ( (xhalf/2) * YR) / YR
bounceD = ( (xhalf/2) * XR) / XR

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
-- UPDATE --------------------------------------------------

function update()
end

-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    sel = math.floor( (knob4*4) + 0.5 ) + 1               --select color modes
    gravity = math.floor( knob3 * (XR/3) )  --set gravity amount
    time = of.getElapsedTimeMillis() * 0.001
    

    
    
    -- print the star
    of.pushMatrix()
        newStar(lines, sel)
    of.popMatrix()
end

-- Make a Star Function ----
function newStar(x, y)
    local self = {}       --make a table
    
    self.lines = x or 10  -- amount of lines
    self.sel = y          -- color mode select
    col1 = {}
    col2 = {}
    
    for i = 1, self.lines do
        -- the different color modes --
        
        if(self.sel == 1) 
            then
            col1 = {255, 0, 255}
            col2 = {0, 255, 255}
        
        elseif(self.sel == 2)
            then
            col1 = {127 + (127 * math.sin( (i*6) * .01 + time) ),
                    0,
                    0
                }
            col2 = {0,
                    0,
                    127 + (127 * math.cos( (i*6) * .01 + time) )
                }
        elseif(self.sel == 3)
            then
            col1 = {127 + (127 * math.sin( (i*6) * .01 + time) ),
                    255,
                    127 + (127 * math.sin( (i*6) * .01 + time) )
                } 
            col2 = {255,
                    math.abs(127+127 * math.cos( (i*6) * .01 + time) ),
                    math.abs(127+127 * math.cos( (i*6) * .01 + time) ) 
                }
        elseif(self.sel == 4)
            then
            col1 = {255,
                    127 + (127 * math.cos( (i*6) * .01 + time ) ),
                    255
                }
            col2 = {255,
                    255,
                    127 + (127 * math.cos( (i*6) * .01 + time ) )
                } 
        elseif(self.sel == 5)
            then
            cos = 127 + (127 * math.cos( (i*6) * .01 + time ) )
            col1[1],col1[2],col1[3] = cos, cos, cos
            col2[1],col2[2],col2[3] = cos, cos, cos
                    
        end
        
        -- all the math to draw these lines ---
        xposPre = xhalf * math.sin( ( i + time ) + gravity )
        xpos = math.floor( xposPre + 0.5)
        xpos1Pre = (xhalf*knob1) * math.sin( 2 + time ) 
        xpos1 = math.floor( xpos1Pre + 0.5)
        ypos1Pre = (yrange*knob1) * math.sin(time)
        ypos1 = math.floor(ypos1Pre + 0.5)
        ypos2Pre = (yrange*knob1) * math.sin( time * ( inL[i]/1000 ) )
        ypos2 = math.floor(ypos2Pre + 0.5)
        bounce1Pre = inL[25] / bounceD
        bounce1 = math.floor(bounce1Pre + 0.5)
        bounce2Pre = inL[75] / bounceD
        bounce2 = math.floor(bounce2Pre + 0.5)
        thickPre = knob2 * 19 
        thick = math.floor(thickPre + 0.5) + 1
        of.setLineWidth = thick
        of.setColor(col1[1], col1[2], col1[3])
        -- draw line 1
        of.drawLine( XR/2 - xpos1, 
                    (yhalf - bounce1) + ypos1, 
                    (XR/2 - xpos) - xpos1, 
                    offset + ( (i * width) + ypos2)
                    )  
        --draw line 2
        of.setColor(col2[1], col2[2], col2[3])
        of.drawLine( xhalf + xpos1, 
                    (yhalf - bounce2) + ypos1, 
                    (xhalf - xpos) + xpos1, 
                    offset + ( (i * width) - ypos2)
                    )  
                
    end
end

    
    

----------------------------------------------------
function exit()
    print("script finished")
end