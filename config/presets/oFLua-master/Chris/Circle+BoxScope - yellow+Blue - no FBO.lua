print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120

inL = {}
inR = {}

g = 0

fbo2 = of.Fbo()

----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
	
	--fbo stuff
	fbo2:allocate(of.getWidth(), of.getHeight())
    fbo2:beginFbo()
    of.clear(255,255,255,0)
    of.setColor(255,0,0, 50)
	of.fill()
    fbo2:endFbo()
    
	of.setCircleResolution(50)
	of.setFrameRate(60) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	of.disableSmoothing()

end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    --Knob Jobs
    --knob 1 circle gain 
    --knob 2 circle radius
    --knob 3 box scope gain
    --knob 4 box & circle offset
    --knob 5 

    of.background(0, 0, 0)
    
    --fbo2:beginFbo()
    --of.setColor(0,0,0, knob5 / 1024 * 30) --controls the color of the trails
	--of.fill()
	--of.drawRectangle(knob4,0,of.getWidth()/2,of.getHeight()) --only did half the screen on purpose! knob1 moves the FBO left & right

    gain = (knob3*1.5)+50
    box3()
    of.noFill()
    of.setColor(255)
    of.pushMatrix()
        --of.translate(of.getWidth() / 2, of.getHeight() / 2)
        of.translate(of.getWidth() / 2 + (knob4 * -1), of.getHeight() / 2)
        circleScope()
    of.popMatrix()
    
   
    --fbo2:endFbo()
    --fbo2:draw(0,0)
    
end

function circleScope()
    of.setLineWidth(5)
    of.beginShape()
    local x0
    local y0
    local R = knob2
    for i=1,256 do
        R = R + inL[i] * (knob1/ 4)
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


function box3()
    of.setLineWidth(1)
    --of.noFill()
    of.fill()
    --top line
    of.setColor(255-g,255,g)
    of.beginShape()
    for i=1,64 do
       of.vertex( knob4+704+(i*8), 284 - inR[i]*gain)
       --of.vertex( 704+(i*8), 284 - inR[i]*gain)
    end

    --right line
    for i=1,64 do
        of.vertex( knob4+1216+inR[64+i]*gain, 284+i*8)
        --of.vertex( 1216+inR[64+i]*gain, 284+i*8)
    end
    
    --bottom line
    for i=1,64 do
        of.vertex( knob4+1216-(i*8), 796 - inR[128+i]*gain)
        --of.vertex( 1216-(i*8), 796 - inR[128+i]*gain)
    end

    --left line
    for i=1,64 do
        of.vertex( knob4+704+inR[192+i]*gain, 796-i*8)
        --of.vertex( 704+inR[192+i]*gain, 796-i*8)
    end
    of.endShape()
    g = (g + 5) %255 --green color fade
end
    

----------------------------------------------------
function exit()
	print("script finished")
	
end