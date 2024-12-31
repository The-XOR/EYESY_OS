modeTitle = "3D - BASIC"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2
heightHalf = Height / 2
width4 = widthHalf / 2
height4 = heightHalf / 2

-- define polyline class, so we can draw a 3d line --
myPoly = of.Polyline()
-- define a camer for simple 3d views --
myCam = of.Camera()
-- define light --
myLight = of.Light()
myLight:setPointLight( )

--myLight:setDiffuseColor( 255 )
-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    myCam:setPosition( widthHalf, heightHalf, 1200)
    myCam:lookAt( glm.vec3( widthHalf, heightHalf, 0 ) )
    
    

end
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
                   -- Background color knob5
    of.setBackgroundColor( 255,255,255 )               -- Background color stuff
    planetSize = ( knob3 * 400 ) + 5
    of.setLineWidth( 4 )
    of.setColor(255,25,255)
    
    for i = 0, 100 do
        sx = math.sin( inL[ (i%100) + 1 ] * 6.28 ) * height4
        sy = math.cos( inL[ (i%100) + 1 ] * 6.28 ) * height4
        iter = i / 100
        x = math.sin( iter * 6.28 ) * ( ( 600 * knob2 ) - 300 )
        y = math.cos( iter * 6.26 ) * width4
        z = math.sin( iter * 6.28 ) * width4
        of.setColor( 200, 230, i)
        myPoly:addVertex( (widthHalf+y), (heightHalf+x) + sx , (z +sy) - height4 )
    end
    
    myCam:setPosition( widthHalf, heightHalf, 2400*knob1 )
    myLight:setPosition( knob4*(Width*2), Height, -Width )
    myCam:beginCamera()
        myLight:enable()
        of.rotateRad( knob3*6.28, widthHalf, heightHalf, 0 )
        -- draw a box the size of the screen with the depth of its height --
        of.setColor( 200,210,60)
        of.drawBox( glm.vec3( widthHalf, heightHalf, 0 ), Width, Height, Height)
        -- draw a simple sphere --
        of.fill( )
        of.setColor( 225, 250, 190)
        of.drawSphere( widthHalf, heightHalf, width4 )
        
        -- draw the polyline with the vertices defined above --
        of.noFill()
        of.setColor( 200, 230, 212)
        myPoly:draw()
        myLight:disable()
    myCam:endCamera()
    -- clear the buffer of the polyline
    myPoly:clear()
    
	
    
    
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end