-- S - Color Lines
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Color Lines"       -- name the mode
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
    cOl = of.Color()
    
    
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
    of.setColor(fg)
    
    of.translate( 0, h/4 )
    for i = 0, 99 do
        local yPos = i * (h/255) 
        vec1 = glm.vec3( 0, yPos, 0 )
        vec2 = glm.vec3( w, yPos, 0)
        aud = math.abs( inL[i+1] ) 
        aud = ( aud * (knob2*255) ) + (knob3*255)
        aud = (aud+(knob3*255))%256
        
        cOl:setHsb( aud, fg:getSaturation(), fg:getBrightness() )
        of.setColor( cOl )
        mesh.draw( 20, 0, vec1, vec2, cOl )
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
    self.mesh:addTriangle( 0,1,2 )
    self.mesh:addTriangle( 2,3,1 )
    
    
    
    function self.draw( width, rot, vec1, vec2 )
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
        
        -- draw it
        self.mesh:draw()
    end
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