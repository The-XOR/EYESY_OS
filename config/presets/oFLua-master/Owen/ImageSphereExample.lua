print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120

inL={}
inR={}

image = of.Image()

----------------------------------------------------
function setup()
	print("script setup")
	image:load("/home/music/openFrameworks/apps/myApps/eyesy/bin/data/images/tdf_1972_poster.jpg")
    of.setLineWidth(4);
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()

	of.pushMatrix()

	    local boxSize = knob1 + 10

	    of.translate(of.getWidth() / 2,of.getHeight()/2)
	    of.rotateXDeg(knob2)
	    of.rotateYDeg(knob3)
	    of.rotateZDeg(knob4)

	    of.fill()

        image:bind();
	        of.setColor(255,255,255)
	        of.drawSphere(boxSize)
	    image:unbind();
	
	
	    of.noFill()
	    of.setColor(255,100,255)
	    of.drawBox(boxSize * 2)
	of.popMatrix()
end

----------------------------------------------------
function exit()
	print("script finished")
end
