print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}

count = 0


----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(0)

end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    of.setLineWidth(5)

    of.noFill()

    count = count+1
    
    local red = knob2/4
    local green = knob3/4
    local blue = knob4/4
    of.pushMatrix()
        of.translate(of.getWidth() / 2, of.getHeight() / 2)
        of.rotateYDeg(count / 10)
        of.rotateXDeg(count / 5)
        of.rotateZDeg(count / 9)

        
        of.pushMatrix()
            of.setColor(red, green, blue, 100)
            circleScope()
        of.popMatrix()
        
        of.pushMatrix()
            translate(red,green,blue,80)
            of.pushMatrix()
                translate(red,green,blue,60)
                of.pushMatrix()
                    translate(red,green,blue,40)
                    of.pushMatrix()
                        translate(red,green,blue,20)
                    of.popMatrix()
                of.popMatrix()
            of.popMatrix()
        of.popMatrix()
    of.popMatrix()
end

function translate(red, green, blue, alpha)
    of.translate(10, 10)
    of.setColor(red, green, blue, alpha)
    circleScope()
end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob5
    for i=1,256 do
        R = R + inL[i] * knob1 / 20
        local x = R*math.cos((i /  64) * 3.14) 
        local y = R*math.sin((i /  64) * 3.14) 
        of.vertex(x, y, i * 2)
        if i==1 then   
            x0 = x
            y0 = y
        end
    end
    --of.vertex(x0,y0) 
    of.endShape(false) 
end

----------------------------------------------------
function exit()
	print("script finished")
end