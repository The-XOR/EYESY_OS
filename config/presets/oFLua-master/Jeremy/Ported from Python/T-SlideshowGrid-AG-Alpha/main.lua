modeTitle = "T - Slideshow Grid - AG - Alpha"

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

--------------------------------------------------------- feedback
w = of.getWidth()
h = of.getHeight()
myTex = of.Texture()                        -- define texture class
myPix = of.Pixels()                         -- define pixels class
myPix:allocate( w, h, of.PIXELS_RGBA )      -- allocate pixels first    
myTex:allocate( myPix )                     -- then allocate those pix to the texture

-------------------------------------------------- global params --
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2
heightHalf = Height / 2
w4 = Width / 4
h4 = Height / 4
w2 = Width / 2
h2 = Height / 2


images_index = 1

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    -------------------------- draw feedback
    of.setColor(255, 255,255, 250)          -- slight transparency
    myTex:draw( 0, 0, w, h )                -- draw the texture captured

   
    aud = avG()
    -- the trigger --
    if( aud >= 0.1 ) then
        if( images_index > imgDir:size()-1 ) then
            images_index = 1
        else
            images_index = images_index + 1
        end
    end
    
    
    myImg:load( imgTable[ images_index ] )
    myImg:setAnchorPoint( myImg:getWidth()/2, myImg:getHeight()/2 ) 
    
    
    of.setColor( 255 )
    myImg:draw( w2, h2)
    
    
    -------------------- capture the feedback
    myTex:loadScreenData( 0, 0, w, h )          -- capture entire screen   
    
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end