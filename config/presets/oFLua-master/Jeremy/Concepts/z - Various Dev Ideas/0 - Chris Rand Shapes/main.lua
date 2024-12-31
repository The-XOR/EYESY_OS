---- Chris Rand Shapes
require("eyesy")                    -- include the eyesy library
modeTitle = "Chris Rand Shapes"     -- name the mode
print(modeTitle)                    -- print the mode title

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2                  -- width half 
h2 = h / 2                  -- height half
w4 = w / 4                  -- width quarter
h4 = h / 4                  -- height quarter
w6 = w / 6                  -- width 6th
h6 = h / 6                  -- height 6th
w8 = w / 8                  -- width 8th
h8 = h / 8                  -- height 8th
h16 = h / 16                -- 16th height
c = glm.vec3( w2, h2, 0 )   -- center in glm vector
itsPeaked = 0
timerSwitch = 0
restTimer = 0
trigger = 0
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    of.enableBlendMode( of.BLENDMODE_ALPHA )    -- turn blend mode for transparency blending
    
    --------------------- define light
    myLight = of.Light()                        -- define a light class
    myLight:setPointLight( )                    -- we'll use a point light for this example
	myLight:setAmbientColor( 
	    of.FloatColor( 1, 1, 1 ) )              -- and make the ambient color white
    myLight:setPosition( c + glm.vec3(0,0,h2) ) -- and set the position in the center with z closer
    
    --------------------- define color classes
    bg = of.Color()                             -- define background color class
    fg = of.Color()                             -- define foreground color class
    
    ---------------- fill a table of image paths, looks for Images folder
    myDirect = of.Directory()                       -- define the Directory Class
    
    thePath = myDirect:getAbsolutePath()            -- get current path
    theImgDirectory =  thePath .. "/Images"         -- look in 'Images'
    imgDir = of.Directory( theImgDirectory )        -- define new Directory class
    imgDir:allowExt( "png" )                        -- load only .png files
    imgDir:allowExt( "jpg" )                        -- and load only .jpg files
    imgDir:listDir()                                -- list the directory
    imgTable = {}                                   -- define the table

    for i = 0, imgDir:size()-1 do                   -- for the size of new directory do
        imagePath = imgDir:getPath( i )             -- load paths into a table
        print( "loaded image:", imagePath )         -- print so we can see what is loaded
        imgTable[ i + 1 ] = imagePath               -- fill the table
    end
    ---------------------------------- tables to track parameters and the images
    trackTab = {}
    myImg1 = of.Image()          					-- define Image class 
    myImg2 = of.Image()          					-- define Image class 
    myImg3 = of.Image()          					-- define Image class 
    myImg4 = of.Image()          					-- define Image class 
    myImg1:load( imgTable[ 1 ] )                    -- load image
    myImg2:load( imgTable[ 2 ] )                    -- load image
    myImg3:load( imgTable[ 3 ] )                    -- load image
    myImg4:load( imgTable[ 4 ] )                    -- load image

    imgRef = { myImg1, myImg2, myImg3, myImg4 }
    
    ---------------------------------- define a Plane class
    myPlane = of.PlanePrimitive()
    
    ---------------------------------- global variables
    imgAmt = 0
    imgIndex = 0
    
    spaceX = w / 4
    spaceY = h / 4
    
    
    
    -- so we know that the setup was succesful
    print("done setup") 
end

---------------------------------------------------------------------------
-- update function runs on loop
function update()
   
end

