-- S - Freeze Donut
require("eyesy")                    -- include the eyesy library
modeTitle = "S - Freeze Donut"      -- name the mode
print(modeTitle)                    -- print the mode title in the print window

---------------------------------------------------------------------------
-- set up function
function setup()
    -- global variables 
    w = of.getWidth()                   -- width of screen, this function returns the width of the screen in pixels
    h = of.getHeight()                  -- height of screen, same as above but height
    count = 0
    globAmount = 100
    countCompare = 0
    
    -- define colors
    bg = of.Color()
    fg = of.Color()
    modCol = of.Color()
    
    -- tabel
    freeze = {}
    for i = 1, globAmount do
        freeze[i] = 0
    end
    
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
    
    -- knob stuff
    k1Raw = math.abs( (knob1 * 0.2) - 0.1 )
    rater = math.pow( k1Raw, 2 )
    
    if( knob1 > 0.5 ) then
        k1Direction = 1
    else
        k1Direction = -1
    end
    
    if ( count > 1 ) then
        count = 0
    elseif ( count < 0 ) then
        count = 1
    end
    
    count = count + (rater*k1Direction)
    
    mesh = ring( h/2, 100, h/20, 10, fg )
    of.translate(w/2,h/2)
    of.rotateXDeg( knob2*360 )
    of.rotateZDeg( count*360 )
    
    -- fill the freeze table
    loopCount = math.floor(count*globAmount )
    if( countCompare ~= loopCount ) then
        freeze[ loopCount+1 ] = inL[ loopCount+1 ]
        countCompare = loopCount
    end
    
    for i = 0, 99 do
        local aud = freeze[i+1] * (h/2)
        
        for j = 0, 9 do
            local it = (i * 10) + j
            local vert = mesh:getVertex(it)
            
            mesh:setVertex( it, vert + glm.vec3( 0, 0, aud) )
        end
    end    
        
    mesh:draw()
end


---------------------------------------------------------------------------
-- 3d Ring
function ring( radius, def, thick, thickDef, locColor )
    local mesh = of.Mesh()
    mesh:clear()
    mesh:setMode( of.PRIMITIVE_TRIANGLES )
    
    for i = 0, def-1 do
        local iter = i/def
        local xPos = math.sin( iter * (math.pi*2) ) 
        local yPos = math.cos( iter * (math.pi*2) )
        
        for j = 0, thickDef-1 do
            inc = math.sin( (j/thickDef) * (math.pi*2) )
            cosInc = math.cos( (j/thickDef) * (math.pi*2) )
            jX = inc * thick
            x = xPos * (radius+jX)
            jZ = cosInc * thick
            z = jZ
            jY = inc * thick
            y =  yPos * (radius+jY) 
            mesh:addVertex( glm.vec3(x,y,z) )
        end
    end
    
    for i = 0, def-1 do
        local m = thickDef
        local iStep = ( i % def ) * m
        local iStep2 = ( (i+1) % def ) * m
        
        for j = 0, thickDef-1 do
        
            x1 = iStep + (j % m)
            x2 = iStep + ((j+1) % m)
            x3 = iStep2 + ((j) % m)
            x4 = iStep2 + ((j+1) % m)
            
            mesh:addTriangle( x1, x2, x3 )
            mesh:addTriangle( x2, x3, x4 )
            
            
        end
    end
    
    for i = 0, (def) * (thickDef) do
        if( i%(thickDef) == 0 ) then
            mesh:addColor( of.FloatColor( (locColor.r/256)+0.75, (locColor.g/256)+0.75, (locColor.b/256)+0.75 ) )
        
        elseif( i%(thickDef) == math.floor(thickDef/2) ) then
            mesh:addColor( of.FloatColor( (locColor.r/256)+0.75, (locColor.g/256)+0.75, (locColor.b/256)+0.75 ) )
        
        elseif( i%(thickDef) == math.floor(thickDef/3) ) then
            mesh:addColor( of.FloatColor( (locColor.r/256)+0.5, (locColor.g/256)+0.5, (locColor.b/256)+0.5 ) )
        
        else
            mesh:addColor( of.FloatColor(locColor.r/256,locColor.g/256,locColor.b/256) )
        
        end
    end
    
    return mesh
    
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

---------------------------------------------------------------------------
-- average the audio buffer
function slider( step )
    local self = {}
    self.current = 0
    self.direction = 1
    self.step = step or 1
    self.new = 0
    self.target = 0
    self.space = 0
    
    function self.update()
        if( math.abs(self.target - self.current) > 0.1 ) then
            --set direction
            if( self.target < self.current) then
                self.direction = -1
            else
                self.direction = 1
            end
            --set step
            self.space = math.abs(self.target - self.current )
            self.step = self.space / 2
            self.current = self.current + (self.step*self.direction)
        end
        return self.current
    end
    
    return self
end

------------------------------------ the exit function ends the update and draw loops
function exit()
    print("script finished")        -- report finished
end