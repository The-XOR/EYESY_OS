-- S - Circle Scope Frz Rotate
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Circle Scope Frz Rotate"  -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
w4 = w * 4
globDepth = h*4
maxAmt = 50
circleRez = 25
globSpace = globDepth / maxAmt

---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    theCam = of.Camera()
    centerNode = of.Node()
    theSlide = slider( .01 )
    theSlide.current = knob2*180
    
    slideTwo = slider( .01 )
    
    
    linesTable = {}
    
    for i = 1, maxAmt do 
        linesTable[i] = circles(maxAmt,(1/maxAmt)* (i-1), circleRez )
    end  
    
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    theLight = of.Light()           -- define light class
    theLight:setup()                -- start the light
	theLight:setPointLight( )       -- we use a point light here
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	
	   
    of.enableDepthTest()
    of.enableBlendMode( of.BLENDMODE_ALPHA )
    
    mainLine = of.Polyline()
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end
---------------------------------------------------------------------------
-- the draw loop
function draw()
    
    slideTwo.target = math.pow( knob3, 2  ) * (h*8)
    globDepth = slideTwo:update()
    
    colorPickHSB( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )
    
    rater = math.pow( knob1 * 0.2, 2)
    theCam:setPosition( w/2, h/2, h/4)            -- set camera position, change z
    theLight:setPosition( w/2, h , globDepth/2 )           -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    of.noFill()
    
    of.setColor(fg)
    
    of.setLineWidth( 10 )
    
    of.pushMatrix()
    of.translate( w/2,h/2 )
    theSlide.target = knob2*180
    of.rotateXDeg( theSlide:update() )
    
    
    for i = 1, maxAmt do
        linesTable[i].rate = rater
        linesTable[i].makeLine()
    end
    
    
    
    for i = 0, circleRez do
        if( i == circleRez ) then
            i = 0
        else
            i  = i
        end
        local audio = math.abs( inL[i+1] )
       
        local step = (i/circleRez)
        local xIter = math.cos( step  * 6.28)  
        local yIter = math.sin( step  * 6.28) 
        local pointMax = glm.vec3( xIter*h, yIter*h, 0 )
        local pointMin = glm.vec3( xIter*h/8, yIter*h/8, 0 )
        mainLine:addVertex( glm.vec3( (pointMax.x*audio) + pointMin.x, (pointMax.y*audio) + pointMin.y, 0 ) )
        
    end
    
    mainLine:close()
    
    of.pushMatrix()
    
    of.setColor( fg )
    mainLine:draw()
    mainLine:clear()
    
    
    theLight:disable()
    theCam:endCamera()
    
    of.popMatrix()
    
end

---------------------------------------------------------------------------
-- circle OOP function
function circles( amt, modd, rez )
    local self = {}
    self.amt = amt or 1
    self.mod = modd or 0
    self.rez = rez or 20
    self.sound = 0
    self.xPos = 0
    self.yPos = 0
    self.zPos = 0
    self.count = 0
    self.rate = 0
    self.place = 0
    self.line = of.Polyline()
    self.modColor = of.Color()
    self.modCompare = 0
    self.modder = 0
    self.color = math.random(0,20)
    self.colCount = 0
    self.freezeTable = {}
    
    --fill freeze Table
    for i = 1, self.rez+1 do
        self.freezeTable[i] = 0
    end
    
    -- draw function and run the count
    function self.makeLine()
       
        if( self.count > 1) then
            self.count = 0
        end
        
        self.count = self.count + self.rate
        self.modder = (self.count + self.mod) % 1
        
        if( self.modder < self.modCompare ) then
            self.color = math.random(0,20) 
            
            for i = 1, self.rez+1 do
                self.freezeTable[i] = math.abs( inL[i] )
            end
        end
        
        self.modCompare = self.modder
        self.modColor:setHsb( ( self.color+fg.getHue(fg) ) % 255, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( self.modColor.r, self.modColor.g, self.modColor.b, math.max( (1-self.modder)*255, 1) )
        
        for i = 0, self.rez do
            if( i == circleRez ) then
                i = 0
            else
                i  = i
            end
            
            local aud = self.freezeTable[ i+1 ]
            
            local xIter = math.cos( ((i/self.rez)*6.28) )  
            local yIter = math.sin(  ((i/self.rez)*6.28) ) 
            local pointMax = glm.vec3( xIter*h, yIter*h, 0 )
            local pointMin = glm.vec3( xIter*h/8, yIter*h/8, 0 )
            self.line:addVertex( glm.vec3( (pointMax.x*aud) + pointMin.x, (pointMax.y*aud) + pointMin.y, self.modder * (globDepth-4) ) )
        end
        
        self.line:close()
        self.line:draw()
        self.line:clear()
        
    end
    
    return self
end
---------------------------------------------------------------------------
-- average the audio buffer
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