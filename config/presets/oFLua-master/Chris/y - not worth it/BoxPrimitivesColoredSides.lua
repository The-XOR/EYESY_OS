print("Hello Worlsssd!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}

box = of.BoxPrimitive()
cam = of.Camera()
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    box:set(100)
    of.setFrameRate(60)
    of.enableDepthTest()
    red = of.Color(255, 0, 0)
    blu = of.Color(0, 0, 200)
    gre = of.Color(0, 250, 0)
    yel = of.Color(255, 255, 0)
    org = of.Color(200, 45, 0)
    pur = of.Color(255, 0, 200)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    cam:beginCamera()
    of.pushMatrix()
        cam:setPosition(of.getWidth() / 2, knob4*2, 1200) --of.getHeight() / 2, 1200)--knob4)
        cam:tiltDeg(knob5/512)
        
        begin = 1000--knob2 * 1.5
    
        of.setLineWidth(5)
    --of.setColor(knob2/2, knob3/2, knob4/2)

    
        for i=0,10 do
            of.pushMatrix()
                of.translate((of.getWidth() / 2 + (i * 200) - begin),of.getHeight() / 2)
                of.rotateYDeg(i * 36)

                of.setColor(i*20, 255-(i*20), knob2/4)
                of.noFill()
                --of.setColor(knob2/2, knob3/2, knob4/2)
                circleScope()
            of.popMatrix()
        end
    
        of.setColor(150,0,150)
        of.fill()
        box:set(100)
        box:setPosition(of.getWidth()*.25, of.getHeight()*.25, 0)
        box:draw()
    
        of.setColor(0,0,0)
        of.noFill()
        boxery()

    of.popMatrix()
    cam:endCamera()
end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob3
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

function boxery()
    local audio = 0
    box:setPosition(of.getWidth()*.5, of.getHeight()*.5, 0)
    for i=1,255 do
        audio = audio + inL[i] * knob1/20
        --box:set(100, inL[i] * knob1/20 ,100)
        box:setHeight(audio+100)
    end
    box:setSideColor(1, red)
    box:setSideColor(2, pur)
    box:setSideColor(3, gre)
    box:setSideColor(4, blu)
    box:setSideColor(5, org)
    box:setSideColor(6, yel)
    box:draw()
end

----------------------------------------------------
function exit()
	print("script finished")
end
