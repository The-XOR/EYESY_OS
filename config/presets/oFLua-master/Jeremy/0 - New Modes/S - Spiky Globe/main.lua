-- S - Spiky Globe
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Spiky Globe"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    
    -- define the sphere class
    myGlobe = meshSphere( h/2, 20 )
    myGlobe.setup()
    
    -- sliders
    slide1 = slider( 0.01 )
    slide2 = slider( 0.01 )
    slide3 = slider( 0.01 )
   
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
    of.setColor(fg)
    
    -- knobs
    slide1.target = knob1 * 360
    slide2.target = knob2 * 360
    slide3.target = (knob3 * w ) - (w/1.8) 
    
    of.translate(w/2,h/2, slide3.update() )
    of.rotateYDeg( slide1.update() )
    of.rotateXDeg( slide2.update() )
    
    myGlobe.update( h/8, inL, fg )
    
end

---------------------------------------------------------------------------
-- mesh sphere
function meshSphere( dia, def )
    local self = {}
    self.mesh = of.Mesh()
    self.bigMesh = of.Mesh()
    self.diameter = dia or 100
    self.def = def or 10
    self.diaCheck = 0
    self.revert = {}
    
    function self.setup()
        
        -- make a sphere
        for i = 0, self.def do
            local yPos = math.cos( (i/(self.def-1)) * math.pi ) * self.diameter 
            local yWidth = math.sin( (i/(self.def-1)) * math.pi ) * self.diameter 
            for j = 0, self.def-1 do
                local xPos = math.cos( (j/self.def) * (math.pi*2) ) * yWidth
                local zPos = math.sin( (j/self.def) * (math.pi*2) ) * yWidth
                self.mesh:addVertex( glm.vec3( xPos, yPos, zPos) )
            end
        end
        ---- connect vertices with triangles
        for i = 0, self.def-2 do
            local iStep = i*self.def
            for j = 0, self.def-1 do
                local mod = self.def
                self.mesh:addTriangle( iStep+j, iStep+((j+1)%mod), ((i+1)*mod)+j )
                self.mesh:addTriangle( iStep+((j+1)%mod), ((i+1)*mod)+j, ((i+1)*mod)+((j+1)%mod)  )
            end
        end
            
        meshVerts =  self.mesh:getNumVertices()
        
        -- add color
        for i = 1, meshVerts do
            self.mesh:addColor( of.FloatColor(i/meshVerts,1,1) )
        end
        
        -- make just vertices for a larger sphere
        for i = 0, self.def do
            local yPos = math.cos( (i/(self.def-1)) * math.pi ) * (self.diameter*2 )
            local yWidth = math.sin( (i/(self.def-1)) * math.pi ) * ( self.diameter*2) 
            for j = 0, self.def-1 do
                local xPos = math.cos( (j/self.def) * (math.pi*2) ) * yWidth
                local zPos = math.sin( (j/self.def) * (math.pi*2) ) * yWidth
                self.bigMesh:addVertex( glm.vec3( xPos, yPos, zPos) )
            end
        end
        
        -- fill the reversion table
        for i = 1, self.mesh:getNumVertices() do
            self.revert[i] = self.mesh:getVertex(i - 1)
        end
    
        
    end
    
    -- draw the mesh
    function self.update( diameter, sound, color )
        -- if the diameter is changed redraw the vertices
        local numVerts = self.mesh:getNumVertices()
        if( diameter ~= diaCheck ) then
            -- resize the sphere
            for i = 0, self.def do
                local yPos = math.cos( (i/(self.def-1)) * math.pi ) * diameter 
                local yWidth = math.sin( (i/(self.def-1)) * math.pi ) * diameter 
                for j = 0, self.def-1 do
                    local count = (i*self.def) + j
                    local xPos = math.cos( (j/self.def) * (math.pi*2) ) * yWidth
                    local zPos = math.sin( (j/self.def) * (math.pi*2) ) * yWidth
                    self.mesh:setVertex( count, glm.vec3( xPos, yPos, zPos) )
                end
            end
            -- resize the big sphere
            for i = 0, self.def do
                local yPos = math.cos( (i/(self.def-1)) * math.pi ) * (diameter*2)
                local yWidth = math.sin( (i/(self.def-1)) * math.pi ) * (diameter*2) 
                for j = 0, self.def-1 do
                    local xPos = math.cos( (j/self.def) * (math.pi*2) ) * yWidth
                    local zPos = math.sin( (j/self.def) * (math.pi*2) ) * yWidth
                    self.bigMesh:addVertex( glm.vec3( xPos, yPos, zPos) )
                end
            end
            -- update the reversion table
            for i = 1, numVerts  do
                self.revert[i] = self.mesh:getVertex(i - 1)
            end
    
        end
        
        -- move the vertices with sound
        for i = 0, numVerts-1 do
            if( i%1 == 0 ) then
                local vert = self.mesh:getVertex( i )
                local bigVert = self.bigMesh:getVertex( i )
                local index = i + i
                local aud = sound[ (index%256)+1 ] 
                local aud = math.abs(aud)
                local audVert = glm.vec3(aud,aud,aud)
                
                self.mesh:setVertex( i, vert + (bigVert * audVert) )
            end
        end
        
        -- chnage color
        
        for i = 0, numVerts-1 do
            local r = color.r/256
            local g = color.g/256
            local b = color.b/256
            local index = math.floor( i + (i/2) )
            local mod = math.pow( i/numVerts, 0.25 )
            local aud = (sound[ (index%256)+1 ] * 5) + 1 
            local aud = math.abs(aud)
            
            
            if( i%1 == 0 ) then
                self.mesh:setColor( i, of.FloatColor((r*aud)*mod, (g*aud)*mod, (b*aud)*mod ) )
            else
                self.mesh:setColor( i, of.FloatColor((r)*mod, (g)*mod, (b)*mod ) )
            end
            
        end
        
        -- draw it!
        self.mesh:draw()
        
        -- revert the vertices
        for i = 1, numVerts do
            self.mesh:setVertex(i-1, self.revert[i] )
        end

    end
    -- OOP return
    return self
end
---------------------------------------------------------------------------
-- color picker
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
-- the slides for knob values
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