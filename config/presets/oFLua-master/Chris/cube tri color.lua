print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120

inL = {}
inR = {}

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
    local b = glm.vec3(500,0,0)
    local c = glm.vec3(500,500,0)
    local d = glm.vec3(0,500,0)
    local e = glm.vec3(0,0,500)
    local f = glm.vec3(500,0,500)
    local g = glm.vec3(500,500,500)
    local h = glm.vec3(0,500,500)
    
    of.setLineWidth(2)
    
    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2)
	    of.rotateXDeg(knob2)
	    of.rotateYDeg(knob3)
	    of.rotateZDeg(knob4)
        
        of.setColor(255)
        draw3DScope(a,b, 500, 2)
        draw3DScope(b,c, 500, 1)
        draw3DScope(c,d, 500, 2)
        draw3DScope(d,a, 500, 1)
        
        of.setColor(0,176,176)
        draw3DScope(a,e, 500, 2)
        draw3DScope(b,f, 500, 2)
        draw3DScope(c,g, 500, 2)
        draw3DScope(d,h, 500, 2)
        
        of.setColor(150,0,164)
        draw3DScope(e,f, 500, 2)
        draw3DScope(f,g, 500, 1)
        draw3DScope(g,h, 500, 2)
        draw3DScope(h,e, 500, 1)
        
	of.popMatrix()
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