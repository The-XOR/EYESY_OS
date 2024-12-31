print("Mode: Flowers Unfilled or Filled Rotate")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}
rot = 1
----------------------------------------------------
function setup()
	--of.setWindowTitle("knobs example")
	print("script setup")
    
    of.setFrameRate(60)
    of.background(0)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    num = 10
    spacing = knob3*300
    mid = of.getWidth() / 2
    begin = mid-((num)*.5 * spacing)
    
    
    
    of.setLineWidth(knob1*20)
    
    
    of.pushMatrix()
        of.translate(of.getWidth()/2, 0,0)
        of.rotateYDeg(rot)
        for i=0,num do
            of.pushMatrix()
                --of.translate(begin + spacing*i, of.getHeight() / 2-52)
                of.translate(spacing*i, of.getHeight() / 2-52)
                of.rotateYDeg(i * 36)
                --of.setColor(i*20, 255-(i*20), knob4/4)
                if (knob4*1023) > 512 then
                    of.fill()
                    of.setColor(i*20, 255-(i*20), (1023-(knob4*1023))*.5)
                else
                    of.noFill()
                    of.setColor(i*20, 255-(i*20), (512-(knob4*1023))*.5)
                end
                --of.setColor(i*20, 255-(i*20), knob4/4)
                circleScope()
            of.popMatrix()
        end
    of.popMatrix()
    rot = (rot + (knob5*4)) % 360


end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob2*1000
    for i=1,256 do
        R = R + inL[i] * 79--knob1 * 120
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