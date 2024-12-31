-- S - Spin Blocks
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Spin Blocks"       -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    numBox = 20
    boxSpace = w / numBox
    dSave = 0
    wSave = 0
    hSave = 0
    -- animation table
    aniTab = {}
    
    for i = 1, numBox+1 do
        aniTab[i] = 0
    end
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    
    -- mesh
    mesh = of.Mesh()
    
    -- make the box
    ---- add vertices
    mesh:addVertex( glm.vec3( -100, -100, 100) )      -- 0
    mesh:addVertex( glm.vec3( 100, -100, 100) )       -- 1
    mesh:addVertex( glm.vec3( -100, 100, 100) )       -- 2
    mesh:addVertex( glm.vec3( 100, 100, 100) )        -- 3
    
    mesh:addVertex( glm.vec3( -100, -100, -100) )     -- 4
    mesh:addVertex( glm.vec3( 100, -100, -100) )      -- 5
    mesh:addVertex( glm.vec3( -100, 100, -100) )      -- 6
    mesh:addVertex( glm.vec3( 100, 100, -100) )       -- 7
    ---- connect the vertices
    mesh:addTriangle(0,2,3)
    mesh:addTriangle(0,1,3)
    
    mesh:addTriangle(1,3,7)
    mesh:addTriangle(1,5,7)
    
    mesh:addTriangle(5,7,6)
    mesh:addTriangle(5,4,6)
    
    mesh:addTriangle(4,6,2)
    mesh:addTriangle(4,0,2)
    
    mesh:addTriangle(0,1,5)
    mesh:addTriangle(0,4,5)
    
    mesh:addTriangle(2,6,7)
    mesh:addTriangle(2,3,7)
    ---- add colors
    for i=0, 7 do
        mesh:addColor( of.FloatColor(1,1,1) )
    end
    
    -- sliders
    k1slide = slider( 0.01 )
   
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
    of.setColor( fg )
    
    depth = (knob1 * (h/2)) + 1
    height = (knob2 * (h/2)) + 1
    width = (boxSpace*knob3) + 1
    
    -- set depth
    if( dSave ~= depth) then
        for i = 0, 7 do
            if(i<4) then
                local vert = mesh:getVertex( i )
                mesh:setVertex( i, glm.vec3( vert.x, vert.y, -(depth/2) ) )
            else
                local vert = mesh:getVertex( i )
                mesh:setVertex( i, glm.vec3( vert.x, vert.y, (depth/2) ) )
            end
        end
    end
    -- set height
    if( hSave ~= height ) then
        for i = 0, 7 do
            if( i==0 or i==1 or i==4 or i==5 ) then
                local vert = mesh:getVertex( i )
                mesh:setVertex( i, glm.vec3( vert.x, -(height/2), vert.z ) )
            else
                local vert = mesh:getVertex( i )
                mesh:setVertex( i, glm.vec3( vert.x, (height/2), vert.z ) )
            end
        end
    end
    -- set width
    if( wSave ~= width ) then
        for i = 0, 7 do
            if( i%2 == 0 ) then
                local vert = mesh:getVertex( i )
                mesh:setVertex( i, glm.vec3( -(width/2), vert.y, vert.z ) )
            else
                local vert = mesh:getVertex( i )
                mesh:setVertex( i, glm.vec3( (width/2), vert.y, vert.z ) )
            end
        end
    end
    
    
    
    local r = fg.r/256
    local g = fg.g/256
    local b = fg.b/256
    mesh:setColor(0, of.FloatColor(r,g,b) )
    mesh:setColor(1, of.FloatColor(r+0.1, g+0.1, b+0.1 ) )
    mesh:setColor(2, of.FloatColor(r,g,b) )
    mesh:setColor(3, of.FloatColor( r+0.1, g+0.1, b+0.1 ) )
    mesh:setColor(4, of.FloatColor( r-0.1, g-0.1, b+0.1 ) )
    mesh:setColor(5, of.FloatColor( r+0.2,g+0.2,b+0.2 ) )
    mesh:setColor(6, of.FloatColor( r,g,b ) )
    mesh:setColor(7, of.FloatColor( r-0.2, g-0.2, b-0.2 ) )
    
    of.translate( 0, h/2 )
    
    for i = 0, numBox do
        of.pushMatrix()
            local xPos = i * boxSpace   -- x position math
            local prev = aniTab[i+1]    -- get the last rotation position (current)
            local aud = math.abs( inL[(i+1)] ) * 100  -- the sudio buffer
            
            local  rot = prev + aud     -- the count
            
            if( rot >= 360 ) then       -- create a 360 degree loop
                rot = 0
            end
            
            aniTab[i+1] = rot           -- add the value back into the table
            of.rotateXDeg( rot )        -- rotate
            of.translate(xPos, 0 )      -- change xposition
            mesh:draw()                 -- draw Mesh
        of.popMatrix()              -- pop the matrix
            
    end
    
    
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