modeTitle = "T - Line Rotate - Trails"

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
-- Trigger Function --
function tFunc( level )
    t = false
    if( avG() >= level ) then
        t = true
    else
        t = false
    end
    return t
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
-- global params --
Width = of.getWidth()   --global width  
Height = of.getHeight() --global height of screen
widthHalf = Width / 2
heightHalf = Height / 2
width4 = Width / 2
height4 = Height / 2
x1000 = relX(1000)
sound = 0


-- trail function OOP --
function Trails( funcName, amt, v1, v2 )  -- add parameters for how many the functions use
    local tab = {}
    tab.var1 = v1 or 0
    tab.var2 = v2 or 0
    tab.amount = amt
    tab.var1Tab = {}
    tab.var2Tab = {}
    
    function tab.update()
        -- store variables
        table.insert( tab.var1Tab, 1, tab.var1 )
        table.insert( tab.var2Tab, 1, tab.var2 )
        maxNum = table.maxn( tab.var1Tab ) -- only need 1 cus same
        if( maxNum == tab.amount ) then
            table.remove( tab.var1Tab, maxNum )
            table.remove( tab.var2Tab, maxNum )
        end
        for i = 1, amt do
            
            of.setColor( fg, 255/i )
            funcName( tab.var1Tab[i], tab.var2Tab[i] )
        end
    end
    return tab
end

-- the draw functions --
function less( ell, aaa )
    local el = ell or 1
    local aa = aaa or 1
    if( knob2 < 0.5 ) then
        x21 = ( el / 2 ) * math.cos( aa )
        y21 = ( el / 2 ) * math.sin( aa )
        x2 = widthHalf + x21
        y2 = heightHalf - y21
        x3 = widthHalf - x21
        y3 = heightHalf + y21
        of.setLineWidth( lineWidth )
        of.drawLine( x2, y2, x3, y3 )
    end
end
function greater( ell, aaa)
    local el = ell or 1
    local aa = aaa or 1
    if( knob2 > 0.5 ) then
        x11 = ( el / 2 ) * math.cos( aa )
        y11 = ( el / 2 ) * math.sin( aa )
        x1 = widthHalf - x11
        y1 = heightHalf + y11
        x4 = widthHalf + x11
        y4 = heightHalf - y11
        of.drawLine( x1, y1, x4, y4 ) 
    end
end
-- UPDATE --------------------------------------------------
function update()
end
-- define trails objects
tails1 = Trails( less, 50, 30, 30 )
tails2 = Trails( greater, 50, 30, 30)

-- DRAW LOOP ------------------

function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )       -- color for foreground
    colorPickHsb( knob5, bg )       -- color for background
    of.setBackgroundColor( bg )     -- set the bg color 


    of.setColor( fg )
    
    aud = avG()
    trailAmount = math.floor( knob3 * 50 ) + 3
    
    -- the trigger --
    trigger = tFunc(0.09)
    
    if( trigger == true ) then
        
        if( sound == 360 ) then
            sound = 0
        end
        sound = sound + ( (knob2 * 0.48) + 0.02 )
    end
    
    a = math.pi * sound
   
    lineWidth = widthHalf - ( knob1 * (widthHalf-1) )
    
    L = ( knob1 * x1000 ) + lineWidth
    if( L > Width ) then 
        L = Width
    end
    
    of.pushMatrix()
        tails1.amount = trailAmount
        tails1.var1 = L
        tails1.var2 = a
        tails1.update()
        
        tails2.amount = trailAmount
        tails2.var1 = L
        tails2.var2 = a
        tails2.update()
        
        
    of.popMatrix()
    
    trigger = false
end -- end draw loop
-- EXIT  --------------------------------------------------

function exit()
    print("script finished")
end