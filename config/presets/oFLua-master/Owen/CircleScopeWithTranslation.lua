print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
  
    of.setLineWidth(2)
    of.setColor(knob2/4, knob3/4, knob4/4);   
    
    of.pushMatrix()
    	of.translate(500,500)
    	of.rotateXDeg(knob2)
    	of.rotateYDeg(knob3)
    	of.rotateZDeg(knob4)
    	of.fill()
    
         of.beginShape()
            local x0
            local y0
            for i=1,256 do
    
                local R = inL[i] * knob1 * 10
                local x = R*math.cos((i /  256) * 3.14) + of.getWidth() / 2
                local y = R*math.sin((i /  256) * 3.14) + of.getHeight() / 2
                of.vertex(x, y)
                if i==1 then   
                    x0 = x
                    y0 = y
                end
            end
            of.vertex(x0,y0) 
         of.endShape(false)
     of.popMatrix()
end

----------------------------------------------------
function exit()
	print("script finished")
end


