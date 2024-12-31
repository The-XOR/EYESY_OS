modeTitle = "T - Marching Four - Img"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
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
------------------------------------ fill a table of image paths, looks for Images folder
myDirect = of.Directory()                       -- define the Directory Class
myImg = of.Image()          					-- define Image class 
thePath = myDirect:getAbsolutePath()            -- get current path
theImgDirectory =  thePath .. "/Images"         -- look in 'Images'
imgDir = of.Directory( theImgDirectory )        -- define new Directory class
imgDir:allowExt( "png" )                        -- load only .png files
imgDir:allowExt( "jpg" )                        -- and load only .jpg files
imgDir:listDir()                                -- list the directory
imgTable = {}                                   -- define the table
for i = 0, imgDir:size()-1 do                   -- for the size of new directory do
    imagePath = imgDir:getPath( i )             -- load paths into a table
    print( "loaded image :", imagePath )              -- print so we can see what is loaded
    imgTable[ i + 1 ] = imagePath               -- fill the table
end
-- global params --
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
xr = Width
yr = Height
xr3rd = Width / 3
yr3rd = Height / 3
xrhalf = Width / 2
yrhalf = Height / 2
speedscalex = relX(40)      --(40*xr)/1280
speedscaley = relY(40)      --(40*yr)/720
x1_nudge=0
y1_nudge=0
x2_nudge=0
y2_nudge=0
x3_nudge=0
y3_nudge=0
x4_nudge=0
y4_nudge=0
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
    
    x_speed = (2*speedscalex*knob1)-speedscalex -- set horizontal speed on knob1
    y_speed = (2*speedscaley*knob2)-speedscaley -- set vertical speed on knob2
    scale_x = math.floor( knob3 * (xr3rd-1) + 1) -- x scale image on knob3; maximum width = 1/3 screen width
    scale_y = math.floor( knob4 * (yr3rd-1) + 1)  -- x scale image on knob4; maximum height = 1/3 screen height
    
    x = xrhalf - ( scale_x / 2 ) -- define x,y for image placement
    y = yrhalf - ( scale_y / 2 )
    
    x1 = x + x1_nudge
    y1 = y + y1_nudge
    x2 = x + x2_nudge * 1.25
    y2 = y + y2_nudge * 1.25
    x3 = x + x3_nudge * 1.5
    y3 = y + y3_nudge * 1.5
    x4 = x + x4_nudge * 2
    y4 = y + y4_nudge * 2
    
    -- the trigger --
    if( avG() >= 0.08 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        x1_nudge = ( x1_nudge + x_speed )
        y1_nudge = ( y1_nudge + y_speed )
        x2_nudge = ( x2_nudge + x_speed )
        y2_nudge = ( y2_nudge + y_speed )
        x3_nudge = ( x3_nudge + x_speed )
        y3_nudge = ( y3_nudge + y_speed )
        x4_nudge = ( x4_nudge + x_speed )
        y4_nudge = ( y4_nudge + y_speed ) 
    end
    trigger = false
    -- bring images back onto the screen once they march off:
    
    -- image 1 --
    of.pushMatrix()
        myImg:load( imgTable[1] ) 
        myImg:resize( scale_x, scale_y )
        if( x1 > xr ) then x1_nudge = -scale_x - x end
        if( x1 < -scale_x ) then x1_nudge = xr-x end
        if( y1 > yr ) then y1_nudge = -scale_y-y end
        if( y1 < -scale_y ) then y1_nudge = yr-y end
        myImg:draw( x1, y1 )
    of.popMatrix()
    
    -- image 2 --
    of.pushMatrix()
        myImg:load( imgTable[2] ) 
        myImg:resize( scale_x, scale_y )
        if( x2 > xr ) then x2_nudge = (-scale_x-x)/1.25 end
        if( x2 < -scale_x ) then x2_nudge = (xr-x)/1.25 end
        if( y2 > yr ) then y2_nudge = (-scale_y-y)/1.25 end
        if( y2 < -scale_y ) then y2_nudge = (yr-y)/1.25 end
        myImg:draw( x2, y2 )
    of.popMatrix()
    
    -- image 3 --
    of.pushMatrix()
        myImg:load( imgTable[3] ) 
        myImg:resize( scale_x, scale_y )
        if( x3 > xr ) then x3_nudge = (-scale_x-x)/1.5 end
        if( x3 < -scale_x ) then x3_nudge = (xr-x)/1.5 end
        if( y3 > yr ) then y3_nudge = (-scale_y-y)/1.5 end
        if( y3 < -scale_y ) then y3_nudge = (yr-y)/1.5 end
        myImg:draw( x3, y3 )
    of.popMatrix()
    
    -- image 4 --
    of.pushMatrix()
        myImg:load( imgTable[4] ) 
        myImg:resize( scale_x, scale_y )
        if( x4 > xr ) then x4_nudge = (-scale_x-x)/2+1 end
        if( x4 < -scale_x ) then x4_nudge = (xr-x)/2 end
        if( y4 > yr ) then y4_nudge = (-scale_y-y)/2 end
        if( y4 < -scale_y ) then y4_nudge = (yr-y)/2 end
        myImg:draw( x4, y4 )
    of.popMatrix()

end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end