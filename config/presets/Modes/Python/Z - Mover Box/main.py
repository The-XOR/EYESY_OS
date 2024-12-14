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

mu = .005
m = 3

alignValue = .5
alignPerceptionRadius = 150  # 50

cohesionValue = 1
cohesionPerceptionRadius = 200  # 100

seperationValue = 1
seperationPerceptionRadius = 150  # 50

queryPerceptionRadius = 200  # 100


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
        b = Mover(i % 9 + 1)  # random.randrange(1, 9)
        moverGroup.append(b)
        i += 1


def draw(screen, etc):
    # print("--------------Starting Draw Loop")
    global trigger


    # print("Start Draw")

    gravity = myVector(0, etc.knob1 * 3)
    wind = myVector(0, 0)
    massScaler = 1
    sizeScaler = etc.knob3 * 3
    i = 0
    for b in moverGroup:
        if etc.audio_trig or etc.midi_note_new:
            trigger = True

        if trigger == True:
            wind = myVector(random.uniform(-100 * m * etc.knob2, 100 * m * etc.knob2),
                            random.uniform(-100 * m * etc.knob2, 100 * m * etc.knob2))
            trigger = False
            
        weightB = gravity
        weightB *= b.mass * massScaler
        wind *= massScaler
        b.edges(sizeScaler)
        b.applyForce(weightB)
        b.friction(sizeScaler)
        b.applyForce(wind)
        b.update()
        b.show(screen, i * 50 * etc.knob4, sizeScaler)
        i += 1

    # Set BG color
    etc.color_picker_bg(etc.knob5)

    # Trails
    veil = pygame.Surface((1280, 720))
    veil.set_alpha(int(etc.knob5 * 50))
    veil.fill((etc.bg_color[0], etc.bg_color[1], etc.bg_color[2]))
    screen.blit(veil, (0, 0))


class Mover:

    def __init__(self, m):

        # create a position vector with a random poistion in the screen
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

    def friction(self, knob3):

        scaledR = self.r * (1 + knob3)

        diff = h1 - (self.position.y + 2 * scaledR)
        if (diff <= scaledR / 2):
            self.velocity *= .95
            # friction = self.velocity
            # friction.normalize()
            # friction *= -1
            # normal = self.mass
            # friction*=(mu * normal)
            # self.applyForce(friction) Kills all motion, y is that?

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


###############Geometry code

class myVector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def distance_to(self, other):
        result = math.sqrt((other.x - self.x) ** 2 + (other.y - self.y) ** 2)
        return result

    def normalize(self):
        magnitude = math.sqrt(self.x ** 2 + self.y ** 2)
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
        if isinstance(other, int):
            other = myVector(other, other)
        elif isinstance(other, float):
            other = myVector(other, other)

        x = self.x * other.x
        y = self.y * other.y
        result = myVector(x, y)
        return result
