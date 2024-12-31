print("Hello World!")

require("eyesy")

sphere = of.SpherePrimitive()
cam = of.EasyCam()
image = of.Image()
fbo = of.Fbo()
light = of.Light()

----------------------------------------------------
function setup()
	print("script setup")
    of.setFrameRate(60)
    of.disableAlphaBlending()

    sphere:setPosition(0, 0, 0)
    sphere:setRadius( 200 )

    fbo:allocate(600, 600)
    fbo:beginFbo()
    of.clear(0,0,0)
    fbo:endFbo()
    image:load("/sdcard/Images/cb.jpg")
    image:getTexture():setTextureWrap(of.REPEAT, of.REPEAT)
    light:enable()
    light:setPosition(glm.vec3(100,100,200))
    light:lookAt(glm.vec3(0,0,0))

end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()

	of.pushMatrix()
	    of.translate(of.getWidth() / 2,of.getHeight()/2)
	    of.rotateXDeg(knob2)
	    of.rotateYDeg(knob3)
	    of.rotateZDeg(knob4)
	   --fbo:getTexture():bind()
	   image:bind()
	        sphere:draw()
	        sphere:drawWireframe()
	        image:unbind()
	        --fbo:getTexture():unbind()
   
	of.popMatrix()
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