-----------------------------------------------------------------------------------------------------
-- the main draw function also runs on loop
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
    
    ----------------------- enable global modes
    of.enableLighting()                         -- enable lighting globally
    myLight:enable()                            -- begin rendering for myLight
    if( knob1 > 0.9 ) then
        imgAmt = 0
        imgIndex = 0
    end
    
    ---------------------- audio trigger with recovery and delay
    if( itsPeaked == 0 ) then
        if( avG() > 0.2 ) then 
            itsPeaked = 1
            of.resetElapsedTimeCounter()
            trigger = 1
            timerSwitch = 1
        end
    else
        if( timerSwitch == 1 ) then
            restTimer = of.getElapsedTimeMillis()
        end
        
        if( restTimer > 250 or avG() < 0.1 ) then
            itsPeaked = 0
            restTimer = 0
            timerSwitch = 0
        end
    end
    
    --------------------- then apply the trigger
    if( trigger == 1 ) then
        if( imgAmt > 25 ) then                     -- loop the imgAmt
            imgAmt = 25                            -- keep at max until manual reset
            
        else
            imgAmt = imgAmt + 1                             -- increase the imgAmt by 1
        end
        
        if( imgIndex > 25 ) then
            imgIndex = 0
        else
            imgIndex = imgIndex + 1
        end
        
        xPos = spaceX * ((imgIndex-1)%5)                 -- get the grid placement X
        yPos = spaceY * ( math.floor((imgIndex-1)/5) )   -- get the grid placement Y
        fillTab( imgIndex, xPos, yPos )               -- fill the tab
        
        trigger = 0                                 -- wait for next trigger
    
    end
    
    ------------------------------------ for loop to draw all the images from the table    
    if( imgAmt > 0 ) then                       -- if imgAmt is more than 0 ...
        for i = 1, imgAmt do                    -- draw the imgAmt
            pics2(  trackTab[i][1], 
                    trackTab[i][2],         
                    trackTab[i][3], 
                    trackTab[i][4],
                    trackTab[i][5]
            )
        end
    end
    
    
    ------------------------ disable lighting and depth
    myLight:disable()                           -- end rendering for myLight
    of.disableLighting()                        -- disable lighting globally
   
    of.popMatrix()                              -- recall last matrix
end
---------------------------------------------------------------------------------------------------

------------------------------------ function to fill trackTab
function fillTab( number, x, y )
    local tab = {}
    
    tab[1] = glm.vec3( x, y, 0 )
    tab[2] = math.random( 0, 8 ) * 45
    tab[3] = math.random( 0, 255 )
    tab[4] = imgRef[ math.random( 1, 4 ) ]
    tab[5] = (math.random( 6, 12 ) / 12) * w4
    
    trackTab[ number ] = tab                    -- fill the tab at specified slot
    
end
    
------------------------------------ function to print pics
function pics2( vec3, rot, color, imgClass, size )
    of.popMatrix()                              -- recall saved matrix
    of.pushMatrix()                             -- save again
    of.translate( vec3 )                        -- move to position  
   
    of.rotateDeg( rot, 0,0,1 )                  -- rotate image on z axis
    colChange = of.Color()
    
    colMod = ( fg:getHue() + color ) % 255
    colChange:setHsb( colMod, fg:getSaturation(), fg:getBrightness() )
    of.setColor( colChange )                        -- set the color
    
    imgClass:draw( -size/2, -size/2, size, size ) -- draw the image
end

------------------------------------ function to print pics
function picS( vec3, rot, color, imgClass, size )
    of.popMatrix()                              -- recall saved matrix
    of.pushMatrix()                             -- save again
    of.translate( vec3 )                        -- move to position
    --of.rotateDeg( rot, 0,0,1 )                  -- rotate image on z axis
    sizeW = imgClass:getWidth()                 -- get original width
    sizeH = imgClass:getHeight()                -- get og height
    rSizeX = sizeW * size                       -- resize width with 'size'
    rSizeY = sizeH * size                       -- resize height    


    imgW = imgClass:getWidth()                  -- get the width
    imgH = imgClass:getHeight()                 -- get the height
    imgClass:setAnchorPoint( imgW/2, imgH/2 )   -- move anchor point to center of image
    
    
    of.setColor( color )                        -- set the color
    imgClass:draw( 0, 0, rSizeX, rSizeY )       -- draw the image
end

------------------------------------ function for audio average
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

------------------------------------ Color Function
function colorPickHsb( knob, name )
    -- middle of the knob will be bright RBG, far right white, far left black
    
    k6 = (knob * 5) + 1                     -- split knob into 8ths
    hue = (k6 * 255) % 255 
    kLow = math.min( knob, 0.49 ) * 2       -- the lower half of knob is 0 - 1
    kLowPow = math.pow( kLow, 2 )
    kH = math.max( knob, 0.5 ) - 0.5    
    kHigh = 1 - (kH*2)                      -- the upper half is 1 - 0
    kHighPow = math.pow( kHigh, 0.5 )
    
    bright = kLow * 255                     -- brightness is 0 - 1
    sat = kHighPow * 255                    -- saturation is 1 - 0
    
    name:setHsb( hue, sat, bright )         -- set the ofColor, defined above
end

------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end