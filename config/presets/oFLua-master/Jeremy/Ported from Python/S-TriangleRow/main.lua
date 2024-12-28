--S-TraingleRow

print("S-TraingleRow")
require ('eyesy')
count = 0
Height = of.getHeight()
Width = of.getWidth()
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
end
--------------------------------------------------
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

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    count = count+1
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    
    of.translate(Width/2,0,0)
    of.pushMatrix()
        of.rotateYDeg(knob4*360)
        of.rotateXDeg(knob3*90)
            of.pushMatrix()
                of.translate(-Width/2,0,0)
                trirow()
            of.popMatrix()
    of.popMatrix() 
end
    
function trirow()
    local tris = knob1*100 + 1
    local space = Width/tris
    
    for i=1,tris do
        H = (inL[i]*Height) + 30
        x = i*(space) - space/2
        y = knob2*Height
        z = 0
        local v1 = glm.vec3(x-space/2,y,z)
        local v2 = glm.vec3(x,y-H,z)
        local v3 = glm.vec3(x+space/2,y,z)
        
        fg:setHue( fg:getHue() + (i*0.25) )
        of.setColor( fg )
        of.drawTriangle(v1,v2,v3)
    end
end

----------------------------------------------------
function exit()
    print("script finished")
end