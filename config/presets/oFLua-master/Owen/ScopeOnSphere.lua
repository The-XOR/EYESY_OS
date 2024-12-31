print("Hello World!")

require("eyesy")

icoSphere = of.IcoSpherePrimitive()
cam = of.EasyCam()
image = of.Image()
fbo = of.Fbo()

----------------------------------------------------
function setup()
	print("script setup")
    of.setFrameRate(60)

    icoSphere:setPosition(0, 0, 0)
    icoSphere:setRadius( 200 )

    fbo:allocate(600, 600)
    fbo:beginFbo()
    of.clear(0,0,0)
    fbo:endFbo()
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    fbo:beginFbo()
        of.background(33, 33, 33)
        of.setColor(11, 111, 232)
        of.setLineWidth(4)
        of.noFill()
        drawScope()
    fbo:endFbo()
    
    -- not necessary, just to see
    fbo:draw(0,0)
    
	cam:beginCamera()
	        fbo:getTexture():bind()
	        icoSphere:draw()
	        fbo:getTexture():unbind()
	cam:endCamera()
end

function drawScope()
    of.beginShape()
    for i=1,256 do
       of.vertex(i*2 , inL[i]*400 + 250)
    end
    of.endShape()
end

----------------------------------------------------
function exit()
	print("script finished")
end