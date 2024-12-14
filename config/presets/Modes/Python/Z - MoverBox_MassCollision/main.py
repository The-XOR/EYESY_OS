#MOVER BOX WITH COLLISION AND MASS#
import pygame
import random
from pygame.locals import *
import pygame.gfxdraw
import math
import time
import glob
import os

# initializing pygame
pygame.font.init()

# check whether font is initialized
# or not
pygame.font.get_init()

# Global Vars
trigger = False
x = 0
y = 0
w1 = 0
h1 = 0

# Image vars
bg = pygame.Surface((656, 416))

# geometry Params
minCircleRadius = 10

# Movers vars
moverGroupSize = 20  # 20
moverGroup = []

m = 3
mu = .01


# QOL methods
def limitVector(vectorToLimit, maxValue):
    # result = myVector(0,0)
    result = vectorToLimit

    if (result.magnitude_squared() > maxValue * maxValue):
        result.normalize()
        result *= maxValue

    return result


def random2DPos():
    result = myVector(random.randrange(0, w1), random.randrange(0, h1))
    return result


def random2DUnit():
    result = myVector(random.uniform(-1, 1), random.uniform(-1, 1))
    return result


def translate(value, leftMin, leftMax, rightMin, rightMax):
    # Figure out how 'wide' each range is
    leftSpan = leftMax - leftMin
    rightSpan = rightMax - rightMin

    # Convert the left range into a 0-1 range (float)
    valueScaled = float(value - leftMin) / float(leftSpan)

    # Convert the 0-1 range into a value in the right range.
    return rightMin + (valueScaled * rightSpan)


################################

def setup(screen, etc):
    global w1, h1, moverGroup, myETC, myScreen, startRect, bg
    w1 = screen.get_width()
    h1 = screen.get_height()
    myETC = etc
    myScreen = screen
    startRect = pygame.Rect(0, 0, w1, h1)

    bg = pygame.Surface((etc.xres, etc.yres))


    i = 0
    while i < moverGroupSize:
        b = Mover(i%2+1)#Mover(i % 9 + 1)  # random.randrange(1, 9) 
        moverGroup.append(b)
        i += 1


def draw(screen, etc):
    # print("--------------Starting Draw Loop")
    global trigger, w1, h1


    # print("Start Draw")

    gravity = myVector(0, etc.knob1 * 3)
    wind = myVector(0, 0)
    massScaler = 1
    sizeScaler = etc.knob3 * 3
    i = 0
    
    handle_collisions(moverGroup, sizeScaler)
    for b in moverGroup:
        if etc.audio_trig or etc.midi_note_new:
            trigger = True

        if trigger == True :
            wind = myVector(random.uniform(-5 * m * 1/(etc.knob2+.01), 5 * m * 1/(etc.knob2+.01)),
                            random.uniform(-5 * m * 1/(etc.knob2+.01), 5 * m * 1/(etc.knob2+.01)))
            trigger = False
            
        weightB = gravity
        weightB *= b.mass * massScaler
        wind *= massScaler
        b.edges(sizeScaler)
        b.applyForce(weightB)
        b.applyForce(wind)
        b.friction(sizeScaler, etc.knob2)
        b.update()
        b.show(screen, i * 50 * etc.knob4, sizeScaler)
        i += 1


    # Set BG color
    etc.color_picker_bg(etc.knob5)

    # Trails
    veil = pygame.Surface((w1, h1))
    veil.set_alpha(int(etc.knob5 * 50))
    veil.fill((etc.bg_color[0], etc.bg_color[1], etc.bg_color[2]))
    screen.blit(veil, (0, 0))

def handle_collisions(moverGroup, knob3):
    for i in range(len(moverGroup)):
        for j in range(i + 1, len(moverGroup)):
            a = moverGroup[i]
            b = moverGroup[j]
            if a.is_colliding(b, knob3):
                resolve_collision(a, b, knob3)

def resolve_collision(a, b, knob3):
    # Calculate normal and tangent unit vectors
    normal = a.position - b.position
    distance = normal.magnitude()
    overlap = (a.r * (1 + knob3) + b.r * (1 + knob3)) - distance
    
    if distance != 0:  # Prevent division by zero
        normal.normalize()
    else:
        # If distance is zero, provide a default direction
        normal = myVector(1, 0)
    
    tangent = myVector(-normal.y, normal.x)

    # Adjust positions to resolve overlap
    a.position += normal * (overlap / 2)
    b.position -= normal * (overlap / 2)

    # Project velocities onto the normal and tangent vectors
    a_normal_velocity = normal.x * a.velocity.x + normal.y * a.velocity.y
    b_normal_velocity = normal.x * b.velocity.x + normal.y * b.velocity.y

    a_tangent_velocity = tangent.x * a.velocity.x + tangent.y * a.velocity.y
    b_tangent_velocity = tangent.x * b.velocity.x + tangent.y * b.velocity.y

    # Swap the normal velocities
    a_normal_velocity, b_normal_velocity = b_normal_velocity, a_normal_velocity

    # Update velocities based on the new normal and unchanged tangent velocities
    a.velocity.x = normal.x * a_normal_velocity + tangent.x * a_tangent_velocity
    a.velocity.y = normal.y * a_normal_velocity + tangent.y * a_tangent_velocity
    b.velocity.x = normal.x * b_normal_velocity + tangent.x * b_tangent_velocity
    b.velocity.y = normal.y * b_normal_velocity + tangent.y * b_tangent_velocity

