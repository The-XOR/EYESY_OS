---- GRADIENT CRYSTAL CUBE
require("eyesy")                    -- include the eyesy library
modeTitle = "GRADIENT CRYSTAL CUBE" -- name the mode
print(modeTitle)                    -- print the mode title

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()           -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()          -- height of screen, same as above but height
w2 = w / 2                  -- width half 
h2 = h / 2                  -- height half
w4 = w / 4                  -- width quarter
h4 = h / 4                  -- height quarter
c = glm.vec3( w2, h2, 0 )   -- center in glm vector

gRid = 10
xSpace = w / ( gRid-1 )
ySpace = h / ( gRid-1 )

capture = 0
captured = 0
freezeIt = 0
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    bg = of.Color()
    fg = of.Color()
    
    smoothIn = averageInL( 6 )                      -- define global table of smoothed audio buffer 
    myFreeze = tabFreeze()
    
    ----------------- frame buffer
    myFbo = of.Fbo()                                -- define a frame buffer to make texture for cube
    myFbo:allocate( w, h)             -- then we need to 'allocate' space for the fbo, define the size
    
    --------- we also need a texture class which also calls for allocation
    myPix = of.Pixels()                         -- define pixels class
    myPix:allocate( w, h, of.PIXELS_RGBA )      -- allocate pixels first    
    myTex = of.Texture()                        -- define texture class
    myTex:allocate( myPix )                     -- allocate w and h and type of pixels
    ------------------------- mesh
    
    myMesh = of.Mesh()
    myMesh:setMode( of.PRIMITIVE_TRIANGLES )        -- set the mesh mode to triangles
    
    for i = 0, gRid-1 do
        xPos = i * xSpace
        for j = 0, gRid-1 do
            yPos = j * ySpace
            
            myMesh:addVertex( glm.vec3( xPos, yPos, 0) )    -- add first vertex
            myMesh:addColor( of.FloatColor( 1,0,0 ) )       -- make it blue
        end
    end
    
    for x = 0, gRid-2 do
        
        for j = 0, gRid-2 do
           
            i = (x*gRid) + j
            myMesh:addIndex( i )
            myMesh:addIndex( i+1 )
            myMesh:addIndex( i+gRid )
        
            myMesh:addIndex( i+(gRid+1) )
            myMesh:addIndex( i+1 )
            myMesh:addIndex( i+gRid )
        end
    end
    
    of.enableBlendMode( of.BLENDMODE_ALPHA )
    of.enableDepthTest()            -- enable 3D rendering globally
    of.enableAlphaBlending()
    
    rotX = brownianMotion( 0, 0.6, 5, 45, 2, 360 )
    rotY = brownianMotion( 0, 0.2, 5, 45, 2, 360 )
    rotZ = brownianMotion( 0, .6, 5, 45, 2, 360 )
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
    
    
    
    
    
    --------------------------------- draw in to the frame buffer
    myFbo:beginFbo()
        
        
        of.clear( 255, 255, 255, 0 )              -- clear the buffer, white-opaque
        
        intense = math.pow( knob1, 2 ) * 20
   
        maxG = math.floor( (gRid) * (gRid) )
    
        for i = 0, maxG-1 do
        
            audio = avgTable[ (i%100)+1 ] * intense
        
            color = of.FloatColor()
       
            color:setHsb(  fg:getHue()/255,
                           fg:getSaturation()/255,
                           fg:getBrightness()/255,
                           knob3 - audio
                        )
        
        
            myMesh:setColor( i, color )
        end
        
        myMesh:draw()                           -- draw the mesh    
        myTex:loadScreenData( 0, 0, w, h)       -- capture the entire scene to myTex
    myFbo:endFbo()                              -- end the fbo
    
    
    of.translate( c )
    
    of.translate( 0,0, -(knob2*2000) )
    of.rotateDeg( rotX.update(), 1, 0, 0 )
    of.rotateDeg( rotY.update(), 0, 1, 0 )
    of.rotateDeg( rotZ.update(), 0, 0, 1 )

    ------------------------------- bind fbo to the cube
    myTex:bind()
        of.drawBox( glm.vec3(0,0,0), w2 )
    myTex:unbind()
