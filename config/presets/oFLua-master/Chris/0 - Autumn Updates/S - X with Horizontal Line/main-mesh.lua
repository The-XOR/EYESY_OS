-- S - X Scope With Horizontal
require("eyesy")                    -- include the eyesy library
modeTitle = "S - X Scope With Horizontal"      -- name the mode
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
    cool = of.Color()
    coool= of.Color()
    cooool = of.Color()
    modCol = of.Color()
    
    -- set up the light
    theLight = of.Light()                                   -- define light class
    theLight:setup()                                        -- start the light
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
    colorPickHSB( knob2, cool )
    colorPickHSB( knob3, coool )
    colorPickHSB( knob4, cooool )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    --of.setColor(fg)
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/2.1)           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h , 0 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    --of.noFill()
    --of.setLineWidth(5)
    --of.drawRectangle( 0,0,0,w, h )
    --of.drawRectangle( 0,0,0,w/8, h/8 )
    sizer = knob1*250+1
    
    of.setColor(coool)
    of.pushMatrix()
        of.translate(w/2,0,0)
        --oscMesh( modder, xPos, yPos, zPos, width, height,        axis,   angle, def )
            oscMesh2( w,     0,    0,     0,    w,   sizer,   glm.vec3(0,1,0), 0, 256 )
    of.popMatrix()
    

    of.setColor(cooool)
    of.pushMatrix()
        of.translate(w/2,h,0)
        --oscMesh( modder, xPos, yPos, zPos, width, height,        axis,   angle, def )
            oscMesh3( w,     0,    0,     0,    w,   sizer,   glm.vec3(0,1,0), 0, 256 )
    of.popMatrix()
    
    
    of.setColor(cool)
    of.pushMatrix()
        of.translate(w/2,h/2,0)
--oscMesh( modder, xPos, yPos, zPos, width, height,        axis,   angle, def )
        oscMesh( w,     0,    0,     0,    w,   sizer,   glm.vec3(0,1,0), 0, 256 )
    of.popMatrix()
    
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
end

---------------------------------------------------------------------------
-- oscilloscope mesh function - MIDDLE (horizontal)
function oscMesh( modder, xPos, yPos, zPos, width, height, axis, angle, def )
    local theMesh = of.Mesh()
    local mod = modder or 0
    local x = xPos or 0
    local y = yPos or 0
    local z = zPos or 0
    local h = height or 100
    local w = width or 100
    local ax = axis or glm.vec3( 0,0,0 ) -- this is a glm.vec3
    local ang = angle or 0
    local d = def or 10
    
    theMesh:setMode( of.PRIMITIVE_TRIANGLES )
    --theMesh:disableTextures()
    --theMesh:flatNormals()
    h2 = h/2
    w2 = w/2
    xStep = w / (def-1)
    
    
    -- the top row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i)+1 ] * mod
        pointX = (x-w2)+(i*xStep)
        pointX = pointX + ang
        pointY = y-h2     --(i-1)*h/255-h/2
        --pointY = i*(of.getHeight()/def) - h2
        pointZ = z
    
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
    end
    
    -- the bottom row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i)+1 ] * mod
        pointX = (xPos-w2)+(i*xStep)
        pointY = yPos+h2
        --pointY = i*(of.getHeight()/def) + h2
        pointZ = zPos
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
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
    -- add normals
    for i = 0, def-1 do
        theMesh:addNormal( glm.vec3(0,0,1) )
    end
    theMesh:draw()
    
    theMesh:clear()
    
end
---------------------------------------------------------------------------
-- oscilloscope mesh function - TOP RIGHT TO BOTTOM LEFT
function oscMesh2( modder, xPos, yPos, zPos, width, height, axis, angle, def )
    local theMesh = of.Mesh()
    local mod = modder or 0
    local x = xPos or 0
    local y = yPos or 0
    local z = zPos or 0
    local h = height or 100
    local w = width or 100
    local ax = axis or glm.vec3( 0,0,0 ) -- this is a glm.vec3
    local ang = angle or 0
    local d = def or 10
    
    theMesh:setMode( of.PRIMITIVE_TRIANGLES )
    h2 = h/2
    w2 = w/2
    xStep = w / (def-1)
    
    
    -- the top row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i)+1 ] * mod
        pointX = (x-w2)+(i*xStep)
        pointX = pointX + ang
        --pointY = y-h2     --(i-1)*h/255-h/2
        pointY = i*(of.getHeight()/def) - h2
        pointZ = z
    
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
    end
    
    -- the bottom row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i)+1 ] * mod
        pointX = (xPos-w2)+(i*xStep)
        --pointY = yPos+h2
        pointY = i*(of.getHeight()/def) + h2
        pointZ = zPos
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
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
    -- add normals
    for i = 0, def-1 do
        theMesh:addNormal( glm.vec3(0,0,1) )
    end
    theMesh:draw()
    
    theMesh:clear()
    
end


---------------------------------------------------------------------------
-- oscilloscope mesh function - BOTTOM LEFT TO TOP RIGHT
function oscMesh3( modder, xPos, yPos, zPos, width, height, axis, angle, def )
    local theMesh = of.Mesh()
    local mod = modder or 0
    local x = xPos or 0
    local y = yPos or 0
    local z = zPos or 0
    local h = height or 100
    local w = width or 100
    local ax = axis or glm.vec3( 0,0,0 ) -- this is a glm.vec3
    local ang = angle or 0
    local d = def or 10
    
    theMesh:setMode( of.PRIMITIVE_TRIANGLES )
    h2 = h/2
    w2 = w/2
    xStep = w / (def-1)
    
    
    -- the top row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i)+1 ] * mod
        pointX = (x-w2)+(i*xStep)
        pointX = pointX + ang
        --pointY = y-h2     --(i-1)*h/255-h/2
        pointY = (i*(of.getHeight()/def) + h2) *-1
        pointZ = z
    
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
    end
    
    -- the bottom row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i)+1 ] * mod
        pointX = (xPos-w2)+(i*xStep)
        --pointY = yPos+h2
        pointY = (i*(of.getHeight()/def) - h2) *-1
        pointZ = zPos
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
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
    -- add normals
    for i = 0, def-1 do
        theMesh:addNormal( glm.vec3(0,0,1) )
    end
    theMesh:draw()
    
    theMesh:clear()
    
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