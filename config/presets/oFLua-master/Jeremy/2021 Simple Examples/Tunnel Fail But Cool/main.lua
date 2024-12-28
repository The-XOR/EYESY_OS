-- Tunnel Fail
require("eyesy")                    -- include the eyesy library
modeTitle = "Tunnel Fail"                -- name the mode
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
    for i = 1, 20 do
        theCircles[i] = circle( w/2, h/2, h, i/20)
    end  
    
    bg = of.Color()
    fg = of.Color()
    newColor = of.Color()
    cyl1 = of.CylinderPrimitive()
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
    of.setBackgroundColor( bg )                 -- set the bg color 
    cyl1.setResolution(cyl1,50,5,2)
    of.setColor(200,100,210)
    rater = knob2 * 0.01                      -- set rate of animation as variable
    
    of.pushMatrix()
    of.translate(0,0)
    
    for i = 1, 20 do
        sound = (inL[i*3] * (h/2)) + (h/2)
        
        --theCircles[i].zPos = sound
        theCircles[i].rate = rater
        theCircles[i].makeCircle()
    end
    
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
    
    function self.makeCircle()
       
       if( self.count > 1) then
            self.count = 0
            self.hue = math.random(0,255)
        end
        
        self.count = self.count + self.rate
        local modder = ( self.count + self.mod ) % 1
        
        newColor:setHsb( self.hue, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( newColor )
        
        of.pushMatrix()
        of.translate(self.xPos, self.yPos, (math.pow(modder,1)*self.maxSize)+self.zPos )
        of.rotateXDeg(90)
        cyl1.setCapped(cyl1,false)
        cyl1.draw(cyl1)
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
    print("script finished")
end