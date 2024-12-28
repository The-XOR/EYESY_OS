print("Hello Wooorld!")

--require("eyesy")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120

inL = {}
inR = {}

rotx =0

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
    
    of.setLineWidth(knob5/50+1)

    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2 - 60)
	    
	    rotx = (knob1/50+rotx)%360
	    of.rotateXDeg(rotx)

	    --tilt control
	    if knob3 <= 490 then
            tiltLeft = 490-knob3
            tiltRight = knob3-490
        elseif knob3 >= 532 then
            tiltLeft = 532-knob3
            tiltRight = knob3-532
        else
            tiltLeft = 0
            tiltRight = 0
        end
        
        offsetY = knob4 --sets height off x axis. 
	   
	    spread = knob2/3 
	    
	    a = glm.vec3(-500, offsetY, tiltLeft)
	    b = glm.vec3(500, offsetY, tiltRight)

        of.setColor(220, 220, 0)
        draw3DScope(a,b, 1000,2 , 256)
        
        of.rotateXDeg(spread)
        of.setColor(255, 2,0)
        draw3DScope(a,b, 1000,2 , 256)

        of.rotateXDeg(spread)
        of.setColor(255, 250,255)
        draw3DScope(a,b, 1000, 2, 256)
        
        of.rotateXDeg(spread)
        of.setColor(100, 255, 180)
        draw3DScope(a,b, 1000, 2, 256)
        
        
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