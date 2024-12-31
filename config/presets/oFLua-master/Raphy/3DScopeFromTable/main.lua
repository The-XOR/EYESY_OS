print("Hello Wooorld!")

--require("eyesy")

knob1 = 120 
knob2 = 120 
knob3 = 120 
knob4 = 120 
knob5 = 120

inL = {}
inR = {}

num = 20
array = {}
check =1
chk2= 1

cooltable = {} --create new table
minrand = -500
maxrand = 500

qq=nil
ee=nil
ww=nil

rotz = 0

----------------------------------------------------
function setup()
    of.noFill()
    of.background(0)
    
    for i=1,num do
            cooltable[i] = {} --create a new table in each 'i'
        for j=1,3 do
            cooltable[i][j]= of.random(minrand,maxrand)
        end
        --print("wow")
    end

end

----------------------------------------------------
function update()
    
end

----------------------------------------------------
function draw()
    
    if check == 1 then
        for i=1,num do
            for j=1,1 do
                --print(array[i][j])
                --concatenate with a character
                print("random values are:", i, " ", table.concat(cooltable[i],", "))
            end
        end
        check = 0
        print("check =",check)
    end
    
    of.setLineWidth(knob5/50+1)

    
    of.pushMatrix()

	    of.translate(of.getWidth() / 2,of.getHeight()/2-250)
	    of.rotateXDeg(knob1/3)
	    of.rotateYDeg(knob2/3)
	    rotz = (knob3/50+rotz)%360
	    of.rotateZDeg(rotz)
        
        for n=1,3 do
            for m=4,7 do 
                --this doesn't work - just fills each m/n with the last 'n' !
                --qq = glm.vec3(cooltable[m][n], cooltable[m][n], cooltable[m][n])--0,of.random(-1000,1000),of.random(-1000,1000))
                --ww = glm.vec3(cooltable[m][n], cooltable[m][n], cooltable[m][n])--of.random(-1000,1000),0,of.random(-1000,1000))
                --ee = glm.vec3(cooltable[m][n], cooltable[m][n], cooltable[m][n])--of.random(-1000,1000),of.random(-1000,1000),0)
            end
        end
        
        q = glm.vec3(cooltable[1][1], cooltable[1][2], cooltable[1][3])
        w = glm.vec3(cooltable[2][1], cooltable[2][2], cooltable[2][3])
        e = glm.vec3(cooltable[3][1], cooltable[3][2], cooltable[3][3])
        qq = glm.vec3(cooltable[4][1], cooltable[4][2], cooltable[4][3])
        ww = glm.vec3(cooltable[5][1], cooltable[5][2], cooltable[5][3])
        ee = glm.vec3(cooltable[6][1], cooltable[6][2], cooltable[6][3])
        
        if chk2 == 1 then
            print("q is ", q)
            print("qq is", qq)
            print("ww is", ww)
            print("ee is", ee)
            chk2 = 0
        end
            
        of.setColor(25,25, 140)
        draw3DScope(q,w, 500, 1, 256)
        of.setColor(255, 0,0)
        draw3DScope(w,e, 500, 2, 256)
        of.setColor(0, 255, 0)
        draw3DScope(e,q, 500, 3, 256)
        
        of.setColor(75,255, 240)
        draw3DScope(qq,ww, 500, 1, 256)
        
        of.setColor(255, 50,255)
        draw3DScope(ww,ee, 500, 2, 256)
        
        of.setColor(100, 255, 180)
        draw3DScope(ee,qq, 500, 3, 256)

	of.popMatrix()
end

----------------------------------------------------
function draw3DScope(a, b, amplitude, axis, steps)
    local stepx = (b.x - a.x) / steps--256
    local stepy = (b.y - a.y) / steps--256
    local stepz = (b.z - a.z) / steps--256
    of.beginShape()
    for i=1,steps do
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