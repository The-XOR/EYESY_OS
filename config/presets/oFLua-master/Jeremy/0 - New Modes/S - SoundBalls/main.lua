-- S - SoundBalls
require("eyesy")                    -- include the eyesy library
modeTitle = "S - SoundBalls"        -- name the mode
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
    modCol = of.Color()
    
    -- sliders
    slide1 = slider()
    slide2 = slider()
    
    -- sphere params stuff
    diameter = w/64
    diaCheck = 0
    hDepth = 20
    wDepth = 20
    
    
    
    -- make a sphere
    mesh = of.Mesh()
    for i = 0, hDepth do
        local yPos = math.cos( (i/(hDepth-1)) * math.pi ) * diameter 
        local yWidth = math.sin( (i/(wDepth-1)) * math.pi ) * diameter 
        for j = 0, wDepth-1 do
            local xPos = math.cos( (j/wDepth) * (math.pi*2) ) * yWidth
            local zPos = math.sin( (j/wDepth) * (math.pi*2) ) * yWidth
            mesh:addVertex( glm.vec3( xPos, yPos, zPos) )
        end
    end
    ---- connect vertices with triangles
    for i = 0, hDepth-2 do
        local iStep = i*hDepth
        for j = 0, wDepth-1 do
            local mod = wDepth
            mesh:addTriangle( iStep+j, iStep+((j+1)%mod), ((i+1)*mod)+j )
            mesh:addTriangle( iStep+((j+1)%mod), ((i+1)*mod)+j, ((i+1)*mod)+((j+1)%mod)  )
        end
    end
        
    meshVerts =  mesh:getNumVertices()
    
    
    for i = 1, meshVerts do
        mesh:addColor( of.FloatColor(i/meshVerts,1,1) )
    end
   
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
    
    -- knobs
    slide1.target = knob1*360
    slide2.target = ( knob2 * h/20 ) + 5
    k3 = math.floor( knob3 * 2 )
    
    diameter = slide2.update()
    xAmount = 20
    yAmount = 15
    -- set ball size
    -- if diameter changes re-draw the sphere mesh
    if( diameter ~= diaCheck ) then
        for i = 0, hDepth do
            local yPos = math.cos( (i/(hDepth-1)) * math.pi ) * diameter 
            local yWidth = math.sin( (i/(wDepth-1)) * math.pi ) * diameter 
            for j = 0, wDepth-1 do
                local count = (i*hDepth) + j
                local xPos = math.cos( (j/wDepth) * (math.pi*2) ) * yWidth
                local zPos = math.sin( (j/wDepth) * (math.pi*2) ) * yWidth
                mesh:setVertex( count, glm.vec3( xPos, yPos, zPos) )
            end
        end
    end
    
    -- color stuff
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    of.setColor(fg)
    
    
    
    for i = 0, meshVerts-1 do
        local mod = i/meshVerts
        mesh:setColor(i, of.FloatColor((fg.r/256)*mod,(fg.g/256)*mod,(fg.b/256) * mod) )
    end
    
    for i = 0, xAmount do
        for j = 0, yAmount do
            local count = (i*(xAmount-1) ) + j
            if( k3 == 0 ) then
                count = count
            elseif( k3 == 1 ) then
                count = count * count 
            elseif( k3 == 2 ) then
                count = (count + count) % (xAmount*yAmount)
            end
            
            
            local yMod = inL[ (count%256) + 1 ] * (h/2)
            of.pushMatrix()
                of.translate( (i*(w/xAmount)), (j*(h/yAmount))+yMod, 0 )
                of.rotateXDeg( slide1.update() )
                mesh:draw()
            of.popMatrix()    
        end
    end
    
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