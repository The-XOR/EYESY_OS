-- S - Cylinder Pieces Scope
require("eyesy")                            -- include the eyesy library
modeTitle = "S - Cylinder Pieces Scope"     -- name the mode
print(modeTitle)                            -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    pieces = 100                        -- define amount of 'pieces'
    height =  h/4                         -- height of cylinder
    circ = h/4                          -- circumference of the circle
    slowCount = 0                       -- count for rotation animation
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    mod = of.Color()
    
    -- sliders
    k1slide = slider( 0.01 )
    k2slide = slider( 0.01 )
    k3slide = slider( 0.01 )
    
    -- random color mod table
    randTab = {}
    for i = 1, pieces do
        randTab[i] = math.random( -20, 20 )
    end
    
    -- define mesh class
    mesh = lineMesh()
   
    -- enable depth
    of.enableDepthTest()
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
    
    
    -- knobs
    ---- circumference of the circle
    k1slide.target = (knob1 * 50)           
    twist = k1slide.update() 
    circ = w/4
    ---- line thick
    k2slide.target = knob2 * 100
    thick = k2slide.update()
    ---- rotation
    k3slide.target = knob3 * 360
    xRotate = k3slide.update()
    
    
    of.translate( w/2, h/2 )
    of.rotateXDeg( xRotate )
    --of.rotateYDeg( slowCount )
    
    
    if( slowCount >= 360 ) then
        slowCount = 0
    else
        slowCount = slowCount + 0.08
    end
    
    for i = 0, pieces-1 do
        
        
        local iter = i / (pieces-1)
        local twisted = (i+twist) % pieces
        local iter2 = (twisted) / (pieces-1)
        local rand = randTab[i+1]
        local xPos1 = math.sin( iter * (math.pi*2) ) * circ
        local zPos1 = math.cos( iter * (math.pi*2) ) * circ
        
        local xPos2 = math.sin( iter2 * (math.pi*2) ) * circ
        local zPos2 = math.cos( iter2 * (math.pi*2) ) * circ
        
       
        yPos = inL[i+1] * (h/2)
        
        mod:setHsb( fg:getHue()+rand, fg:getSaturation(), fg:getBrightness() ) 
        of.setColor(mod)
        mesh.draw( thick, 90, glm.vec3(xPos1, -(h/8) + yPos, zPos1), glm.vec3( xPos2, (h/8) + yPos, zPos2 ) )
    end
    
    
    
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


    function self.draw( width, rot, vec1, vec2)
        local w2 = width / 2
        local turnV = vec1 - vec2
        
        local rot1X = math.sin( (rot/360) * (math.pi*2) ) * w2
        local rot1Y = math.cos( (rot/360) * (math.pi*2) ) * w2
        
        local rot2X = math.sin( ((rot+180)/360) * (math.pi*2) ) * w2
        local rot2Y = math.cos( ((rot+180)/360) * (math.pi*2) ) * w2
        -- set 1st vertex
        self.mesh:setVertex( 0, glm.vec3(vec1.x+rot1X, vec1.y+rot1Y, vec1.z) ) -- 0
        self.mesh:setVertex( 1, glm.vec3(vec1.x+rot2X, vec1.y+rot2Y, vec1.z) ) -- 1
    
        -- set 2nd point
        self.mesh:setVertex( 2, glm.vec3(vec2.x+rot1X, vec2.y+rot1Y, vec2.z) ) -- 2
        self.mesh:setVertex( 3, glm.vec3(vec2.x+rot2X, vec2.y+rot2Y, vec2.z) ) -- 3
    
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

------------------------------------ the exit function ends the update and draw loops
function exit()
    of.disableDepthTest()
    print("script finished")        -- report finished
end