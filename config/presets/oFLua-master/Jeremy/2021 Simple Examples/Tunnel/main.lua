-- Tunnel
require("eyesy")                    -- include the eyesy library
modeTitle = "Tunnel"                -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
count = 0
theCircles = {}
modForLoop = 0
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    avgTable = {}
    theAvg = averageInL(60)
    theCam = of.Camera()
    theCam:setFarClip( -8000 )
    for i = 1, 10 do
        theCircles[i] = circle( w/2, h/2, w, i/10)
    end  
    
    bg = of.Color()
    fg = of.Color()
    newColor = of.Color()
    cyl1 = of.CylinderPrimitive()
    theLight = of.Light()        -- define light class
    theLight:setup()         -- start the light
	theLight:setPointLight( )-- we use a point light here
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	theLight:setPosition( 0, h , 0 )           -- set light position, change x
    of.enableDepthTest()
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
    
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    avgTable = theAvg:update()                          -- this fills a table called avgTable
    
    theCam:setPosition( w/2, h/2, knob1*2400 )            -- set camera position, change z
    
    theCam:beginCamera()
    theLight:enable()
    colorPickHSB( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
    cyl1.setResolution(cyl1,30,1,2)
    rater = knob2 * 0.01                      -- set rate of animation as variable
    
    of.pushMatrix()
    
    k3 = (knob3*w) 
    
    for i = 1, 10 do
        sound = avgTable[i*3] *(h/2)
        
        theCircles[i].xWarp = k3
        theCircles[i].audio = sound
        theCircles[i].rate = rater
        theCircles[i].makeCircle()
    end
    theLight:disable()
    theCam:endCamera()
    
    of.popMatrix()
end

---------------------------------------------------------------------------
-- circle OOP function
function circle( x, y, maxSize, modd )
    local self = {}
    self.xPos = x
    self.yPos = y
    self.maxSize = maxSize
    self.count = 0
    self.rate = 0
    self.mod = modd or 0
    self.hue = math.random(0,255)
    self.zPos = 0
    self.audio = 0
    self.xWarp = 0
    function self.makeCircle()
       
       if( self.count > 1) then
            self.count = 0
            self.hue = math.random(0,255)
        end
        
        self.count = self.count + self.rate
        local modder = ( self.count + self.mod ) % 1
        local xModder = (1 - math.pow( self.count, 1)) * self.xWarp
        newColor:setHsb( self.hue, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( newColor )
        
        of.pushMatrix()
        of.translate(self.xPos, self.yPos, (modder*self.maxSize)+self.audio )
        of.rotateXDeg(90)
        cyl1.setCapped(cyl1,false)
        cyl1.draw(cyl1)
        of.popMatrix()
    end
    
    return self
end
---------------------------------------------------------------------------
-- average the audio buffer
function averageInL( amt )      -- this oop averages each audio buffer point
    local self = {}
   
    amount = amt or 10              -- how many loops to average
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

------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end