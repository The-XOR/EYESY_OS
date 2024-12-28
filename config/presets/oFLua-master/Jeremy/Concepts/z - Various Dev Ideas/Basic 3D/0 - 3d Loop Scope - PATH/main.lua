modeTitle = "3D - SCOPE-PATH - COLOR"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2
heightHalf = Height / 2
width4 = widthHalf / 2
height4 = heightHalf / 2

-- define path class --
myPath = of.Path()
-- define camera
myCam = of.Camera()
-- define stroke color
myCol = of.FloatColor( 0, 215, 255 )
-- define ambient light
myLight = of.Light()
myLight:setAmbientColor( myCol )
myLight:setPosition( Width, Height, 0 )



-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    myPath:setStrokeColor( of.Color( 255, 255, 255 ) )
    
    myCam:setPosition( widthHalf, heightHalf, 1200)
    myCam:lookAt( glm.vec3( widthHalf, heightHalf, 0 ) )

end
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    myCol = of.FloatColor( knob4, 1-knob4, 0 )
    myLight:setAmbientColor( myCol )
                   
    of.setBackgroundColor( 205,205,205 )               
    
    myPath:setFilled( false )   -- just the stroke of the path
    myPath:setStrokeWidth( 4 )  -- stroke width
    
    -- draw the 3D loop
    for j = 0, 200 do
        if( j <= 99 ) then
            i = j
        else
            i = 100 - (j - 100)
        end
        s = inL[ (i%100) + 1 ] 
        sSin = math.sin( s ) * widthHalf
        sCos = math.cos( s ) * widthHalf
        iter = i / 100
        
        x = math.sin( iter * 6.28 ) * width4
        z1 = math.cos( iter * 6.28 ) * width4
        z = z1 - widthHalf
        
        myPath:lineTo( (widthHalf+x) , heightHalf + sSin , z + sCos)
    end     
    -- camera control --
    myCam:setPosition( widthHalf, heightHalf, 2400*knob1 )
    myCam:lookAt( glm.vec3( widthHalf, heightHalf, 0 ) )
    -- light control
    
    
    myCam:beginCamera()
        myLight:enable()
        
            
            -- rotate the drawing
            of.rotateRad( knob3*6.28, widthHalf, heightHalf, 0 )
            
            -- draw the path to the screen
            myPath:draw()
            
        
        myLight:disable()
    myCam:endCamera()
    
    -- clear the path --
    myPath:clear()
	
    
    
    
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end