modeTitle = "T - Bezier Cousins-Trails"
-- Global Params and various setups ------
print(modeTitle)
require('eyesy')
Height = of.getHeight() --global height of screen
Width = of.getWidth()   --global width  
wiHlf = Width / 2
hiHlf = Height / 2
w2 = wiHlf
h2 = hiHlf
w4 = Width / 4
h4 = Height / 4
h8 = Height / 8
c = glm.vec3( 0,0,0 )

myFbo = of.Fbo()
myPix = of.Pixels()
myTex = of.Texture()
myPlane = of.PlanePrimitive()

-- SETUP --------------------------------
function setup()
    of.setWindowTitle(modeTitle)
    print("script setup")
    of.setFrameRate(60)
    
    myPix:allocate( Width, Height, of.PIXELS_RGBA )    -- allocate pixels first    
    myTex:allocate( myPix )                     -- then allocate those pix to the texture
    
    
   
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

x12 = Width / 12
y10 = Height / 12
xMarg = Width - x12
yMarg = Height - y10
x45 = relX(45)
x10 = relX(10)
x760 = relX(760)
x90 = relX(90)
x180 = relX(180)
trigger = false


-- fill points tables --
function fillRandPs( num, minX, maxX, minY, maxY )
    x1 = minX or 0
    x2 = maxX or 10
    y1 = minY or 0
    y2 = maxY or 10
    tab = {}
    tab[1] = { math.random( x1, x2 ), math.random( y1, y2 ) }
    for i = 2, num do
        tab[i] = { 
            math.random( x1, x2 ), math.random( y1, y2 ),
            math.random( x1, x2 ), math.random( y1, y2 ),
            math.random( x1, x2 ), math.random( y1, y2 )
        }
    end
    table.insert( tab, tab[1] )
    return tab
end
-- make points for tables --
function tabber(name, num, add)
    tab = {}
    function rand()
        x = math.random( 1, 3 )
        x1 = x - 2
        return x1
    end
    tab[1] = { name[1][1] + add, name[1][2] + add }
    for i = 2, num do
        tab[i] = { 
            name[i][1] + (rand()*add),
            name[i][2] + (rand()*add),
            name[i][3] + (rand()*add),
            name[i][4] + (rand()*add),
            name[i][5] + (rand()*add),
            name[i][6] + (rand()*add),
        }
    end
    table.insert( tab, tab[1] )
    return tab
end
-- draw the bezier --
function pVtx( name, num, x, y )
    of.vertex( name[1][1] + x, name[1][2] + y )
    for i = 2, num do
        of.bezierVertex(
            name[i][1] + x,
            name[i][2] + y,
            name[i][3] + x,
            name[i][4] + y,
            name[i][5] + x,
            name[i][6] + y
        )
        
    end
end

pNum = 30


points = fillRandPs( pNum, x12, xMarg, y10, yMarg )
-- points 1 --
points1 = tabber( points, pNum, x10 )
-- points 2 --
points2 = tabber( points1, pNum, x10 * 2 )
-- points 3 --
points3 = tabber( points2, pNum, x10 * 4 )
-- points 4 --
points4 = tabber( points3, pNum, x10 * 8 ) 
init = 0
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
   
     
    
    of.setColor(255, 255,255, 240)
    myTex:draw( 0, 0, Width, Height )                       -- draw the texture captured
        
    
   
    
    
    of.noFill()
    of.setColor( fg )
    
    aud = avG()
    of.setLineWidth(10)
    if( avG() >= 0.1 ) then
        trigger = true
    else
        trigger = false
    end
    pNum = math.floor( knob1 * 28 ) + 2
    number = math.floor( knob2 * 4 ) + 1
    
    xMod = math.sin( knob3 * 6.28 ) * x10
    yMod = math.cos( knob3 * 6.28 ) * x10
    
    
    
    if( trigger == true ) then
        points = fillRandPs( pNum, x12, xMarg, y10, yMarg )
        
        -- points 1 --
        points1 = tabber( points, pNum, x10)
    
        -- points 2 --
        points2 = tabber( points1, pNum, x10 * 2 )

        -- points 3 --
        points3 = tabber( points2, pNum, x10 * 4 )

        -- points 4 --
        points4 = tabber( points3, pNum, x10 * 8 ) 
    end
    trigger = false

    of.pushMatrix()
    of.beginShape()

        if( number == 1) then
            pVtx( points, pNum, xMod, yMod )
            
                
        elseif( number == 2 ) then
            pVtx( points1, pNum, xMod, yMod  )
        
        elseif ( number == 3 ) then
            pVtx( points2, pNum, xMod, yMod  )
    
        elseif ( number == 4 ) then
            pVtx( points3, pNum, xMod, yMod  )

        elseif ( number == 5 ) then
            pVtx( points4, pNum, xMod, yMod  )
    end
    of.endShape()
    of.popMatrix()
    
    
    myTex:loadScreenData( 0, 0, Width, Height )
end



-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end