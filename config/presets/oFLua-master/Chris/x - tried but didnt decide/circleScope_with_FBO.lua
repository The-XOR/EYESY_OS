--circle scope with FBO

print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}
rot2 =1

fbo = of.Fbo()
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(255)
   
    
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
    --white scope gets transparent rectangle of random colors printed on top of white background
    
    --Knob Jobs:
    --knob1 gain
    --knob2 radius 
    --knob3 background fade
    --knob4 line thickness
    --knob5 z rotate
    
    col1 = of.random(0,255)
    col2 = of.random(0,255)
    col3 = of.random(0,255)
    
    fbo:beginFbo()
    of.setColor(col1,col2,col3, knob3 *30) --pick random colors to build up subtle changes
	of.fill()
	of.drawRectangle(0,0,of.getWidth(),of.getHeight())
    of.noFill()

    
    of.setLineWidth(knob4*10+1)
    
    of.setColor(255)
    
    of.pushMatrix()
        of.translate(of.getWidth()/2, of.getHeight()/2, 0)
        of.rotateZDeg(rot2) -- rotates scope so that the line btwn first + last vertices does show up in same spot (usually only a problem if audio is loud/bassy)
        circleScope()
    of.popMatrix()
    

    rot2 = (rot2 + (of.random(0, knob5*50))) % 360

    fbo:endFbo()
    fbo:draw(0,0)

end

function circleScope()
    of.beginShape()
    local x0
    local y0
    local R = knob2*1023
    for i=1,256 do
        R = R + inL[i] * knob1 *120
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