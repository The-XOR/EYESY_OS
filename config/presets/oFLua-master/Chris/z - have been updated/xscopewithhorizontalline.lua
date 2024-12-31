print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120


inL = {}
inR = {.5,.5,.5}

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

    
	of.noFill()
   
    of.background(0, 0, 0)
    of.setColor(11, 111, 232)
    
    gain = (knob3*1500)+50
    
    -- line scope
    of.setColor(53, 151, 102)
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       --of.vertex((1280+i*(knob2/137))%1920, i*4 - inL[i]*gain)
       of.vertex((i*(knob2*9)), i*4 - inL[i]*gain)
    end
    of.endShape()
    
    -- line scope2
    of.setColor(255, 128, 179)
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       --of.vertex((640+i*(knob2/137))%1920, 540 - inL[i]*gain)
       of.vertex((i*(knob2*9)), 540 - inL[i]*gain)
    end
    of.endShape()
    
    -- line scope2
    of.setColor(230, 230, 0)
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       of.vertex( i*(knob2*9), 1080-i*4 - inL[i]*gain)
    end
    of.endShape()

end

----------------------------------------------------
function exit()
	print("script finished")
	
end