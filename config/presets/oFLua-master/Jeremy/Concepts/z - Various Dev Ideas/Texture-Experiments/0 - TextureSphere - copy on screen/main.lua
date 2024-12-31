require("eyesy")
modeTitle = "texture on sphere on screen"
print(modeTitle)
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2
h2 = h / 2
c = glm.vec3( w2, h2, 0 )   -- center in glm vector

h8 = h / 8
myCam = of.Camera()         -- define camera class
myLine = of.Path()          -- define path class
myLight = of.Light()        -- define light class
myTex = of.Texture()       -- define a texture class
myPix = of.Pixels()
--------------------------------------------------- 
    -- local functions
function oscRGB( knob, scale )  -- knob color
    local tab = {}
    k = knob or 0
    k1 = ( k + 0.33333333 ) % 1
    k2 = k
    k3 = ( k - 0.333333333 ) % 1
    tab[1] = math.max( 0, math.sin( k1 * 6.28 ) ) * scale
    tab[2] = math.max( 0, math.sin( k2 * 6.28 ) ) * scale   
    tab[3] = math.max( 0, math.sin( k3 * 6.28 ) ) * scale
    return tab
end
function pickRGB( knob, scale ) -- knob color 2
    local tab = {}                  -- define the local table
    k = math.floor( knob * 4 )      -- make knob 0 - 3 integer
    add = ( k * 0.25 )              -- then times by 0.25 for bottom range
    timesBy = 1 - add               -- get the range from bottom to 1
    t = oscRGB( (knob*4) % 1, timesBy )      -- use the oscRBG function, mod the knob by 1
    
    tab[1] = ( ( t[1]  ) + add ) * scale
    tab[2] = ( ( t[2]  ) + add ) * scale
    tab[3] = ( ( t[3]  ) + add ) * scale

    return tab
end
function makeLine( class, amount, startX, startY, width, height ) -- make an oscillascope
    a = amount or 1
    wi = width or 1
    hi = height or 1
    sX = startX or 0
    sY = startY or 0
    steps = wi / a
    hi2 = hi/2
    
    
    for i = 1, a do
        aud = inL[ (i%100) + 1 ] * hi2
        x = i * steps
        class:lineTo( sX + x, sY + aud , 0 )
    end
    
    class:draw()
    class:clear()
end
        
----------------------------------------------------
function setup()
    myCam:setPosition( c )  -- set the first position, changes later
    myCam:lookAt( c )       -- the camera looks at the center
    of.enableLighting()     -- very important to turn these on
	of.enableDepthTest()    -- this too
	myLight:setup()         -- start the light
	myLight:setPointLight( )-- we use a point light here
	myLight:setAmbientColor( of.FloatColor( .8, .8, .8 ) )
	
    myPix:allocate( h8, h8, of.PIXELS_RGBA )  -- allocate pixels first    
    myTex:allocate( myPix )                     -- then allocate those pix to the texture
    print("done setup")     -- so we know that the setup was succesful
    
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    bg = pickRGB( knob5, 255 )                      -- background color
    fg = pickRGB( knob4, 255 )                      -- color for drawings
    of.setBackgroundColor( bg[1], bg[2], bg[3] )    -- set the bg color  
    
    myCam:setPosition( w2, h2, knob1*2400 )         -- set camera position, change z
    myLight:setPosition( (knob2*8000)- 4000, h ,1000 )        -- set light position, change x
    
    myLine:setFilled( false )
    myLine:setStrokeWidth( 4 )
    
    makeLine( myLine, 99, -2, h2, h8, h8 )        -- make the path
    myTex:loadScreenData( 0, h2-(h8/2), h8, h8 )        -- capture the makeLine
   
    
   
   
    myCam:beginCamera()                             -- begin camera
        myLight:enable()                            -- start the light
            
            of.pushMatrix()
            of.rotateRad( knob3*6.28, w2, h2, 0 )   -- rotate eveything after this
            of.setColor( fg[1], fg[2], fg[3], 255 ) -- set color after this
            
            myTex:bind()                            -- apply the texture
            of.drawIcoSphere( w2, h2, 200 )         -- draw the sphere
            myTex:unbind()
            of.popMatrix()
            
        myLight:disable()                           -- stop the light
    myCam:endCamera()                               -- stop the camera
    
end

----------------------------------------------------
function exit()
	print("script finished")
end