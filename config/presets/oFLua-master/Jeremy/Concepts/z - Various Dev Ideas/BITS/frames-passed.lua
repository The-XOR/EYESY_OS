----- Bits and PIECES ----


-- function for frames that have passed ---

function frame(x, y)
    -- frame rate dependent time-- 
    local locTime = {}      -- define local table
    
    locTime.res = x or 360  -- the resolution of the loop
    locTime.step = y or 1   -- how big the step is for each frame
    locTime.current = 0     -- start
    
    function locTime.update()
        if(locTime.current >= locTime.res)
        then locTime.current = 0
        end
        locTime.current = locTime.current + locTime.step -- add to the count
    end
    
return locTime

end

