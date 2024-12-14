import pygame
import random
from pygame.locals import *
import pygame.gfxdraw
import math
import glob
import os

# initializing pygame
pygame.font.init()
 
# check whether font is initialized
# or not
pygame.font.get_init()

#Global Vars
trigger = False
x = 0
y = 0
w1 = 0
h1 = 0

#Image vars
images = []
input_images = []
scaled_images = []
image_index = 0
bg = pygame.Surface((656,416))
image_x=100
image_y=100
image_index = 0
image_scale_factor = 0.02
image_upscale_factor = 1.5
knob3_storeValue = -1.0

#geometry Params
minCircleRadius = 10
triangleLength = 5

# Boids vars
flockSize = 20
flock = []
maxSpeed = 10
lerpFactor = .1

alignValue = .5
alignPerceptionRadius = 50

cohesionValue = 1
cohesionPerceptionRadius = 100

seperationValue = 1
seperationPerceptionRadius = 50

queryPerceptionRadius = 100

# QOL methods
def limitVector(vectorToLimit, maxValue):
    #result = myVector(0,0)
    result = vectorToLimit

    if(result.magnitude_squared() > maxValue* maxValue):
        result.normalize()
        result *= maxValue

    return result

def random2DPos():
    result = myVector(random.randrange(0,w1), random.randrange(0,h1))
    return result

def random2DUnit():
    result = myVector(random.uniform(-1,1), random.uniform(-1,1))
    return result

def drawCircle(screen, etc, x, y, audioSample) :

    global minCircleRadius

    #get user input for Circle size and color
    circleScaleFactor = 300 * (1/(etc.knob3 + .01))
    circleRadiusFloor = etc.knob2 * minCircleRadius + minCircleRadius
    circleColor =  etc.color_picker(etc.knob1)
    
    #calculate circle radius
    circleRadius = abs(audioSample)/circleScaleFactor + circleRadiusFloor
    
    #Draw Circle
    pygame.gfxdraw.filled_circle(screen,int(x),int(y),int(circleRadius),circleColor)
        
def translate(value, leftMin, leftMax, rightMin, rightMax):
    # Figure out how 'wide' each range is
    leftSpan = leftMax - leftMin
    rightSpan = rightMax - rightMin

    # Convert the left range into a 0-1 range (float)
    valueScaled = float(value - leftMin) / float(leftSpan)

    # Convert the 0-1 range into a value in the right range.
    return rightMin + (valueScaled * rightSpan)

################################

def setup(screen, etc) :
    global w1,h1, flock,myETC, myScreen, startRect, bg, images, scaled_images,image_scale_factor, image_upscale_factor, input_images
    w1 = screen.get_width()
    h1 = screen.get_height()
    myETC = etc
    myScreen = screen
    startRect = pygame.Rect(0,0,w1,h1)
    
    
    bg = pygame.Surface((etc.xres,etc.yres))


    #load in images
    for filepath in sorted(glob.glob(etc.mode_root + '/Images/*.png')):
        filename = os.path.basename(filepath)
        img = pygame.image.load(filepath)
        input_images.append(img)

    image_scale_factor = translate(etc.knob3, 0,1,0.02,0.1)
    
    for img in input_images:
        #scale images 
        image_size_x=int(img.get_width() * image_scale_factor)
        scaled_image = pygame.transform.scale(img,(image_size_x, image_size_x))
        images.append(scaled_image)
        
        upscaled_image_size = int(img.get_width() * (.1))
        upscaled_image = pygame.transform.scale(img,(upscaled_image_size, upscaled_image_size))
        scaled_images.append(upscaled_image)

    knob3_storeValue = etc.knob3
    
    print(len(images))


    i = 0
    while i < flockSize:
        b = Boid()
        flock.append(b)
        i+=1
    
