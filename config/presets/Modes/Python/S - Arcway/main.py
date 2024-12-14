import os
import pygame
import random
import math

#knob1 - line width/length
#knob2 - rate of rotation. left half controls counter clockwise rotation; right half controls clockwise. 
#knob3 - offset of bottom disc
#knob4 - color of top disc
#knob5 - background color

def setup(screen, etc):
    global rotation_factor, color_count, timer, color_mod, color, r, g, b
    rotation_factor = 0   # Initialize rotation factor
    color_count = 0
    timer = 0
    color_mod = (-10, 0, 10)
    color = (0,0,0)
    r = 100
    g = 200
    b= 71

def draw(screen, etc):
    global rotation_factor, color_count, timer, color_mod, color, r, g, b
    etc.color_picker_bg(etc.knob5) #set background
    color2 = etc.color_picker(etc.knob4) #the color of the second 'disc'
    xres_half = int(etc.xres / 2)
    yres_half = int(etc.yres / 2)
    start_angle = 0
    stop_angle = math.pi/50   
    width = int(etc.knob1*155)+1 #width of lines
    
    #rate of rotation
    if etc.knob2 <= 0.5:
            rotation_factor += etc.knob2*2
    else:
            rotation_factor -= (etc.knob2*2 - 1)

    rotation_detune = etc.knob3 #offset the second disc

#------rate of picking colors
    timer +=1
    color_count = etc.knob4 * 255
    
    if (timer%255) >= color_count :
        r = random.choice(color_mod)
        g = random.choice(color_mod)
        b = random.choice(color_mod)
        timer = 0
        
    color = list(etc.color_picker(etc.knob4))  # Get colors as a list
#-----------

    for i in range(100):
        rect = pygame.Rect(xres_half-250, yres_half-250, 500, 500)
        rect = rect.move((125*math.cos(2*math.pi*i/100)+(etc.audio_in[i]/30) - 0.1 * width, 125*math.sin(2*math.pi*i/100)+(etc.audio_in[i]/200) - 0.1 * width))
        pygame.draw.arc(screen, color2, rect, start_angle + 2*math.pi*(rotation_factor-rotation_detune), stop_angle + 2*math.pi*(rotation_factor-rotation_detune), width) 
        
        rect = pygame.Rect(xres_half-250, yres_half-250, 500, 500)
        rect = rect.move((125*math.cos(2*math.pi*i/100)+(etc.audio_in[i]/30) + 0.1 * width, 125*math.sin(2*math.pi*i/100)+(etc.audio_in[i]/200) + 0.1 * width)) 

        color[0] = (color[0] + i*r) %255
        color[1] = (color[1] + i*g) %255
        color[2] = (color[2] + i*b) %255
        
        pygame.draw.arc(screen, color, rect, start_angle + 2*math.pi*rotation_factor, stop_angle + 2*math.pi*rotation_factor, width)
        
        start_angle += math.pi/50
        stop_angle += math.pi/50

