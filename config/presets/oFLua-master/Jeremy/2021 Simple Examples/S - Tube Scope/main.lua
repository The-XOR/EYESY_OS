-- S - Tube Scope
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Tube Scope"        -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    
    -- define camera 
    theCam = of.Camera()
    
    -- make parent Node
    tubeSpin = of.Node()
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    -- set up the light
    theLight = of.Light()                                  -- define light class
    theLight:setPointLight()                               -- set as a point light
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) )    -- make the ambient color white
	
	
	-- turn on Depth, set blend mode and frame rate
    of.enableSmoothing()
    of.setSmoothLighting( true )
    of.enableDepthTest()
    of.setFrameRate(60)
    
    -- define tubes
    tube1 = tuber( w/24, 10, w, 100, h/2, inL, glm.vec3(0,1,0) )
    tube1:setup()

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
    theCam:setPosition( w/2, h/2, (knob1*(w*2)) + w/5 )           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h/6 , h/8 )              -- set light position, change x
   
    theLight:enable()
    theCam:beginCamera()
    
    
    
    of.pushMatrix()
        of.translate( w/2, h/2 )
        of.rotateYDeg( knob2*360 )
        of.rotateXDeg( knob3*360 )
        of.translate( -(w/2), 0 )
        
        tube1:update( )
        
        
    of.popMatrix()
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
end
---------------------------------------------------------------------------
-- function tube scope try 2
function tuber( radius, radDef, height, heightDef, amp, audioTab, direction )
    local self = {}
    self.mesh = of.Mesh()
    self.hChunk = height / heightDef
    self.totalSize = radDef * (heightDef+1)
    self.r = radius
    self.rDef = radDef
    self.h = height
    self.hDef = heightDef
    self.amp = amp
    
    self.dirVert = direction or glm.vec3(0,1,0) -- this needs to be a glm.vec3 just the Y axis is default
    
    function self.setup()
    
        -- draw the vertices
        for i = 0, self.hDef do
            local hite = i * self.hChunk
            
            for j = 0, self.rDef-1 do
                xPos = hite 
                yPos = math.cos( (j/self.rDef)*6.28) * self.r
                zPos = math.sin( (j/self.rDef)*6.28) * self.r
                self.mesh:addVertex( glm.vec3( xPos, yPos, zPos ))        
            end
        end
    
        -- draw the center vertices for the faces
        self.mesh:addVertex( glm.vec3( 0, 0, 0 ) )
        self.mesh:addVertex( glm.vec3( height, 0, 0 ) )
    
        -- connect the 1st face vertices
        for i = 0, self.rDef-1 do
            self.mesh:addIndex(i)
            self.mesh:addIndex( (i+1)%(self.rDef) )
            self.mesh:addIndex( self.totalSize  )
        end
    
        -- connect the body
        for i = 0, self.hDef-1 do
            for j = 0, self.rDef-1 do
                iter = radDef * i
                self.mesh:addIndex( j + iter )
                self.mesh:addIndex( (j+self.rDef) + iter )
                self.mesh:addIndex( ( (j+1) % self.rDef ) + iter )
                
                self.mesh:addIndex( ((j+1)%self.rDef) + iter )
                self.mesh:addIndex( (((j+1)%self.rDef)+self.rDef) + iter )
                self.mesh:addIndex(  ((j%self.rDef)+self.rDef) + iter )
            end
        end
        
        -- connect the last face vertices
        for i = 0, self.rDef-1 do
            iter = (self.totalSize-self.rDef)
            self.mesh:addIndex( i + iter )
            self.mesh:addIndex( ((i+1)%self.rDef) + iter )
            self.mesh:addIndex( self.totalSize + 1 )
        end
        
        -- set normals
        for i = 0, self.totalSize+1 do
            local init = 1 / ( i % self.rDef )
            self.mesh:addNormal( glm.vec3(0,0,1) )
        end
        
    end  
    -- function to animate
    function self.update( )
        
        -- move the vertices based on the audio table
        for i = 0, self.hDef do
            local aud = audioTab[(i%256)+1] * self.amp
            for j = 0, self.rDef-1 do
                local vert = self.mesh:getVertex( (self.rDef*i) + j )
                xPos = vert.x + ( aud * self.dirVert.x)
                yPos = vert.y + ( aud * self.dirVert.y)
                zPos = vert.z + ( aud * self.dirVert.z)
                self.mesh:setVertex( (self.rDef*i) + j, glm.vec3( xPos, yPos, zPos ))        
            end
        end
        
        
        -- move the two face points as well
        local vert1 = self.mesh:getVertex( self.totalSize )
        local aud1 = audioTab[1] * self.amp
        local xPos1 = vert1.x + ( aud1 * self.dirVert.x)
        local yPos1 = vert1.y + ( aud1 * self.dirVert.y)
        local zPos1 = vert1.z + ( aud1 * self.dirVert.z)   
        self.mesh:setVertex( self.totalSize, glm.vec3( xPos1, yPos1, zPos1 ) )
        
        local topPoint = math.max( math.min(self.hDef,100), 1)
        local vert2 = self.mesh:getVertex( self.totalSize+1 )
        local aud2 = audioTab[topPoint] * self.amp
        local xPos2 = vert2.x + ( aud2 * self.dirVert.x)
        local yPos2 = vert2.y + ( aud2 * self.dirVert.y)
        local zPos2 = vert2.z + ( aud2 * self.dirVert.z)   
        self.mesh:setVertex( self.totalSize+1, glm.vec3( xPos2, yPos2, zPos2 ) )
        
    
        self.mesh:draw()
        
        for i = 0, self.hDef do
            local hite = i * self.hChunk
            
            for j = 0, self.rDef-1 do
                xPos = hite 
                yPos = math.cos( (j/self.rDef)*6.28) * self.r
                zPos = math.sin( (j/self.rDef)*6.28) * self.r
                self.mesh:setVertex( (i*self.rDef)+j, glm.vec3( xPos, yPos, zPos ) )        
            end
        end
        
        -- draw the center vertices for the faces
        self.mesh:setVertex( self.totalSize, glm.vec3( 0, 0, 0 ) )
        self.mesh:setVertex( self.totalSize+1, glm.vec3( height, 0, 0 ) )
    
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
    of.disableSmoothing()
    of.setSmoothLighting( false )
    of.disableDepthTest()           -- disable depth
    print("script finished")        -- report finished
end