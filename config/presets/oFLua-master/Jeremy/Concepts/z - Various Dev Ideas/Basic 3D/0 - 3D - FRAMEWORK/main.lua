modeTitle = "3D - FRAMEWORK"

-- Global Params and Class Definitions ------
print(modeTitle)
require('eyesy')
Width = of.getWidth()           -- global width  
Height = of.getHeight()         -- global height of screen
w2 = Width / 2                  -- width / 2 to get center
h2 = Height / 2                 -- height / 2 to get center
h4 = Height / 4                 -- use for the size of the cube
center = glm.vec3( w2, h2, 0 )  -- define a 3d point using glm.vec3, this is the center
zeroVec = glm.vec3( 0, 0, 0 )   -- this vec3 is just 0 0 0, used after the translate, to save typing

-- define a camera for viewing our 3D scene --
myCam = of.Camera()
-- define a light class to light the scene --
myLight = of.Light()

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)        -- set the title for the window 
    print("script setup")               -- print to see if setup is executing
    of.setFrameRate(60)                 -- set the framerate, 60 is good
    
    myCam:setPosition( widthHalf, heightHalf, 0)            -- Center the Camera
    myCam:lookAt( glm.vec3( widthHalf, heightHalf, 0 ) )    -- Camera locks on the center point
    of.enableLighting()         -- make sure lighting is enabled
	of.enableDepthTest()        -- and depth too
	myLight:setup()             -- start the light
	myLight:setPointLight( )    -- make the light a 'point'
    myLight:setDiffuseColor( of.FloatColor( 0.51, 1, 0.1) ) -- set the diffuse color
    
    of.setLineWidth( 14 )

end
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
-- this is the draw loop, every frame it starts at the top and works down (60 times per second)
function draw()
    of.drawBitmapString( modeTitle, 20, 20 )        -- draw the name of the mode to screen
    of.setBackgroundColor( 255,255,255 )            -- set background color 
    
    myLight:setAmbientColor( of.FloatColor( 0.41, 0.1, 0.81 ) )
    
    myCam:setPosition( w2, h2, knob1 * (Width*4) )  -- zoom the camera on the z axis
    myLight:setPosition( knob4*Width, Height, Width )   -- set the light position
    -- help to see the light
    of.drawBitmapString( "MYLIGHT", glm.vec3(knob4*(Width*8), Height-100, Width) ) 
    
    
    -- 'begin' the camera anything after this will be in the camers perspective
    myCam:beginCamera()
        -- 'enable' the light, everything after this will be lit by the light 
        myLight:enable()
        -- rotate the box
        of.pushMatrix()         -- 1st store the current matrix
        of.translate( center )  -- then 'translate' the matrix to the center
        of.noFill()
        of.drawBox( zeroVec, Width, Height, Height )
        -- than rotate the entire matrix, everything after this will be rotated, popMatrix returns the push
        of.rotateRad( knob2*6.28, 1, 0.5, 1) 
        
        -- draw a box the size of the screen(Width,Height) with the depth of its height --
        of.fill()   -- make the box filled
        of.setColor(155)
        of.drawBox( glm.vec3( 0,0,0 ), h4, h4, h4)
        of.popMatrix()  -- pop the matrix, so the outer large box doesnt rotate
        -- 'disable' light
        myLight:disable()
    -- 'end' the camera
    myCam:endCamera()
    
	
    
    
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end