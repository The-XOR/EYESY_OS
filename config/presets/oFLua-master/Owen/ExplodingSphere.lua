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
	mesh:setMode(of.PRIMITIVE_LINES)
	print("script setup")
    of.setFrameRate(60)

    icoSphere:setPosition(0, 0, 0)
    icoSphere:setRadius( 200 )
	of.noFill()
	of.setColor(200, 240, 222)
	
	-- get the mesh of sphere
	mesh = icoSphere:getMesh()

    print(mesh:getVertices():size())
    print(mesh:getVertex(0))
    print(mesh:getVertices()[0])
    
    local thing = mesh:getVertex(0)
    print(thing * 2)
    --mesh:setVertex(0,thing*2)
    print(of.random(0,.1) + 1)

end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()

    for i=0, mesh:getVertices():size()-1 do
        local vertex = mesh:getVertex(i)
        vertex.x = (of.random(0,.01) + 1) * vertex.x
        vertex.y = (of.random(0,.01) + 1) * vertex.y
        vertex.z = (of.random(0,.01) + 1) * vertex.z
        mesh:setVertex(i, vertex)
    end
    
	cam:beginCamera()
	mesh:drawWireframe()
	cam:endCamera()

end

----------------------------------------------------
function exit()
	print("script finished")
end