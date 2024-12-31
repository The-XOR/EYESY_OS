modeTitle = "T - Migrating Circle Grids"
print(modeTitle)
require('eyesy')
-- Global Params and various setups ------

xr = of.getWidth()   --global width  
yr = of.getHeight() --global height of screen
Width = xr
Height = yr
xhalf = Width / 2
yhalf = Height / 2
x1=0
y1=0
x2=0
y2=0
x3=0
y3=0
x4=0
y4=0

x_nudge=0
y_nudge=0
x1_nudge=0
y1_nudge=0
x2_nudge=0
y2_nudge=0
x3_nudge=0
y3_nudge=0
x4_nudge=0
y4_nudge=0

x5 = xr / 5
y3 = yr / 3
x10 = xr / 10
y6 = yr / 6

rad50 = ((50*xr)/1280)
speed60 = ((60*xr)/1280)

bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class



-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
end
-- Trigger Function, Average amp of audio buffer --
function avG()  
    a = 0
    for i = 1, 100 do
        a = a + inL[i]
    end
    x = a / 100
    if( x <= 0.001 ) then
        x = 0
    else
        x = x
    end
    return  x
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

function circleGrid( nX, nY )
    nudgeX = nX or 0
    nudgeY = nY or 0
    for i = 0, 3 do
        for j = 0, 5 do
            x = ( j * x5 ) + x10 + math.floor( nudgeX )
            y = ( i * y3 ) + y6 + math.floor( nudgeY )
            if( (i%2) == 1 ) then
                x = j*x5 + x10 + math.floor( nudgeX )
            end
            if( (j%2) == 1 ) then
                y = i*y3 + y6 + math.floor( nudgeY )
            end
            of.drawCircle( x, y, restRad )
        end
    end
end
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
    
    aud = avG()
    restRad = math.floor( rad50 * knob3 ) + 2
    of.setColor( fg )
    -- set different speeds for 4 layers
    x1_nudge = 1 * x1_nudge
    y1_nudge = 1 * y1_nudge
    x2_nudge = 1.25 * x1_nudge
    y2_nudge = 1.25 * y1_nudge
    x3_nudge = 1.5 * x1_nudge
    y3_nudge = 1.5 * y1_nudge
    x4_nudge = 1.75 * x1_nudge
    y4_nudge = 1.75 * y1_nudge
    x_speed = knob1 * speed60 --- (speed60/2) -- horizontal speed on knob1
    y_speed = knob2 * speed60 --- (speed60/2) -- vertical speed on knob2
    
    -- move circles on audio trigger
    -- the trigger --
    if( avG() > 0.09 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        x1_nudge =  x1_nudge + x_speed 
        y1_nudge =  y1_nudge + y_speed 
        x2_nudge =  x2_nudge + x_speed 
        y2_nudge =  y2_nudge + y_speed 
        x3_nudge =  x3_nudge + x_speed 
        y3_nudge =  y3_nudge + y_speed
        x4_nudge =  x4_nudge + x_speed 
        y4_nudge =  y4_nudge + y_speed 
    end
    
    
    if( x1_nudge > xhalf ) then x1_nudge = -xhalf end
    if( x2_nudge > xhalf ) then x2_nudge = -xhalf end
    if( x3_nudge > xhalf ) then x3_nudge = -xhalf end
    if( x4_nudge > xhalf ) then x4_nudge = -xhalf end
    
    if( x1_nudge < -xhalf ) then x1_nudge = xhalf end
    if( x2_nudge < -xhalf ) then x2_nudge = xhalf end
    if( x3_nudge < -xhalf ) then x3_nudge = xhalf end
    if( x4_nudge < -xhalf ) then x4_nudge = xhalf end
    
    if( y1_nudge > yhalf ) then y1_nudge = -yhalf end
    if( y2_nudge > yhalf ) then y2_nudge = -yhalf end
    if( y3_nudge > yhalf ) then y3_nudge = -yhalf end
    if( y4_nudge > yhalf ) then y4_nudge = -yhalf end
    
    if( y1_nudge < -yhalf ) then y1_nudge = yhalf end
    if( y2_nudge < -yhalf ) then y2_nudge = yhalf end
    if( y3_nudge < -yhalf ) then y3_nudge = yhalf end
    if( y4_nudge < -yhalf ) then y4_nudge = yhalf end 
    
    of.pushMatrix()
        circleGrid( x1_nudge, y1_nudge )
        circleGrid( x2_nudge, y2_nudge )
        circleGrid( x3_nudge, y3_nudge )
        circleGrid( x4_nudge, y4_nudge )
    of.popMatrix()
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end