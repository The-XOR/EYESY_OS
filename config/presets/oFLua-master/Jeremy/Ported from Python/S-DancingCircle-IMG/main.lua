modeTitle = "S - Dancing Circle - IMG"
print(modeTitle)
require('eyesy')


-- SETUP --------------------------------

function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    of.enableAntiAliasing() 
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
-- PARAMETERS --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width
hiHlf = Height / 2
wiHlf = Width / 2
x300 = relX(300)
x30 = relX(30)
i = 1

-- DRAW LOOP ------------------
function draw()
        ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 
    of.setColor( fg )               -- set the fgt color
    
    of.setLineWidth( (knob3 * 10) + 1 )
    
    resize1 = ( (Width/12) * knob1 ) + 10
    if(resize1 ~= resize) then
        myImg:load( imgTable[1] )
    end
    resize = resize1
    
    k21 = knob2 * Height 
    y1 = k21 + (inL[i] * hiHlf)
    
    R = (knob2 * x300) - (x300/2)
    R = R + (inL[i] * hiHlf)
    x = ( R * math.cos( (i / 100) * 6.28) ) + wiHlf 
    y = ( R * math.sin( (i / 100) * 6.28) ) + hiHlf 
    
    if( knob3 <= 0.5 ) then
        circle_size = knob3 * x300
        line_width = 0
    else
        circle_size = math.abs( x300 - (knob3 * x300) )
        line_width =  math.abs( x30 - (knob3 * x30) )
    end

    of.pushMatrix()
        of.drawCircle( x, y, circle_size)
        of.setColor(255)
        myImg:resize( resize, resize)
        myImg:draw(x - (myImg:getWidth() / 2), y - (myImg:getHeight() / 2) )
        
    of.popMatrix()
    if(i >= 100) then
        i = 1
    end
    i = i + 1
    
end

-- EXIT  --------------------------------------------------

function exit()
    of.disableAntiAliasing() 
    print("script finished")
end