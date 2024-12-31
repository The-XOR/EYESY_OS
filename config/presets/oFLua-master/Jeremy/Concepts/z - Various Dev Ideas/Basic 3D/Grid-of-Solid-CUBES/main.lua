modeTitle = "Grid - Cubes"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
width2 = Width / 2
height2 = Height / 2
width4 = width2 / 2
height4 = height2 / 2
x10 = Width / 10
y10 = Height / 10

-- define polyline class, so we can draw a 3d line --
myPoly = of.Polyline()
-- define a camera for simple 3d views --
myCam = of.Camera()
-- define light --
myLight = of.Light()


-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    myCam:move( widthHalf, heightHalf, 0)
    myCam:lookAt( glm.vec3( widthHalf, heightHalf, 0 ) )
    of.setFrameRate(60)
    of.enableLighting()
	of.enableDepthTest()
	myLight:setup()
	myLight:setPointLight( )
    myLight:setDiffuseColor( of.FloatColor( 0.7, 1, 0.1) )
end
-- FUNCTIONS -----------------------------------------------    
    -- grid Blueprint Function, fill a table with grid points --
function makeGrid( x, y, xNum, yNum )
    xSpace = x / xNum  
    ySpace = y / yNum   
    tab = {}
    for j = 0, ( xNum - 1 ) do -- go along x axis and make columns                   
        rowTab = {}
        for i = 0, yNum - 1 do -- y axis the columns
            
            x = j * xSpace
            y = i * ySpace
            rowTab[ i + 1 ] = { x, y }
        end
        tab [ j + 1 ] = rowTab
    end
    return tab
end
    -- then define the global table xyGrid --
xyGrid = {}
xyGrid = makeGrid( Width, Height, 10, 10 )
    -- draw the boxes to the screen --
function makeBoxes( xNum, yNum, shifterX, shifterY )
    xSize = Width / xNum
    ySize = Height / yNum
    xOffset = xSize / 2
    yOffset = ySize / 2
    
    for x = 1, xNum do
        oddEvenX = x % 2
        for y = 1, 10 do
            iter = ( (x - 1) * xNum ) + (y - 1)  
            oddEvenY = ( y + oddEvenX) % 2
            xPos = xyGrid[x][y][1] + xOffset
            yPos = xyGrid[x][y][2] + yOffset
            aud = inL[ (iter % 100) + 1 ] * Height
            of.pushMatrix()
            if( oddEvenY == 1 ) then
                of.translate( xPos, yPos, aud  )
                of.rotateRad( knob2*6.28, 1,1,1 )
                of.drawBox( glm.vec3( shifterX, shifterY, 0 ), xSize, ySize, xSize)
                
            else
                of.translate( xPos, yPos,  aud )
                of.rotateRad( knob2*6.28, 1,1,1 )
                of.drawBox( glm.vec3( 0, 0, 0 ), xSize, ySize, xSize)
            end
            of.popMatrix()
        end
    end
    
end   
    -- one knob does xy shift, returns a two point table --
function oneKnobShift( knob, xAmt, yAmt )
    tab = {}
    if( knob <= 0.5 ) then
        tab[1] = (knob * 2) * xAmt
        tab[2] = 0
    else
        tab[1] = xAmt
        tab[2] = (knob - 0.5) * (yAmt*2)
    end
    return tab
end

    
    
-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------

function draw()
    of.drawBitmapString( modeTitle, 20, 20 )              
    of.setBackgroundColor( 200,200,190 )               
    
    of.setLineWidth( 2 )

    myLight:setPosition( knob4*(Width*8), Height, Width )
    myCam:setPosition( width2, height2, 4200*knob1 )
    
    myShifter = oneKnobShift( knob2, x10, y10 )
    
    myCam:beginCamera()         -- begin Camera
        myLight:enable()        -- begin Light
            of.pushMatrix()     -- save matrix xy before rotate
            of.rotateRad( knob3*6.28, width2, height2, 0 )
            -- draw the boxes
            --of.noFill()
            of.setColor( 200,210,60)
            
            makeBoxes( 10, 10, myShifter[1], myShifter[2] )
        
        of.popMatrix()          --recall the saved matrix
        myLight:disable()
    myCam:endCamera()

end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end