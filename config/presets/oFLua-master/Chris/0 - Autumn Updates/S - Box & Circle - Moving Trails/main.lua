-- S - Box & Circle - Moving Trails
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Box & Circle - Moving Trails"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window


g = 0

fbo = of.Fbo()

xpos = 25
dir = 1
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
    
    --fbo stuff
	fbo:allocate(of.getWidth(), of.getHeight())
    fbo:beginFbo()
    of.clear(255,255,255,0)
    of.setColor(255,255,255,0)
	of.fill()
    fbo:endFbo()
    
	of.setCircleResolution(50)
	of.disableSmoothing()

    
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
    
    --of.noFill()
    --of.setLineWidth(5)
    --of.drawRectangle( 0,0,0,w, h )
    --of.drawRectangle( 0,0,0,w/8, h/8 )
    
    
    --Knob Jobs
    --knob 1 fbo size
    --knob 2 fbo move rate
    --knob 3 transparency
    --knob 4 fg color 
    --knob 5 bg color

    
    fbo:beginFbo()

	move_FBO(knob1, knob2)

    gain =1000
    of.setColor(fg)
    
    of.pushMatrix()
        of.translate( w/2-((w/2.75)/2), h/2-((w/2.75)/2) )
        box()
    of.popMatrix()
    

    of.setLineWidth(6)
    of.noFill()
    of.setColor(255,255,255,255) --of.setColor(fg)
    
    of.pushMatrix()
        of.translate(w/2, h/2)
        circleScope()
    of.popMatrix()
    
   

    fbo:endFbo()
    fbo:draw(0,0)
    
    
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
    
    
    
end


---------------------------------------------------------------------------
--move_FBO

function move_FBO( knb1, knb2)
    k1 = knb1
    k2 = knb2
    --local xpos = 0
    speed = k2*(w/9)
    fbo_width = (k1*w/4)+4
    --dir = 1
    
    if xpos > w-(fbo_width*0.7) or xpos < (0-(fbo_width/5)) then
        dir = dir * -1
    end 
    
    xpos = xpos + (speed * dir)
    
    --if fbo_width < 2 then
    --    fbo_width = 2
    --end
    
    of.setColor(bg, 255 - (knob3*255))
    --of.setColor(0,255,0)
    of.fill()
    
    --of.pushMatrix()
        --of.translate(w/2, 0)
    of.drawRectangle(xpos,0,fbo_width,h) 	--of.drawRectangle(knob1*1024,0,w/2,h) 
    --of.popMatrix()

   
    
end


---------------------------------------------------------------------------
--Circle Scope

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = h/2--knob2*1024
    for i=1,256 do
        R = R + inL[i] * (125) --(knob1*250)
        local x = R*math.cos((i /  128) * 3.14) 
        local y = R*math.sin((i /  128) * 3.14) 
        of.vertex(x, y)
        if i==1 then   
            x0 = x
            y0 = y
        end
    end
    of.vertex(x0,y0) 
    of.endShape(false) 
end

---------------------------------------------------------------------------
-- Box Scope

function box()
    of.setLineWidth(1)
    of.fill()
    
    local xw = w/2.75
    local yh = h/5
    
    of.pushMatrix()

        of.beginShape()
        --top line
        for i=1,64 do
            of.vertex(0+(i*8), 0 - inR[i]*gain)
        end

        --right line
        for i=1,64 do
            of.vertex(xw+inR[64+i]*gain, 0+i*8)
        end
    
        --bottom line
        for i=1,64 do
            of.vertex(xw-(i*8), xw - inR[128+i]*gain)
        end

        --left line
        for i=1,64 do
            of.vertex(0+inR[192+i]*gain, (xw)-i*8)
        end
        of.endShape()
    
    of.popMatrix()

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