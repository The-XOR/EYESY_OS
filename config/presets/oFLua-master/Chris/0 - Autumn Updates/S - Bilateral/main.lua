-- S - Bilateral
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Bilateral"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

fbo = of.Fbo()
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
	
	fbo:allocate(w, h)
    fbo:beginFbo()
    of.clear(0,0,0,0)
    fbo:endFbo()
	
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
    --colorPickHSB( knob4, fg )                       -- color for background, see above for ofColor class
    colorPickHSB( knob5, bg )                       -- color for drawings
    of.setBackgroundColor(bg)--bg )
    of.setColor(fg)
    
    -- camera/light stuff
    theCam:setPosition( w/2, h/2, w/2.05 )           -- set camera position, change z
    theCam:setVFlip( true )
    theLight:setPosition( w/2, h , 0 )              -- set light position, change x
    theLight:enable()
    theCam:beginCamera()
    
    --knobs
    --knob1 linewidth
    --knob2 scope length
    --knob3 x offset
    --knob4 fbo opacity
    --knob5 background color
    
    of.setLineWidth(knob1*15+1)
    
    fbo:beginFbo()
    of.setColor(bg, knob4 * 255)
	of.fill()
	of.drawRectangle(0,0,w,h)

    of.noFill()
    
    of.pushMatrix()

	    of.translate( w/2,h/2)
	    
        len = knob2*w
        offsetX = knob3*w/2+8

	    --left line (when offsetX at 0)
	    a = glm.vec3(offsetX, 0, 0)
	    b = glm.vec3(offsetX-len, 0, 0)
        of.setColor(of.random(255), of.random(255), of.random(255), 255)
        draw3DScope(a,b,1080,2,256)
	    
	    --right line (when offsetX at 0)
	    c = glm.vec3(offsetX*-1, 0,0)
	    d = glm.vec3(offsetX*-1+len, 0,0)
	    of.setColor(of.random(255), of.random(255), of.random(255), 255)
        draw3DScope(c,d,1080,2,256)

	of.popMatrix()
	
	fbo:endFbo()
    fbo:draw(0,0)
        
    -- turn off light and camera
    theLight:disable()
    theCam:endCamera()
       
end


----------------------------------------------------
-- Draw 3D Scope
function draw3DScope(a, b, amplitude, axis, vertices)
    local stepx = (b.x - a.x) / vertices--256 max vertices
    local stepy = (b.y - a.y) / vertices--256 max vertices
    local stepz = (b.z - a.z) / vertices--256 max vertices
    of.beginShape()
    for i=1,vertices do
        if axis == 1 then
            of.vertex(a.x + stepx*i + inL[i]*amplitude, a.y + stepy*i, a.z + stepz*i)
        end
        if axis == 2 then
            of.vertex(a.x + stepx*i, a.y + stepy*i + inL[i]*amplitude, a.z + stepz*i)
        end
        if axis == 3 then
            of.vertex(a.x + stepx*i, a.y + stepy*i, a.z + stepz*i + inL[i]*amplitude)
        end
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