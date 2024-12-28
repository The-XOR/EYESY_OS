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
	--of.setWindowTitle("knobs example")
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
    --knob 1 z rotation 
    --knob 2 
    --knob 3 box scope gain
    --knob 4 
    --knob 5 
    
    boxNumX = knob5*25 + 1--14
    boxNumY = boxNumX*0.5625
    boxSize = of.getWidth()/boxNumX
    vectorlength = boxSize/64
    yOffset = (boxNumY*boxSize-of.getHeight())/2
    --xOffset = ((boxNumX+1)*boxSize-of.getWidth())/2

    of.background(0)
    
    --fbo2:beginFbo()
    --of.setColor(0,0,0, knob5 / 1024 * 30) --controls the color of the trails
	--of.fill()
	--of.drawRectangle(knob4,0,of.getWidth()/2,of.getHeight()) --only did half the screen on purpose! knob1 moves the FBO left & right

    gain = (knob3*1500)+50
    
    --of.noFill()
    --of.setColor(255)
    
    
        for i= -1, boxNumX+1 do
            for j=0, boxNumY do
                of.pushMatrix()
                    of.translate(i*boxSize, j*boxSize-yOffset)
                    if (i+j)%2 == 0 then
                        of.pushMatrix()
                            --of.translate(-1*(boxsize/2), -1*(boxsize/2))
                            of.rotateZDeg(knob1*300)
                            boxTB()
                        of.popMatrix()
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
        of.vertex(boxSize, 0)
    end
    
    --bottom line
    for i=1,64 do
        of.vertex(boxSize-(i*vectorlength), boxSize - inL[128+i]*gain)
        --of.vertex(1216-(i*8), 796 - inL[128+i]*gain)
    end

    --left line
    for i=1,1 do
        of.vertex(0, boxSize)
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