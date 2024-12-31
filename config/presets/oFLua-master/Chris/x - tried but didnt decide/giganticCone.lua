print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}
rot = 1
rot2 =1
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(0)
    of.enableDepthTest()
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    num = 2
    spacing = knob3*50
    mid = of.getWidth() / 2
    begin = mid-((num)*.5 * spacing)
    
    
    
    of.setLineWidth(4)
    
    
    of.pushMatrix()
        of.translate(of.getWidth()/2, of.getHeight()/2,0)
        of.rotateYDeg(rot)
        of.rotateZDeg(rot2)
        lines()
        for i=0,num do
            of.pushMatrix()
                --of.translate(begin + spacing*i, of.getHeight() / 2-52)
                --of.translate(spacing*i, of.getHeight() / 2-52)
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
                --circleScope()
            of.popMatrix()
                --lines()
        end
    of.popMatrix()
    
    of.pushMatrix()
        of.translate(of.getWidth()/2, of.getHeight()/2,0)
        of.rotateYDeg(rot)
        of.rotateZDeg(rot2)
        lines2()
        for i=0,num do
            of.pushMatrix()
                --of.translate(begin + spacing*i, of.getHeight() / 2-52)
                --of.translate(spacing*i, of.getHeight() / 2-52)
                of.rotateYDeg(i * 36)
                --of.setColor(i*20, 255-(i*20), knob4/4)
                if (knob4*1023) > 512 then
                    of.fill()
                    of.setColor(i*20, 255-(i*20), (1023-(knob4*1023))*.5)
                else
                    of.noFill()
                    of.setColor(i*20, 255-(i*20), (512-(knob4*1023)*.5))
                end
                --of.setColor(i*20, 255-(i*20), knob4/4)
                --circleScope()
            of.popMatrix()
            --lines2()
        end
    of.popMatrix()
    rot = (rot + (knob5*4)) % 360
    rot2 = (rot2 + (of.random(0, knob5*5))) % 360


end

function lines()
    --of.setColor(255)
    for i=1,20 do
        of.setColor(i*5, 200-i*6, i*10)
        --of.setLineWidth(inL[i] * knob2 / 10)
        --of.drawLine(i*20,0,inL[i+40] * knob1,  inL[i+20] * knob1,500, inL[i] * knob1 / 4)
        of.drawLine(i*spacing,0,0,  inL[i+20] * (knob1*1023),500, inL[i] * knob1*250)
    end
end

function lines2()
    --of.setColor(255)
    for i=1,20 do
        of.setLineWidth(1+(i/2))
        --of.rotateXDeg(i)
        of.rotateXDeg(knob4 / 49)
        of.setColor(75+i*5, 30+i*2, i*5)
        --of.setLineWidth(inL[i] * knob2 / 10)
        --of.drawLine(i*20,0,inL[i+40] * knob1,  inL[i+20] * knob1,500, inL[i] * knob1 / 4)
        of.drawLine(i*spacing,0,0,  inL[i+20] * (knob1*1023),500, inL[i] * knob1*250)
    end
end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob2*1023
    for i=1,256 do
        R = R + inL[i] * knob1*120
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