-- Compare Draw Line Functions
require("eyesy")                    -- include the eyesy library
modeTitle = "Compare Draw Line Functions"      -- name the mode
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
    
    -- knobs
    thick = ( knob1*(h/8) ) + 1
    yRot = knob2 * 360
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/1.2 )           -- set camera position, change z
    theCam:setVFlip( true )
    theCam:beginCamera()
    
    of.translate(w/2,0)
    of.rotateYDeg( yRot )
    of.translate( -w/2, 0 )
    
    of.pushMatrix()
        of.translate( 0 , 0)
        meshLineX( thick, w, 256, inL, h/8, glm.vec3(0,1,0) )
    of.popMatrix()
    
    of.pushMatrix()
        of.translate( 0, h/2 )
        oscMesh( h/8, 0, 0, 0, w, thick, glm.vec3(0,1,0), 0, 256, inL )
    of.popMatrix()
   
    of.pushMatrix()
        of.translate( 0, h )
        for i = 0, 254 do
            step = i * (w/255)
            
            aud1 = inL[i+1] * h/8
            aud2 = inL[i+2] * h/8
            lineMesh( thick, glm.vec3(step,aud1,0), glm.vec3(step+(w/255),aud2,0) )
        end
    of.popMatrix()
   
    
    -- end the camera
    theCam:endCamera()
    
    
    
end

---------------------------------------------------------------------------
-- draw a line with mesh, has a criss cross pattern
function meshLineX( width, length, lengthPoints, audioTable, amp, vecAmpDir )
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
-- oscilloscope mesh function
function oscMesh( modder, xPos, yPos, zPos, width, height, axis, angle, def, theTab )
    local theMesh = of.Mesh()
    local tab = theTab or {}
    local mod = modder or 0
    local x = xPos or 0
    local y = yPos or 0
    local z = zPos or 0
    local hi = height or 100
    local wi = width or 100
    local ax = axis or glm.vec3( 0,0,0 ) -- this is a glm.vec3
    local ang = angle or 0
    local d = def or 10
    
    theMesh:setMode( of.PRIMITIVE_TRIANGLES )
    
    xStep = wi / (def-1)
    hi2 = hi/2
    
    
    -- the top row of vertices
    for i = 0, d - 1 do
        aud = tab[ i+1 ] * mod
        pointX = xPos + (i*xStep)
        pointX = pointX + ang
        pointY = yPos - hi2
        pointZ = zPos
    
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
    end
    
    -- the bottom row of vertices
    for i = 0, def - 1 do
        aud = tab[ i+1 ] * mod
        pointX = xPos + (i*xStep)
        pointY = yPos + hi2
        pointZ = zPos
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        --theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
    end
    
    
    -- connect the vertices
    for i = 0, def-1 do
        if( i < def-1 ) then
            theMesh:addIndex( i )
            theMesh:addIndex( i+1 )
            theMesh:addIndex( i+def )
        end
        if( i > 0 ) then
            theMesh:addIndex( i )
            theMesh:addIndex( i+(def-1) )
            theMesh:addIndex( i+(def) )
        end
    end
    --[[]
    -- add normals
    for i = 0, def-1 do
        theMesh:addNormal( glm.vec3(0,0,1) )
    end
    ]]--
    theMesh:draw()
    theMesh:clear()
    
end

---------------------------------------------------------------------------
-- mesh thats one line segment
function lineMesh( width, vec1, vec2)
    local mesh = of.Mesh()
    local w2 = width / 2
    -- add 1st vertex
    mesh:addVertex( glm.vec3(vec1.x, vec1.y - w2, vec1.z) ) -- 0
    mesh:addVertex( glm.vec3(vec1.x, vec1.y + w2, vec1.z) ) -- 1
    
    -- add 2nd point
    mesh:addVertex( glm.vec3(vec2.x, vec2.y - w2, vec2.z) ) -- 2
    mesh:addVertex( glm.vec3(vec2.x, vec2.y + w2, vec2.z) ) -- 3
    
    -- connect
    mesh:addIndex(0)
    mesh:addIndex(1)
    mesh:addIndex(2)
    
    mesh:addIndex(2)
    mesh:addIndex(3)
    mesh:addIndex(1)
    
    -- normal
    mesh:addNormal( glm.vec3(0,1,1) )
    mesh:addNormal( glm.vec3(0,1,1) )
    mesh:addNormal( glm.vec3(0,1,1) )
    mesh:addNormal( glm.vec3(0,1,1) )
    
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