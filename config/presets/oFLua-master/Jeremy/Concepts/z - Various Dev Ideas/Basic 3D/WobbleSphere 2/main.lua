modeTitle = "Wobble Sphere"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
wHalf = Width / 2
hHalf = Height / 2
w4 = wHalf / 2
h4 = hHalf / 2
Center = glm.vec3( wHalf, hHalf, 0 )   -- center in glm vector

-- define a camera for simple 3d views --
myCam = of.Camera()
-- define light --
myLight = of.Light()
-- define meshes, we are using a small sphere and one twice as large
myMesh = of.Mesh()
myMesh2 = of.Mesh()
-- define icoSphere
icoSphere = of.IcoSpherePrimitive()
icoSphere2 = of.IcoSpherePrimitive()
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
    myMesh:setMode(of.PRIMITIVE_LINES)    -- set mesh mode
    -- draw the two spheres
    icoSphere:setPosition( 0,0,0 )
    icoSphere:setRadius( 200 )
    icoSphere2:setPosition( 0,0,0 )
    icoSphere2:setRadius( 400 )

	-- get the mesh of sphere
	myMesh = icoSphere:getMesh()
	myMesh2 = icoSphere2:getMesh()

    -- fill a table with all the vertices
    meshSize = myMesh:getVertices():size()
    
    
end
-------------------------------------------- FUNCTIONS --
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
    bgColor = pickRGB( knob5, 255 )         -- background color
    fgColor = pickRGB( knob4, 255 )         -- color for drawings
    of.setBackgroundColor( bgColor[1], bgColor[2], bgColor[3] )  --set the bg color            
    
    -- redraw the icoSPhere --
    -- draw the two spheres
    icoSphere:setPosition( 0,0,0 )
    icoSphere:setRadius( 200 )
    icoSphere2:setPosition( 0,0,0 )
    icoSphere2:setRadius( 400 )

	-- get the mesh of the spheres
	myMesh = icoSphere:getMesh()
	myMesh2 = icoSphere2:getMesh()
    
    for i = 0, meshSize - 1 do
        myVertex = myMesh:getVertex( i )    -- get small sphere to draw
        myVertTo = myMesh2:getVertex( i )   -- get larger sphere verts to travel to
        
        aud = inL[ (i%100) + 1 ]         -- audio buffer ( -1 to 1 )
        
        myVertex.x = myVertex.x + (myVertTo.x * aud)   
        myVertex.y = myVertex.y + (myVertTo.y * aud)  
        myVertex.z = myVertex.z + (myVertTo.z * aud)  
        myMesh:setVertex(i, myVertex)
    end
    
    
    
    
    myCam:setPosition( wHalf, hHalf, 2400*knob1 )
    myLight:setPosition( knob2*(Width*8), Height, Width )
    myCam:beginCamera()
        myLight:enable()
        of.rotateRad( knob3*6.28, wHalf, hHalf, 0 )
        of.translate( wHalf, hHalf )    --center the mesh
        of.setColor( fgColor[1], fgColor[2], fgColor[3] ) -- set the color
        myMesh:flatNormals()
        myMesh:draw()       -- draw the mesh
        
        myLight:disable()
    myCam:endCamera()
    myMesh:clear()
   
end -- end draw loop

-- EXIT  --------------------------------------------------
function exit()
    print("script finished")
end