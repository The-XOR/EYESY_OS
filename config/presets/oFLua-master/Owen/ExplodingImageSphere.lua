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
image = of.Image()

----------------------------------------------------
function setup()
	of.setWindowTitle("knobs example")
	mesh:setMode(of.PRIMITIVE_LINES)
	print("script setup")
    of.setFrameRate(60)

    icoSphere:setPosition(0, 0, 0)
    icoSphere:setRadius( 200 )

	-- get the mesh of sphere
	mesh = icoSphere:getMesh()
    
    image:load("/home/music/openFrameworks/apps/myApps/eyesy/bin/data/images/tdf_1972_poster.jpg")

end

----------------------------------------------------
function update()
end

----------------------------------------------------
function draw()

    for i=0, mesh:getVertices():size()-1 do
        local vertex = mesh:getVertex(i)
        -- multipy each vertex by a little more than 1 causing explosion
        vertex.x = (of.random(0,.01) + 1) * vertex.x
        vertex.y = (of.random(0,.01) + 1) * vertex.y
        vertex.z = (of.random(0,.01) + 1) * vertex.z
        mesh:setVertex(i, vertex)
    end
    
	cam:beginCamera()
	        image:bind();
	        of.setColor(255,255,255)
	        mesh:draw()
	        image:unbind();
	cam:endCamera()

end

----------------------------------------------------
function exit()
	print("script finished")
end