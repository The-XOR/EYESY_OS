import pygame
import random
from pygame.locals import *
import pygame.gfxdraw
import math

#Global Vars
trigger = False
x = 0
y = 0
w1 = 0
h1 = 0

#Circle Params
minCircleRadius = 5
colorWarbleFactor = 100

#determins how many points are rendered per draw cycle
maxIterations = 30
minIterations = 1
baseIterations = maxIterations / 3
iterations = baseIterations

#Used to keep track of audio input range for scaling values
audioMin = -5000
audioMax = 3000

#audio checking vars
audioSampleRate = 15
audioFloorThreshold = -100
audioRoofThreshold = 100

#Phyllotaxis Parameters
c = 50.0

#Current point drawn after center
n = 0.0

currentFrame = 0

def setup(screen, etc) :
    global w1,h1, x
    w1 = screen.get_width()
    h1 = screen.get_height()
    pass

def clamp(num, min_value, max_value):
        num = max(min(num, max_value), min_value)
        return num

def translate(value, leftMin, leftMax, rightMin, rightMax):
    # Figure out how 'wide' each range is
    leftSpan = leftMax - leftMin
    rightSpan = rightMax - rightMin

    # Convert the left range into a 0-1 range (float)
    valueScaled = float(value - leftMin) / float(leftSpan)

    # Convert the 0-1 range into a value in the right range.
    return rightMin + (valueScaled * rightSpan)



def drawCircle(screen, etc, x, y, audioSample) :

    global minCircleRadius

    #get user input for Circle size and color
    circleScaleFactor = 300 * (1/(etc.knob3 + .01))
    circleRadiusFloor = etc.knob2 * minCircleRadius + minCircleRadius
    circleColor =  etc.color_picker(etc.knob1)
    
    warbledColor = warbleColor(circleColor)
    
    #calculate circle radius
    circleRadius = abs(audioSample)/circleScaleFactor + circleRadiusFloor
    
    #Draw Circle
    pygame.gfxdraw.filled_circle(screen,int(x),int(y),int(circleRadius),warbledColor)
        
def warbleColor(color):
    
    global colorWarbleFactor
    
    indexCounter = 0
    largestColorIndex = -1
    largestColorIntensity = -1
    
    
    
    #check R,G,B and see which is largest
    for i in color:
        if(i > largestColorIntensity):
            largestColorIndex = indexCounter
            largestColorIntensity = i
        indexCounter +=1
    
    r = color[0]
    g = color[1]
    b = color[2]
    
    if(r == g and g ==b):
        rand = random.randint(0,2)
        largestColorIndex = rand
    
    if largestColorIndex == 0:
        r = clamp(int(color[largestColorIndex] + (math.sin(currentFrame) * colorWarbleFactor)), 0, 255)

    elif largestColorIndex ==1:
        g = clamp(int(color[largestColorIndex] + (math.sin(currentFrame) * colorWarbleFactor)),0,255)

    elif  largestColorIndex == 2:
        b = clamp(int(color[largestColorIndex] + (math.sin(currentFrame) * colorWarbleFactor)),0,255)

    else:
        print("no warble index")

    
    newColor = (int(r), int(g), int(b))
    return newColor

def draw(screen, etc) :
    global trigger
    global n, currentFrame
    global maxIterations, minIterations, iterations
    global audioMin, audioMax 
    global c
    
    #user adjuisted c parameter
    cAdjusted = c * etc.knob4 + 1

    #Set BG color
    etc.color_picker_bg(etc.knob5)
    
    #check audio
    audioSample = etc.audio_in[10]
    
    #used to only update ranges occasionally
    
    if currentFrame % audioSampleRate == 0:

        #update the min max variables 
        if audioSample < audioMin:
            audioMin = audioSample
        elif audioSample > audioMax:
            audioMax = audioSample

        #updateIterations if reading is outside audio sample threshold update iterations, if not then decrease iterations up to baseIterations
        if audioSample < audioFloorThreshold or audioSample > audioRoofThreshold :
            iterations = translate(audioSample,audioMin,audioMax,minIterations,maxIterations) 
        elif iterations > baseIterations:
            iterations -= 1
        
    #increment sample rate Counter
    currentFrame += 1
    
    for i in range(int(iterations)):
        #Phyllotaxis
        a = 137.5 * n
        r = cAdjusted * math.sqrt(n)
        x = r * math.cos(a) + w1 / 2
        y = r * math.sin(a) + h1 / 2
        
        drawCircle(screen, etc, x,y, audioSample)
        n += 1 
    
    #Reset Spiral to center once its off screen
    if x >  w1 + 60:
        n = 0
       