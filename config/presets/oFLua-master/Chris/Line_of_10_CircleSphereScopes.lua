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
    of.setFrameRate(60)
    of.background(0)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    num = 10
    spacing = knob3/3
    mid = of.getWidth() / 2
    begin = mid-((num)*.5 * spacing)
    
    
    of.setLineWidth(2)
    
    if knob5 > 500 then
        of.fill()
    else
        of.noFill()
    end
    
    for i=0,num do
        of.pushMatrix()
            of.translate(begin + spacing*i, of.getHeight() / 2-52)
            of.rotateYDeg(i * 36)
            of.setColor(i*20, 255-(i*20), knob4/4)
            circleScope()
        of.popMatrix()
    end


end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob2
    for i=1,256 do
        R = R + inL[i] * knob1 / 8
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