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

myMesh = of.Mesh()          -- define Mesh
myCam = of.Camera()         -- define camera class
myLight = of.Light()        -- define light class
myIco = of.IcoSpherePrimitive() -- define icosphere

bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class

cloudPoints = {}            -- define a global table to store the points for the Spheres
--------------------------------------------------- 

    -- local functions
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
function drawClouds( amount, radius )
    minR = radius/4
    for i = 1, amount do
        theVertex = cloudPoints[i]
        aud = avgTable[ i ] * 4
        trans = (aud * 200) + 55 
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
   avg = averageInL( 6 )        -- define the class 
----------------------------------------------------
function setup()
    myCam:setPosition( c )  -- set the first position, changes later
    myCam:lookAt( c )       -- the camera looks at the center
    of.enableLighting()     -- enable lighting in the scene
	of.enableDepthTest()    -- enable depth
	myIco:setPosition( 0,0,0 )      -- set the position of icoSphere
    myIco:setRadius( 200 )          -- and the first radius
	
	myLight:setup()         -- start the light
	myLight:setPointLight( )-- we use a point light here
	myLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	myMesh:setMode(of.PRIMITIVE_LINE_LOOP)    -- set mesh mode
	
	myMesh = myIco:getMesh()        -- get the icosphere as a mesh, so we can get vertex
    
    
    print("done setup")     -- so we know that the setup was succesful
end
----------------------------------------------------
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

cloudPoints = cloudTab( 50, h2 )
----------------------------------------------------
function update()
    if(knob2 > 0.99) then
        cloudPoints = cloudTab( 50, h2 )
    end
end
----------------------------------------------------
function draw()
    
        
    avgTable = avg.update()         -- this fills a table called avgTable
    
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
        of.rotateRad( knob3*6.28, w2, h2, 0 )
        drawClouds( 50, h8)    
        of.popMatrix()
            
           
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end