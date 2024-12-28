--S-BoxTowerLamp
print("Hello World!")
require ('eyesy')
knob1 = .5 --x position
knob2 = .5 --number of boxes
knob3 = .5 --proximity
knob4 = .5 --brightness of lamp
knob5 = .5 --night or day
inL = {}
inR = {}

count = 0
Height=of.getHeight()
Width=of.getWidth()
----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    cooltable = {}
end

----------------------------------------------------
function update()
end

----------------------------------------------------

function draw()
    count = count+1
    of.fill()
    of.background(knob5*255)
    Distance = knob3*Width*4
    local Red = glm.mod(count,255-254*knob5)
    local Green = glm.mod(count*2,255-254*knob5)
    local Blue = glm.mod(count*4,255-254*knob5)
    of.translate(0,0,-Distance)
    of.pushMatrix()
        shadow(Red, Green, Blue, alpha)
    of.popMatrix()
    of.setColor(Red,Green,Blue,10+245*knob4)
    boxrow()
end

function shadow(Red, Green, Blue, alpha)
    local angle = 90
    of.translate(0,Height,0)
    of.rotateXDeg(angle)
    boxrow1(Red, Green, Blue, alpha)
end
    
function boxrow1(Red, Green, Blue, alpha)
    local boxes = 10+knob2*50
    local space = Height/boxes
    local inflate = 100*(1-knob2)+1
    for i=1,boxes do
        R = inL[i]*300+inflate
        x = knob1*(Width+Distance*2)-Distance
        y = space/2-(boxes-i+1)*space
        z = 0
        ghost = (i*4*knob4)+i/10
        of.setColor(Red, Green, Blue, ghost)
        of.drawRectangle(x-R/2,y,R,R)
    end
end

function boxrow()
    local boxes = 10+knob2*50
    local space = Height/boxes
    for i=1,boxes do
        R = inL[i]*300+100*(1-knob2)+1
        x = knob1*(Width+Distance*2)-Distance--
        y = i*(space) - space/2
        z = 0
        of.drawBox(x,y,z,R)
    end
end

----------------------------------------------------
function exit()
    print("script finished")
end