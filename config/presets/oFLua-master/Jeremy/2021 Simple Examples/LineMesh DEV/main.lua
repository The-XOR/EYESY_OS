-- LineMesh DEV
require("eyesy")                    -- include the eyesy library
modeTitle = "LineMesh DEV"          -- name the mode
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
    
    -- define custom mesh line class
    myLine = lineMesh()
    
    -- set up the light
    theLight = of.Light()                                   -- define light class
    --theLight:setup()                                        -- start the light
	theLight:setPointLight( )                               -- set as a point light
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) )    -- make the ambient color white
	of.setSmoothLighting( true )
	-- turn on Depth, set blend mode and frame rate
    of.enableDepthTest()
    of.setFrameRate(24)
    
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
    theCam:setPosition( w/2, h/2, knob3*(w*2) )           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h , 0 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    thick = ( knob1 * (w) ) + 1
    of.translate(w/2,h/2)
    of.rotateXDeg(knob2*360)
    of.translate(-w/2, -h/2)
    
    for i = 0, 200 do
        step = i * (w/200)
        --i = i * 4
        aud1 = inL[i+1] * h
        aud2 = inL[i+2] * h
        -- draw the custom line class
        myLine.draw( thick, glm.vec3(step,(h/2),0+aud1), glm.vec3(step+(w/200),(h/2),0+aud2))
    end
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
    
    
end

---------------------------------------------------------------------------
-- mesh thats one line segment
function lineMesh()
    local self = {}
    self.mesh = of.Mesh()
    -- add 1st vertex
    self.mesh:addVertex( glm.vec3(0,0,0) ) -- 0
    self.mesh:addVertex( glm.vec3(0,1,0) ) -- 1
    
    -- add 2nd point
    self.mesh:addVertex( glm.vec3(1,0,0) ) -- 2
    self.mesh:addVertex( glm.vec3(1,1,0) ) -- 3
    
    -- connect
    self.mesh:addIndex(0)
    self.mesh:addIndex(1)
    self.mesh:addIndex(2)
    
    self.mesh:addIndex(2)
    self.mesh:addIndex(3)
    self.mesh:addIndex(1)
    
    -- normal
    self.mesh:addNormal( glm.vec3(0,1,1) )
    self.mesh:addNormal( glm.vec3(0,1,1) )
    self.mesh:addNormal( glm.vec3(0,1,1) )
    self.mesh:addNormal( glm.vec3(0,1,1) )


    function self.draw( width, vec1, vec2)
        local w2 = width / 2
    
        -- set 1st vertex
        self.mesh:setVertex( 0, glm.vec3(vec1.x, vec1.y - w2, vec1.z) ) -- 0
        self.mesh:setVertex( 1, glm.vec3(vec1.x, vec1.y + w2, vec1.z) ) -- 1
    
        -- set 2nd point
        self.mesh:setVertex( 2, glm.vec3(vec2.x, vec2.y - w2, vec2.z) ) -- 2
        self.mesh:setVertex( 3, glm.vec3(vec2.x, vec2.y + w2, vec2.z) ) -- 3
    
        self.mesh:draw()
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
    
    of.disableDepthTest()           -- disable depth
    print("script finished")        -- report finished
end