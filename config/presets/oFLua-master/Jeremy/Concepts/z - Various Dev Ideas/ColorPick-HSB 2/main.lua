require("eyesy")
modeTitle = "Color Pick - HSB"
print(modeTitle)
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
c = glm.vec3( w2, h2, 0 )   -- center in glm vector


myCam = of.Camera()         -- define a camera for simple 3d views
myLight = of.Light()        -- define light

bg = of.Color()
fg = of.Color()
-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    myCam:setPosition( c )
    myCam:lookAt( c )
    of.enableLighting()     -- very important to turn these on
	of.enableDepthTest()    -- this too
	myLight:setup()
	myLight:setPointLight( )
	myLight:setAmbientColor( of.FloatColor( .8, .8, .8 ) )
end

-------------------------------------------- FUNCTIONS --
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

    
    
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    colorPickHsb( knob4, fg )
    colorPickHsb( knob5, bg )

                
    of.setBackgroundColor( bg )               -- Background color stuff
    
    
    
    
    
    
    myCam:setPosition( w2, h2, 2400*knob1 )
    myLight:setPosition( knob2*(w*8), h, w )
    myCam:beginCamera()
        myLight:enable()
        of.rotateRad( knob3*6.28, w2, h2, 0 )
        -- draw a box the size of the screen with the depth of its height --
        of.setColor( fg )
        of.drawBox( glm.vec3( w2, h2, 0 ), w, h, h)
        
        myLight:disable()
    myCam:endCamera()
    
   
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end