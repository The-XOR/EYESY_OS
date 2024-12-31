require("eyesy")

rotz =0

----------------------------------------------------
function setup()
    of.noFill()
    of.background(0)
    of.setFrameRate(30)
end

----------------------------------------------------
function update()
    
end

----------------------------------------------------
function draw()
    
    
    
    --knobjobs:
    --knob1 xrotate speed
    --knob2 xrotation spread
    --knob3 tilt control
    --knob4 height offset
    --knob5 linewidth
    
    of.setLineWidth(knob5*20+1)
    
    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2)
	    tilter=knob3*1000
	    rotz = (knob1*100+rotz)%360
	    of.rotateZDeg(rotz)

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
        
        offsetX = knob4*1000 --sets height off x axis. 
	   
	    spread = knob2*300
	    
	    --a = glm.vec3(offsetX, -500, tiltLeft)
	    a = glm.vec3(0, 0, tiltLeft)
	    b = glm.vec3(offsetX, 500, tiltRight)

        of.setColor(220, 220, 0) --yellow
        draw3DScope(a,b,1000,1,256)
        
        of.rotateZDeg(spread)
        of.setColor(255, 2,0) --red
        draw3DScope(a,b,1000,2,256)

        of.rotateZDeg(spread)
        of.setColor(255, 250,255) --white
        draw3DScope(a,b,1000,1,256)
        
        of.rotateZDeg(spread)
        of.setColor(100, 255, 180) --light green
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