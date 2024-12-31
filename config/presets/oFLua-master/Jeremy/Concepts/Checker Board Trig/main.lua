---- CheckerBoard Trigger 

require("eyesy")                    -- include the eyesy library
modeTitle = "Checker Board Trigger"  -- name the mode
print( modeTitle )                  -- print the mode title

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
itsPeaked = 0
timerSwitch = 0
restTimer = 0
trigger = 0
---------------------------------------------------------------------------
-- the setup function runs once before the update and draw loops
function setup() 
    
    
    of.enableBlendMode( of.BLENDMODE_ALPHA )        -- turn blend mode for transparency blending
    
    --------------------- define light
    myLight = of.Light()                            -- define a light class
    myLight:setPointLight( )                        -- we'll use a point light for this example
	myLight:setAmbientColor( 
	    of.FloatColor( 1, 1, 1 ) )                  -- and make the ambient color white
    myLight:setPosition( c + glm.vec3(0,0,h2) )     -- and set the position in the center with z closer
    
    --------------------- define color classes
    bg = of.Color()                                 -- define background color class
    fg = of.Color()                                 -- define foreground color class
    
    ---------------- fill a table of image paths, looks for Images folder
    myDirect = of.Directory()                       -- define the Directory Class
    
    thePath = myDirect:getAbsolutePath()            -- get current path
    theImgDirectory =  thePath .. "/Images"         -- look in 'Images'
    imgDir = of.Directory( theImgDirectory )        -- define new Directory class
    imgDir:allowExt( "png" )                        -- load only .png files
    imgDir:allowExt( "jpg" )                        -- and load only .jpg files
    imgDir:listDir()                                -- list the directory
    imgTable = {}                                   -- define the table
    imgTabSize = imgDir:size()                      -- size of the table
    
    for i = 1, imgTabSize do                     -- for the size of new directory do
        imagePath = imgDir:getPath( i - 1 )         -- load paths into a table
        print( "loaded image:", imagePath )         -- print so we can see what is loaded
        imgTable[ i ] = imagePath                   -- fill the table
    end
    
    imgVars = {}                                    -- define a table for variables
    
    for i = 1, imgTabSize do                     -- for loop based on how many images in folder
        imgVars[ "myImg" .. i ] = of.Image()        -- create that many image classes
        imgVars[ "myImg" .. i ]:load( imgTable[ i ] )   -- load all the images in setup
    end
    
    ---------------------------------- global variables
    imgAmt = 0
    imgIndex = 0
    
    setW = 6
    setH = 6
    setNum = setW * setH
    spaceX = w / setW
    spaceY = w / setH
    
    vars = {}
    
    for i = 0, setW - 1 do
        x = i * spaceX
        for j = 0, setH - 1 do
            count = (i * setW) + j
            y = j * spaceY
            local county = (i * (setW-1) ) + j
            point = glm.vec3( x, y, 0 )
            local howMany = math.random( 1, 8 )
            vars[ "pic_" .. count ] = pic( imgTabSize, spaceX, spaceY, point, 400, howMany, county )
        end
    end

    
    
    -- so we know that the setup was succesful
    print("done setup") 
end

---------------------------------------------------------------------------
-- update function runs on loop
function update()
   
end

-----------------------------------------------------------------------------------------------------
-- the main draw function also runs on loop
function draw()
    ----------------------- Color stuff
    colorPickHsb( knob4, fg )                   -- color for background, see above for ofColor class
    colorPickHsb( knob5, bg )                   -- color for drawings
    of.setBackgroundColor( bg )                 -- set the bg color 
    
    ----------------------- enable global modes
    of.enableLighting()                         -- enable lighting globally
    myLight:enable()                            -- begin rendering for myLight

    ---------------------- audio trigger with recovery and delay
    if( itsPeaked == 0 ) then
        if( avG() > 0.2 ) then 
            itsPeaked = 1
            of.resetElapsedTimeCounter()
            trigger = 1
            timerSwitch = 1
            --print("TRIGGR", trigger )
        end
    else
        if( timerSwitch == 1 ) then
            restTimer = of.getElapsedTimeMillis()
        end
        
        if( restTimer > 150 or avG() < 0.1 ) then
            itsPeaked = 0
            restTimer = 0
            timerSwitch = 0
        end
    end
    
    --------------------- then apply the trigger
    if( trigger == 1 ) then
        for i = 0, setNum - 1 do
            vars[ "pic_" .. i ]:rotate()
            vars[ "pic_" .. i ]:jump()
            vars[ "pic_" .. i ]:imgScramble()
        end
    
    trigger = 0                                 -- wait for next trigger
    end
    
    of.setColor( fg )
    
    for i = 0, setNum - 1 do
        vars[ "pic_" .. i ]:update()
        vars[ "pic_" .. i ]:draw()
    end
    
    
    
    ------------------------ disable lighting and depth
    myLight:disable()                           -- end rendering for myLight
    of.disableLighting()                        -- disable lighting globally
    of.popMatrix()                              -- recall last matrix
