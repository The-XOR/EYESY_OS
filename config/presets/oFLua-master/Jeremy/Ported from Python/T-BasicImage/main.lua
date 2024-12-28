modeTitle = "T - Basic Image"
print(modeTitle)
require('eyesy')


-- Trigger Function, Average amp of audio buffer --
function avG()  
    a = 0
    for i = 1, 100 do
        amp = math.abs( inL[i] )
        a = a + amp
    end
    x = a / 100
    if( x <= 0.001 ) then
        x = 0
    else
        x = x
    end
    return  x
end  
-- global params --
h = of.getHeight() --global height of screen
w = of.getWidth()   --global width  
h2 = h / 2
w2 = w / 2
h8 = h / 8
wT2 = w * 2
hT2 = h * 2
xr = h / 4
yr = h / 3
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
imgCount = 3
randX = w2
randY = h2
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



-- feedback fbo buffer --

--myPix = of.Pixels()
--myTex = of.Texture()

--myPix:allocate( h8, h8, of.PIXELS_RGBA )    -- allocate pixels first    
--myTex:allocate( myPix )                     -- then allocate those pix to the texture



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

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    myImg:load( imgTable[ 1 ] )
end

-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
function draw()
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for pics
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    
    aud = avG()
    
    

   
    if( avG() > 0.1 ) then
        if( imgCount >= imgDir:size() ) then
            imgCount = 1
        else
            imgCount = imgCount + 1    
        end
    myImg:load( imgTable[ imgCount ] )
    randX = math.random( 0, w )
    randY = math.random( 0, h )
    end
   
    --myTex:loadScreenData( randX, randY, h8, h8 )            
    ximg = myImg:getWidth()
    yimg = myImg:getHeight()
    
    
    
    x2 = ximg * 2
    y2 = yimg * 2
    
    sizeX = ( knob2 * x2 ) + 5
    sizeY = ( knob2 * y2 ) + 5
    
    xCenter = sizeX / 2
    yCenter = sizeY / 2
    
    
    of.pushMatrix()
    
    of.translate( randX, randY )
    of.translate( -xCenter, -yCenter )
    of.rotateRad( knob1*6.24, w2, h2, h2 )
    of.setColor( fg, (knob3*245) + 10 )
    
    myImg:draw( 0, 0, sizeX, sizeY )
    of.popMatrix()
    
end

-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end