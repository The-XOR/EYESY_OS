print("Hello World!")

require("eyesy")

----------------------------------------------------
function setup()
    of.noFill()
end

----------------------------------------------------
function update()
    
end

----------------------------------------------------
function draw()

    local a = glm.vec3(0,0,0)
    local b = glm.vec3(of.getWidth(),of.getHeight(),0)
    draw3DScope(a,b, 500, 2)
    
    a = glm.vec3(0,of.getHeight()/2,0)
    b = glm.vec3(of.getWidth(),of.getHeight()/2,0)
    draw3DScope(a,b, 500, 2)
end

----------------------------------------------------
function draw3DScope(a, b, amplitude, axis)
    local stepx = (b.x - a.x) / 256
    local stepy = (b.y - a.y) / 256
    local stepz = (b.z - a.z) / 256
    of.beginShape()
    for i=1,256 do
        if axis == 1 then
            of.vertex(a.x + stepx*i + inL[i]*amplitude, a.y + stepy*i, a.z + stepz*i)
        end
        if axis == 2 then
            of.vertex(a.x + stepx*i, a.y + stepy*i + inL[i]*amplitude, a.z + stepz*i)
        end
        if axis == 3 then
            of.vertex(a.x + stepx*i, a.y + stepy*i, a.z + stepz*i + inL[i]*amplitude)
        end
    end
    of.endShape()
end

----------------------------------------------------
function exit()
	print("script finished")
end