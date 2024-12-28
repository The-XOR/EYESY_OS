-- S - LineScope Freeze
require("eyesy")                    -- include the eyesy library
modeTitle = "S - LineScope Freeze"  -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
w4 = w * 4
globDepth = h*4
maxAmt = 50
globSpace = globDepth / maxAmt
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    theCam = of.Camera()
    
    linesTable = {}
    for i = 1, maxAmt do 
        linesTable[i] = lines(50,(1/50)* i)
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
    mainLine = of.Polyline()
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    globDepth = knob3* (h*8)
    colorPickHSB( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )
    
    rater = math.pow( knob1 * 0.2, 2)
    theCam:setPosition( w/2, h/2, h)            -- set camera position, change z
    theLight:enable()
    theCam:beginCamera()
    of.setColor(fg)
    
    of.setLineWidth(10)
    
    of.pushMatrix()
    of.translate(0,h/2)
    of.rotateXDeg(knob2*360)
    
    
    for i = 1, 50 do
        linesTable[i].rate = rater
        linesTable[i].makeLine()
    end
    
    for i = 0, 20 do
        mainLine:addVertex( glm.vec3( i*(w/20), inL[(i+1)*5] * h, 0) )
    end
    mainLine:draw()
    mainLine:clear()
    
    
    theLight:disable()
    theCam:endCamera()
    of.popMatrix()
    
end

---------------------------------------------------------------------------
-- circle OOP function
function lines( amt, modd )
    local self = {}
    self.amt = amt or 1
    self.mod = modd or 0
    self.sound = 0
    self.xPos = 0
    self.yPos = 0
    self.zPos = 0
    self.count = 0
    self.rate = 0
    self.place = 0
    self.line = of.Polyline()
    self.modCompare = 0
    self.color = math.random(0,20)
    self.colCount = 0
    self.freezeTable = {}
    for i = 1, 20 do
        self.freezeTable[i] = 0
    end
    function self.makeLine()
       
        if( self.count > 1) then
            self.count = 0
        end
        
        self.count = self.count + self.rate
        local modder = (self.count + self.mod) % 1
        
        if(modder < self.modCompare ) then
            
            self.color = math.random(0,20) 
            
            for i = 1, 20 do
                self.freezeTable[i] = inL[i*5] * h
            end
        end
        self.modCompare = modder
        modCol:setHsb( ( self.color+fg.getHue(fg) ) % 255, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( modCol )
        
        for i = 0, 19 do
            self.line:addVertex( glm.vec3( (w/19)*i, self.freezeTable[i+1], modder * globDepth) )
        end
        
        self.line:draw()
        self.line:clear()
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