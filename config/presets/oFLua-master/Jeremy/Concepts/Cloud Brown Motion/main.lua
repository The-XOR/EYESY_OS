require("eyesy")
modeTitle = "Cloud"
print(modeTitle)
------------------------- based on the Sound Jaws mode for etc. also trying a smoother

w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
wT4 = w * 4                 -- width times 4
wT2 = w * 2                 -- width times 2
c = glm.vec3( w2, h2, 0 )   -- center in glm vector
h8 = h / 8                  -- 8th of the height
h8t3 = h8 * 3               -- h8 * 3 (3/4ths)

itsPeaked = 0
timerSwitch = 0
restTimer = 0
trigger = 0

myMesh = of.Mesh()          -- define Mesh
myCam = of.Camera()         -- define camera class
myLight = of.Light()        -- define light class
myIco = of.IcoSpherePrimitive() -- define icosphere

bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

----------------------------------------------------
function setup()
    myCam:setPosition( c )  -- set the first position, changes later
    myCam:lookAt( c )       -- the camera looks at the center
    of.enableLighting()     -- enable lighting in the scene
	of.enableDepthTest()    -- enable depth
	myIco:setPosition( 0,0,0 )      -- set the position of icoSphere
    myIco:setRadius( 200 )          -- and the first radius
	
	of.enableBlendMode( of.BLENDMODE_ALPHA )
	
	myLight:setup()         -- start the light
	myLight:setPointLight( )-- we use a point light here
	myLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	myMesh:setMode(of.PRIMITIVE_LINE_LOOP)    -- set mesh mode
	
	myMesh = myIco:getMesh()        -- get the icosphere as a mesh, so we can get vertex
    cloudPoints = {}            -- define a global table to store the points for the Spheres
    cloudPoints = cloudTab( 50, h2, knob2 )
    
    --------------------------------------------------- 
    avg = averageInL( 5 )        -- define the class 

    motionx = brownianMotion( 0, 1, 1, 60, 2, 360 )
    motiony = brownianMotion( 0, .1, 1, 60, 2, 360 )
    motionz = brownianMotion( 0, 1, 1, 60, 2, 360 )
    
    
    print("done setup")     -- so we know that the setup was succesful
end

----------------------------------------------------
function update()
    ---------------------- audio trigger with recovery and delay
    if( itsPeaked == 0 ) then
        if( avG() > 0.2 ) then 
            itsPeaked = 1
            of.resetElapsedTimeCounter()
            trigger = 1
            timerSwitch = 1
            
        end
    else
        if( timerSwitch == 1 ) then
            restTimer = of.getElapsedTimeMillis()
        end
        
        if( restTimer > 150 or avG() < 0.1 ) then
            itsPeaked = 0
            restTimer = 0
            timerSwitch = 0
        end
    end
    
    
    
    if( trigger == 1 ) then
        cloudPoints = cloudTab( 50, h2 )
    end
    trigger = 0
end
----------------------------------------------------
function draw()
    
    avgTable = avg.update()         -- this fills a table called avgTable
    
    rotSpeedx = motionx.update()
    rotSpeedy = motiony.update()
    rotSpeedz = motionz.update()

    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for fg
    colorPickHsb( knob5, bg )       -- color for background, see above for ofColor class
    of.setBackgroundColor( bg )     -- set the bg color 
  
    ------------------------- set Camera and Light Position
    myCam:setPosition( w2, h2, (knob1*wT2)+h8 ) -- set camera position, change z
    myLight:setPosition( wT4, h , w )           -- set light position, change x
    
    --------------------- 
    
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
        
        of.pushMatrix()    
        of.translate( w2, h2)
        
        of.rotateRad( (rotSpeedx/360)*6.28, 1, 0, 0 )
        of.rotateRad( (rotSpeedy/360)*6.28, 0, 1, 0 )
        of.rotateRad( (rotSpeedz/360)*6.28, 0, 0, 1 )

        drawClouds( 50, knob3*h2, knob2 )    
        of.popMatrix()
            
           
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
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

-- fill a table with random vertex points within a a sphere
function cloudTab( amount, maxR )
    local tab = {}
    for i = 1, amount do
        randR = math.random( 1, maxR )
        myIco:setRadius( randR )
        myMesh = myIco:getMesh()
        size = myMesh:getVertices():size()
        randM = math.random( 0, size )
        theVertex = myMesh:getVertex( randM )
        tab[i] = theVertex
    end
    return tab
end

function colorPickHsb( knob, name )
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

---------------- function to draw cloud
function drawClouds( amount, radius, transL )
    minR = radius/4
    for i = 1, amount do
        theVertex = cloudPoints[i]
        aud = avgTable[ i ]
        trans = (aud * (transL * 245) ) + 10
        negTrans = 255 - trans
        r = (aud * radius) + minR
        of.setColor( fg, negTrans)
        of.drawIcoSphere( theVertex, r)
    end
end

--------------- average the audio buffer
function averageInL( amt )      -- this oop averages each audio buffer point
    local self = {}
   
    amount = amt or 10
    self.amtMin = math.max( amount, 1 )
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
            countTab[i][self.count] =  inL[i] 
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
------------------------------------ function for audio average
function avG()  
    a = 0
    for i = 1, 100 do
        aud = math.abs( inL[i] )
        a = a + aud
    end
    x = a / 100
    if( x <= 0.001 ) then
        x = 0
    else
        x = x
    end
    return  x
end  

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end