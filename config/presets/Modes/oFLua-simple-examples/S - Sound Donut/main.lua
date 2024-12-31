-- S - Sound Donut
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Sound Donut"       -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
w4 = w * 4
globDepth = h*4
maxAmt = 30
circleRez = 14
globSizeMax = h*2
globSizeMin = h/4
---------------------------------------------------------------------------
-- helpful global variables 
function setup()
    theCam = of.Camera()
    centerNode = of.Node()
    theSlide = slider( .01 )
    theSlide.current = knob2*180
    
    theSlide2 = slider( .01 )
    theSlide2.current = knob2*180
    
    theSlideY = slider( .01 )
    theSlideY.current = knob3*180
    
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
    
    theSlideY.target = (knob3 * (w*3)) + 10
    local sizeStuff = theSlideY:update()
    globSizeMax = sizeStuff
    globSizeMin = sizeStuff / 8
    globDepth = theSlide2:update()
    
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    
    k1Raw = math.abs( (knob1 * 0.2) - 0.1 )
    rater = math.pow( k1Raw, 2 )
    
    if( knob1 > 0.5 ) then
        k1Direction = 1
    else
        k1Direction = -1
    end
    
    theCam:setPosition( w/2, h/2, w*2)              -- set camera position, change z
    theLight:setPosition( w/2, h , globDepth/2 )    -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    of.noFill()
    
    of.setColor(fg)
    
    of.setLineWidth( 2 )
    
    
    theSlide.target = knob2*180
    of.pushMatrix()
    of.translate( w/2, h/2)
    -- this is the x rotation
    of.rotateXDeg( theSlide:update() )
    --of.rotateZDeg( theSlideY:update() )
    
    for i = 1, maxAmt do
        linesTable[i].rate = rater
        linesTable[i].direction = k1Direction
        linesTable[i].makeLine()
    end
    
    
    of.translate( h+(w/4), 0 )
    
    for i = 0, circleRez do
        if( i == circleRez ) then
            i = 0
        else
            i  = i
        end
        local audio = math.abs( inL[  (i+1) * math.floor(100 / circleRez) ] )
       
        local step = (i/circleRez)
        local xIter = math.cos( step  * 6.28 )  
        local yIter = math.sin( step  * 6.28 ) 
        local pointMax = glm.vec3( xIter*(globSizeMax), yIter*(globSizeMax), 0 )
        local pointMin = glm.vec3( xIter*(globSizeMin), yIter*(globSizeMin), 0 )
        
        mainLine:addVertex( glm.vec3( (pointMax.x*audio) + pointMin.x, (pointMax.y*audio) + pointMin.y, 0 ) )
        
    end
    
    mainLine:close()
    of.setColor( fg )
    mainLine:draw()
    mainLine:clear()
    
    of.popMatrix()
    
    theLight:disable()
    theCam:endCamera()
    
    
    
end

---------------------------------------------------------------------------
-- circle OOP function
function circles( amt, modd, rez )
    -- self.modder controls the circles place in the larger circle
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
    self.direction = 0
    self.place = 0
    self.line = of.Polyline()
    self.modColor = of.Color()
    self.modCompare = 0
    self.modder = 0
    self.color = math.random(0,20)
    self.colCount = 0
    self.freezeTable = {}
    self.xMod = 0
    self.yMod = 0
    
    --fill freeze Table
    for i = 1, self.rez+1 do
        self.freezeTable[i] = 0
    end
    
    -- draw function and run the count
    function self.makeLine()
       
        if( self.count > 1 ) then
            self.count = 0
        end
        if( self.count < 0 ) then
            self.count = 1
        end
        
        self.count = self.count + (self.rate * self.direction)
        self.modder = (self.count + self.mod) % 1
        
        if(self.direction == 1 ) then
            
            if( self.modder < self.modCompare ) then
                self.color = math.random(0,20) 
                for i = 1, self.rez+1 do
                    self.freezeTable[i] = math.abs( inL[i*math.floor(100 / self.rez) ] )
                end
            end
        end
    
        if(self.direction == -1 ) then
            
            if( self.modder > self.modCompare ) then
                self.color = math.random(0,20) 
                for i = 1, self.rez+1 do
                    self.freezeTable[i] = math.abs( inL[i*math.floor(100 / self.rez) ] )
                end
            end
        end
    
    
    
        
        self.modCompare = self.modder
        
        
        self.modColor:setHsb( ( self.color+fg.getHue(fg) ) % 255, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( self.modColor.r, self.modColor.g, self.modColor.b )
        self.xMod = math.cos( self.modder * 6.28) * h
        self.zMod = math.sin( self.modder * 6.28) * h
        
        for i = 0, self.rez do
            
            if( i == circleRez ) then
                i = 0
            else
                i  = i
            end
            
            local aud = self.freezeTable[ i+1 ]
            
            local xIter = math.cos( ((i/self.rez)*6.28) )  
            local yIter = math.sin(  ((i/self.rez)*6.28) ) 
            local pointMax = glm.vec3( xIter*(globSizeMax), yIter*(globSizeMax), 0 )
            local pointMin = glm.vec3( xIter*(globSizeMin), yIter*(globSizeMin), 0 )
            local x = (pointMax.x*aud) + pointMin.x
            
            self.line:addVertex( glm.vec3( x, (pointMax.y*aud) + pointMin.y, 0 ) )
        end
        
        self.line:close()
        
        of.pushMatrix()
        
        of.rotateYDeg( self.modder * 360 )
        of.translate( h+(w/4), 0)
        self.line:draw()
        self.line:clear()
        
        of.popMatrix()
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