def draw(screen, etc) :
    

    #print("--------------Starting Draw Loop")
    global qtree
    global cohesionValue,alignValue,seperationValue, images,scaled_images, trigger, image_index,knob3_storeValue,input_images, image_scale_factor
    
    #value used to track if knob3 has changed
    
    
    #map knob1 to image
    image_index = int(translate(etc.knob1, 0,1,0,len(scaled_images) - 1))
    
    #print("Start Draw")
    if(knob3_storeValue != etc.knob3):

        image_scale_factor = translate(etc.knob3, 0,1,0.02,0.1)
        
        del images[:]
        
        for img in input_images:
            #scale images 
            image_size_x=int(img.get_width() * image_scale_factor)
            scaled_image = pygame.transform.scale(img,(image_size_x, image_size_x))
            images.append(scaled_image)
            
            upscaled_image_size = int(img.get_width() * (.1))
            #upscaled_image = pygame.transform.scale(img,(upscaled_image_size, upscaled_image_size))
            #scaled_images.append(upscaled_image)

        knob3_storeValue = etc.knob3
    
    show_array = images

    if etc.audio_trig or etc.midi_note_new :
        trigger = True

    if trigger == True : 
        show_array = scaled_images
        image_index += 1
        trigger = False


    qtree = Quadtree(startRect, 3)

    alignValue = .35
    cohesionValue = .25
    seperationValue = .5

    
    for b in flock:
        qtree.insert(b)

    for b in flock:
        #pygame.gfxdraw.filled_circle(screen,int(b.position.x),int(b.position.y),5, etc.color_picker_bg(etc.knob1+ 0.3))
        b.edges()
        b.flock()
        b.update()
        b.show(screen, show_array)


    #Set BG color
    etc.color_picker_bg(etc.knob5)
    
    qtree.deleteTree
 
class Quadtree:
    def __init__(self, rect, cap):
        
        #print(str(self))
        self.childBoids = []
        self.divide = False
        self.boundary = rect
        self.capacity = cap

        #print(rect)
    def deleteTree(self):
        if(self.divide):
            self.northeast.deleteTree
            self.northwest.deleteTree
            self.southeast.deleteTree
            self.southwest.deleteTree
            del self
        else:
            del self

    def query (self, r, resultPoints):
        #print("Starting Query")
        range = pygame.Rect(r.left,r.top,r.width,r.height)

        #show query location
        #pygame.gfxdraw.rectangle(myScreen,range, myETC.color_picker(0.7))
        #pygame.gfxdraw.filled_circle(myScreen,int(range.centerx),int(range.centery),4,myETC.color_picker(0.4))


        if(range.colliderect(self.boundary)):
            #print("childBoids length: " + str(len(self.childBoids)))
            #print("RectOverlap")
            for b in self.childBoids:
                #print("Boid at " + "x: " + str(b.position.x) + ", y: " + str(b.position.y))
                #pygame.gfxdraw.filled_circle(myScreen,int(b.position.x),int(b.position.y),4,myETC.color_picker(0.7))

                if(range.collidepoint(b.position.x,b.position.y)):
                    #print("appending Boid")
                    resultPoints.append(b)
                #else:
                    #print("Boid not in range")
            if(self.divide):
                #print("               Running Recusion")
                self.northeast.query(range, resultPoints)
                self.northwest.query(range, resultPoints)
                self.southeast.query(range, resultPoints)
                self.southwest.query(range, resultPoints)

    def doesContain(self, b):

        bx = b.position.x
        by = b.position.y

        sx = self.boundary.x
        sy = self.boundary.y

        sw = self.boundary.width
        sh = self.boundary.height

        if(bx <= sx+ sw * 2 and bx >= sx and by <= sy+sh and by >= sy):
            #print("Point is contained")
            return True
        else:
            #print("Point is not containded")
            return False
    
    def insert(self, b):
        #print("Insert Called")

        if(self.doesContain(b) == False):
             return False
        if(len(self.childBoids) < self.capacity):
            self.childBoids.append(b)
            b.parentTree = self
            #print("ChildBoids list length: " + str(len(self.childBoids)))
            return True
        else:
            if(self.divide == False):
                self.subdivide()
                
            if(self.northeast.insert(b)):
                #print(str(b) +  " added to quadtree northeast")
                return True
            elif(self.northwest.insert(b)):
                #print(str(b) +  " added to quadtree northwest")
                return True
            elif(self.southeast.insert(b)):
                #print(str(b) +  " added to quadtree southeast")
                return True
            elif(self.southwest.insert(b)):
                #print(str(b) +  " added to quadtree southwest")
                return True
            else:
                #print(str(b) +  " not added to quadtree")
                return False
    
    def subdivide(self):
        #global numTrees
        #print(self.boundary)

        x = self.boundary.x
        y = self.boundary.y
        w = self.boundary.width
        h = self.boundary.height
        
        self.northwest = Quadtree(pygame.Rect(x , y , w/2 , h/2),self.capacity)
        self.northeast = Quadtree(pygame.Rect(x+w/2 , y , w/2 , h/2),self.capacity)
        self.southwest = Quadtree(pygame.Rect(x , y+h/2 , w/2 ,  h/2),self.capacity)
        self.southeast = Quadtree(pygame.Rect(x+w/2 , y+h/2 , w/2 , h/2),self.capacity)

        self.divide = True

    def show(self, screen, etc):
        x = self.boundary.x
        y = self.boundary.y
        w = self.boundary.width
        h = self.boundary.height

        rect = pygame.Rect(x,y,w,h)
        pygame.gfxdraw.rectangle(screen, rect, etc.color_picker(etc.knob1+ 0.2) )

        if(self.divide):
            #print("showing Children Quadtrees")
            self.northeast.show(screen, etc)
            self.northwest.show(screen, etc)
            self.southeast.show(screen, etc)
            self.southwest.show(screen, etc)   
                     
