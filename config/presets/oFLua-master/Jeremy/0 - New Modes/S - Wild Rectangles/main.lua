-- S - Wild Rectangles
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Wild Rectangles"   -- name the mode
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
    
    -- define sliders
    slider1 = slider( 0.01 )
    slider2 = slider( 0.01 )
    slider3 = slider( 0.01 )
    
    -- define mesh class
    mesh = lineMesh()
    
    -- define class for audio buffer smoother
    avg = averageInL( 6 )   
    avgTable = {}               -- make table for audio smoother
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
    avgTable = avg.update()         -- this fills a table called avgTable
    
    -- color stuff
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    of.setColor(fg)
    
    
    slider1.target = ( knob1 * (w/9) ) + 1          -- rectangle width
    slider2.target = ( ( knob2 * (h/9) ) / 2 ) + 2  -- rectangle height
    slider3.target = (knob3*180) + 90                -- rectangle rotation
    
    recHeight = slider2.update()
    -- try this 2 point idea
    for i = 0, 9 do
        for j = 0, 9 do
            count = (i*10) + j
            xAud1 = avgTable[(count%256)+1] * (h/4)
            yAud1 = avgTable[ ((count+10)%256)+1 ] * (h/4)
            xPos1 = ( j * (w/9) ) 
            yPos1 = i * (h/9) - recHeight
            
            xAud2 = avgTable[((count+15)%256)+1] * (h/4)
            yAud2 = avgTable[ ((count+20)%256)+1 ] * (h/4)
            xPos2 = ( j * (w/9) )
            yPos2 = (i * (h/9) ) + recHeight
            
            mesh.draw( slider1.update(), slider3.update(), 
                glm.vec3(xPos1+xAud1,yPos1+yAud1,0), glm.vec3(xPos2+xAud2,yPos2+yAud2,0),
                fg
            )
            
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
    self.mesh:addTriangle( 0,1,2 )
    self.mesh:addTriangle( 2,3,1 )
    
    -- add color
    self.mesh:addColor( of.FloatColor(1,0.5,1) )
    self.mesh:addColor( of.FloatColor(1,1,1) )
    self.mesh:addColor( of.FloatColor(1,0.5,1) )
    self.mesh:addColor( of.FloatColor(1,1,1) )
    
    function self.draw( width, rot, vec1, vec2, colorMod )
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
        
        -- set color
        local r = colorMod.r/256
        local g = colorMod.g/256
        local b = colorMod.b/256
        
        self.mesh:setColor( 0, of.FloatColor(r*1.2,g*1.2,b*1.2) )
        self.mesh:setColor( 1, of.FloatColor(r,g,b) )
        self.mesh:setColor( 2, of.FloatColor(r/2,g/2,b/2) )
        self.mesh:setColor( 3, of.FloatColor(r,g,b) )
        
        -- draw it
        self.mesh:draw()
    end
    return self
end

---------------------------------------------------------------------------
-- smooth the sudio buffer
function averageInL( amt )      -- this oop averages each audio buffer point
    local self = {}
   
    amount = amt or 10              -- how many loops to average
    self.amtMin = math.max( amount, 1 )
    self.count = 1
    
    local countTab = {}             -- make a table with 100 tables with the amount size
    for i = 1, 256 do               
        countTab[i] = {}
        for j = 1, self.amtMin do
            countTab[i][j] = 0
        end
    end
    
    local averageTab = {}           -- make a table with 100 numbers
    for i = 1, 256 do               
        averageTab[i] = 0
    end
    
    
    function self.update()
        if( self.count > self.amtMin ) then
            self.count = 1
        else
            self.count = self.count + 1
        end
        for i = 1, 256 do
            ----- fill the count table
            countTab[i][self.count] = inL[i]
            local added = 0
            for j = 1, self.amtMin do
                added = added + countTab[i][j]
            end
            getAverage = added / self.amtMin
            
            averageTab[i] = getAverage
        end
        
        return averageTab
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