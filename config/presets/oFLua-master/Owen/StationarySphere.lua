print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120
inL = {}
inR = {}

icoSphere = of.IcoSpherePrimitive()
cam = of.EasyCam()
mesh = of.Mesh()
----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	print("script setup")
    of.setFrameRate(60)
    
end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()
    local screenWidth = of.getWidth()
	local screenHeight = of.getHeight()
	cam:beginCamera()
    icoSphere:setPosition(0, 0, 0)
    icoSphere:setRadius( 200 )
	icoSphere:setScale(1.01)
	of.noFill()
	of.setColor(200, 100, 222)
	
	icoSphere:drawWireframe()

	cam:endCamera()

end

----------------------------------------------------
function exit()
	print("script finished")
end