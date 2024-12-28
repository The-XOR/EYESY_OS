-- S - Twists
require("eyesy")                    -- include the eyesy library
    modeTitle = "S - Twists"        -- name the mode
    print(modeTitle)                -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    
    -- define sliders
    slideAud = slider( 0.01 )
    
    -- define twist
    daTwist = twist()
    
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
    
    lineThick = (knob1*45) + 1
    lineSpace = (knob2*3) + 1
   
    for i = 0, 5 do
        local yPos = i * (h/6)
        for j = 0,5 do
            local xPos = j * (w/6)
            of.pushMatrix()
                of.translate( xPos+((w/6)/2), yPos+((h/6)/2) )
                of.rotateYDeg(knob3*180)
                local index = i * 3
                local aud = (math.abs(inL[ (index%256)+1 ])* 256 )
                daTwist.draw( aud, lineThick, lineSpace )
            of.popMatrix()
        end
    end
    
    
    
    
    
    
end

---------------------------------------------------------------------------
-- twists
function twist()
    local self = {}
    self.mesh = of.Mesh()           -- define mesh
    
    function self.draw( audio, thick, space )
        local thicker = thick / 2
        local t = thicker / space
       
        local direction = 3         -- 0: up, 1: right, 2: down, 3: left
        local jump = 0
        local countX = 0
        local countY = 0
        local stretch = 0
        local stretchX = 0
        local stretchY = 0
        local stepp = 0
        
        -- make center sqaure
        self.mesh:addVertex( glm.vec3( -t, -t, 0) )
        self.mesh:addVertex( glm.vec3( t, -t, 0) )
        self.mesh:addVertex( glm.vec3( -t, t, 0) )
        self.mesh:addVertex( glm.vec3( t, t, 0) )
        
        self.mesh:addTriangle( 0, 1, 3)
        self.mesh:addTriangle( 0, 2, 3)
        
        for j = 1, audio  do
            
            -- count the steps
            stepp = stepp + 1
            if( j>1 and j<2 ) then
                jump = 0
            elseif( j == 4 ) then
                jump = 2
            end
            
            if ( stepp >= math.floor(jump) ) then
                stepp = 0
            end
            
            if( stepp ==  0 ) then
                direction = direction + 1
                if( direction > 3 ) then
                    direction = 0
                end
                jump = jump + 0.5
            end
            
            -- directions
            if( direction == 0 ) then
                countY = countY - 1
           
            elseif( direction == 1) then
                countX = countX + 1
            
            elseif( direction == 2 ) then
                countY = countY + 1
            
            else
                countX = countX - 1
            end
            
            -- create the placement
            local xPos = (countX * thick) 
            local yPos = (countY * thick) 
            local zPos = 0
            
            local vec1 = glm.vec3( xPos-t, yPos-t, zPos )   -- top left
            local vec2 = glm.vec3( xPos+t, yPos-t, zPos )   -- top right
            local vec3 = glm.vec3( xPos-t, yPos+t, zPos )   -- bottom left
            local vec4 = glm.vec3( xPos+t, yPos+t, zPos )   -- bottom right
            
            self.mesh:addVertex( vec1 )
            self.mesh:addVertex( vec2 )
            self.mesh:addVertex( vec3 )
            self.mesh:addVertex( vec4 )
            
            i = j*4
            -- directions
            if( direction == 0 ) then           -- up
                self.mesh:addTriangle( i, i-4, i-3 )
                self.mesh:addTriangle( i, i+1, i-3 )
                
            elseif( direction == 1) then        -- right
                self.mesh:addTriangle( i-1, i-3, i+1 )
                self.mesh:addTriangle( i-1, i+3, i+1 )
                
            elseif( direction == 2 ) then      -- down
                self.mesh:addTriangle( i-2, i+2, i+3 )
                self.mesh:addTriangle( i-2, i-1, i+3 )
            else                                -- left
                self.mesh:addTriangle( i, i-3, i+2 )
                self.mesh:addTriangle( i+2, i-2, i-3 )
            end
        
    
        end
        
        
        self.mesh:draw()
        self.mesh:clear()
           
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