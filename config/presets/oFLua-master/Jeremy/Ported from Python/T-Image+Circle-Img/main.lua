modeTitle = "T - Image + Circle - Img"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
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

-- amplitude average of audio buffer --
function avG()  
    a = 0
    for i = 1, 100 do
        aud = math.abs( inL[i])
        a = a + aud
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
widthHlf = Height / 2
heightHlf = Width / 2
x50 = relX(50)
x1080 = relX(1080)
x600 = relX(600)
image_index = 1
imageX = widthHlf
imageY = heightHlf
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    alpha = (knob3 * 251) + 4
    
    aud = avG()
    
    -- the trigger --
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        imageX = math.random( -x50, x1080 )
        imageY = math.random( -x50, x600 )
        image_index = image_index + 1
        if( image_index == 5 ) then 
            image_index = 1
        end
    end
    
     
    myImg:load( imgTable[ image_index ] )
    
    imageSizeX = ( knob1 * myImg:getWidth() ) + 5
    imageSizeY = ( knob1 * myImg:getHeight() ) + 5
    myImg:resize( imageSizeX, imageSizeY )
    
    circle_size = knob2 * ( imageSizeX * 1.5 )
    
    of.pushMatrix()
    of.setColor( fg, alpha )    -- set the fg color
    of.drawCircle( 
        imageX + (myImg:getWidth() / 2),
        imageY + (myImg:getHeight() / 2),
        circle_size
    )
    fg:setHue(255)
    of.setColor( fg, alpha/2+100 )
    myImg:draw(imageX, imageY)
    of.popMatrix()
    
    trigger = false
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end