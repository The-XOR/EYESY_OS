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

   
    of.background(33, 33, 33)
    of.setColor(11, 111, 232)
    of.setLineWidth(2)
    of.noFill()


	for i=0,50 do
        of.pushMatrix()
            of.translate(of.getWidth() / 2, of.getHeight() / 2 + (i*(knob2 / 5)), (i * (knob1 - 512)))
            of.setColor(i*5, 111, 232)
            drawScope()
        of.popMatrix()
    end

end

function drawScope()
    of.beginShape()
    for i=1,256 do
       of.vertex(i*8 - 1024, inL[i]*800)
    end
    of.endShape()
end

----------------------------------------------------
function exit()
	print("script finished")
end