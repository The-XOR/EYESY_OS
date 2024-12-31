--S-XScope3D
--KNOB JOBS
--1 Z zoom
--2 Shadow offset
--3 Y rotation
--4 Fig color
--5 bg color
print("Hello World!")
require ('eyesy')

knob1 = 1 
knob2 = 1 
knob3 = 1 
knob4 = 1 
knob5 = 1
inL = {}
inR = {}

count = 0
front = true



----------------------------------------------------
function setup()
    of.setWindowTitle("knobs example")
    print("script setup")
    of.setLineWidth(4)
    of.setFrameRate(60)
    of.background(100)
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    
    of.background(255*knob5)
    lineW = 5-(knob1*4)
    of.setLineWidth(lineW)
    
    Height = of.getHeight()
    Width = of.getWidth()
    count = count+1
    of.noFill()
    local offset = Width*knob2
    local Red = (240*3*knob4+15)%255
    local Green = (200*2*knob4+55)%255
    local Blue = (150*5*knob4+105)%255
    of.setColor(Red,Green,Blue,255)
    
    of.translate(Width/2,Height/2,0)
    
    if .25 < knob3 and knob3 < .75 then
        front = false
    else
        front = true
    end
    
    if front == true then
        of.pushMatrix()
            of.translate(0,0,-knob1*Width)
            of.rotateYDeg(knob3*360)
    
            of.pushMatrix()
                of.translate(-offset/100,-offset/100,-offset)
                shadow(Red,Green,Blue,alpha)
            of.popMatrix()
        
            of.pushMatrix()
                of.setLineWidth(lineW)
                of.setColor(Red,Green,Blue,255)
                slantScopes()
            of.popMatrix()
            
        of.popMatrix()
    end
    
    if front == false then
    of.pushMatrix()
            of.translate(0,0,-knob1*Width)
            of.rotateYDeg(knob3*360)

            of.pushMatrix()
                of.setColor(Red,Green,Blue,255)
                slantScopes()
            of.popMatrix()

            of.pushMatrix()
                of.translate(-offset/100,-offset/100,-offset)
                shadow(Red,Green,Blue,alpha)
            of.popMatrix()
        
    of.popMatrix()
    end
    
end

function shadow(Red,Green,Blue,alpha)
    local ghost = 255-(255*knob2)
    of.setColor(Red/2,Green/2,Blue/2,ghost)
    slantScopes()
end


function slantScopes()
    
    of.beginShape()
    for i=1,256 do
       local slantx = i*Width/256-Width/2
       local slanty = (i-1)*Height/255-Height/2
       local soundL = inL[i]*800
        of.vertex(slantx,slanty+soundL)
    end
    of.endShape()
    
    of.beginShape()
    for i=1,256 do
       local slantx = i*Width/256-Width/2
       local slanty = (i-1)*Height/255-Height/2
       local soundR = inR[i]*800
        of.vertex(-slantx,slanty+soundR)
    end
    of.endShape()
end

----------------------------------------------------
function exit()
    print("script finished")
end