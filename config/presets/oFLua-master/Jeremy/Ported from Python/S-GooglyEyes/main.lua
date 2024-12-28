modeTitle = "S - Googley Eyes" 
print(modeTitle)
require('eyesy')

Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width

rad = 5
xpos = 300
ypos = 300
color = {0,0,0}
last_point = {Width/4, 0}
last_pint1 = {Width/4, 0}



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

-- LFO OBJECT-------------------------------------------------

function LFOtri(x, y, o)
    local locLFO = {}  -- make table
    
    locLFO.start = x      -- start point
    locLFO.max = y        -- max
    locLFO.step = o       -- how big each step is
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
-- smooth function
function smooth(o,y)
    
    local self = {}
    
    self.start = o or 0 --start number
    self.amt = y or 1   --step for smoothing
    
    self.direction = 1  --internal direction
    
    function self.go(z)
	    target = z or 1
		
		if(target > self.start)
			then self.direction = 1
        end
        
        if(target < self.start)
        	then self.direction = -1
        end
        
        if(target == self.start)
        	then self.start = self.start
        else
        	self.start = self.start + (self.amt * self.direction)
        end

        return self.start
    end

    return self
end
--conversion functions--
function relY(x)
    num = x or 1
    converted = (x * Height) / 720
    return converted
end
function relX(x)
    num = x or 1
    converted = (x * Width) / 1280
    return converted
end

-- Define new LFOS ----------
lfo1 = LFOtri(-200,200,1)
lfo2 = LFOtri(-300,300,1)
-- define new smoothing
smoother1 = smooth(0, 0.1)
smoother2 = smooth(0, 0.1)
-- DRAW LOOP ------------------

function draw()
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    lfo1.start = relX(-200)
    lfo1.max = relX(200)
    lfo2.start = relX(-300)
    lfo2.max = relX(300)
    
    xhalf = relX(640)
    x720 = relX(720)
    x1116 = (11*Width) / 16
    
    y3d = Height / 3
    y600 = relY(600)
    y640 = relY(640)
    
   
    widthmod = relX(25)
    linewidth = math.floor( (knob1*widthmod) + 0.5 ) + 1
    
    -- the mouth --
    
    
    of.pushMatrix()

        drawTheMouth()
        drawTheEyes()
    
    of.popMatrix()

end
-- Draw the mouth
function drawTheMouth()  --function to draw the mouth
    for i = 1, 100 do -- draw the triangles
        xscale = (xhalf / 99) * i
        xoffsetMath = ( (xhalf + xscale) * ((knob2 * i)/100) ) + (x720 - (knob2*xhalf) ) 
        xoffset = xoffsetMath 
        yoffset = y600 - (inL[2] * y640)
        auDio =  math.floor( inL[i+1] * (knob1 * (Height/100)) )
        of.setColor( fg )
        
        if(i == 0) then
            last_point = { x720 - (knob2*xhalf), yoffset + auDio }
        end
        of.setLineWidth( linewidth )
        of.drawLine(last_point[1], last_point[2], xoffset + -auDio, yoffset + auDio)
        last_point = {xoffset + -auDio, yoffset + auDio}
    end
end
-- Draw the Eyes
function drawTheEyes()
    audio1 = (inL[1] * (Height/100) ) + 1 
    audio2 = (inL[50] * (Height/100) ) + 1 
    radrat = relX(125)
    radMath = (knob1 * radrat) + 20
    rad = math.floor(radMath + 0.5)
    xpos1 = (2 * radrat) + audio1
    ypos1 = y3d - audio1
    xpos2 = x1116 - audio2
    ypos2 = y3d - audio2
    xrad = (rad/2) * math.sin( inL[1] * (Height/1000) ) 
    yrad = (rad/2) * math.cos( inL[99] * (Height/1000) )
    
    step1mod = relX(30)
    step2mod = relX(40)
    speed = knob3 / 3
    lfo1.step = speed * step1mod
    lfo2.step = speed * step2mod
    roll1 = math.floor( lfo1.update() )
    roll2 = -math.floor( lfo1.update() )
    slide1 = math.floor( lfo2.update() )
    slide2 = -math.floor( lfo2.update() )
    
    of.setColor( fg )
    of.drawCircle( xpos1+slide1, ypos1+roll1, 0, rad)
    of.drawCircle( xpos2+slide2, ypos2+roll2, 0, rad)
    
    of.setColor( 245, 255, 234 )
    of.drawCircle( (xpos1+(xrad/2)) + slide1, (ypos1-math.floor(yrad/2) ) + roll1, 0, rad/2)
    of.drawCircle( (xpos2+(xrad/2)) + slide2, (ypos2-math.floor(yrad/2) ) + roll2, 0, rad/2)
end

-- EXIT  -------------------------------------------------- 

function exit()
    print("script finished")
end