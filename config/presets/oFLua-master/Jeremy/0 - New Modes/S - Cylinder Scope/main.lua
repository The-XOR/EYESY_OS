-- S - Cylinder Scope
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Cylinder Scope"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    points = 256
    cylHeight = h/4
    k1Store = 0
    k2Store = 0
    
    -- define sliders
    k1slide = slider( 0.01 )
    k2slide = slider( 0.01 )
    k3slide = slider( 0.01 )
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    
    -- define mesh
    mesh = of.Mesh()
    
    ---- make mesh points for body
    for i = 0, points do
        local xPos = math.sin( (i/points)*(math.pi*2) ) * (h/4)
        local zPos = math.cos( (i/points)*(math.pi*2) ) * (h/4)
        mesh:addVertex( glm.vec3( xPos, (h/4), zPos ) )
        mesh:addVertex( glm.vec3( xPos, 0, zPos ) )
    end
    ---- add two for caps
    mesh:addVertex( glm.vec3( 0, h/4, 0 ) )
    mesh:addVertex( glm.vec3( 0, 0, 0 ) )
    ---- connect mesh points for body
    for i = 0, points*2 do
        local mod = points*2
        local p1 = i % mod
        local p2 = (i+1) % mod
        local p3 = (i+2) % mod
        local p4 = (i+3) % mod
        mesh:addTriangle( p1, p2, p3 )
        mesh:addTriangle( p2, p3, p4 )
    end
    
    
    ---- connect caps
    for i = 0, ((points)*2)-1 do
        if( i % 2 == 0 ) then
            mesh:addTriangle( i, 514, (i+2)%(points*2) )
        elseif( i % 2 == 1 ) then
            mesh:addTriangle( i, 515, (i+2)%(points*2) )
        end
    end

    ---- define colors
    for i = 0, points-1 do
        mesh:addColor( of.FloatColor(1,1,1) )
        mesh:addColor( of.FloatColor(1,0.5,1) )
    end
    ------ cap colors
    mesh:addColor( of.FloatColor(1,0,0) )
    mesh:addColor( of.FloatColor(0,0,1) )
    
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
    ---- circumference of the circle
    k1slide.target = ( knob1 * (h/2) ) + 1          
    circ = k1slide.update() 
    
    ---- height of cylinder
    k2slide.target = (knob2 * h) + 3
    height = k2slide.update()
    ---- rotation
    k3slide.target = knob3 * 360
    xRotate = k3slide.update()
    
    -- translations
    of.translate( w/2, h/2 )
    of.rotateXDeg( xRotate )
    of.translate( 0, -height/2)
    
    -- resizing
    ---- width (circumference)
    if( circ ~= k1Store ) then
        for i = 0, points-1 do
            local iter = i * 2
            local vert1 = mesh:getVertex(iter)
            local vert2 = mesh:getVertex(iter+1)
            local xPos = math.sin( (i/points)*(math.pi*2) ) * circ
            local zPos = math.cos( (i/points)*(math.pi*2) ) * circ
            mesh:setVertex( iter, glm.vec3( xPos, vert1.y, zPos) )
            mesh:setVertex( iter+1 , glm.vec3( xPos, vert2.y, zPos) )
            
        end
        k1Store = circ
    end
    
    ---- height
    if( height ~= k2Store ) then
        local vert = mesh:getVertex(515)
        mesh:setVertex( 514, glm.vec3( vert.x, height, vert.z) )
        k2Store = height
    end
    

    -- modd the points with audio
    for i=0, points-1 do
        local iter = i * 2
        local aud1 = inL[i+1] * h  
        local aud2 = (inL[i+1] * h ) + height
        local vert1 = mesh:getVertex(iter)
        local vert2 = mesh:getVertex(iter+1)
        mesh:setVertex( iter, glm.vec3( vert1.x, aud2, vert1.z) )
        mesh:setVertex( iter+1 , glm.vec3( vert2.x, aud1, vert2.z) )
    end
    
    -- update color based on fg
    local r = fg.r/256
    local g = fg.g/256
    local b = fg.b/256
    for i = 0, points-1 do
        iter = i*2
        mesh:setColor( iter, of.FloatColor(r+0.5, g+0.5, b+0.5) )
        mesh:setColor( iter+1, of.FloatColor(r,g,b) )
    end
    ------ cap colors
    mesh:setColor( 514, of.FloatColor(r+0.1, g+0.1, b+0.1) )
    mesh:setColor( 515, of.FloatColor(r-0.1,g-0.1,b-0.1) )
    
    mesh:draw()
   
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
-- slide movement
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