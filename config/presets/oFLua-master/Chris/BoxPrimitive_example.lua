print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}

box = of.BoxPrimitive()
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    box:set(100)
    of.setFrameRate(60)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    begin = knob2 * 1.5
    space = knob3/5
    
    of.setLineWidth(2)
    --of.setColor(knob2/2, knob3/2, knob4/2)

    
    for i=0,10 do
        of.pushMatrix()
            of.translate((of.getWidth() / 2 + (i * knob3) - begin),of.getHeight() / 2)
            of.rotateYDeg(i * 36)

            of.setColor(i*20, 255-(i*20), knob4/4)
            --of.setColor(knob2/2, knob3/2, knob4/2)
            circleScope()
        of.popMatrix()
    end
    
    of.setColor(150,0,150)
    of.fill()
    box:setPosition(of.getWidth()*.5, of.getHeight()*.5, 0)
    box:draw()
    

end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob5
    for i=1,256 do
        R = R + inL[i] * knob1 / 20
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

----------------------------------------------------
function exit()
	print("script finished")
end
