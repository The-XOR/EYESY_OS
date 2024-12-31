-- S - Name Mode
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Spiral Scope"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window


count = 0

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
    --of.setColor(fg)
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/2.1 )           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h , 0 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    
    of.setLineWidth(7)

    of.noFill()

    count = (count+ (knob3*24)) % 100000 
    
    spread = knob2 * 255
    
    of.pushMatrix()
        of.translate( w/2, h/2)
        of.rotateYDeg(count / 10)
        of.rotateXDeg(count / 5)
        of.rotateZDeg(count / 9)

        
        of.pushMatrix()
            of.setColor(fg, 100)
            spiralScope()
        of.popMatrix()
        
        of.pushMatrix()
            of.translate(spread, spread)
            of.rotateYDeg(knob3*30)
            of.setColor(fg, 80)
            spiralScope()
            
            of.pushMatrix()
                of.translate(spread, spread)
                of.rotateYDeg(knob3*60)
                of.setColor(fg, 60)
                spiralScope()
                
                of.pushMatrix()
                    of.translate(spread, spread)
                    of.rotateYDeg(knob3*90)
                    of.setColor(fg, 40)
                    spiralScope()
                    
                    of.pushMatrix()
                        of.translate(spread, spread)
                        of.rotateYDeg(knob3*120)
                        of.setColor(fg, 20)
                        spiralScope()
                        
                    of.popMatrix()
                of.popMatrix()
            of.popMatrix()
        of.popMatrix()
    of.popMatrix()
    
    
    
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
    
    
end

---------------------------------------------------------------------------
--Spiral Scope
function spiralScope()
    of.beginShape()
    local x0
    local y0
    local R = knob1*800     -- set radius
    for i=1,256 do
        R = R + inL[i] * 25 -- set audio gain
        local x = R*math.cos((i /  64) * 3.14) 
        local y = R*math.sin((i /  64) * 3.14) 
        of.vertex(x, y, i * 2)
        if i==1 then   
            x0 = x
            y0 = y
        end
    end
    of.endShape(false) 
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