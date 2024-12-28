---- GRADIENT CRYSTALS
require("eyesy")                        -- include the eyesy library
modeTitle = "GRADIENT CRYSTALS"         -- name the mode
print(modeTitle)                        -- print the mode title

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                       -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                      -- height of screen, same as above but height
w2 = w / 2                              -- width half 
h2 = h / 2                              -- height half
w4 = w / 4                              -- width quarter
h4 = h / 4                              -- height quarter
gridChange = 0                          -- variable to comparte if mesh grid size changed


---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    bg = of.Color()                                 -- background color class
    fg = of.Color()                                 -- foreground color class
    
    smoothIn = averageInL( 6 )                      -- define global table of smoothed audio buffer 
    myFreeze = tabFreeze()
    
    of.enableBlendMode( of.BLENDMODE_ALPHA )        -- alpha blend mode on
    
    ------------------------- mesh
    myMesh = of.Mesh()                              -- make a mesh class
    myMesh:setMode( of.PRIMITIVE_TRIANGLES )        -- set the mesh mode to triangles
end

---------------------------------------------------------------------------
function update()
end

---------------------------------------------------------------------------
function draw()
    
    avgTable = smoothIn.update()                -- this fills a table called avgTable
    myFreeze.freeze( avgTable, trig )
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
    
    gridSize = math.floor( (knob2*30) + 4 )     -- set the grid size of the mesh
    intense = math.pow( knob1, 2 ) * 20         -- adjust opacity intesity
    
    if( gridSize ~= gridChange ) then           -- if gridSize has changed...
        myMesh:clear()                          -- clear old mesh
        makeMesh( gridSize, w, h, myMesh  )     -- write new one
        gridChange = gridSize                   -- new grid size to compare
    end
    
    for i = 0, gridSize-1 do                    -- for loop to adjust color
        for j = 0, gridSize-1 do
        
            count = (j * gridSize ) + ( (i + j) % gridSize)     -- skew the count
            audio = avgTable[ (count%100)+1 ] * intense         -- get the audio level
            color = of.FloatColor()                             -- define a color class
            -- set a new alpha value
            color:setHsb(  fg:getHue()/255,
                           fg:getSaturation()/255,
                           fg:getBrightness()/255,
                           knob3 - audio
                        )
            myMesh:setColor( count, color )                     -- reset the color at this point
        end
    end
    
    myMesh:draw()                                               -- draw the mesh             
end

---------------------------------------------------------------------------------------------------
-- this is how the knobs pick color
function colorPickHsb( knob, name )
    -- middle of the knob will be bright RBG, far right white, far left black
    
    k6 = (knob * 5) + 1                     -- split knob into 8ths
    hue = (k6 * 255) % 255 
    kLow = math.min( knob, 0.49 ) * 2       -- the lower half of knob is 0 - 1
    kLowPow = math.pow( kLow, 2 )
    kH = math.max( knob, 0.5 ) - 0.5    
    kHigh = 1 - (kH*2)                      -- the upper half is 1 - 0
    kHighPow = math.pow( kHigh, 0.5 )
    
    bright = kLow * 255                     -- brightness is 0 - 1
    sat = kHighPow * 255                    -- saturation is 1 - 0
    
    name:setHsb( hue, sat, bright )         -- set the ofColor, defined above
end

-----------------------------------------------------------
function tabFreeze() -- OOP function to freeze an updated table
    local self = {}
    
    local capture = 0
    local freezeIt = 0
    local freezeTab = {}
    
    function self.freeze( tab2freeze, trigger )
        if( trigger == true ) then
            if( capture == 0 and freezeIt == 0 ) then 
                capture = 1
                freezeIt = 1
            end
            if( capture == 0 and freezeIt == 1 ) then
                capture = 0
                freezeIt = 0
            end
        end
        
        if( capture == 1 ) then
            for i = 1, 100 do
                freezeTab[i] = tab2freeze[i]
            end
            capture = 0
        end
    
        if( freezeIt == 1 ) then
            for i = 1, 100 do
                tab2freeze[i] = freezeTab[i]
            end
        end
    end
    return self
end
------------------------------------------- function to redraw mesh
function makeMesh( size, width, height, mesh )
    xSpace = width / (size-1)                           -- get width
    ySpace = height / (size-1)                          -- get height
    for i = 0, size-1 do                                -- for loop to add all the vertices
        xPos = i * xSpace
        
        for j = 0, size-1 do
            yPos = j * ySpace
            mesh:addVertex( glm.vec3( xPos, yPos, 0) )    -- add first vertex
            mesh:addColor( of.FloatColor( 1,0,0 ) )       -- make it blue
        end
    end
    
    for x = 0, size-2 do                                -- for loop to connect the vertices
        for j = 0, size-2 do
           
            i = (x*size) + j
            mesh:addIndex( i )
            mesh:addIndex( i+1 )
            mesh:addIndex( i+size )
        
            mesh:addIndex( i+(size+1) )
            mesh:addIndex( i+1 )
            mesh:addIndex( i+size )
        end
    end
    
end

------------------------------------------- average the audio buffer
function averageInL( amt )      -- this oop averages each audio buffer point
    local self = {}
   
    self.amount = amt or 10              -- how many loops to average
    self.amtMin = math.max( self.amount, 1 )
    self.count = 1
    
    local countTab = {}             -- make a table with 100 tables with the amount size
    for i = 1, 100 do               
        countTab[i] = {}
        for j = 1, self.amtMin do
            countTab[i][j] = 0
        end
    end
    
    local averageTab = {}           -- make a table with 100 numbers
    for i = 1, 100 do               
        averageTab[i] = 0
    end
    
    
    function self.update()
        if( self.count > self.amtMin ) then
            self.count = 1
        else
            self.count = self.count + 1
        end
        for i = 1, 100 do
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
  

------------------------------------ the exit function ends the update and draw loops
function exit()
    of.disableBlendMode()
    -- so we know the script is done
    print("script finished")
end