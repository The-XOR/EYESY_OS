-- spiralscope with trails    
print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}

count = 0

fbo = of.Fbo()

----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(26,26,26)

    fbo:allocate(of.getWidth(), of.getHeight())
    fbo:beginFbo()
    of.clear(255,255,255,0)
    fbo:endFbo()
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    --Knob Jobs:
    --knob1 = gain
    --knob2 = radius
    --knob3 = trails
    --knob4 = x+ytranslate amount
    --knob5 = 

    fbo:beginFbo()
    of.setColor(26,26,26, knob3 / 1024 * 30)
	of.fill()
	of.drawRectangle(0,0,of.getWidth(),of.getHeight())
    of.noFill()
    
    of.setLineWidth(5)

    of.noFill()

    count = count+1
    
    local red = 255--knob2/4
    local green = 255--knob3/4
    local blue = 204--knob4/4
    move = knob4/16+2
    ymove = knob5/8
    
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
    
    fbo:endFbo()
    fbo:draw(0,0)
end

function translate(red, green, blue, alpha)
    of.translate(move, move)
    of.setColor(red, green, blue, alpha)
    circleScope()
end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob2/2
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