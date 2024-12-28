modeTitle = "S - Interference - LFO"
print(modeTitle)
require('eyesy')
Height = of.getHeight()         --global height of screen
Width = of.getWidth()           --global width
HiHlf = Height / 2          
WiHlf = Width / 2
-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    of.enableAntiAliasing()         -- enable aa for smooth lines
    of.noFill()                     -- do not fill the shopes
    of.setLineWidth(1)
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

-- LFO OBJECT-------------------------------------------------
function LFOtri(x, y, o)
    local locLFO = {}  -- make table
    
    locLFO.start = x or 0     -- start point
    locLFO.max = y or 1        -- max
    locLFO.step = o or 0.1       -- how big each step is
    locLFO.current = 0    -- start of the count
    locLFO.direction = 1  -- direction of triangle wave LFO
    
    function locLFO.update()    --the update function, this runs the LFO
        
    -- when it gets to the top, flip direction
        
        if(locLFO.current >= locLFO.max)
        then locLFO.direction = -1
             locLFO.current = locLFO.max -- in case it steps above max
        end
    -- when it gets to the bottom, flip direction
        
        if(locLFO.current <= locLFO.start)
        then locLFO.direction = 1
             locLFO.current = locLFO.start -- in case it steps below min
        end
        
    -- the counter
        locLFO.current = locLFO.current + (locLFO.step * locLFO.direction)
        
        return locLFO.current -- return the LFO steps
       
    end
    
    return locLFO --OOP stuf--  
end
-- Audio Math --
function auDi(x)
    y = ( inL[x] * HiHlf ) + HiHlf
    return y
end
-- declare LFOs --
fanner = LFOtri( 1, HiHlf, 10 )   -- make an triangle LFO named fanner
pointer = LFOtri( 1, HiHlf, 1 )  -- named pointer

-- DRAW LOOP ------------------
function draw()    -- reload image after resizing --
   ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )
    
    lines = math.floor( (knob1*29) + 1 )
    stepP = knob2 * 10
    fanner.step = stepP
    pointer.step = stepP
    r = auDi(1)     -- different points in the 100 point audio buffer inL
    l = auDi(11)
    t = auDi(21)
    e = auDi(45)
    f = auDi(75)
    k3= knob3 / 8
    halfMod = ( (knob3 + 0.5) * 100 ) % 100
    k3o2 = (halfMod / 100) / 8
    fan = fanner.update() * k3
    point = pointer.update() * k3o2
    
    
    of.pushMatrix()
        for i = 0, lines do
            mod = 1 % 2
            if(mod == 1) then
                of.beginShape()
                    of.vertex( 0, r - (i*point) )
                    of.vertex( WiHlf, l - (i*fan) )
                    of.vertex( WiHlf, t - (i*point) )
                    of.vertex( Width*0.75, e - (i*fan) )
                    of.vertex( Width, f - i )
                of.endShape()
            else
                of.beginShape()
                    of.vertex( 0, r + (i*point) )
                    of.vertex( WiHlf, l + (i*fan) )
                    of.vertex( WiHlf, t + (i*point) )
                    of.vertex( Width*0.75, e + (i*fan) )
                    of.vertex( Width, f + i )
                of.endShape()
            end
                
        end    
    of.popMatrix()
end
-- EXIT  --------------------------------------------------

function exit()
    of.disableAntiAliasing()         -- disable aa for smooth lines
    print("script finished")
end