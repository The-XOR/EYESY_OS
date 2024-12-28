-- S - Fish Tank
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Fish Tank"         -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    globPoints = 20
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    -- compose the mesh
    mesh = of.Mesh()
    ---- draw the vertices
    for i = 0, globPoints-1 do
        local xPos = i * (w/globPoints)
        mesh:addVertex( glm.vec3(xPos, 0, 0) )
        mesh:addVertex( glm.vec3(xPos, 100, 0) )        
    end
    ---- connect the vertices
    for i = 0, globPoints-2 do
        local iter = i * 2
        mesh:addTriangle( iter, iter+1, iter+2 )
        mesh:addTriangle( iter+1, iter+2, iter+3 )       
    end
    
    -- define table of fishies
    fishTable = {}
    -- define some fish
    for i = 1, 10 do
        fishTable[i] = fish() 
    end
    
    -- define fish params
    fishParams = {}
    for i = 1, 10 do
        local tab = {}
        tab[1] = math.random(1,10)
        tab[2] = math.random(10,h/2)
        tab[3] = math.random(10,w/4)
        tab[4] = math.random(1, h/8 )
        tab[5] = math.random(0, w)
        tab[6] = math.random(-10,10)
        tab[7] = math.random(0,h)
        fishParams[i] = tab
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
    
    -- color stuff
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    of.setColor(fg)
    
    for i = 1, 10 do
        fishTable[i].step = fishParams[i][1] * knob1
        fishTable[i].amp = fishParams[i][2]
        fishTable[i].size = fishParams[i][3]
        fishTable[i].thick = fishParams[i][4]
        fishTable[i].xOffset = fishParams[i][5]
        modd = fishParams[i][6]
        fishTable[i].yOffset = fishParams[i][7]
        
        modCol:setHsb( fg:getHue()+modd, fg:getSaturation(), fg:getBrightness())
        of.setColor( modCol )
        fishTable[i]:update()
    end
    
end

---------------------------------------------------------------------------
-- make a fish
function fish()
    local self = {}
    self.xOffset = 0         -- offset X
    self.yOffset = 0        -- offset Y
    self.count = self.xOffset  -- count
    self.step = 0           -- step
    self.amp = 0            -- how loud
    self.size = 10          -- how long x axis
    self.thick = 10         -- line thickness
    self.yPos = self.yOffset           -- y position
    
    
    self.soundTab = {}
    for i = 1, globPoints do
         self.soundTab[i] = 0
    end
    
    function self.update()
        -- basic loop
        if ( self.count >= w+self.size ) then
            self.count = 0 
            self.yPos = math.random(0,h)    -- set random y position
        else
            self.count = self.count + self.step
        end
        -- update the sound table
        if ( self.count >= 0 and self.count <= self.size ) then
            local iter = math.floor( (self.count / self.size) * 50 )
            local wow = inL[1]
            self.soundTab[iter+1] = wow
        end
        
        -- draw the fish
        ---- draw the vertices
        for i = 0, globPoints-1 do
            local iter = i*2
            local xPos = w - self.count
            local xStep = i * (self.size/globPoints) 
            local yMod = self.soundTab[i+1] * self.amp
            mesh:setVertex( iter, glm.vec3( (xPos+xStep), (self.yPos-(self.thick/2)) + yMod, 0) )
            mesh:setVertex( iter+1, glm.vec3( (xPos+xStep), (self.yPos+self.thick/2) + yMod, 0) )        
        end
        
        mesh:draw()
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