end
---------------------------------------------------------------------------------------------------
------------------------------------ OOP function for each pic
function pic( picAmt, w, h, vec3, jumMax, freq, iter )
    local self = {}                                 -- refer to self for OOP method
    
    
    self.freq = freq or 3                           -- how often the item triggers
    self.amt = picAmt or 2                          -- how many pictures are loaded
    self.width = w or 100                           -- the width of the image
    self.height = h or 100                          -- wheight of image
    self.vec3 = vec3 or glm.vec3(0,0,0)             -- x position
    self.newRDeg = 0                                -- trigger new rotation
    local rDeg = 1                                  -- internal rotation stored
    self.rCount = 0                                 -- rotation animation count
    self.rSpeed = 16                                -- speed of rotation animation
    local rDirection = 0                            -- direction variable
    
    local jumpHeight = 0                            -- target height
    local jumpIt = 0                                -- jump trigger
    local jCount = 0                                -- jump animation count
    self.jSpeed = 5                                 -- jump animation speed
    self.jMax = jumMax or 200                       -- maximum jump distance in pixels
    local jSin = 0                                  -- variable to put into the draw function for the jump
    
    local startNum = iter % 3                       -- get a 1 - 3 start number
    self.imgNum = (iter % self.amt) + 1             -- var for image number
    local imgCount = startNum                       -- var for img count trigger
    local rotCount = startNum                       -- var for rot count trigger
    local jumpCount = startNum                      -- var for jump count trigger

    --------------------------------------------------- start rotation function 
    function self.rotate()
        if( rotCount > self.freq ) then              -- if rot count greater than 10
            self.newRDeg = math.random( 1, 8 ) * 90 -- new random rotation
            if( self.newRDeg ~= rDeg ) then         -- different rotation
                if( self.newRDeg > rDeg ) then      -- determine direction
                    rDirection = 1
                elseif( self.newRDeg < rDeg ) then
                    rDirection = 0
                end
            end
            rotCount = 1
        else
            rotCount = rotCount + 1       -- add to the counter
        end        
    end
    
    ----------------------------------------------- start jump function
    function self.jump()
        if( jumpCount > self.freq ) then
            if( jumpIt == 0 ) then
                jumpHeight = (math.random( 1, 10 ) / 10) * self.jMax
                jumpIt = 1
            end
            jumpCount = 1
        else
            jumpCount = jumpCount + 1
        end        
    end
    
    -------------------------------------- random image change
    function self.imgScramble()
        if( imgCount > self.freq ) then
            local rand = math.random( 1, self.amt )
            self.imgNum = rand
            imgCount = 1
        else
            imgCount = imgCount + 1
        end        
    end
        
    function self.update()
        
        -------------------------------------------------- rotation  
        if( rDirection == 1 ) then
            if( self.rCount >= self.newRDeg ) then
                self.rCount = self.newRDeg
                rDeg = self.newRDeg
            else
                self.rCount = self.rCount + self.rSpeed    
            end
        end
        
        if( rDirection == 0 ) then
            if( self.rCount <= self.newRDeg ) then
                self.rCount = self.newRDeg   
                rDeg = self.newRDeg
            else
                self.rCount = self.rCount - self.rSpeed    
            end
        end
        
        --------------------------------------------------- jump
        if( jumpIt == 1 ) then
            if( jCount >= 100 ) then
                jCount = 0
                jumpIt = 0
            else
                jCount = jCount + self.jSpeed
                c100 = jCount / 100
                jSin = math.sin( c100 * 3.14 ) * self.jMax
            end
        end
    
    end

    function self.draw()
        local wi2 = self.width / 2
        local hi2 = self.height / 2
        of.pushMatrix()
        of.translate( self.vec3 )
        of.translate( wi2, hi2 )
        of.rotateDeg( self.rCount, 0,0,1 )
        of.translate( -wi2, -hi2 )
        lclVec = glm.vec3(0,0,0) + glm.vec3( 0,0, jSin )
        imgVars[ "myImg" .. self.imgNum ]:draw( lclVec, self.width, self.height )
        of.popMatrix()
    end
    
    
    
    return self
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