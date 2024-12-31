-- S - X Scope With Horizontal
require("eyesy")                    -- include the eyesy library
modeTitle = "S - X Scope With Horizontal"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    -- define camera 
    theCam = of.Camera()
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    -- set up the light
    theLight = of.Light()                                   -- define light class
    theLight:setup()                                        -- start the light
	theLight:setPointLight( )                               -- set as a point light
	theLight:setAmbientColor( of.FloatColor( 1, 1, 1 ) )    -- make the ambient color white
	
	-- turn on Depth, set blend mode and frame rate
    of.enableDepthTest()
    of.setFrameRate(60)
    
end

---------------------------------------------------------------------------
-- update function part of main loop
function update()
end

---------------------------------------------------------------------------
-- the draw loop
function draw()
    
    -- color stuff
    colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor( bg )
    of.setColor(fg)
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/1.2 )           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h , 0 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    of.noFill()
    of.setLineWidth(5)
    of.drawRectangle( 0,0,0,w, h )
    of.drawRectangle( 0,0,0,w/8, h/8 )
    
    rot = knob1*90
    len = knob2*8.5
    of.noFill()
   
    --of.background(0, 0, 0)
    of.setColor(11, 111, 232)
    
    gain = (knob3*1500)+50
    
    -- line scope
    of.setColor(53, 151, 102)
    of.setLineWidth(4)
    of.pushMatrix()
        --of.translate ()
        of.rotateZDeg(rot)
        of.beginShape()
        --for i=1,256 do
           -- --of.vertex((1280+i*(knob2/137))%1920, i*4 - inL[i]*gain)
        --    --of.vertex((i*(knob2*9)), i*4 - inL[i]*gain)
            --of.vertex(i*len, inL[i]*gain)
        --end
        of.endShape()
    of.popMatrix()
    
    -- line scope2
    of.setColor(255, 128, 179)
    of.setLineWidth(4)
    of.pushMatrix()
        of.translate(0,h/2,0)
        of.beginShape()
        for i=1,256 do
            --of.vertex((640+i*(knob2/137))%1920, 540 - inL[i]*gain)
            of.vertex(i*w/256, inL[i]*gain)
        end
        of.endShape()
    of.popMatrix()
    
    -- line scope3
    of.setColor(230, 230, 0)
    of.setLineWidth(4)
    of.pushMatrix()
        of.translate(0,h,0)
        of.rotateZDeg(rot*-1)
        of.beginShape()
        --for i=1,256 do
           -- --of.vertex( i*(knob2*9), 1080-i*4 - inL[i]*gain)
            --of.vertex(i*len, inL[i]*gain)
        --end
        of.endShape()
    of.popMatrix()
    --print(rot)
    
    of.setColor(255, 128, 179)
    of.pushMatrix()
        of.translate(w/2,h/2,0)
        of.setColor(255, 0, 0)
        of.setLineWidth(4)
        hexScopes()
    of.popMatrix()
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
    
    
end


---------------------------------------------------------------------------
function hexScopes()
    
    of.setColor(53, 151, 102)
    
    of.beginShape()
    for i=1,256 do
       local slantx = i*w/256-w/2
       local slanty = (i-1)*h/255-h/2
       local soundL = inL[i]*gain
        of.vertex(slantx,slanty+soundL)
    end
    of.endShape()
    
    of.setColor(230, 230, 0)
    of.beginShape()
    for i=1,256 do
       local slantx = i*w/256-w/2
       local slanty = (i-1)*h/255-h/2
       local soundR = inL[i]*gain
        of.vertex( -slantx, slanty+soundR )
    end
    of.endShape()
end



---------------------------------------------------------------------------
--color picker
function colorPickHSB( knob, name )
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

------------------------------------ the exit function ends the update and draw loops
function exit()
    
    of.disableDepthTest()           -- disable depth
    print("script finished")        -- report finished
end