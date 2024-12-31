require("eyesy")
modeTitle = "Chris' Wheel MESH"
print(modeTitle)
------------------------- Draw circular scopes, rotate them over each other

w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
h4 = h / 4
hT2 = h * 2
wT4 = w * 4                 -- width times 4
wT2 = w * 2                 -- width times 2
c = glm.vec3( w2, h2, 0 )   -- center in glm vector
h8 = h / 8                  -- 8th of the height
h8t3 = h8 * 3               -- h8 * 3 (3/4ths)

myMesh = of.Mesh()          -- define Mesh
myCam = of.Camera()         -- define camera class
myLight = of.Light()        -- define light class

og = glm.vec3( 100,100,100 )
og = glm.rotate( og, glm.radians(90), glm.vec3(1,1,0) )
myMesh:addVertex( og )
print("og", og)
wowie = myMesh:getVertex(0)
print("hmmm", wowie)
print( glm.radians(90) )
--------------------------------------------------- 
bg = of.Color()             -- define background color class
fg = of.Color()             -- define foreground color class
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
-- amplitude average of audio buffer --
function avG()  
    a = 0
    for i = 1, 100 do
        aud = math.abs( inL[i])
        a = a + aud
    end
    x = a / 100
    if( x <= 0.001 ) then
        x = 0
    else
        x = x
    end
    return  x
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
	myMesh:setMode( of.PRIMITIVE_TRIANGLES )    -- set mesh mode
    of.enableAlphaBlending()
    --of.enableBlendMode( of.BLENDMODE_ALPHA )
    
    
    print("done setup")     -- so we know that the setup was succesful
end

----------------------------------- draw wheels function
function drawWheel( radius, vec, rot, width )
    xChunk = radius / 12
    wid2 = width / 2
    of.pushMatrix()
    of.translate( vec )
    ---- draw the vertices
    for i = 1, 8 do    
        rDeg = (45 * i) + rot
        for j = 0, 11 do
            audio = inL[j+1] * radius
            --of.translate( 0, -wid2, 0 )
            new = glm.vec3( 0,0,0 )
            xMove = j * xChunk
            new.x = xMove
            new.y = -wid2
            new.z = audio
            new = glm.rotate( new, glm.radians( rDeg ), glm.vec3(0,0,1) )
            myMesh:addVertex( new )
            
        end
        for j = 0, 11 do
            audio = inL[j+1] * radius
            new = glm.vec3( 0,0,0 )
            xMove = j * xChunk
            new.x = xMove
            new.y = wid2
            new.z = audio
            new = glm.rotate( new, glm.radians( rDeg ), glm.vec3(0,0,1) )
            myMesh:addVertex( new )
        end
    end
    ----------------- connect the vertices
    for i = 0, 7 do
        for j = 0, 10 do
            iter = (i * 24) + j
            myMesh:addIndex( iter )
            myMesh:addIndex( iter + 1 )
            myMesh:addIndex( iter + 12 )
            
            myMesh:addIndex( iter + 12 )
            myMesh:addIndex( (iter + 12) + 1 )
            myMesh:addIndex( iter + 1 )
        end
    end
    
    of.fill()
    myMesh:draw()
    myMesh:clear()        
    of.popMatrix()
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )       -- color for drawings
    of.setBackgroundColor( bg )     -- set the bg color 
    ----------------------- 
    
    rotate = knob2 * 360
    
   
    
    
    
  
    ------------------------- set Camera and Light Position
    myCam:setPosition( w2, h2, knob1*2400 )            -- set camera position, change z
    myLight:setPosition( wT4, h , w )           -- set light position, change x
    
    --------------------- 
    spiralH = knob2 * h2
    of.setLineWidth( 1 )
    
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
           
            of.rotateDeg( knob3*360, w2, h2, 0)
            --of.noFill()
            --of.setColor(0)
            --of.drawBox( c, w, h, h )
            
           
            
            
            of.setColor( fg ) 
           
            
            drawWheel( w2, c, 0, 80 )
            fg:setHue( fg:getHue() + 20 )
            of.setColor( fg ) 
            drawWheel( w2, glm.vec3( w2,h2,-h2), rotate, 80 )
            fg:setHue( fg:getHue() + 50 )
            of.setColor( fg ) 
            drawWheel( w2, glm.vec3( w2,h2,h2), rotate + 24, 80 )
            
            
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
    of.disableLighting()        -- turn these off
	of.disableDepthTest()    
    
	print("script finished")
end