-- S - Tunnel Scope  Freeze
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Tunnel Scope Freeze"     -- name the mode
print(modeTitle)                     -- print the mode title in the print window

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()                  -- height of screen, same as above but height
maxObj = 12
theDepth = h
c = glm.vec3(0,0,0)
cylHeight = theDepth/maxObj

---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    theCam = of.Camera()
    theMesh = of.Mesh()
    theLight = of.Light()           -- define light class
    theCyl = of.CylinderPrimitive( h/8, cylHeight, 20, 1, 1, false, of.PRIMITIVE_TRIANGLE_STRIP )
    
    theLight:setup()                -- start the light
	theLight:setPointLight( )       -- we use a point light here
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	theLight:setPosition( 0, 0 , 0 )           -- set light position, change x
    of.enableDepthTest()
    
    
    
    tuberTable = {}
    for i = 1, maxObj do
        tuberTable[i] = tubes( 0, 0, (1/maxObj) * i )
    end

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
    
    
    theCam:setPosition( w/2, h/2, h)            -- set camera position, change z
    theLight:enable()
    theCam:beginCamera()
    of.setColor(fg)
    
    of.pushMatrix()
    of.translate( w/2, h/2)
    of.rotateXDeg(knob2*360)
    of.rotateYDeg(knob3*360)
    
    k2rate = math.pow( knob1*0.1, 2 )
    
    
    for i = 1, maxObj do
        tuberTable[i].rate = k2rate
        tuberTable[i].makeTube()
    end
    
    
    
    -- draw a cylinder
    theCyl:set( h/12, cylHeight, 20, 2, 2, false, of.PRIMITIVE_TRIANGLE_STRIP )
    theCyl:setPosition( glm.vec3(0,0,0) )
    -- make a mesh
    theMesh = theCyl:getMesh()
    wow = tuberTable[1].count
    wow = (wow*maxObj) % 1 
    wow = wow * cylHeight
    for j = 0, 2 do
        for i = 0, 20 do
            
            theV = theMesh:getVertex( i + (j*21) )
            if( i < 10 )then
                it = i
            else
                it = 10 - (i-10)
            end
            aud = inL[ (it+1) + (j*21) ] * 2
    
            newX = (theV.x * aud) + (theV.x)
            newZ = (theV.z * aud) + (theV.z)
            theMesh:setVertex( i + (j*21), glm.vec3( newX, j*(wow/2)-wow, newZ) )
        end
    end
    
    of.rotateXDeg(180)
    of.rotateXDeg(90)
   
    theCyl:draw()
    theMesh:clear()
    of.popMatrix()
        
    theLight:disable()
    theCam:endCamera()
    
    
end

---------------------------------------------------------------------------
-- tube OOP function
function tubes( x, y, modd )
    local self = {}
    self.mod = modd or 0
    self.xPos = x or 0
    self.yPos = y or 0
    self.zPos = 0
    self.count = 0
    self.rate = 0
    self.place = 0
    self.modCompare = 0
    self.color = math.random(0,255)
    self.colCount = 0
    self.freezeTab = {}
    for i = 1, 64 do
        self.freezeTab[i] = 0 
    end
    
    -- function to draw a tube segment
    function self.makeTube()
        -- internal counter
        if( self.count > 1) then
            self.count = 0
        end
        
        self.count = self.count + self.rate
        local modder = (self.count + self.mod) % 1
        
        -- if looped trigger options
        if(modder < self.modCompare ) then
            self.color = ( fg.getHue(fg) + math.random(0,20) ) % 255
            
            -- fill the freeze tab
            for j = 0, 2 do
                for i = 1, 21 do
                    if( i < 10 )then
                        it = i
                    else
                        it = 10 - (i-10)
                    end
                    aud = inL[ (it+1) + (j*21) ]
                    self.freezeTab[ (it+1) + (j*21) ] = aud
                end
            end
    
        end
        
        -- bit of code to detect loop
        self.modCompare = modder
        -- mod the color
        modCol:setHsb( self.color, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( modCol )
        
        -- draw a cylinder
        theCyl:set( h/12, cylHeight, 20, 2, 2, false, of.PRIMITIVE_TRIANGLE_STRIP )
        theCyl:setPosition( glm.vec3(self.xPos, self.yPos, self.zPos ) )
        -- make a mesh
        theMesh = theCyl:getMesh()
        
        for j = 0, 2 do
            for i = 0, 20 do
            
                theV = theMesh:getVertex( i + (j*21) )
                if( i < 10 )then
                    it = i
                else
                    it = 10 - (i-10)
                end
                aud = self.freezeTab[ (it+1) + (j*21) ]
        
                newX = ((theV.x*2) * aud) + (theV.x)
                newZ = ((theV.z*2) * aud) + (theV.z)
                theMesh:setVertex( i + (j*21), glm.vec3( newX, ((cylHeight/2)*j)+(modder*theDepth), newZ) )
            end
        end
        -- draw it!
        of.pushMatrix()
        of.rotateXDeg(90)
        theCyl:draw()
        theMesh:clear()
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