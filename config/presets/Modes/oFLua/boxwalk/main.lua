modeTitle = "boxwalk"		-- name the mode
-- Adapted to EYESY from https://junkiyoshi.com/openframeworks20210626/ by Nakauchi Kiyoshi

require("eyesy")

-- helpful global variables 
w = of.getWidth()           -- global width  
h = of.getHeight()          -- global height of screen
w2 = w / 2                  -- width half 
h2 = h / 2                  -- height half
w4 = w / 4                  -- width quarter
h4 = h / 4                  -- height quarter
w8 = w / 8                  -- width 8th
h8 = h / 8                  -- height 8th
w16 = w / 16                  -- width 16th
h16 = h / 16                  -- height 16th
c = glm.vec3( w2, h2, 0 )   -- center in glm vector

sizemult = 3
----------------------------------------------------
function setup()
	of.noFill()
	bg = of.Color()
	of.setBackgroundColor( bg )
	knob1 = 0
	knob2 = 0.1
	knob3 = 0.1
	knob4 = 0
	
	of.setLineWidth(2)
	of.enableDepthTest()

end

----------------------------------------------------
function update()
	colorPickHsb( knob5, bg )					-- color for drawings
	of.setBackgroundColor( bg )					-- set the bg color 

  of.seedRandom(39)
end

----------------------------------------------------
function draw()
	-- OSD
  amplitude = knob4*100
  
  of.translate(c)
  	
	noise_location_param = glm.vec3(of.random(w*2), of.random(h*2), of.random(1000));
	noise_rotation_param = glm.vec3(of.random(1000), of.random(1000), of.random(1000));
	number_of_log = 20;

	of.noFill()

	for i = 1, number_of_log do
		location = glm.vec3(
			of.map(of.noise(noise_location_param.x, of.getFrameNum() * 0.008 + i * 0.08), 0, 1, -100 - (knob1*100), 100 + (knob1*100)),
			of.map(of.noise(noise_location_param.y, of.getFrameNum() * 0.008 + i * 0.08), 0, 1, -100 - (knob1*100), 100 + (knob1*100)),
			of.map(of.noise(noise_location_param.z, of.getFrameNum() * 0.008 + i * 0.08), 0, 1, -100 - (knob1*100), 100 + (knob1*100))
		);

		rotate = glm.vec3(
			of.map(of.noise(noise_rotation_param.x, of.getFrameNum() * 0.008 + i * 0.08), 0, 1, -360, 360),
			of.map(of.noise(noise_rotation_param.y, of.getFrameNum() * 0.008 + i * 0.08), 0, 1, -360, 360),
			of.map(of.noise(noise_rotation_param.z, of.getFrameNum() * 0.008 + i * 0.08), 0, 1, -360, 360)
		);

		of.pushMatrix()
	  of.translate(location)
		of.rotateZDeg(rotate.z);
		of.rotateYDeg(rotate.y);
		of.rotateXDeg(rotate.x);

		if (i == number_of_log) then
			of.setColor(line_color);
			--of.fill();
			--of.drawBox(loc, w/num, inL[i]*amplitude*2, inR[i]*amplitude)
			of.drawBox(glm.vec3(), 5 + number_of_log*sizemult + inL[i]*amplitude*i);
		else

      line_color = of.Color()
      line_color:setHsb((of.getFrameNum() + i * 15) % 255, 255, 255)
      of.setColor(line_color)
      of.noFill()
      of.setLineWidth(of.map(i, 0, number_of_log, 0.3, 2));
      of.drawBox(glm.vec3(), 5 + i*sizemult + inL[i]*amplitude*i);
    end
		of.popMatrix()

  end
  
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

------------------------------------ Color Function
-- this is how the knobs pick color
function colorPickHsb( knob, name )
	-- middle of the knob will be bright RBG, far right white, far left black
	
	k6 = (knob * 5) + 1						-- split knob into 8ths
	hue = (k6 * 255) % 255 
	kLow = math.min( knob, 0.49 ) * 2		-- the lower half of knob is 0 - 1
	kLowPow = math.pow( kLow, 2 )
	kH = math.max( knob, 0.5 ) - 0.5	
	kHigh = 1 - (kH*2)						-- the upper half is 1 - 0
	kHighPow = math.pow( kHigh, 0.5 )
	
	bright = kLow * 255						-- brightness is 0 - 1
	sat = kHighPow * 255					-- saturation is 1 - 0
	
	name:setHsb( hue, sat, bright )			-- set the ofColor, defined above
end


----------------------------------------------------
function exit()
	print("script finished")
end