class Boid:
    
    def __init__(self):
        
        #create a position vector with a random poistion in the screen
        self.position = random2DPos() 
        self.velocity = random2DUnit()
        self.velocity.scale_to_length(random.uniform(5.5,5.5))
        self.acceleration = myVector(0,0)
        self.maxForce = 1
        self.maxSpeed = maxSpeed
        self.parentTree = Quadtree

    def edges(self):
        
        #x position handling
        if(self.position.x > w1):
            self.position.x = 0
        elif(self.position.x < 0):
            self.position.x = w1

        # y position handling
        if(self.position.y > h1):
            self.position.y = 0
        elif(self.position.y < 0):
            self.position.y = h1

    def flock(self):
       
        nearBoids = []
        nearRect = pygame.Rect(self.position.x - queryPerceptionRadius/2,self.position.y- queryPerceptionRadius/2,queryPerceptionRadius ,queryPerceptionRadius)
        qtree.query(nearRect, nearBoids)
        #print(len(nearBoids))

        alignment = self.align(nearBoids)
        cohesion = self.cohesion(nearBoids)
        separation = self.seperation(nearBoids)
        
        alignment *= alignValue
        cohesion *= cohesionValue
        separation *= seperationValue
        
        #Lerping acceleration
        #self.acceleration = self.acceleration.lerp(alignment, lerpFactor)
        #self.acceleration = self.acceleration.lerp(cohesion, lerpFactor)
        #self.acceleration = self.acceleration.lerp(separation, lerpFactor)

        #non Lerping acceleration
        self.acceleration += alignment
        self.acceleration += cohesion
        self.acceleration += separation
        
    def cohesion(self, boids):
        steering = myVector(0,0)
        total = 0
        for other in boids:
            d = self.position.distance_to(other.position)
            if(self != other and d < cohesionPerceptionRadius):
                steering += other.position
                total += 1

        if(total > 0):
            steering //= total
            
            ##test
            averagePos = steering
            #pygame.gfxdraw.filled_circle(myScreen, int(averagePos.x), int(averagePos.y),minCircleRadius * 5,myETC.color_picker(0.6))

            steering -= self.position 
            steering.scale_to_length(self.maxSpeed)
            steering -= self.velocity
            steering = limitVector(steering, self.maxForce)

        return steering

    def align(self, boids):
        steering = myVector(0,0)
        total = 0
        for other in boids:
            d = self.position.distance_to(other.position)
            if(self != other and d < alignPerceptionRadius):
                steering += other.velocity
                total += 1

        if(total > 0):
            #print("------------" + str(steering.magnitude()))
            steering //= total
            steering.scale_to_length(self.maxSpeed)
            steering -= self.velocity
            steering = limitVector(steering, self.maxForce)

        return steering

    def seperation(self, boids):
        steering = myVector(0,0)
        total = 0

        for other in boids:
            d = self.position.distance_to(other.position)
            if(d == 0): d = 0.01
            #print("distance between boids: " + str(d))
            if(self != other and d < seperationPerceptionRadius):
                diff = self.position - other.position
                diff //= (d * d)
                steering += diff
                total += 1
            elif(self != other and d <= 0):
                steering += random2DUnit()
                #print("Calling random add")
        

        if(total > 0):
            #print("------------" + str(steering.magnitude()))
            steering //= total
            steering.scale_to_length(self.maxSpeed)
            steering -= self.velocity
            steering = limitVector(steering, self.maxForce)

        #avoid mouse
        #print(str(pygame.mouse.get_pressed()))
        if(pygame.mouse.get_pressed()[0]):
            mousePos =pygame.mouse.get_pos()
            mouseVector = myVector(mousePos[0], mousePos[1])
            diff = self.position.distance_to(mouseVector)
            if diff < queryPerceptionRadius:
                steering += self.position - mouseVector

        return steering
            
    def show(self, screen, show_array):
        global scaled_images, image_index
        #drawCircle(myScreen,myETC,self.position.x, self.position.y, 10)
    
        x = self.position.x
        y = self.position.y
        r = triangleLength

        #draw boid as circle
        #pygame.gfxdraw.filled_circle(myScreen, int(self.position.x), int(self.position.y),minCircleRadius,myETC.color_picker(myETC.knob1))

        
        #Draw boid as image
        #print(image_index)
        image = show_array[image_index]
        image_bg = show_array[0]
        
        #draw BG circle
        image_center_xpos = self.position.x + image.get_width()/2
        image_center_ypos = self.position.y + image.get_width()/2
        pygame.gfxdraw.filled_circle(myScreen, int(image_center_xpos), int(image_center_ypos),image.get_width()/2,myETC.color_picker(myETC.knob2))

        #print background image
        #bg_image_size = int(image.get_width() *1.1)
        #image_bg = pygame.transform.scale(image,(bg_image_size,bg_image_size))

        #screen.blit(image_bg, (x,y))
        screen.blit(image, (x,y))
        
        #reset image index
        #image_index += 1
        #if image_index == len(scaled_images) : image_index = 0
        
    def update(self):
        self.position += self.velocity
        self.velocity += self.acceleration
        self.velocity = limitVector(self.velocity, self.maxSpeed)

        self.acceleration *= 0

