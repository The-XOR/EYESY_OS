module(..., package.seeall)

----MAKE LFOsine---------

function new(x, y, o)
    local locLFO = {} --make table
    
    locLFO.rate = x   --rate of LFo
    locLFO.size = y   --size of the LFO in pxls
    locLFO.start = o  --starting number (0-359)((360 is the resolution)
    
    
    function locLFO.update()    --the update function, this runs the LFO
       
        if(locLFO.start == 359) --a modulo that avoids an infintely growing number
        then locLFO.start = 0
        end
        
        locLFO.start = locLFO.start + locLFO.rate  --the counter
        
        ---this is the math that converts it to a sine wave----
        x = locLFO.start
        x = x / 360        --360 resolution converted to 0-1
        x = x * 6.283      --radians
        x = math.cos(x)    --cosine
        x = (x*0.5)+ 0.5   --scale in the positive range
        
        --than the 0-1 times the desired scale--
        return x * locLFO.size
    end
    ----OOP stuf-------
    return locLFO    
end
------------------------------------