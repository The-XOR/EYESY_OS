require("eyesy")
modeTitle = "Mesh Plane"
print(modeTitle)
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
c = glm.vec3( w2, h2, 0 )   -- center in glm vector
h8 = h / 8                  -- 8th of the height
count = 0                   -- define count variable globally
myMesh = of.Mesh()          -- define Mesh
myCam = of.Camera()         -- define camera class
myLine = of.Path()          -- define path class
myLight = of.Light()        -- define light class
myTex = of.Texture()       -- define a texture class
myPix = of.Pixels()         -- define pixels class
myFbo = of.Fbo()            -- define an fbo class
myPlane = of.PlanePrimitive() -- define a plane primitive
icoSphere = of.IcoSpherePrimitive()
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
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
    -- make an oscilloscope
function makeLine( class, amount, startX, startY, width, height ) 
    a = amount or 1
    wi = width or 1
    hi = height or 1
    sX = startX or 0
    sY = startY or 0
    steps = wi / a
    hi2 = hi/2
    
    
    for i = 1, a do
        aud = inL[ (i%100) + 1 ] * hi
        x = i * steps
        class:lineTo( sX + x, sY + aud , 0 )
    end
    
    class:draw()
    class:clear()
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

	myFbo:allocate( h8, h8)    -- allocate for FBO
    myPix:allocate( h8, h8, of.PIXELS_RGBA )  -- allocate pixels first    
    myTex:allocate( myPix )                     -- then allocate those pix to the texture
    -- draw the plane
    
    myPlane:setPosition(0,0,0)
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
    myPlane:setPosition(0,0,0)
    myPlane:set( w2, w2, 10, 10 )
   -- pass the plane to a mesh
    myMesh = myPlane:getMesh()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )
    colorPickHsb( knob5, bg )                      -- color for drawings
    of.setBackgroundColor( bg )    -- set the bg color  
    
    myCam:setPosition( w2, h2, knob1*2400 )         -- set camera position, change z
    myLight:setPosition( (knob2*8000)- 4000, h ,1000 )  -- set light position, change x
    
    myLine:setFilled( false )
    myLine:setStrokeWidth( 2 )
    ----------------- draw the oscillopscope to a render buffer        
    myFbo:beginFbo()              
                                 

        of.clear( 255,255,255,255)                    -- clear the buffer, white-opaque
        
        makeLine( myLine, 99, 0, h8/2 , h8, h8 )        -- make the path
        myTex:loadScreenData( 0, 0, h8, h8 )            -- capture the makeLine
        
    myFbo:endFbo()                                      -- end the fbo
    
    ----------------- manipulate the plane
    
    for i=0, meshSize-1 do
        aud = inL[ (i%100) + 1 ] * h2
        
        myVertex = myMesh:getVertex( i )
        
        
        myVertex.z = myVertex.z + aud
        myMesh:setVertex(i, myVertex)
    end
    
        
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
            of.pushMatrix()
            of.translate( w2, h2)
            of.rotateRad( count*6.28, w2, h2, 0 )   -- rotate eveything after this
            of.setColor( fg )                       -- set color after this
            
            myTex:bind()                            -- apply the texture
           
            myMesh:draw()                           -- draw the plane
            
            myTex:unbind()                          -- unbind the texture
            of.popMatrix()                          -- pop the oushed matrix
            
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end