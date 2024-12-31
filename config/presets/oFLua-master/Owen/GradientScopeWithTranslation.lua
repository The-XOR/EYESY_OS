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

    of.pushMatrix()


	of.translate(500,500)
	of.rotateXDeg(knob2)
	of.rotateYDeg(knob3)
	of.rotateZDeg(knob4)
	of.fill()
   
    of.background(33, 33, 33)
    of.setColor(11, 111, 232)

   -- print(table.getn(inL))
    --print(inL[2] * 500)
    
    -- circle scope
    for i=1,256 do
        of.setColor(i, 111, 232)
        --of.setColor(of.random(0, 255), of.random(0, 255), of.random(0, 255))
        of.drawCircle(1000, i*5, inL[i] * 500 +1)
    end
    
    -- line scope
    of.setLineWidth(4);
    of.beginShape();
    for i=1,256 do
        --of.setColor(of.random(0, 255), of.random(0, 255), of.random(0, 255))
        of.setColor(i, 111, 232)
       of.vertex(i*3, 360 - inL[i]*500);
    end
    of.endShape();
    of.popMatrix()

end

----------------------------------------------------
function exit()
	print("script finished")
	
end



