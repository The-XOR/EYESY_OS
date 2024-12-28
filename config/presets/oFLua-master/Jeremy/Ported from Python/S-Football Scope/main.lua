--S-FootballScope

require('eyesy')
knob1 = .5 --X
knob2 = .5 --Y
knob3 =  0 --Ball Size
knob4 = .33--color
knob5 = .5--bg color picker
inL = {}
inR = {}
Height = of.getHeight()
Width = of.getWidth()
----------------------------------------------------
function setup()
    of.setWindowTitle("S - FootballScope")
    of.setFrameRate(60)
    of.setLineWidth(3)
    print("S - FootballScope")
end
----------------------------------------------------

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
function update()
end
----------------------------------------------------
function draw()
   ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    
    of.fill()
    of.pushMatrix()
        FootballScope()
    of.popMatrix()
end
    
function FootballScope()
    lines=100
    circlespaceH = Height/lines
    circlespaceW = Width/lines
    circlebuff = 3*Width/lines
    circlerad = Width/100
    
    for i=1,lines-1 do
        x0 = knob2*Height
        x1 = knob1*Width + inL[i]*Height*2
        y0 = i*circlespaceW - circlebuff
        y1 = i*circlespaceH - circlebuff
        
        fg:setHue( fg:getHue() + (i/80) )
        of.setColor( fg )
        of.drawSphere(x1, y1 + circlebuff,knob3 * circlerad)
        of.drawLine(y0 + circlebuff, x0, x1, y1+circlebuff)
    end
end
----------------------------------------------------
function exit()
    print("script finished")
end