require("eyesy")
modeTitle = "Magic-Carpet-IMG"
-- in this mode we'll put images on the "magic carpet", but also use the OF library to 
-- figure out the paths to images

print(modeTitle)
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
wT4 = w * 4                 -- width times 4
wT2 = w * 2                 -- width times 2

c = glm.vec3( w2, h2, 0 )   -- center in glm vector
h8 = h / 8                  -- 8th of the height
count = 0                   -- define count variable globally
myMesh = of.Mesh()          -- define Mesh
myCam = of.Camera()         -- define camera class
myImg = of.Image()          -- define Image class 
myLight = of.Light()        -- define light class
myPlane = of.PlanePrimitive() -- define a plane primitive
myDirect = of.Directory()
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

------------------------------------ fill a table of image paths, looks for Images folder
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

--------------------------------------------------- 
    -- local functions
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


----------------------------------------------------
function setup()
    
    
    myCam:setPosition( c )  -- set the first position, changes later
    myCam:lookAt( c )       -- the camera looks at the center
    of.enableLighting()     -- enable lighting in the scene
	of.enableDepthTest()    -- enable depth
	myLight:setup()         -- start the light
	myLight:setPointLight( )-- we use a point light here
	myLight:setAmbientColor( of.FloatColor( .8, .8, .8 ) )
	myMesh:setMode(of.PRIMITIVE_LINE_LOOP)    -- set mesh mode
	


    
    -- draw the plane
    
    myPlane:setPosition( c )
    myPlane:set( w2, w2, 10, 10 )
   
    -- pass the plane to a mesh
    myMesh = myPlane:getMesh()
    -- fill a table with all the vertices
    meshSize = myMesh:getVertices():size()
    
    print("done setup")     -- so we know that the setup was succesful
    
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    -- drive the rotation with knob3
    if( count >= 1 ) then
        count = 0
        count = count + (math.pow(knob3,2) * 0.01)
    else
        count = count + (math.pow(knob3,2) * 0.01)
    end
    
    ---------------------- redraw the plane at the begining of each loop
    myPlane:setPosition( c )
    myPlane:set( w2, w2, 10, 10 )
   -- pass the plane to a mesh
    myMesh = myPlane:getMesh()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )
    colorPickHsb( knob5, bg )                      -- color for drawings
    of.setBackgroundColor( bg )    -- set the bg color 
    ------------------------ Image Table
    image_index = math.floor( knob2 * (imgDir:size()-1) ) + 1 
    myImg:load( imgTable[ image_index ] )       -- load the image
    
    myCam:setPosition( w2, h2, (knob1*wT2)+h8 ) -- set camera position, change z
    myLight:setPosition( wT4, h , w )  -- set light position, change x
    
    
    --------------------- animate the plane point by point
    for i=0, meshSize-1 do
        aud = inL[ (i%100) + 1 ] * h2
        
        myVertex = myMesh:getVertex( i )
        
        myVertex.z = myVertex.z + aud
        myMesh:setVertex(i, myVertex)
    end
    
        
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
            of.pushMatrix()                         -- save the matrix
            of.translate( w2, h2)                   -- center to draw the plane
            of.rotateRad( count*6.28, w2, h2, 0 )   -- rotate eveything after this
            of.setColor( fg )                       -- set color after this
            
            myImg:bind()                            -- apply the texture
           
            myMesh:draw()                           -- draw the plane
            
            myImg:unbind()                          -- unbind the texture
            of.popMatrix()                          -- pop the pushed matrix
            
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end