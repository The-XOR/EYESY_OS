require("eyesy")
modeTitle = "Spiral Tube?"
print(modeTitle)
------------------------- see if we can warp a cylinder into a spiral --

w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
h4 = h / 4
hT2 = h * 2
wT4 = w * 4                 -- width times 4
wT2 = w * 2                 -- width times 2
c = glm.vec3( w2, h2, 0 )   -- center in glm vector
h8 = h / 8                  -- 8th of the height
h8t3 = h8 * 3               -- h8 * 3 (3/4ths)

myMesh = of.Mesh()          -- define Mesh
myCam = of.Camera()         -- define camera class
myLight = of.Light()        -- define light class
myPoly = of.Polyline()      -- define polyline class
myCyl = of.CylinderPrimitive()  -- define a cylinder class


--------------------------------------------------- 
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
----------------------------------------------------
function setup()
    myCam:setPosition( c )  -- set the first position, changes later
    myCam:lookAt( c )       -- the camera looks at the center
    of.enableLighting()     -- enable lighting in the scene
	of.enableDepthTest()    -- enable depth
	myLight:setup()         -- start the light
	myLight:setPointLight( )-- we use a point light here
	myLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	myMesh:setMode( of.PRIMITIVE_LINE_LOOP )    -- set mesh mode
    
    ----------------------- draw the cylinder
    spiralRadius = 200
    myCyl:setPosition( c )              -- cet position as center
    myCyl:set( 100, hT2, true )           -- radius, height, capped = true
    myCyl:setResolution( 8, 50, 2 )    -- set resolution, 8 vertices radius, and 100 of those
    
    myMesh = myCyl:getMesh()            -- pass to the mesh       
    
    meshSize = myMesh:getVertices():size()  -- fill a table with all the vertices
    myPoints = myCyl:getResolutionHeight() * myCyl:getResolutionRadius()
    totalCapPoints = meshSize - myPoints
    print( totalCapPoints, meshSize )
    print("done setup")     -- so we know that the setup was succesful
end

-----------------------------------------------------
function drawSpiral( radius, length, xPos, yPos, relSize )
    yLength = length / 100          -- divide the length into 100 parts                  
    largerRad = radius * relSize    -- get the max distance

    for i = 1, 100 do               -- 100 for loop
        audio =  inL[ i ]           -- get the audio
        loop10 = i % 10             -- loop 10 times
        iter = loop10 / 10          -- divide by 10
        scale = largerRad * audio   -- scale the distance with audio
        scaleRad = scale + radius   -- add the minimum radius
        
        xCos = math.cos( iter * 6.28 ) * scaleRad
        yDown = i * yLength
        zSin = math.sin( iter * 6.28 ) * scaleRad
        
        x = xPos + xCos             -- the points plus x position
        y = yPos + yDown            -- the points with the Y
        z = zSin                    -- wrap around the z, 0
        
        myPoly:curveTo( x, y, z )   -- draw the lines with curve
    end
    ------ get the height and re-center
    boundBox = myPoly:getBoundingBox()
    hi = boundBox:getHeight()
    hi2 = hi / 2
    
    --of.pushMatrix()
    of.translate( 0, -hi2 )
    myPoly:draw()
    myPoly:clear()

end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )       -- color for drawings
    of.setBackgroundColor( bg )     -- set the bg color 
    
    ------------------------------ redraw the cylinder
    spiralRadius = knob2 * w2 + 1
    myCyl:setPosition( c )              -- cet position as center
    myCyl:set( spiralRadius/2, hT2, true )           -- radius, height, capped = true
    myCyl:setResolution( 8, 50, 2 )    -- set resolution, 8 vertices radius, and 10 of those
    
    
    myMesh = myCyl:getMesh()            -- pass to the mesh
    ------------------------------------
    
    
    
    capPoints = math.floor( totalCapPoints / 2 )
   
    for i = 0, myCyl:getResolutionHeight() - 1 do
        hCount = (i * 8) + capPoints
        
        spiral = i / 10
        xCos = math.cos( spiral * 6.28 ) * spiralRadius
        zSin = math.sin( spiral * 6.28 ) * spiralRadius
        
        for j = 0, myCyl:getResolutionRadius() - 1 do
            audio = inL[ (i%100) + 1 ] * h
            iterRaw = (hCount + j) + 1            
            iter = math.min( iterRaw, meshSize )
            myVertex = myMesh:getVertex( iter )
            myVertex.x = (myVertex.x + xCos) + audio
            myVertex.z = myVertex.z + zSin
            myMesh:setVertex( iter, myVertex )
        end    
    end
    
    
  
    ------------------------- set Camera and Light Position
    myCam:setPosition( w2, h2, knob1*2400 )            -- set camera position, change z
    myLight:setPosition( wT4, h , w )           -- set light position, change x
    
    --------------------- 
    
    
    
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
            
            of.translate( w2, h2 )
            of.rotateDeg( knob3*360, w2, h2, 0)
            
            
            of.setColor( fg ) 
            myMesh:draw()
            
           
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end