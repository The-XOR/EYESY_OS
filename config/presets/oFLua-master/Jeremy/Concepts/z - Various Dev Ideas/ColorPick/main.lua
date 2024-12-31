modeTitle = "Color Pick"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
wHalf = Width / 2
hHalf = Height / 2
w4 = wHalf / 2
h4 = hHalf / 2
center = glm.vec3( wHalf, hHalf, 0 )   -- center in glm vector

-- define a camera for simple 3d views --
myCam = of.Camera()
-- define light --
myLight = of.Light()

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    myCam:setPosition( wHalf, hHalf, 0)
    myCam:lookAt( glm.vec3( wHalf, hHalf, 0 ) )
    of.enableLighting()     -- very important to turn these on
	of.enableDepthTest()    -- this too
	myLight:setup()
	myLight:setPointLight( )
    --myLight:setDiffuseColor( of.FloatColor( 1, 1, 1) )
    

end
-- FUNCTIONS --
----------- two functions 
-- 0 - 1 rgb color gen, uses sine curve
function oscRGB( knob, scale )
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
-- an attempt a getting a wider colortable output with one knob (rgb 0-1 output)
function pickRGB( knob, scale )
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
    
    
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    howdy = pickRGB( knob5, 255 )
    fgColor = pickRGB( knob4, 255 )
    of.drawBitmapString( (knob3*4)%1, 400, 20 ) 
    of.drawBitmapString( howdy[1], 20, 20 )               -- Background color knob5
    of.setBackgroundColor( howdy[1], howdy[2], howdy[3] )               -- Background color stuff
    
    
    
    
    
    
    myCam:setPosition( wHalf, hHalf, 2400*knob1 )
    myLight:setPosition( knob2*(Width*8), Height, Width )
    myCam:beginCamera()
        myLight:enable()
        of.rotateRad( knob3*6.28, wHalf, hHalf, 0 )
        -- draw a box the size of the screen with the depth of its height --
        of.setColor( fgColor[1], fgColor[2], fgColor[3] )
        of.drawBox( glm.vec3( wHalf, hHalf, 0 ), Width, Height, Height)
        
        myLight:disable()
    myCam:endCamera()
    
   
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end