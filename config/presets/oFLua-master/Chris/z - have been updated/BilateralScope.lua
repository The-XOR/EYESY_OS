require("eyesy")

fbo = of.Fbo()
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
    --knob1 linewidth
    --knob2 x offset
    --knob3 scope length
    --knob4 fbo & background color
    --knob5  fbo opacity 
    
    cool = knob4*255
    of.background(cool,cool,cool) --need to put this outside of the fbo otherwise it doesn't do the trails
    
    of.setLineWidth(knob1*20+1)
    
    fbo:beginFbo()
    of.setColor(cool,cool, cool, knob5 * 255)
	of.fill()
	of.drawRectangle(0,0,of.getWidth(),of.getHeight())
	
    of.noFill()
    
    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2 - 35)

        len = knob3*of.getWidth()/2
        offsetX = knob2*500+3
	   

	    --left line (when offsetX at 0)
	    a = glm.vec3(offsetX, 0, 0)
	    b = glm.vec3(offsetX-len, 0, 0)
        of.setColor(of.random(255), of.random(255), of.random(255), 255)
        draw3DScope(a,b,1000,2,256)
	    
	    --right line (when offsetX at 0)
	    c = glm.vec3(offsetX*-1, 0,0)
	    d = glm.vec3(offsetX*-1+len, 0,0)
        of.setColor(of.random(255), of.random(255), of.random(255), 255)
        draw3DScope(c,d,1000,2,256)

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