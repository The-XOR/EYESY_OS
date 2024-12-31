-- Smooth Movement Function (not finished) --
function smooth(o,x,y)
    
    local self = {}
    
    self.start = o or 0
    self.targ = x or 1
    self.amt = y or 1
    self.direction = 1
    

    function self.go(z)
	
		if(z > self.start)
			do self.direction = 1
        end
        
        if(z < self.start)
        	do self.direction = -1
        end
        
        if(self.start == self.start)
        	do self.start = self.start
        else
        	self.start = self.start + (self.amt * self.direction)
        end

        return self.start
    end

    return self
end   