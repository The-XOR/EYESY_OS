-- S - Neon Grid
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Neon Grid"         -- name the mode
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
    neon = of.Color()
    
    -- define mesh
    mesh = lineMesh()
    
    -- define fbo
    fbo = of.Fbo()
    fbo:allocate(of.getWidth(), of.getHeight())
    fbo:beginFbo()
    of.clear(255,255,255,0)
    fbo:endFbo()
   
    -- sliders
    k1Slide = slider( 0.01 )
    k2Slide = slider( 0.01 )
    
    
    
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
    colorPickHSB( knob3, neon )                     -- color for neon lines
    of.setBackgroundColor( bg )
        
	    
    ballWidth = w
    k1Slide.target = knob1*180
    skew = k1Slide.update()
    k2Slide.target = (knob2*20)+1
    thick = k2Slide.update()
    thick2 = thick/2
    
    
    
    
	   
    of.setColor(neon)
    for i = 0, 9 do
        xPos = i * (w/9)
        for j = 0, 9 do
            count = (i*8) + j
            ball = ( inL[count+1] * ballWidth ) + thick2
            
            yPos = j * (h/9)
            mesh.draw( thick, skew, glm.vec3(xPos-ball,yPos,0), glm.vec3(xPos+ball,yPos,0) )
            mesh.draw( thick, 90+skew, glm.vec3(xPos,yPos-ball,0), glm.vec3(xPos,yPos+ball,0) )
        end
    end
    
    of.setColor(fg)
    for i = 0, 9 do
        xPos = i * (w/9)
        for j = 0, 9 do
            yPos = j * (h/9)
            mesh.draw( thick, 90, glm.vec3(xPos,0,0), glm.vec3(xPos,yPos,0) )
            mesh.draw( thick, 0, glm.vec3(0,yPos,0), glm.vec3(w,yPos,0) )
        end
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