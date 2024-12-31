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
    --knob 1  
    --knob 2 
    --knob 3 box scope gain
    --knob 4 box & circle offset
    --knob 5 
    
    boxnum = 10
    boxsize = of.getWidth()/boxnum
    vectorlength = boxsize/64

    of.background(0)
    
    --fbo2:beginFbo()
    --of.setColor(0,0,0, knob5 / 1024 * 30) --controls the color of the trails
	--of.fill()
	--of.drawRectangle(knob4,0,of.getWidth()/2,of.getHeight()) --only did half the screen on purpose! knob1 moves the FBO left & right

    gain = (knob3*1.5)+50
    
    --of.noFill()
    --of.setColor(255)
    
    
    
        for i=0, boxnum-1 do
            for j=0, boxnum-1 do
                of.pushMatrix()
                    of.translate(i*boxsize, j*boxsize)
                    if (i+j)%2 == 0 then
                        boxTB()
                    end
                of.popMatrix()
            end
        end
    
    
   
    --fbo2:endFbo()
    --fbo2:draw(0,0)
    
end


function boxTB()
    of.setLineWidth(1)
    --of.noFill()
    of.fill()
    --top line
    of.setColor(255)--255-g,255,g)
    of.beginShape()
    for i=1,64 do
       of.vertex(i*vectorlength, inL[i]*gain)
       --of.vertex(704+i*8, 284 - inL[i]*gain)
    end

    --right line
    for i=1,1 do
        --of.vertex( knob4+1216+inL[64+i]*gain, 284+i*8)
        of.vertex(boxsize, 0)
    end
    
    --bottom line
    for i=1,64 do
        of.vertex(boxsize-(i*vectorlength), boxsize - inL[128+i]*gain)
        --of.vertex(1216-(i*8), 796 - inL[128+i]*gain)
    end

    --left line
    for i=1,1 do
        of.vertex(0, boxsize)
    end
    of.endShape()
    g = (g + 5) %255 --green color fade
end

function box3()
    of.setLineWidth(1)
    --of.noFill()
    of.fill()
    --top line
    of.setColor(255-g,255,g)
    of.beginShape()
    for i=1,64 do
       of.vertex( knob4+704+(i*8), 284 - inL[i]*gain)
       --of.vertex( 704+(i*8), 284 - inR[i]*gain)
    end

    --right line
    for i=1,64 do
        of.vertex( knob4+1216+inL[64+i]*gain, 284+i*8)
        --of.vertex( 1216+inR[64+i]*gain, 284+i*8)
    end
    
    --bottom line
    for i=1,64 do
        of.vertex( knob4+1216-(i*8), 796 - inL[128+i]*gain)
        --of.vertex( 1216-(i*8), 796 - inR[128+i]*gain)
    end

    --left line
    for i=1,64 do
        of.vertex( knob4+704+inL[192+i]*gain, 796-i*8)
        --of.vertex( 704+inR[192+i]*gain, 796-i*8)
    end
    of.endShape()
    g = (g + 5) %255 --green color fade
end

----------------------------------------------------
function exit()
	print("script finished")
	
end