---- Chris Scope
require("eyesy")                    -- include the eyesy library
modeTitle = "Chris Scope"           -- name the mode
print(modeTitle)                    -- print the mode title

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2                  -- width half 
h2 = h / 2                  -- height half
w4 = w / 4                  -- width quarter
h4 = h / 4                  -- height quarter
w6 = w / 6                  -- width 6th
h6 = h / 6                  -- height 6th
w8 = w / 8                  -- width 8th
h8 = h / 8                  -- height 8th
h16 = h / 16                -- 16th height
c = glm.vec3( w2, h2, 0 )   -- center in glm vector



---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    of.enableBlendMode(of.BLENDMODE_ALPHA)      -- turn blend mode for transparency blending
    
    --------------------- define light
    myLight = of.Light()                        -- define a light class
    myLight:setPointLight( )                    -- we'll use a point light for this example
	myLight:setAmbientColor( 
	    of.FloatColor( 1, 1, 1 ) )              -- and make the ambient color white
    myLight:setPosition( c + glm.vec3(0,0,h2) ) -- and set the position in the center with z closer
    
    --------------------- define color classes
    bg = of.Color()                             -- define background color class
    fg = of.Color()                             -- define foreground color class
    
    --------------------- define mesh class and mesh for lines
    myMesh = of.Mesh()
    myMesh:setMode( of.PRIMITIVE_LINE_STRIP )       -- set the mesh mode to triangles
    
    change = 0
    pMaxx = 50
    pSpread = 11
    wSeg = w / pMaxx
   
    ---- add vertices to make a horizontal line
    for i = 0, pMaxx do
        x = i * wSeg
        myMesh:addVertex( glm.vec3( x, 0, 0) )
    end
    
   
    -- so we know that the setup was succesful
    print("done setup") 
end
---------------------------------------------------------------------------
-- update function runs on loop
function update()
    end

---------------------------------------------------------------------------
-- the main draw function also runs on loop
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
    
    ----------------------- enable global modes
    of.enableLighting()                         -- enable lighting globally
    of.enableDepthTest()                        -- enable 3D rendering globally
    myLight:enable()                            -- begin rendering for myLight
    
   
    
    of.translate( 0, h2)
    of.pushMatrix()                             -- save the h2 matrix
    of.setColor( fg )
    of.setLineWidth( 4 )
    
    lineAmt = ( knob2*47 ) + 3
    hSeg = h / lineAmt
    for i = 0,  lineAmt do
        line( i )
    end
   
    ------------------------ disable lighting and depth
    myLight:disable()                           -- end rendering for myLight
    of.disableLighting()                        -- disable lighting globally
    of.disableDepthTest()                       -- enable 3D rendering globally
    of.popMatrix()                              -- recall last matrix
end
---------------------------------------------------------------------------------------------------
------------------------------------ function to draw line
function line( num )
    of.popMatrix()                              -- recall last matrix
    of.pushMatrix()                             -- save again
    
    ogPs = {}
    newPs = {}
    pS = pSpread-1
    pS2 = pS / 2
    pScal = 50 / lineAmt
    for i = 0, pS do                        -- get the vertex and the two to its left and 2 right
        iter = i + 1                        -- +1 for lua tables (1-5)
        pMod = num + (i - pS2)              -- mod for -2 to 2 (5 points)
        
        aMod = math.abs(i - pS2) + 1                -- modulate audio 3,2,1,2,3
        if( pMod > 0 and pMod < pMaxx ) then        -- if to keep in bounds
            sound = inL[ num+1 ] * h2               -- the audio, max height h2
            scalS = sound / aMod                    -- scale audio
            pnts = myMesh:getVertex( pMod*pScal )         -- get the vertex
            ogPs[ iter ] = pnts                     -- fill og table so we can return original value
            newPoint = myMesh:getVertex( pMod*pScal )     -- define a vertex point to edit
            newPoint.y = scalS                      -- change the y with the sound
            myMesh:setVertex( pMod*pScal, newPoint )      -- set the new Vertex
        end
        
    end
    
    adjustHseg = knob1 * hSeg
    move = ( num-(lineAmt/2) ) * adjustHseg 
    of.translate( 0, move )
    myMesh:draw()
    
    for i = 0, pS do
        iter = i + 1                            -- +1 for lua tables (1-5)
        pMod = num + (i - pS2)                  -- mod for -2 to 2 (5 points)
        
        if( pMod > 0 and pMod < pMaxx ) then
            myMesh:setVertex( pMod*pScal, ogPs[iter] ) -- return the point back to og position 
        end
    end

end
------------------------------------ function for audio average
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

------------------------------------ Color Function
function colorPickHsb( knob, name )
    -- middle of the knob will be bright RBG, far right white, far left black
    
    k6 = (knob * 5) + 1                     -- split knob into 8ths
    hue = (k6 * 255) % 255 
    kLow = math.min( knob, 0.49 ) * 2       -- the lower half of knob is 0 - 1
    kLowPow = math.pow( kLow, 2 )
    kH = math.max( knob, 0.5 ) - 0.5    
    kHigh = 1 - (kH*2)                      -- the upper half is 1 - 0
    kHighPow = math.pow( kHigh, 0.5 )
    
    bright = kLow * 255                     -- brightness is 0 - 1
    sat = kHighPow * 255                    -- saturation is 1 - 0
    
    name:setHsb( hue, sat, bright )         -- set the ofColor, defined above
end

------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end