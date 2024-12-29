-- S - Tunnel Freeze
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Tunnel Freeze"     -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
maxObj = 60
theDepth = h/2
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    theCam = of.Camera()
    tubeTable = {}
    theCyl = of.CylinderPrimitive()
    theCyl:setCapped(false)
    theCyl:setHeight(theDepth/(maxObj*1.05) )
    theCyl:setResolution( 30, 10, 10)
    theCyl:setPosition( glm.vec3( 0,0,0 ) )

    
    for i = 1, maxObj do 
        tubeTable[i] = tubes( w/2, h/2, (1/maxObj)* i )
    end  
    
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    theLight = of.Light()        -- define light class
    theLight:setup()         -- start the light
	theLight:setPointLight( )-- we use a point light here
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	theLight:setPosition( w/2, h , 0 )           -- set light position, change x
    of.enableDepthTest()
    
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    colorPickHSB( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )
    k2Rot = knob2 * 360
    rater = math.pow( knob1 * -0.2, 2)
    theCam:setPosition( w/2, h/2, theDepth)            -- set camera position, change z
    theLight:enable()
    theCam:beginCamera()
    of.setColor(fg)
    
    for i = 1, maxObj do
        tubeTable[i].rate = rater
        tubeTable[i].makeTube()
    end
    
    of.pushMatrix()
    
    of.translate( w/2, (inL[1]*h) + (h/2), 0 )
    of.rotateXDeg(90)
    of.rotateZDeg( k2Rot )
    theCyl:draw()
        
    of.popMatrix()
    
    theLight:disable()
    theCam:endCamera()
    
    
end

---------------------------------------------------------------------------
-- tube OOP function
function tubes( x, y, modd )
    local self = {}
    
    self.mod = modd or 0
    
    self.xPos = x
    self.yPos = y
    self.zPos = 0
    self.count = 0
    self.rate = 0
    self.place = 0
    
    self.modCompare = 0
    self.color = math.random(0,255)
    self.colCount = 0
    
    self.tabMod = 0
    self.freeze = 0
    self.rotFreeze = 0
    
    function self.makeTube()
       
        if( self.count > 1) then
            self.count = 0
        end
        
        self.count = self.count + self.rate
        local modder = (self.count + self.mod) % 1
        
        if(modder < self.modCompare ) then
            
            self.color = ( fg.getHue(fg) + math.random(0,20) ) % 255
            self.tabMod =  math.floor( (modder*99) + 1)
            self.freeze = inL[ 1 ] * h
            self.rotFreeze = k2Rot
            
        end
        self.modCompare = modder
        modCol:setHsb( self.color, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( modCol )
        
        
        of.pushMatrix()
        
        of.translate( self.xPos, self.freeze + (h/2), modder * theDepth )
        of.rotateXDeg(90)
        of.rotateZDeg(self.rotFreeze)
        theCyl:draw()
        
        of.popMatrix()
        
        
    
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
    theLight:disable()
    theCam:endCamera()
    print("script finished")
end