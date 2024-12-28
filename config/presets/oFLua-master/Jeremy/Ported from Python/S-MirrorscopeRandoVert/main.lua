--S-MirrorscopeRandoVert
print("S-MirrorscopeRandoVert")
require('eyesy')
knob1 = .5 --scope position
knob2 = .5 --circle size
knob3 =  0 --linewidth
knob4 = .33--color
knob5 = .5--bg color picker
inL = {}
inR = {}
lines=100
Height = of.getHeight()
Width = of.getWidth()
ypos = {}
----------------------------------------------------
function setup()
    of.setWindowTitle("S-MirrorscopeRandoVert")
    print("script setup")
    of.setFrameRate(60)
    for j=1,lines+2 do
        ypos[j] = math.random(-100,Height)
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
    if inL[1]*3 > 1 then
        lines = knob3*60+5
        for j=1,lines+2 do
            ypos[j] = math.random(-100,Height)
        end
    end    
   
----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )
    
    space = Width/(lines+1)
    position = knob1*Height
    --ballSize = knob2*Width/(lines-75)
    of.setLineWidth(Width/lines)
    --of.fill()
    of.pushMatrix()
        of.translate(Width/2,0,0)
        of.translate(-Width/2,0,0)
        Hscope()
    of.popMatrix()
end
    
function Hscope()
    for i=1,lines do
        y0 = 0
        y1 = inL[i]*Height/2
        x = i*space
        
        
        of.drawLine(x,ypos[i],x,y1+position)
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end