###############Geometry code

class myVector:
    def __init__(self, x ,y):
        self.x = x
        self.y = y
    
    def distance_to(self, other):
        result = math.sqrt((other.x-self.x)**2 + (other.y-self.y)**2)
        return result
    def normalize(self):
        magnitude = math.sqrt(self.x**2 + self.y**2)
        if magnitude == 0: pass
        self.x /= magnitude
        self.y /= magnitude
    def magnitude_squared(self):
        return self.x**2 + self.y**2
    def scale_to_length(self, scaleFactor):
        self.normalize()
        self.x *= scaleFactor
        self.y *= scaleFactor

    #Arithmetic
    def __sub__(self, other):
        if isinstance(other, int):
            other = myVector(other,other)
        elif  isinstance(other, float):
            other = myVector(other, other)

        x = self.x - other.x
        y = self.y - other.y

        result = myVector(x,y)
        return result

    def __iadd__(self, other):
        if isinstance(other, int):
            other = myVector(other,other)
        elif  isinstance(other, float):
            other = myVector(other, other)

        x = self.x + other.x
        y = self.y + other.y

        result = myVector(x,y)
        return result

    def __isub__(self, other):
        if isinstance(other, int):
            other = myVector(other,other)
        elif  isinstance(other, float):
            other = myVector(other, other)

        x = self.x - other.x
        y = self.y - other.y

        result = myVector(x,y)
        return result

    def __ifloordiv__(self, other):
        if isinstance(other, int):
            other = myVector(other,other)
        elif  isinstance(other, float):
            other = myVector(other, other)
        
        if(other.x == 0): other.x=0.1
        if(other.y == 0): other.y=0.1

        x = self.x / other.x 
        y = self.y / other.y
        
        result = myVector(x,y)
        return result
    
    def __truediv__(self, other):
        if isinstance(other, int):
            other = myVector(other,other)
        elif  isinstance(other, float):
            other = myVector(other, other)
        
        if(other.x == 0): other.x=0.1
        if(other.y == 0): other.y=0.1

        x = self.x / other.x 
        y = self.y / other.y
        
        result = myVector(x,y)
        return result
       

    def __imul__(self, other):
        if isinstance(other, int):
            other = myVector(other,other)
        elif  isinstance(other, float):
            other = myVector(other, other)
        
        x = self.x * other.x
        y = self.y * other.y
        result = myVector(x,y)
        return result