end

-- a brownian OOP object that changes speeds over time, loosely basedd on brownian motion
function brownianMotion( minSpeed, maxSpeed, minTime, maxTime, direction, countMax )
    local self = {}
    
    ----------------------------------- parameters
    self.minSpd = minSpeed or 0                         -- min speed of the count, in frames
    self.maxSpd = maxSpeed or 10                        -- max speed of the count
    self.minT = minTime or 1                            -- min time for a movement, in seconds
    self.maxT = maxTime or 20                           -- max time for a movement, in seconds
    self.dir = direction or 2                           -- direction of count, 
                                                        -- 0=negative, 1=positive, 2=omni
    self.cMax = countMax or 360                         -- count (loop) length, 360 default

    ----------------------------------- variables
    local count = 0                                     -- output count
    local countStep = 1                                 -- speed of the count
    local countDir = 1                                  -- direction of count
    
    local tCount = 0                                    -- time count
    
    local spdCount = 0                                  -- speed step
    local spdSpeed = 0                                  -- speed that speed increases
    local spdStep = 0                                   -- speed that builds for count

    local newMove = 0                                   -- new movement?                                                                  
    local targetSpd = 0                                 -- target speed
    local transTime = 0                                 -- transition time
    local moveTime = 0                                  -- time for movement
    local targSpdDir = 0                                -- speed count direction
    local powSpdStep = 0
    local moveMath = 0 
    local transMath = 0
    local targetSpdMath = 0
    ----------------------------------- functions
    function self.update()
        if( newMove == 0 ) then                         -- if there is no new Movement then...
            
            -- set new direction
            if( self.dir == 0 ) then
                countDir = -1
            elseif( self.dir == 1 ) then
                countDir = 1
            else
                local randDir = math.random( 1, 2 )
                if( randDir == 1 ) then
                    countDir = -1
                else
                    countDir = 1
                end
            end
        
            -- make new speed and see what direction to go with new target speed
                                        
            targetSpdMath = math.random( 0, 1000 ) / 1000     -- set random target speed
            targetSpd = (targetSpdMath * (self.maxSpd-self.minSpd) ) + self.minSpd
            
            
            if( countStep < targetSpd ) then
                targSpdDir = 1
            elseif( countStep > targetSpd ) then
                targSpdDir = -1
            else
                targSpdDir = 0
            end
            
            -- create new time for the transition 
            transMath = math.random( self.minT, self.maxT )   -- set random trans time
            transTime = math.floor( transMath * 60 )                -- times by frame/sec 60 fps
            
            -- create a new time for the movement, how long it holds at new speed
            moveMath = math.random( self.minT, self.maxT )    -- set random time for hold
            moveTime = math.floor( moveMath * 60 )                  -- times by frame/sec 60 fps
            
            spdCount = 0                                            -- restart speed count
            spdStep = 1 / transTime                                 -- step over time to get to target
            tCount = 0                                              -- start new count
            newMove = 1                                             -- there is a new movement
        end
        
        if( newMove == 1 ) then                         -- if there is a new Movement then...
            tCount = tCount + 1                                 -- count frames
            
            -------------- count the transition time
            if( tCount <= transTime ) then
                
                spdCount = spdCount + spdStep                               -- grow speed from 0
                --powSpdStep = math.pow( math.min( spdCount, 1 ), 2 )   -- step to the power of 2  
                countStep = targetSpd * (spdCount * targSpdDir )         -- update the countStep
            end
            
            if( (tCount-transTime) >= moveTime ) then
                newMove = 0
            end
                                                
            
        end
        
        if( count > self.cMax ) then
            count = 0
        elseif( count < 0 ) then
            count = 360
        end
        
        count = count + ( countStep * countDir)
        
        -- this function update() return the count
        return count                                
        
    end
    
    return self                                         -- OOP return
    
end

---------------------------------------------------------------------------------------------------
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

---------------------------------------------- this is how the knobs pick color
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