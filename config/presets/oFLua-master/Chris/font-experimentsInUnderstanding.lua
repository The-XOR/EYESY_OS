print("Hello World!")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120


inL = {}
inR = {.5,.5,.5}

franklinBook = of.TrueTypeFont()
verdana = of.TrueTypeFont()
franklinBookLarge = of.TrueTypeFont()
-- cool
counter = 0

----------------------------------------------------
function setup()
	of.setWindowTitle("fonts example")

	-- this load font loads the non-full character set
	-- (ie ASCII 33-128), at size "32"
	franklinBook:load("fonts/frabk.ttf", 32)
	
	franklinBookLarge:load("fonts/frabk.ttf", 100)
	
	-- now load another font, but with extended parameters:
	-- font name, size, anti-aliased, full character set
	verdana:load("fonts/verdana.ttf", 8, false, true)
	verdana:setLineHeight(20)
end

----------------------------------------------------
function update()
	of.background(255, 255, 255)	
	counter = counter + 1
end

----------------------------------------------------
function draw()
    franklinBook:setLetterSpacing(1)

	of.setHexColor(0x00FF00)
	franklinBook:drawString("YEYEYAYYAYA?", 100, 100)
	
	of.setHexColor(0x000000)
	verdana:drawString("hello, I II  am aliased verdana -- full character set, see: ? ! ", 100, 210)
	
	of.setHexColor(0x00FF00)
	franklinBook:drawString("I can't make an (?) like you", knob3, 310)
	
	of.setHexColor(0x000000)
	verdana:drawString("yeah, but I'm not exactly pretty\nthe problem is with freeType library...\napple has a patent on TTF font hints\nso our aliased type via freeType isn't super looking", 100, 380)
	
	of.setHexColor(0x00FF00)
	franklinBook:drawString("you look ok ! don't worry", 100, 520)

	--------------------- bounding rectangle : 
	tempString = tostring(counter)
	-- ok first job to rotate around the center, is to get the bounding box:
	rect = franklinBook:getStringBoundingBox(tempString, 0, 0)
	-- this is the actual midpt (x + w/2, y + h/2);
	local centerx = rect.x + rect.width / 2
	local centery = rect.y + rect.height / 2

	of.pushMatrix()
		of.translate(100, 650, 0)
		of.rotateDeg(counter, 0, 0, 1)
		-- draw type & rect centered around 0,0 (subtract midpt from both):
		of.setHexColor(0xcccccc)
		of.drawRectangle(rect.x - centerx, rect.y - centery, rect.width, rect.height)
		of.setHexColor(0xff3399)
		franklinBook:drawString(tempString, -centerx,-centery);
	of.popMatrix()

	---------------------------------------
    local sizer = knob1/25
    tempString2 = tostring(sizer)
	of.pushMatrix()
		of.translate(225, 675, 0)
		of.scale(sizer+1,sizer+1, 1)
		of.setHexColor(0x333333)
		verdana:drawString(tempString2, 0, 0)
	of.popMatrix()
	
	local size = 2 + 2*math.sin(counter/(knob2 / 30 + 1))
	of.pushMatrix()
		of.translate(520, 675, 0)
		of.scale(size, size, 1)
		of.setHexColor(0x00FF00)
		franklinBook:drawString("Crushadorus", 0, 0);
	of.popMatrix()
	
	
	of.setColor(200,0,149)
	
	-----------------------
	--work = tostring("is this working?")
    
    --franklinBook:setLetterSpacing(512-knob2)
	--of.translate(of.getWidth() /2, of.getHeight()/2-300)
	--franklinBook:drawString(work, 0, 0)
	
	
	work2 = tostring("¿is this working?")
	of.pushMatrix()
	    
	    franklinBookLarge:setLetterSpacing(knob4/30)
	    local textbox = franklinBookLarge:getStringBoundingBox(work2, 0, 0)
	    local midx = textbox.width / 2
	    
	    of.scale(knob5/1023,knob5/1023, 1)
	    of.translate((of.getWidth() /2) - midx, of.getHeight()/2)
	    
	    franklinBookLarge:drawString(work2, 0, 0)
	of.popMatrix()
	
end

----------------------------------------------------
function exit()
	print("script finished")
end

