-- S - Line That Is Mesh
require("eyesy")                    -- include the eyesy library
modeTitle = "S -  Line That Is Mesh"-- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    -- define camera 
    theCam = of.Camera()
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    -- set up the light
    theLight = of.Light()                                   -- define light class
    --theLight:setup()                                        -- start the light
	theLight:setPointLight( )                               -- set as a point light
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) )    -- make the ambient color white
	
	-- turn on Depth, set blend mode and frame rate
    of.enableDepthTest()
    of.setFrameRate(60)
    
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end

---------------------------------------------------------------------------
-- the draw loop
function draw()
    
    -- color stuff
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    of.setColor(fg)
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/1.2 )           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h , h/4 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    of.translate(0, h/2)
    thickness = (knob1 * (h/2)) + 1
    
    if( 0 > 0.4999 ) then
        for i = 0, 20 do
            of.pushMatrix()
            of.translate( i*(w/20), 0 )
            local tabber = {}
            tabber[1] = inL[(i*3)+1]
            tabber[2] = inL[(i*3)+2]
            tabber[3] = inL[(i*3)+3]
            meshLine( thickness, w/20, 2, tabber, h, glm.vec3(1,1,1) )
            of.popMatrix()
        end
    else
        tabber = {}
        for i = 1, 100 do
            tabber[i] = inL[i*2]
        end
        meshLine( thickness, w, 100, inL, h, glm.vec3(0,1,1) )
    end
    
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
    
    
end

---------------------------------------------------------------------------
-- draw a line with mesh
function meshLine( width, length, lengthPoints, audioTable, amp, vecAmpDir )
    local mesh = of.Mesh()
    local lengthStep =  length / (lengthPoints-1 )
    local yBasePos = width/2
    
    -- top row
    -- -- 1st point
    a = audioTable[1] * amp
    mesh:addVertex( glm.vec3( (a * vecAmpDir.x), -yBasePos+(a * vecAmpDir.y), (a * vecAmpDir.z)) )
    for i = 0, lengthPoints-2 do
        aud = audioTable[i+2] * amp 
        xPos = (i*lengthStep) + (lengthStep/2)
        xPos = xPos + (aud * vecAmpDir.x)
        yPos = -yBasePos + (aud * vecAmpDir.y)
        zPos = aud * vecAmpDir.z

        mesh:addVertex( glm.vec3( xPos, yPos, zPos) )
    end 
    a = audioTable[lengthPoints] * amp
    mesh:addVertex( glm.vec3( ((lengthPoints-1)*lengthStep)+(a * vecAmpDir.x), -yBasePos + (a * vecAmpDir.y), (a * vecAmpDir.z)))
    
    -- bottom row
    for i = 0, lengthPoints-1 do
        aud = audioTable[i+1] * amp 
        xPos = (i * lengthStep) + (aud * vecAmpDir.x)
        yPos = yBasePos + (aud * vecAmpDir.y)
        zPos = aud * vecAmpDir.z
        mesh:addVertex( glm.vec3( xPos, yPos, zPos) )
    end
    
    -- connect them
    for i = 0, lengthPoints-2 do
        local iter = i+(lengthPoints+1)
        mesh:addIndex( iter )
        mesh:addIndex( i+1 )
        mesh:addIndex( iter + 1 )
    end
    
    for i = 0, lengthPoints do
        if( i == 0 ) then
            mesh:addIndex( i )
            mesh:addIndex( i + (lengthPoints+1) )
            mesh:addIndex( i + 1 )
        elseif( i == lengthPoints ) then
            mesh:addIndex( i )
            mesh:addIndex( i - 1 )
            mesh:addIndex( i + (lengthPoints) )
        else
            mesh:addIndex( i )
            mesh:addIndex( i + (lengthPoints+1) )
            mesh:addIndex( i+1 )
        end
    end
    -- normals
    for i = 0, mesh:getNumVertices() do
       
            mesh:addNormal( glm.vec3( 0,1,0.5 ))
       
        
    end


    mesh:draw()
    mesh:clear()
    
end

---------------------------------------------------------------------------
--color picker
function colorPickHSB( knob, name )
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

------------------------------------ the exit function ends the update and draw loops
function exit()
    
    of.disableDepthTest()           -- disable depth
    print("script finished")        -- report finished
end