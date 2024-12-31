---- GRADIENT SOUND ALPHA
require("eyesy")                    -- include the eyesy library
modeTitle = "GRADIENT SOUND ALPHA"  -- name the mode
print(modeTitle)                    -- print the mode title

---------------------------------------------------------------------------
-- helpful global variables 
w = of.getWidth()           -- width of screen, this function returns the width of the screen in pixels
h = of.getHeight()          -- height of screen, same as above but height
w2 = w / 2                  -- width half 
h2 = h / 2                  -- height half
w4 = w / 4                  -- width quarter
h4 = h / 4                  -- height quarter

gRid = 10
xSpace = w / ( gRid-1 )
ySpace = h / ( gRid-1 )

---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    bg = of.Color()
    fg = of.Color()
    
    smoothIn = averageInL( 6 )                      -- define global table of smoothed audio buffer 
    
    
    ------------------------- mesh
    
    myMesh = of.Mesh()
    myMesh:setMode( of.PRIMITIVE_TRIANGLES )        -- set the mesh mode to triangles
    
    for i = 0, gRid-1 do
        xPos = i * xSpace
        for j = 0, gRid-1 do
            yPos = j * ySpace
            
            myMesh:addVertex( glm.vec3( xPos, yPos, 0) )    -- add first vertex
            myMesh:addColor( of.FloatColor( 1,0,0 ) )       -- make it blue
        end
    end
    
    for x = 0, gRid-2 do
        
        for j = 0, gRid-2 do
           
            i = (x*gRid) + j
            myMesh:addIndex( i )
            myMesh:addIndex( i+1 )
            myMesh:addIndex( i+gRid )
        
            myMesh:addIndex( i+(gRid+1) )
            myMesh:addIndex( i+1 )
            myMesh:addIndex( i+gRid )
        end
    end
     of.enableBlendMode( of.BLENDMODE_ALPHA )
    
    
    
end

---------------------------------------------------------------------------
function update()
    
   
end

---------------------------------------------------------------------------
function draw()
    
    avgTable = smoothIn.update()                -- this fills a table called avgTable
    
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
    
    
   
    
    intense = math.pow( knob1, 2 ) * 20
   
    maxG = math.floor( (gRid) * (gRid) )
    
    for i = 0, maxG-1 do
        
        audio = avgTable[ (i%100)+1 ] * intense
        
        color = of.FloatColor()
       
        color:setHsb(  fg:getHue()/255,
                       fg:getSaturation()/255,
                       fg:getBrightness()/255,
                       knob3 - audio
                    )
        
        
        myMesh:setColor( i, color )
    end
    
    of.pushMatrix()                     -- save matrix
    of.translate( 0,0, -(knob2*2000) )
    myMesh:draw()               
    
    of.popMatrix()
    
end
---------------------------------------------------------------------------------------------------
-- this is how the knobs pick color
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

------------------------------------------- average the audio buffer
function averageInL( amt )      -- this oop averages each audio buffer point
    local self = {}
   
    self.amount = amt or 10              -- how many loops to average
    self.amtMin = math.max( self.amount, 1 )
    self.count = 1
    
    local countTab = {}             -- make a table with 100 tables with the amount size
    for i = 1, 100 do               
        countTab[i] = {}
        for j = 1, self.amtMin do
            countTab[i][j] = 0
        end
    end
    
    local averageTab = {}           -- make a table with 100 numbers
    for i = 1, 100 do               
        averageTab[i] = 0
    end
    
    
    function self.update()
        if( self.count > self.amtMin ) then
            self.count = 1
        else
            self.count = self.count + 1
        end
        for i = 1, 100 do
            ----- fill the count table
            countTab[i][self.count] = inL[i]
            local added = 0
            for j = 1, self.amtMin do
                added = added + countTab[i][j]
            end
            getAverage = added / self.amtMin
            
            averageTab[i] = getAverage
        end
        
        return averageTab
    end
    
    return self
end 
  

------------------------------------ the exit function ends the update and draw loops
function exit()
    -- so we know the script is done
    print("script finished")
end