-- S - Gradient Cloud  ------

-- Global Params and various setups ------

print("S - Gradient Cloud")
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width




-- SETUP --------------------------------

function setup()
    of.setWindowTitle("Gradient Cloud")
    print("script setup")
    of.setFrameRate(60)

end

-- UPDATE --------------------------------------------------

function update()
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
-- Conversion Functions--
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

-- Define new time ----------
xr = Width   --old python shorthand for WIdth and Height
yr = Height  -- "  "

x240 = relX(240)
xhalf = Width/2
yhalf = Height/2
y480 = relY(480)
num = yhalf
xpos = 0

-- DRAW LOOP ------------------

function draw()
    time = of.getElapsedTimeMillis() * 0.0001

    
   ----------------------- Color stuff
   
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    xpos1 = ((knob1*4) * x240 ) - (2*x240)
    sel = math.floor( (knob4 * 4) + 0.5 ) + 1
    


    
    
    of.pushMatrix()

        fluffyLittleClouds(sel, num)
    
    of.popMatrix()
end

function fluffyLittleClouds(y,z)  --function to draw the cloud, with an if argument(x)
    x = y    --selector
    cool = z --number
    
    if(x == 1) then        --- GRAYSCALE
        for i = 1, cool do 
            auDio = math.floor( inL[(i%100)+1] * (Height / 30) )
            xpos = x240 + (xhalf*math.sin(.5 + time )*knob3)
			ypos = (knob2*y480) + inL[(i%100)+1]/100 + (30* math.cos(1 * 1 + time) )
		    of.setColor( 128 + 127 * math.sin(i * .002 + time ) ) -- one argument in of.setColor makes it gray scale
			radius = ( (20 * math.sin(i*knob3 * 3 + time  ))*Height)/Height
			xpos = Width / 2 + xpos * math.sin(i * 1 + time ) 
			of.drawCircle(xpos+xpos1, (i+ypos) + auDio, 0, radius + auDio )
        end
        
    elseif(x == 2) then     --- RED
        for i = 1, cool do 
            auDio = math.floor( inL[(i%100)+1] * (Height / 30) )
            xpos = x240 + (xhalf*math.sin(.5 + time )*knob3)
			ypos = (knob2*y480) + inL[(i%100)+1]/100 + (30* math.cos(1 * 1 + time) )
			of.setColor(128 + 127 * math.sin(i * .02 + time ), 0, 0)
			radius = ( (20 * math.sin(i*knob3 * 3 + time  ))*Height)/Height
			xpos = Width / 2 + xpos * math.sin(i * 1 + time ) 
			of.drawCircle(xpos+xpos1, (i+ypos) + auDio, 0, radius + auDio )   -- draw a 2D circle
        end 
    elseif(x == 3) then    ---  GREEN
        for i = 1, cool do 
            auDio = math.floor( inL[(i%100)+1] * (Height / 30) )
            xpos = x240 + (xhalf*math.sin(.5 + time )*knob3)
			ypos = (knob2*y480) + inL[(i%100)+1]/100 + (30* math.cos(1 * 1 + time) )
			of.setColor(0, (127 + 127 * math.sin(i * .012 + time )), 0)
			radius = ( (20 * math.sin(i*knob3 * 3 + time  ))*Height)/Height
			xpos = Width / 2 + xpos * math.sin(i * 1 + time ) 
		    of.drawCircle(xpos+xpos1, (i+ypos) + auDio, 0, radius + auDio )   -- draw a 2D circle
        end
    elseif(x == 4) then     --- BLUE
        for i = 1, cool do 
            auDio = math.floor( inL[(i%100)+1] * (Height / 30) )
            xpos = x240 + (xhalf*math.sin(.5 + time )*knob3)
			ypos = (knob2*y480) + inL[(i%100)+1]/100 + (30* math.cos(1 * 1 + time) )
			of.setColor(0, 0, (127 + 127 * math.sin(i * .012 + time ) ) )
			radius = ( (20 * math.sin(i*knob3 * 3 + time  ))*Height)/Height
			xpos = Width / 2 + xpos * math.sin(i * 1 + time ) 
		    of.drawCircle(xpos+xpos1, (i+ypos) + auDio, 0, radius + auDio )    
        end
    elseif(x == 5) then     -- RAINBOW
        for i = 1, cool do 
            auDio = math.floor( inL[(i%100)+1] * (Height / 30) )
            xpos = x240 + (xhalf*math.sin(.5 + time )*knob3)
			ypos = (knob2*y480) + inL[(i%100)+1]/100 + (30* math.cos(1 * 1 + time) )
			of.setColor(
			        128 + 127 * math.sin(i * .02 + time)  ,
					127 + 127 * math.sin(i * 1 + time)    ,
					127 + 127 * math.sin(i * .012 + time) 
			    )
			radius = ( (20 * math.sin(i*knob3 * 3 + time  ))*Height)/Height
			xpos = Width / 2 + xpos * math.sin(i * 1 + time ) 
		    of.drawCircle(xpos+xpos1, (i+ypos) + auDio, 0, radius + auDio )
		end
    end
end
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end