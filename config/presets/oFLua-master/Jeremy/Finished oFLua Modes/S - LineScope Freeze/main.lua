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
maxAmt = 20
globSpace = globDepth / maxAmt
defineLine = 40
setLineWidth = 4
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    theCam = of.Camera()
    
    -- line mesh class
    theLine = lineMesh()
    
    linesTable = {}
    for i = 1, maxAmt do 
        linesTable[i] = lines( maxAmt, i*(1/maxAmt), theLine, defineLine, inL)
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
    
    
    
    of.pushMatrix()
    of.translate(0,h/2)
    of.rotateXDeg(knob2*360)
    
    oscMesh( setLineWidth, w, glm.vec3(0,1,0), h, 0, maxAmt, inL, glm.vec3(0,0,0), knob1*360 )
    
    
    for i = 1, maxAmt do
        linesTable[i].rotate = 90
        linesTable[i].width = setLineWidth
        linesTable[i].rate = rater
        linesTable[i].makeLine()
        
    end
    
    
    theLight:disable()
    theCam:endCamera()
    of.popMatrix()
    
end



---------------------------------------------------------------------------
-- circle OOP function
function lines( amt, modd, lineName, lineDef, audioTab )
    local self = {}
    self.tab = audioTab
    self.amt = amt or 2
    self.mod = modd or 0
    self.width = 1
    self.count = 0
    self.rate = 0
    self.lineDef = lineDef or 50
    self.line = lineName
    self.modCompare = 0
    self.color = math.random(0,20)
    self.colCount = 0
    self.freezeTable = {}
    self.rotate = 0
    
    for i = 1, self.lineDef do
        self.freezeTable[i] = 0
    end
    
    -- make a mesh line
    
    function self.makeLine()
       
        if( self.count > 1) then
            self.count = 0
        end
        
        self.count = self.count + self.rate
        local modder = (self.count + self.mod) % 1
        
        if(modder < self.modCompare ) then
            
            self.color = math.random(0,20) 
            
            for i = 1, self.lineDef do
                self.freezeTable[i] = audioTab[i]
            end
        end
        self.modCompare = modder
        modCol:setHsb( ( self.color+fg.getHue(fg) ) % 255, fg.getSaturation(fg), fg.getBrightness(fg) )
        of.setColor( modCol, (1-modder)*255 )
        
        
        oscMesh(self.width, w, glm.vec3(0,1,0), h, 0, self.lineDef, self.freezeTable, glm.vec3(0,0,modder*globDepth), self.rotate )
        
    end
    
    return self
end

---------------------------------------------------------------------------
-- oscilloscope mesh function
function oscMesh( width, length, axis, amp, angle, def, theTab, vertPos, rotate )
    local theMesh = of.Mesh()
    
    local tab = theTab or {}
    local mod = amp or 0
    local len = length or 100
    local hi = width or 10
    local ax = axis or glm.vec3( 0,0,0 ) -- this is a glm.vec3
    local ang = angle or 0
    local d = def or 10
    local pos = vertPos or glm.vec3(0,0,0)
    local rot = rotate or 0
    local xStep = length / (def-1)
    local hi2 = hi/2
    
    local roti = rot/360
    
    -- the top row of vertices
    for i = 0, d - 1 do
        aud = tab[ i+1 ] * mod
        pointX = pos.x + (i*xStep)
        pointX = pointX + ang
        pointY = pos.y - hi2
        pointZ = pos.z
    
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
    end
    
    -- the bottom row of vertices
    for i = 0, def - 1 do
        aud = tab[ i+1 ] * mod
        pointX = pos.x + (i*xStep)
        pointY = pos.y + hi2
        pointZ = pos.z
        
        pointX = pointX + (aud * axis.x)
        pointY = pointY + (aud * axis.y)
        pointZ = pointZ + (aud * axis.z)
        
        
        
        theMesh:addVertex( glm.vec3( pointX, pointY, pointZ ) )
    end
    
    -- connect the vertices
    for i = 0, def-1 do
        if( i < def-1 ) then
            theMesh:addIndex( i )
            theMesh:addIndex( i+1 )
            theMesh:addIndex( i+def )
        end
        if( i > 0 ) then
            theMesh:addIndex( i )
            theMesh:addIndex( i+(def-1) )
            theMesh:addIndex( i+(def) )
        end
    end
   
    theMesh:draw()
    theMesh:clear()
    
end

---------------------------------------------------------------------------
-- mesh thats one line segment
function lineMesh()
    local self = {}
    self.mesh = of.Mesh()
    -- add 1st vertex
    self.mesh:addVertex( glm.vec3(0,0,0) ) -- 0
    self.mesh:addVertex( glm.vec3(0,1,0) ) -- 1
    
    -- add 2nd point
    self.mesh:addVertex( glm.vec3(1,0,0) ) -- 2
    self.mesh:addVertex( glm.vec3(1,1,0) ) -- 3
    
    -- connect
    self.mesh:addIndex(0)
    self.mesh:addIndex(1)
    self.mesh:addIndex(2)
    
    self.mesh:addIndex(2)
    self.mesh:addIndex(3)
    self.mesh:addIndex(1)
    
    -- normal
    self.mesh:addNormal( glm.vec3(0,1,1) )
    self.mesh:addNormal( glm.vec3(0,1,1) )
    self.mesh:addNormal( glm.vec3(0,1,1) )
    self.mesh:addNormal( glm.vec3(0,1,1) )


    function self.draw( width, vec1, vec2)
        w2 = width / 2
    
        -- set 1st vertex
        self.mesh:setVertex( 0, glm.vec3(vec1.x, vec1.y - w2, vec1.z) ) -- 0
        self.mesh:setVertex( 1, glm.vec3(vec1.x, vec1.y + w2, vec1.z) ) -- 1
    
        -- set 2nd point
        self.mesh:setVertex( 2, glm.vec3(vec2.x, vec2.y - w2, vec2.z) ) -- 2
        self.mesh:setVertex( 3, glm.vec3(vec2.x, vec2.y + w2, vec2.z) ) -- 3
    
        self.mesh:draw()
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