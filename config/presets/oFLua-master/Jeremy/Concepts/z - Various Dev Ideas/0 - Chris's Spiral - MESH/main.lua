require("eyesy")
modeTitle = "Chris's Spiral - MESH"
print(modeTitle)
------------------------- based on the Sound Jaws mode for etc. also trying a smoother

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


count = 0
----------- color knobs ---------------------------------------- 
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
	
	myMesh:setMode( of.PRIMITIVE_TRIANGLES )    -- set mesh mode
    
    
    print("done setup")     -- so we know that the setup was succesful
end

-----------------------------------------------------
function drawSpiral( radius, length, xPos, yPos, relSize, rotate, ribbon )
    yLength = length / 100          -- divide the length into 100 parts                  
    largerRad = radius * relSize    -- get the max distance
     
    
    for i = 1, 2 do
        rWidth = ribbon * (i-1)
        for i = 1, 500 do               -- 100 for loop
            audio =  inL[ (i%100)+1 ]  * (rWidth*2)         -- get the audio
            loop10 = i % 50             -- loop 10 times
            iter = loop10 / 50          -- divide by 10
            scale = largerRad--* audio   -- scale the distance with audio
            scaleRad = scale + radius   -- add the minimum radius
            
            xCos = math.cos( iter * 6.28 ) * scaleRad
            yDown = i * yLength
            zSin = math.sin( iter * 6.28 ) * scaleRad
            
            x = xPos + xCos             -- the points plus x position
            y = (yPos + yDown) + rWidth -- the points with the Y
            z = zSin                    -- wrap around the z, 0
            
            myMesh:addVertex( glm.vec3( x,y+audio,z) )
        
        end
    end
    
    ------- tell the mesh how to connect the vertices
    for i = 0, 498 do
        myMesh:addIndex( i )
        myMesh:addIndex( i + 500 )
        myMesh:addIndex( i + 1 )
        
        myMesh:addIndex( i + 500 )
        myMesh:addIndex( i + 1 )
        myMesh:addIndex( (i + 500) + 1 )
        
    end
    
    of.pushMatrix()
    
    of.translate( 0, -(length*2.4) )
    myMesh:draw()
    myMesh:clear()
    of.popMatrix()
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
  
    ------------------------- set Camera and Light Position
    myCam:setPosition( w2, h2, wT2 ) -- set camera position, change z
    myLight:setPosition( wT4, h , w )           -- set light position, change x
    rW = 45                 -- ribbon width
    --------------------- 
    of.setLineWidth( 1 )
    
    if( count >= 10 ) then
        count = 0
    end
    
    count = count + .01
    
    spiralW = (knob1 * w2) + 1
    spiralH = knob2 * wT2
    
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
            of.rotateDeg( knob3*360, w2, h2, 0)
            
            of.setColor( fg )
            
            of.fill()
            drawSpiral( spiralW, spiralH, w2, h2, 4, count, rW )
            
            
           
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end