class Mover:

    def __init__(self, m):

        # create a position vector with a random position in the screen
        self.position = random2DPos()
        self.velocity = random2DUnit()
        self.velocity.scale_to_length(random.uniform(5.5, 5.5))
        self.acceleration = myVector(0, 0)
        self.mass = m
        self.r = math.sqrt(m) * 10

    def edges(self, knob3):
        scaledR = self.r * (1 + knob3)

        # x position handling
        if (self.position.x >= (w1 - 2 * scaledR)):
            self.position.x = (w1 - 2 * scaledR)
            self.velocity.x *= -1
        elif (self.position.x <= 0):
            self.position.x = 0
            self.velocity.x *= -1

        # y position handling
        if (self.position.y >= (h1 - 2 * scaledR)):
            self.position.y = (h1 - 2 * scaledR)
            self.velocity.y *= -1
        elif (self.position.y <= 0):
            self.position.y = 0
            self.velocity.y *= -1

    def applyForce(self, force):
        f = force
        f //= self.mass
        self.acceleration += f

    def friction(self, sizeScalar, knob2):

        scaledR = self.r * (1 + sizeScalar)

        diff = h1 - (self.position.y + 2 * scaledR)
        diff2 = w1 - (self.position.x + 2 * scaledR)
        diff3 = 0 + (self.position.y + 2 * scaledR)
        diff4 = 0 + (self.position.x + 2 * scaledR)
        if (diff <= scaledR / 2 or diff2 <= scaledR / 2 or diff3 >= scaledR / 2 or diff4 >= scaledR / 2):
            self.velocity *= (.9 + .1*knob2)
            #friction = self.velocity
            #friction.normalize()
            #friction *= -.01
            #normal = self.mass
            #friction*=(mu * normal)
            #self.applyForce(friction)# Kills all motion, y is that?

    def show(self, screen, i, knob3):

        color = (int(127 + 120 * math.sin(i * .01 + time.time())),
                 int(127 + 120 * math.sin(i * (.01 + .01) + time.time())),
                 int(127 + 120 * math.sin(i * (.01 + .02) + time.time())))

        # Draw Mover as circle
        scaledR = self.r * (1 + knob3)
        center_xpos = self.position.x + scaledR
        center_ypos = self.position.y + scaledR
        pygame.gfxdraw.filled_circle(myScreen, int(center_xpos), int(center_ypos),
                                     int(scaledR), color)

    def update(self):
        self.velocity += self.acceleration
        self.position += self.velocity

        self.acceleration *= 0
    
    def is_colliding(self, other, knob3):
        scaledR = self.r * (1 + knob3)
        scaledOtherR = other.r * (1 + knob3)
        distance = self.position.distance_to(other.position)
        return distance < (scaledR + scaledOtherR)

###############Geometry code

class myVector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def distance_to(self, other):
        result = math.sqrt((other.x - self.x) ** 2 + (other.y - self.y) ** 2)
        return result

    def magnitude(self):
        return math.sqrt(self.x ** 2 + self.y ** 2)

    def normalize(self):
        magnitude = self.magnitude()
        if magnitude == 0: pass
        self.x /= magnitude
        self.y /= magnitude

    def magnitude_squared(self):
        return self.x ** 2 + self.y ** 2

    def scale_to_length(self, scaleFactor):
        self.normalize()
        self.x *= scaleFactor
        self.y *= scaleFactor

    # Arithmetic
    def __sub__(self, other):
        if isinstance(other, int):
            other = myVector(other, other)
        elif isinstance(other, float):
            other = myVector(other, other)

        x = self.x - other.x
        y = self.y - other.y

        result = myVector(x, y)
        return result

    def __iadd__(self, other):
        if isinstance(other, int):
            other = myVector(other, other)
        elif isinstance(other, float):
            other = myVector(other, other)

        x = self.x + other.x
        y = self.y + other.y

        result = myVector(x, y)
        return result

    def __isub__(self, other):
        if isinstance(other, int):
            other = myVector(other, other)
        elif isinstance(other, float):
            other = myVector(other, other)

        x = self.x - other.x
        y = self.y - other.y

        result = myVector(x, y)
        return result

    def __ifloordiv__(self, other):
        if isinstance(other, int):
            other = myVector(other, other)
        elif isinstance(other, float):
            other = myVector(other, other)

        if (other.x == 0): other.x = 0.1
        if (other.y == 0): other.y = 0.1

        x = self.x / other.x
        y = self.y / other.y

        result = myVector(x, y)
        return result

    def __truediv__(self, other):
        if isinstance(other, int):
            other = myVector(other, other)
        elif isinstance(other, float):
            other = myVector(other, other)

        if (other.x == 0): other.x = 0.1
        if (other.y == 0): other.y = 0.1

        x = self.x / other.x
        y = self.y / other.y

        result = myVector(x, y)
        return result

    def __imul__(self, other):
        if isinstance(other, (int, float)):
            x = self.x * other
            y = self.y * other
        else:
            x = self.x * other.x
            y = self.y * other.y
        self.x = x
        self.y = y
        return self

    def __mul__(self, other):
        if isinstance(other, (int, float)):
            x = self.x * other
            y = self.y * other
        else:
            x = self.x * other.x
            y = self.y * other.y
        return myVector(x, y)