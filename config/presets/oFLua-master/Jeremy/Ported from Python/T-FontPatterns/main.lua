modeTitle = "T - Font Patterns"

-- Global Params and various setups ------
print(modeTitle)
require('eyesy')

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
end

--------------------------------------------------
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

-- Conversion Functions--
function relY(x)
    num = x or 1
    converted = (x * of.getHeight() ) / 720
    return converted
end
function relX(x)
    num = x or 1
    converted = (x * of.getWidth() ) / 1280
    return converted
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

-- global params --
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
wiHlf = Width / 2
hiHlf = Height / 2
x10 = Width / 10
y10 = Height / 10
x20 = x10 / 2
y20 = y10 / 2

x320 = relX(320)  --((320*xr)/1280)
x160 = relX(160)  --((160*xr)/1280)
x260 = relX(260)  --((260*xr)/1280)
x80 = relX(80)    --((80*xr)/1280)
y90 = relY(90)    --((90*yr)/720)
y45 = relY(45)    --((45*yr)/720)
y = 0

trigger = false


 
font = of.TrueTypeFont()
font:load( "font.ttf", 180, true, true, true, 10, 64 )
randomAscii = string.char( math.random(1, 128) ) .. string.char( math.random(1, 128) )

textpos = { 0, 0 }
-- make a function for receding text --
function recede( theSize, theString, theFont, x, y )
    of.pushMatrix()
        of.translate( x, y )
        of.scale( theSize )
        of.translate( -x, -y )
        
        wow = theFont:getStringBoundingBox( theString, 0, 0 )
        xCorrect = wow:getWidth() / 2
        yCorrect = wow:getHeight() / 2
        
        font:drawString( theString, x - xCorrect, y + yCorrect ) 
    of.popMatrix()
end
-- Grid Blueprint Function, fill a table with grid points --
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

xyGrid = {}
xyGrid = makeGrid( Width, Height, 10, 10 )


-- UPDATE --------------------------------------------------
function update()
end

-- DRAW LOOP ------------------
of.noFill()
function draw()
   ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 

    aud = avG()
          
    of.setColor( fg ) -- make font white
    
    -- Knobs
    if( knob1 <= 0.5 ) then
        shiftX = (knob1*2) * x10
        shiftY = 0
    else
        shiftX = x10
        shiftY = (knob1 - 0.5) * (y10*2)
    end
    
    size1 =  math.pow( knob2, 2 ) 
    size =  ( size1 * 2 ) + 0.01
    -- the trigger --
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    
    if( trigger == true ) then
        randomAscii = string.char( math.random(5, 127) ) .. string.char( math.random(5, 127) )
    end
    
    for x = 1, 10 do
        oddEvenX = x % 2
        for y = 1, 10 do
            oddEvenY = ( y + oddEvenX) % 2
            xPos = xyGrid[x][y][1] + x20
            yPos = xyGrid[x][y][2] + y20
            if( oddEvenY == 1 ) then
                recede( size, randomAscii, font, xPos+shiftX, yPos+shiftY )
            else
                recede( size, randomAscii, font, xPos, yPos )
            end
        end
    end
    
    trigger = False
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end