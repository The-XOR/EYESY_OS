require("eyesy")
modeTitle = "Jaws - 3D - Room"
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

bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
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
    --------- draw the ceiling columns
function ceilingRow( number, clampKnob, depthNum )
    space = w / number                  -- the global width / number
    dSpace = h / depthNum               -- the global depth / depthNum
    dSpace2 = dSpace / 2                -- the depth space / 2
    space2 = space / 2                  -- the space divided in 2
    clampRange = (1 - clampKnob) * h2   -- the range of height
    clampMin = h2 - clampRange          -- the min height     
    
    for i = 0, number - 1 do              -- the for loop
        
        for j = 0, depthNum - 1 do
            count = (i*depthNum) + j               
            depth = ( j * dSpace ) + dSpace2
            x = ( i * space ) + space2        -- the iter times the space amount, centered
        
            aud = inL[ (count%100) + 1 ] * 2      -- audio buffer point 
            audio = math.min( aud, 0 )
            height = (audio * clampRange) - clampMin
            y = h + (height/2)
            z = depth - h2
        
            placement = glm.vec3( x, y, z )
            of.drawBox( placement, space*0.95, height, dSpace*0.95 ) -- draw the box
        end
    end
end
    ------------- draw the floor columns 
function floorRow( number, clampKnob, depthNum )
    space = w / number                  -- the global width / number
    dSpace = h / depthNum               -- the global depth / depthNum
    dSpace2 = dSpace / 2                -- the depth space / 2
    space2 = space / 2                  -- the space divided in 2
    clampRange = (1 - clampKnob) * h2   -- the range of height
    clampMin = h2 - clampRange          -- the min height     
    
    for i = 0, number - 1 do              -- the for loop
        
        for j = 0, depthNum - 1 do
            count = (i*depthNum) + j               
            depth = ( j * dSpace ) + dSpace2
            x = ( i * space ) + space2        -- the iter times the space amount, centered
        
            aud = inL[ (count%100) + 1 ] * 2      -- audio buffer point 
            audio = math.max( aud, 0 )
            height = (audio * clampRange) + clampMin
            y = height/2
            z = depth - h2
        
            placement = glm.vec3( x, y, z )
            
            
            of.drawBox( placement, space*0.95, height, dSpace*0.95 ) -- draw the box
        end
    end
end

            
----------------------------------------------------
function setup()
    myCam:setPosition( c )  -- set the first position, changes later
    myCam:lookAt( c )       -- the camera looks at the center
    of.enableLighting()     -- enable lighting in the scene
	of.enableDepthTest()    -- enable depth
	myLight:setup()         -- start the light
	myLight:setPointLight( )-- we use a point light here
	myLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) ) -- make the ambient color white
	myMesh:setMode(of.PRIMITIVE_LINE_LOOP)    -- set mesh mode
    
    print("done setup")     -- so we know that the setup was succesful
end
----------------------------------------------------
function update()
end
----------------------------------------------------
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, bg )       -- color for background, see above for ofColor class
    colorPickHsb( knob5, fg )       -- color for drawings
    of.setBackgroundColor( bg )     -- set the bg color 
  
    ------------------------- set Camera and Light Position
    myCam:setPosition( w2, h2, (knob1*wT2)+h8 ) -- set camera position, change z
    myLight:setPosition( wT4, h , w )           -- set light position, change x
    
    --------------------- 
    
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
            
            of.setColor( fg )                       -- set color of floor and ceiling
            
            ceilingRow( 10, knob2, 10 )             -- draw the ceiling
            floorRow( 10, knob2, 10 )               -- draw the floor
           
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end