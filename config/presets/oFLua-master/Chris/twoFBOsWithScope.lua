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
fbo2 = of.Fbo()

----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    
    fbo2:allocate(of.getWidth(), of.getHeight())
    fbo2:beginFbo()
    of.clear(255,255,255,0)
    of.setColor(255,0,0, 50)
	of.fill()
	of.drawRectangle(200,200,400,450)
	of.noFill()
    --of.background(255,255,255)
    --of.clear(255,255,255,0)
    fbo2:endFbo()
    
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
    
    --Knob Jobs
    --knob 1 gain
    --knob 2 radius
    --knob 3 fbo movement
    --knob 4 scope color
    --knob 5 transparency

    fbo2:beginFbo()
    --of.background(0,250,0)
    fbo:beginFbo()
    --of.background(250,250,250)
    of.setColor(255,255,255, knob5 / 1024 * 30)
	of.fill()
	of.drawRectangle(0,0,of.getWidth(),of.getHeight())
	
    of.setLineWidth(3)
    of.noFill()

    count = count+1
    of.pushMatrix()
        of.translate(of.getWidth() / 2, of.getHeight() / 2)
        of.setColor(knob4/4,128+knob4/8,255)
        circleScope()
    of.popMatrix()
    

    
    fbo:endFbo()
    fbo:draw(knob3*1.5,0)
    
    fbo2:endFbo()
    fbo2:draw(0,0)
    

end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob2
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