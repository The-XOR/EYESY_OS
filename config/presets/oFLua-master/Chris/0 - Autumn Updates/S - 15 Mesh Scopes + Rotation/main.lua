-- S - Name Mode
require("eyesy")                    -- include the eyesy library
modeTitle = "S - 15 Mesh Scopes + Rotation"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

rot = 0
col = 223
num = 15
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
    
    -- define slides
    k1Slide = slider( .01 )
    k2Slide = slider( .01 )
    k3Slide = slider( .01 )
    
    -- set up the light
    theLight = of.Light()                                   -- define light class
    theLight:setup()                                        -- start the light
	theLight:setPointLight()                               -- set as a point light
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
    
    ---knobs
    -- 1 Z rotation
    -- 2 y translation
    -- 3 z translation
    -- 4 fg color
    -- 5 bg color  
    
    -- color stuff
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    of.setColor(fg)
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/1.7 )           -- set camera position, change z
    theCam:setVFlip( true )
    of.setSmoothLighting(true)
    theLight:setPosition( w/2, h , 0 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    --of.noFill()
    --of.setLineWidth(5)
    --of.drawRectangle( 0,0,0,w, h )
    --of.drawRectangle( 0,0,0,w/8, h/8 )
    of.fill()
    
    rot = rot + rotation_dir_speed( knob1, 25 )
    of.pushMatrix()
        of.translate(w/2, h/2)
        
    	of.pushMatrix()
        	of.rotateZDeg(rot)
	    	for i=0,num do
            	of.pushMatrix()
                	of.translate(0, (i*(knob2 * 200)), (i * ((knob3*800)- 512)))
                	of.setColor(fg, 255 - (i*(255/num)))
                	 oscMesh( w, 0, 0, 0, w, 50, glm.vec3(0,1,0), 0, 100 )
            	of.popMatrix()
        	end
    	of.popMatrix()
    of.popMatrix()
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
end

---------------------------------------------------------------------------
-- oscilloscope mesh function
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
    h2 = h/2
    w2 = w/2
    xStep = w / (def-1)
    
    
    -- the top row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i%100)+1 ] * mod
        pointX = (xPos-w2)+(i*xStep)
        pointX = pointX + ang
        pointY = yPos-h2
        pointZ = zPos
    
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
        theMesh:addNormal( glm.vec3(pointX, pointY, pointZ ) )
    end
    
    -- the bottom row of vertices
    for i = 0, def - 1 do
        aud = inL[ (i%100)+1 ] * mod
        pointX = (xPos-w2)+(i*xStep)
        pointY = yPos+h2
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
function rotation_dir_speed( knob, range )
 -- for rotational direction and speed
 
    k = knob    --which knob are you passing in?
    r = range   --how big is knob value being scaled?
    
    kRaw = math.abs( (k * r))
    rater = math.pow( kRaw, 2 )
    
    if( k > 0.5 ) then
        kDirection = 1
    else
        kDirection = -1
    end
    
    if( k > 0.49 and k < 0.51 ) then
        rater = 0
    else 
        rater = rater
    end
    
    return rater * kDirection
end



---------------------------------------------------------------------------
-- average the audio buffer
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