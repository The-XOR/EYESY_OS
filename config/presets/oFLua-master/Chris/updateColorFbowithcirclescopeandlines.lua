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

fbo = of.Fbo()
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(0)
    --of.enableDepthTest()
    
    fbo:allocate(of.getWidth(), of.getHeight())
    fbo:beginFbo()
    --of.background(255,255,255)
    of.clear(255,255,255,0)
    fbo:endFbo()
    --fbo:draw(0,0)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    --Knob Jobs:
    --knob1 gain
    --knob2 background fade
    --knob3 spacing
    --knob4 lines2 xrotated
    --knob5 y & z rotate
    
    fbo:beginFbo()
    of.setColor(255,255,255, knob2 / 1024 * 30)
	of.fill()
	of.drawRectangle(0,0,of.getWidth(),of.getHeight())
    of.noFill()
    
    num = 2
    spacing = knob3/20
    mid = of.getWidth() / 2
    begin = mid-((num)*.5 * spacing)
    
    

    
    of.setLineWidth(4)
    
    of.setColor(255)
    circleScope()
    
    
    of.pushMatrix()
        of.translate(of.getWidth()/2, of.getHeight()/2,0)
        of.rotateYDeg(rot)
        of.rotateZDeg(rot2)
        lines()
    of.popMatrix()
    
    of.pushMatrix()
        of.translate(of.getWidth()/2, of.getHeight()/2,0)
        of.rotateYDeg(rot)
        of.rotateZDeg(rot2)
        lines2()
    of.popMatrix()
    rot = (rot + (knob5/250)) % 360
    rot2 = (rot2 + (of.random(0, knob5/220))) % 360

    fbo:endFbo()
    fbo:draw(0,0)

end

function lines()

    for i=1,20 do
        of.setColor(i*5, 200-i*6, i*10)
        of.drawLine(i*spacing,0,0,  inL[i+20] * knob1,500, inL[i] * knob1 / 4)
    end
end

function lines2()

    for i=1,20 do
        of.setLineWidth(1+(i/2))
        of.rotateXDeg(knob4 / 49)
        of.setColor(75+i*5, 30+i*2, i*5)
        of.drawLine(i*spacing,0,0,  inL[i+20] * knob1,500, inL[i] * knob1 / 4)
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