--S-BoxRow-NEW.lua
--KNOB JOBS
--1: number of cubes
--2: x-axis rotation speed
--3: y-axis rotation speed
--4: z-axis zoom range
--5: background color fade speed
print("Hello World!")
require ('eyesy')

knob1 = .5 
knob2 = .5 
knob3 = .5 
knob4 = .5 
knob5 = .5
inL = {}
inR = {}

count = 1
bkcount = 1
rotY = 0
rotX = 0
zoomer = 1
Height = of.getHeight()
Width = of.getWidth()

----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(0)
end

----------------------------------------------------
function update()
end

----------------------------------------------------


function draw()
    of.fill()
    of.setColor(glm.mod(count-2,175),glm.mod(count/1.3,255),glm.mod(count/22,255),200)
    gray = knob5*255
    of.background(gray,gray,gray)
    boxrow()
    count = count+1
    bkcount = bkcount+1
    zoomer = zoomer + 1
    rotX = rotX+200*knob2
    if knob2 == 0 then
        rotX = 0
    end
    rotY = rotY+100*knob3
    if knob3 == 0 then
        rotY = 0
    end
end

    
function boxrow()
    local boxes = knob1*100 + 1
    local space = Width/boxes
    local zoom = 0-(glm.sin(zoomer/50)*knob4*1000)
    if knob4 == 0 then
        zoom = 0
    end
    

    of.pushMatrix()
        of.translate(Width/2,Height/2,0)
        of.pushMatrix()
        of.translate(0,0,zoom)
        of.rotateXDeg(rotX)
        of.rotateYDeg(rotY)
        of.pushMatrix()
            of.translate(-Width/2,0, 0)
                for i=1,boxes do
                    H = inL[i]*1000
                    R = 500*inR[i]/3+50
                    x = i*(space) - space/2
                    y = H
                    z = 0
                    local v1 = glm.vec3((i*space)-space/2,y,z)
                    of.setColor(glm.mod(count+i,255),glm.mod(count/2+i,255),glm.mod(count/3+i,255),255)
                    of.drawBox(v1,R,R,R)
                end
        of.popMatrix()
    of.popMatrix()
    of.popMatrix()
end

----------------------------------------------------
function exit()
    print("script finished")
end