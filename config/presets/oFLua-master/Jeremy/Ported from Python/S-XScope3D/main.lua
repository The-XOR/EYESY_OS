require ('eyesy')

count = 0
front = true
w = of.getWidth()
h = of.getHeight()
w2 = w / 2
h2 = h / 2


----------------------------------------------------
function setup()
    of.setWindowTitle( "S - XScope 3D" )
    of.setFrameRate( 60 )
    print("S - XScope 3D")
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
    
   
    lineW = ( knob1 * 35 ) + 1
    of.setLineWidth(lineW)
    
    
    count = count+1
    of.noFill()
    offset = knob2 * w
   
    of.setColor( fg )
    
    of.translate( w2, h2 )
    
    if .25 < knob3 and knob3 < .75 then
        front = false
    else
        front = true
    end
    
    if front == true then
        of.pushMatrix()
            of.translate(0,0,-knob1*w)
            of.rotateYDeg(knob3*360)
    
            of.pushMatrix()
                of.translate(-offset/100,-offset/100,-offset)
                shadow( fg, alpha)
            of.popMatrix()
        
            of.pushMatrix()
                of.setLineWidth(lineW)
                of.setColor(fg, 255)
                slantScopes()
            of.popMatrix()
            
        of.popMatrix()
    end
    
    if front == false then
    of.pushMatrix()
            of.translate( 0, 0, -knob1 * w )
            of.rotateYDeg(knob3*360)

            of.pushMatrix()
                of.setColor( fg, 255 )
                slantScopes()
            of.popMatrix()

            of.pushMatrix()
                of.translate(-offset/100,-offset/100,-offset)
                shadow( fg, alpha )
            of.popMatrix()
        
    of.popMatrix()
    end
    
end

function shadow( color, alpha)
    local ghost = 255-(255*knob2)
    of.setColor( color, ghost)
    slantScopes()
end


function slantScopes()
    
    of.beginShape()
    for i=1,256 do
       local slantx = i*w/256-w/2
       local slanty = (i-1)*h/255-h/2
       local soundL = inL[i]*800
        of.vertex(slantx,slanty+soundL)
    end
    of.endShape()
    
    of.beginShape()
    for i=1,256 do
       local slantx = i*w/256-w/2
       local slanty = (i-1)*h/255-h/2
       local soundR = inL[i]*800
        of.vertex( -slantx, slanty+soundR )
    end
    of.endShape()
end

----------------------------------------------------
function exit()
    print("script finished")
end