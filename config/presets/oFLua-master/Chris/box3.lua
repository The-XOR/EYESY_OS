print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120


inL = {}
inR = {}

rot = 0
count = 0
r = 0
g = 255
b = 204

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
    --knob 1 = gain
    --knob 2 = length of scope

    of.background(0, 0, 0)
    --rot = (rot + (knob5/250)) % 360
    
    gain = (knob1*1.5)+50

    -- line scope
    of.fill()
    --of.setColor(0, 255, 204)--11, 111, 232)
    of.setColor(255, 0, 0)
    --line1()
    
    -- line scope2
    of.noFill()
    of.setColor(255)--50, 232, 50)
    --of.pushMatrix()
        --of.translate((of.getWidth() / 2) * -1,0)--of.getHeight() / 2)
        --of.translate(0, of.getHeight() / 2)
        --of.rotateYDeg(rot)
    --line2()
    --of.popMatrix()
    
    -- horizontal line
    --of.setColor(232, 111, 50)
    --of.setLineWidth(0)
    --of.beginShape()
    --for i=1,256 do
       --of.vertex((i*(knob2/137)), 540 - inL[i]*gain)
    --end
    --of.endShape()
    of.setColor(0,44,222)
    of.fill()
    --box()
    box3()
    count = count + 1
    
    if count >= 5 then
        if r < 170 then
            r = (r + 20)
        else 
            r = 0 
        end
        
        if b > 100 then 
            b = (b - 10)
        else 
            b = 240
        end
        count = 1
    end
    
end

function line1()
    of.setLineWidth(4)
    of.beginShape()
    for i=1,256 do
       of.vertex((i*(knob2/137)), i*4 - inR[i]*gain)
    end
    of.endShape()
end

function line2()
    of.setLineWidth(7)
    of.beginShape()
    for i=1,256 do
       of.vertex( i*(knob2/137), 1080-i*4 - inL[i]*gain)
    end
    of.endShape()
end

function box()
    of.setLineWidth(7)
    of.beginShape()
    for i=1,64 do
       of.vertex( 400+i*2, 300 - inL[i]*gain)
    end
    for i=65,128 do
        of.vertex( 528+inL[i]*gain, 300+((i-64)*2))
    end
    for i=129,193 do
        of.vertex( 528-((i-128)*2), 428 + inL[i]*gain)
    end
    for i=194,256 do
        of.vertex( 400+inL[i]*gain, 428-((i-193)*2))
    end
    of.endShape()
end


function box2()
    of.setLineWidth(7)
    of.noFill()
    
    --top line
    of.setColor(255,0,0)
    of.beginShape()
    for i=1,64 do
       of.vertex( 704+(i*8), 284 - inL[i]*gain)
    end
    of.endShape()
    
    --right line
    of.setColor(0,255,0)
    of.beginShape()
    for i=1,64 do
        of.vertex( 1216+inL[64+i]*gain, 284+i*8)
    end
    of.endShape()
    
    --bottom line
    of.setColor(0,0,255)
    of.beginShape()
    for i=1,64 do
        of.vertex( 1216-(i*8), 796 - inL[128+i]*gain)
    end
    of.endShape()

    --left line
    of.setColor(255,255,0)
    of.beginShape()
    for i=1,64 do
        of.vertex( 704+inL[192+i]*gain, 796-i*8)
    end
    of.endShape()
end

function box3()
    of.setLineWidth(7)
    --of.noFill()
    of.fill()
    --top line
    of.setColor(255,0,0)
    of.beginShape()
    for i=1,64 do
       of.vertex( 704+(i*8), 284 - inL[i]*gain)
    end
    --of.endShape()
    
    --right line
    --of.setColor(0,255,0)
    --of.beginShape()
    for i=1,64 do
        of.vertex( 1216+inL[64+i]*gain, 284+i*8)
    end
    --of.endShape()
    
    --bottom line
    --of.setColor(0,0,255)
    --of.beginShape()
    for i=1,64 do
        of.vertex( 1216-(i*8), 796 - inL[128+i]*gain)
    end
    --of.endShape()

    --left line
    --of.setColor(255,255,0)
    --of.beginShape()
    for i=1,64 do
        of.vertex( 704+inL[192+i]*gain, 796-i*8)
    end
    of.endShape()
end
    

----------------------------------------------------
function exit()
	print("script finished")
	
end