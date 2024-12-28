-- S - Aquarium
print("S - Aquarium")
require('eyesy')

Height = of.getHeight()
Width = of.getWidth()
speedlist = {}
ylist = {}
widthlist = {}
countlist = {}
xden = 19
yden = 19
----------------------------------------------------
function setup()
    of.setWindowTitle("S - Aquarium")
    print("script setup")
    of.setFrameRate(60)
    for i=0,20 do                               --SPEEDS
        speedlist[i] = math.random(-10,10)/10
    end
    for i=0,20 do                               --Y POINTS
        ylist[i] = math.random(-50,Height+50)
    end
    for i=0,20 do                               --WIDTHS
        widthlist[i] = math.random(20,glm.ceil(Width/6))
    end
    for i=0,20 do                               --COUNT
        countlist[i] = math.random(0,20)
    end
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
----------------------------------------------------
function update()
end
----------------------------------------------------
function draw()
    
----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )
    
    of.setLineWidth((Height/12)*knob3)
    xden = knob2*19+1
    if yden ~= knob1*19+1 then
        yden = knob1*19+1
        for i=0,20 do                               --SPEEDS
            speedlist[i] = math.random(-20,20)/10
        end
        for i=0,20 do                               --Y POINTS
            ylist[i] = math.random(-50,Height+50)
        end
        for i=0,20 do                               --WIDTHS
            widthlist[i] = math.random(20,glm.ceil(Width/6))
        end
    end

    of.pushMatrix()
        of.translate(Width/2,0,0)
        of.translate(-Width/2,0,0)
        Fish()
    of.popMatrix()
end
    
function Fish()
    
    
    for i=1,yden do
        local y0 = ylist[i]
        local ymod = 2*Height/3
        for j=1,xden do
            fishwidth = widthlist[i]*knob3
            y1 = y0 + inL[j+i]*ymod + 2
            countlist[i] = countlist[i] + speedlist[i]
            modspeed = countlist[i]%(Width+fishwidth*2)
            x = (j * (fishwidth/5)) + (modspeed-fishwidth)
            of.drawLine(x,y1,x,y0)
        end    
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end