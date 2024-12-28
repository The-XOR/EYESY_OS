print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120


inL = {}
inR = {}

rot = 0

----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")


	of.setCircleResolution(50)
	of.background(0,0,0)
	of.setFrameRate(60) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	of.disableSmoothing()
	--of.disableAlphaBlending()
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()

    of.background(0, 0, 0)
    rot = (rot + (knob5/250)) % 360
    
    gain = (knob3*1.5)+50

    -- line scope
    of.fill()
    of.setColor(0, 255, 204)--11, 111, 232)
    line1()
    
    -- line scope2
    of.noFill()
    of.setColor(255)--50, 232, 50)
    of.pushMatrix()
        --of.translate(of.getWidth() / 2,0)--of.getHeight() / 2)
        --of.translate(0, of.getHeight() / 2)
        of.rotateXDeg(rot)
        line2()
    of.popMatrix()
    
    -- horizontal line
    --of.setColor(232, 111, 50)
    --of.setLineWidth(0)
    --of.beginShape()
    --for i=1,256 do
       --of.vertex((i*(knob2/137)), 540 - inL[i]*gain)
    --end
    --of.endShape()
end

function line1()
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       of.vertex((i*(knob2/137)), i*4 - inR[i]*gain, 256-i*1)
    end
    of.endShape()
end

function line2()
    of.setLineWidth(5)
    of.beginShape()
    for i=1,256 do
       of.vertex( i*(knob2/137), 1080-i*4 - inL[i]*gain, i*1)
    end
    of.endShape()
end
    

----------------------------------------------------
function exit()
	print("script finished")
	
end