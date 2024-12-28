print("Hello World!")
require ('eyesy')

knob1 = .5 
knob2 = .5 
knob3 = .5 
knob4 = .5 
knob5 = .5
inL = {}
inR = {}

count = 0
Width = of.getWidth()
Height = of.getHeight()
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
    
    count = count+1
    of.fill()
    of.setColor(glm.mod(count,255),glm.mod(count/2,255),glm.mod(count/3,255),255) 
    boxrow()

end

    
function boxrow()
    local boxes = knob1*100 + 1
    local space = Width/boxes
    for i=1,boxes do
        H = inL[i]*100 + knob2*10
        x = i*(space) - space/2
        y = knob3*Height
        z = 0
        local v1 = glm.vec3(x-space/2,y+H,z)
        --local v2 = glm.vec3(x+(space-2*(space*knob4),y-H,z)
        --local v3 = glm.vec3(x+space/2,y,z)
        of.setColor(glm.mod(count+i,255),glm.mod(count/2+i,255),glm.mod(count/3+i,255),255)
        --of.drawTriangle(v1,v2,v3)
        of.drawBox(v1,50,50,50)
        
    end
end

----------------------------------------------------
function exit()
    print("script finished")
end