require("eyesy")

fbo = of.Fbo()

num=256
----------------------------------------------------
function setup()
    of.noFill()
    of.setFrameRate(30)
    
    fbo:allocate(of.getWidth(), of.getHeight())
    fbo:beginFbo()
    of.clear(0,0,0,0)
    fbo:endFbo()
end

----------------------------------------------------
function update()
    
end

----------------------------------------------------
function draw()
    
    --knobjobs:
    --knob1 x rotation
    --knob2 y rotation
    --knob3 gain
    --knob4 fbo & background color
    --knob5 fbo opacity 
    
    cool = knob4*255
    of.background(cool,cool,cool) --need to put this outside of the fbo otherwise it doesn't do the trails
    
    amplitude = 1000+knob3*3000
    
    of.setLineWidth(knob1*20+1)
    
    fbo:beginFbo()
    of.setColor(cool,cool, cool, knob5 * 255)
	of.fill()
	of.drawRectangle(0,0,of.getWidth(),of.getHeight())
	
    of.noFill()
    
    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2 - 35)
	    of.rotateXDeg(knob1*600)
	    of.rotateYDeg(knob2*600)

        for i=1,num do
            of.setColor(of.random(255), of.random(255), of.random(255), 255)
            of.fill()
            loc = glm.vec3(i*(of.getWidth()/num)-of.getWidth()/2, 0, 0)
            of.drawBox(loc, of.getWidth()/num, inL[i]*amplitude*2, inL[i]*amplitude)
        end


	of.popMatrix()
	
	fbo:endFbo()
    fbo:draw(0,0)
end

----------------------------------------------------
function draw3DScope(a, b, amplitude, axis, vertices)
    local stepx = (b.x - a.x) / vertices--256 max vertices
    local stepy = (b.y - a.y) / vertices--256 max vertices
    local stepz = (b.z - a.z) / vertices--256 max vertices
    of.beginShape()
    for i=1,vertices do
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