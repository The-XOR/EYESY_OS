require("eyesy")
rotx =0
----------------------------------------------------
function setup()
    of.noFill()
    of.background(0)
end

----------------------------------------------------
function update()
    
end

----------------------------------------------------
function draw()
    
    of.setLineWidth(knob5*20+1)

    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2 - 60)
	    tilter=knob3*1000
	    rotx = (knob1*20+rotx)%360
	    of.rotateXDeg(rotx)

	    --tilt control
	    if tilter <= 490 then 
            tiltLeft = 490-tilter
            tiltRight = tilter-490
        elseif tilter >= 510 then
            tiltLeft = 510-tilter
            tiltRight = tilter-510
        else
            tiltLeft = 0
            tiltRight = 0
        end
        
        offsetY = knob4*1000 --sets height off x axis. 
	   
	    spread = knob2*300+1
	    
	    a = glm.vec3(-500, offsetY, tiltLeft)
	    b = glm.vec3(500, offsetY, tiltRight)

        of.setColor(255,165,0) --orange
        draw3DScope(a,b,1000,2,256)
        
        of.rotateXDeg(spread)
        of.setColor(255,163,0) --orange
        draw3DScope(a,b,1000,2,256)

        of.rotateXDeg(spread)
        of.setColor(255,161,0) --orange
        draw3DScope(a,b,1000,2,256)
        
        of.rotateXDeg(spread)
        of.setColor(255,159,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,156,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,153,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,150,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,148,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,145,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,143,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,140,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                of.rotateXDeg(spread)
        of.setColor(255,138,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,135,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,133,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,130,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,127,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,124,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,120,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,117,0) --orange
        draw3DScope(a,b,1000,2,256)
        
                        of.rotateXDeg(spread)
        of.setColor(255,115,0) --orange
        draw3DScope(a,b,1000,2,256)
        
	of.popMatrix()
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