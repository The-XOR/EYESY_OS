-- S - Frame Scope
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Frame Scope"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    count = 0                           -- count for frame freeze interval
    freezeCount = 0                     -- initial count of frames as they build up
    globFrameCount = 0                  -- global count of frames
    lineDef = 10                        -- how many points in the osc
    globXAmt = 8                        -- how many frame across
    globYAmt = 8                        -- how many frames down
    -- define camera 
    theCam = of.Camera()
    
    
    -- define slides
    k2Slide = slider( .01 )
    k3Slide = slider( .01 )
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    -- set up the light
    theLight = of.Light()                                   -- define light class
    theLight:setup()                                        -- start the light
	theLight:setPointLight( )                               -- set as a point light
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) )    -- make the ambient color white
	
	-- create tables
	theTable = {}                   -- table to save amplitude points
	for i = 1, globXAmt*globYAmt do
	    local tabber = {}
        for j = 1, lineDef do
            tabber[j] = inL[j]
        end
        theTable[i] = tabber
    end
	
	theColorTab = {}                -- table to save background color
	for i = 1, globXAmt*globYAmt do
	    local tabber = {}
        for j = 1, 3 do
            tabber[j] = 0
        end
        theColorTab[i] = tabber
    end
	
	
	-- turn on Depth, set blend mode and frame rate
    of.enableDepthTest()
    of.enableAlphaBlending()
    of.enableSmoothing()
    of.setFrameRate(30)
    
    
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
    of.setBackgroundColor( bg )                     -- set the background color
    of.setColor( fg )                               -- set the foreground color
                    
    --knob Stuff
    speed = math.pow( knob1 * 50, 2)                             -- speed
    k2Slide.target = ( knob2*(w*2) ) + w/2.05                 --zoom
    k3Slide.target = knob3 * 180                              -- rotate
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, k2Slide.update() )               -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h/2 , w )              -- set light position, change x
    theLight:enable()                               -- enable light in the scene
    theCam:beginCamera()                            -- start the camera
    
    -- draw frame
    
    of.translate(w/2,0)
    of.rotateYDeg( k3Slide.update() )
    of.translate(-w/2,0)
    of.noFill()
    of.setLineWidth(3)
    of.drawRectangle( glm.vec3(0,0,0), w, h)
    
    -- top left scope always on
    wowTab = {}
    globAudioStep = math.floor(100/lineDef)
    
    for i = 1, lineDef do
        wowTab[i] = inL[i*globAudioStep]
    end
        
    oscMesh( h/globYAmt, 0, (h/globYAmt)/2, 0, w/globXAmt, h/200, glm.vec3(0,1,0), 0, lineDef, wowTab )

    -- if count is greater than 1 save the scope position and color, return count to 0
    if( count > 1 ) then
        count = 0
        -- add the freezeCount
        if( globFrameCount >= globXAmt*globYAmt ) then
            globFrameCount = 0
        end
        
        if(freezeCount < globXAmt*globYAmt) then
            freezeCount = freezeCount + 1
        else
            freezeCount = globXAmt*globYAmt
        end
        
        globFrameCount = globFrameCount + 1
        
        --freeze the scope
        local tabber = {}
        
        for i = 1, lineDef do
            tabber[i] = inL[i*globAudioStep]
        end
        theTable[globFrameCount] = tabber
        
        -- freeze the bg color
        theColorTab[globFrameCount][1] = fg:getHue( )
        theColorTab[globFrameCount][2] = fg:getSaturation( )
        theColorTab[globFrameCount][3] = fg:getBrightness( )
        
    end
    
    -- count interval
    count = count + speed
    
    -- in freezeCount is greater than 1 start printing the frozen frames in the grid from left to right.
    if( freezeCount > 1 ) then
        for i = 1, freezeCount-1 do
        
            j = math.floor( (i) / 8 )
            itr = i % 8 
            of.pushMatrix()
            of.translate( itr*(w/8), j*(h/8) )
            
            
            --modCol.setHsb( 234, 212, 123 )
            
            --of.setColor( modCol )
            
            
            of.setColor(fg)
            oscMesh( h/globYAmt, 0, (h/globYAmt)/2, 0, w/globXAmt, h/200, glm.vec3(0,1,0), 0, lineDef, theTable[i] )
            
            
            
            of.popMatrix()
        end
    end
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()

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
-- OPP slide function, smooths movement
function slider( step )
    local self = {}
    self.current = 0
    self.direction = 1
    self.step = step or 1
    self.new = 0
    self.target = 0
    self.space = 0
    
    function self.update()
        if( math.abs(self.target - self.current) > 0.1 ) then
            --set direction
            if( self.target < self.current) then
                self.direction = -1
            else
                self.direction = 1
            end
            --set step
            self.space = math.abs(self.target - self.current )
            self.step = self.space / 2
            self.current = self.current + (self.step*self.direction)
        end
        return self.current
    end
    
    return self
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
    theCam:setVFlip( false )
    of.disableDepthTest()           -- disable depth
    print("script finished")        -- report finished
end