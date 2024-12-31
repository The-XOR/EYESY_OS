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
    
    --knob jobs
    --1 gain
    --2 scope lenght
    --3 
    --4 v offset
    --5 fill/noFill

    if knob5 > 512 then
	    of.fill()
	else
	    of.noFill()
	end
   
    of.background(0, 0, 0)
    of.setColor(11, 111, 232)
    
    gain = (knob1*1.5)+50
    v_offset = knob4/2


    
    -- line scope
    of.setColor(11, 111, 232)
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       of.vertex((1280+i*(knob2/137))%1920, 540-v_offset - inL[i]*gain)
    end
    of.endShape()
    
    -- line scope2
    of.setColor(232, 111, 50)
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       of.vertex((640+i*(knob2/137))%1920, 540 - inL[i]*gain)
    end
    of.endShape()
    
    -- line scope2
    of.setColor(50, 232, 50)
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       of.vertex( i*(knob2/137), 540+v_offset - inL[i]*gain)
    end
    of.endShape()

end

----------------------------------------------------
function exit()
	print("script finished")
	
end