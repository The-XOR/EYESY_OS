import os
import pygame
import time
import random
import math

last_point = [0, 360]
first_point = []


def setup(screen, etc):
    pass

def draw(screen, etc):
    global last_point, first_point
    sel = etc.knob4*8
    etc.color_picker_bg(etc.knob5)  
    for i in range(0, 100) :
        if sel >= 7 :
            color = (int(127 + 127 * math.sin((i) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*1) * .05+ time.time())),
                    int(127 + 127 * math.sin((i*1) * .01 + time.time())))
        if 1 <= sel < 2 :
            color = (int(127 + 127 * math.sin((i) * .1 + time.time())),42,75)
        if 2 <= sel < 3 :
            color = (75,int(127 + 127 * math.sin((i) * .1 + time.time())),42)
        if 3 <= sel < 4 :
            color = (42,75,int(127 + 127 * math.sin((i) * .1 + time.time())))
        if 4 <= sel < 5 :
            color = (int(127 + 127 * math.sin((i*1) * .1 + time.time())),255,127)
        if 5 <= sel < 6 :
            color = (255,int(127 + 127 * math.sin((i) * .1 + time.time())),127)
        if 6 <= sel < 7 :
            color = (205,200,int(127 + 127 * math.sin((i) * .1 + time.time())))    
        if 1 > sel :
            color = (int(127 + 127 * math.sin((i) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*1) * .1 + time.time()))) 
        lineseg(screen, etc, i, color)
        ballseg(screen, etc, i, color)
    for i in range(0, int(etc.knob3 * 100)):
        pygame.draw.rect(screen, color, [random.randrange(0,1280),random.randrange(0,720),5,5], 0)
    

def lineseg(screen, etc, i, color):
    global last_point, first_point
    
    linewidth = int(etc.knob1*75)+1
    y1 = (screen.get_height() // 2) + (etc.audio_in[i] / 50)
    x = i * 10
    xoffset = (1280 - (99*10)) // 2

    if i == 0 : 
        first_point = last_point
    else :
        last_point = last_point
    
    pygame.draw.line(screen, color, last_point, [x + xoffset, y1], linewidth)
    last_point = [x + xoffset, y1]

def ballseg(screen, etc, i, color):
    
    ballwidth = int(etc.knob2*75)+1
    y1 = (screen.get_height() // 2) + (etc.audio_in[i] / 50)
    x = i * 10
    xoffset = (1280 - (99*10)) // 2
    
    pygame.draw.circle(screen,color,(x + xoffset, y1),ballwidth, 0)
    
    
