import os
import pygame
import time
import random
import math

lines = 40
hwidth = 720 / lines
vwidth = 1280/lines
hoffset = hwidth / 2
voffset = vwidth / 2
x21=y21=x2=y2=x3=y3=x11=y11=x1=y1=x4=y4=sound=0

def setup(screen, etc):
    pass

def draw(screen, etc):
    global lines, hoffset, voffset, vwidth, hwidth, sound
    
    etc.color_picker_bg(etc.knob5)
    for i in range(0, 100) :
        if abs(etc.audio_in[i]) > 10000 :
            sound = (((2*etc.knob2-1)/2000 + sound))
    
    hlength = int(etc.knob1 * 600) + 39
    vlength = int(etc.knob1 * 320) + 39
    sel = etc.knob4*8
    Nsel=8-sel
    
    #drawing horizontal lines
    for i in range(0, lines) :
        color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .05+ time.time())),
                    int(127 + 127 * math.sin((i*51) * .01 + time.time())))
        if 1 <= sel < 2 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),42,75)
        if 2 <= sel < 3 :
            color = (75,int(127 + 127 * math.sin((i*51) * .1 + time.time())),42)
        if 3 <= sel < 4 :
            color = (42,75,int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        if 4 <= sel < 5 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),255,127)
        if 5 <= sel < 6 :
            color = (255,int(127 + 127 * math.sin((i*51) * .1 + time.time())),127)
        if 6 <= sel < 7 :
            color = (205,200,int(127 + 127 * math.sin((i*51) * .1 + time.time())))    
        if 1 > sel :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        a = (-.5)*sound*math.pi
        xc = 640
        yc = hoffset + (i * hwidth)
        linewidth = (hwidth / 2) + 1 - int(etc.knob1 * 9)
        L = 8*hlength
        
        if etc.knob2 < .5 :
            x21 = (L/2)*math.cos(a)
            y21 = (L/2)*math.sin(a)
            x2 = int(xc+x21)
            y2 = int(yc-y21)
            x3 = int(xc-x21)
            y3 = int(yc+y21)
            pygame.draw.line(screen, (color), [x2,y2], [x3, y3], linewidth)
            
        if etc.knob2 > .5 :
            x11 = (L/2)*math.cos(a)
            y11 = (L/2)*math.sin(a)
            x1 = xc-x11
            y1 = yc+y11
            x4 = xc+x11
            y4 = yc-y11
            pygame.draw.line(screen, (color), [x1,y1], [x4, y4], linewidth) 


    #drawing vertical lines  
    for i in range(0, lines) :
        a = sound*math.pi
        xc = voffset + (i * vwidth)
        yc = 360
        linewidth = vwidth / 3 - int(etc.knob1 * 9)
        L = 4*vlength
        
            
        color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .05+ time.time())),
                    int(127 + 127 * math.sin((i*51) * .01 + time.time())))
        if 1 <= Nsel < 2 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),42,75)
        if 2 <= Nsel < 3 :
            color = (75,int(127 + 127 * math.sin((i*51) * .1 + time.time())),42)
        if 3 <= Nsel < 4 :
            color = (42,75,int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        if 4 <= Nsel < 5 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),255,127)
        if 5 <= Nsel < 6 :
            color = (255,int(127 + 127 * math.sin((i*51) * .1 + time.time())),127)
        if 6 <= Nsel < 7 :
            color = (205,200,int(127 + 127 * math.sin((i*51) * .1 + time.time())))    
        if 1 > Nsel :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        
        if etc.knob2 < .5 :
            x21 = (L/2)*math.cos(a)
            y21 = (L/2)*math.sin(a)
            x2 = int(xc+x21)
            y2 = int(yc-y21)
            x3 = int(xc-x21)
            y3 = int(yc+y21)
            pygame.draw.line(screen, (color), [x2,y2], [x3, y3], linewidth)
            
        if etc.knob2 > .5 :
            x11 = (L/2)*math.cos(a)
            y11 = (L/2)*math.sin(a)
            x1 = xc-x11
            y1 = yc+y11
            x4 = xc+x11
            y4 = yc-y11
            pygame.draw.line(screen, (color), [x1,y1], [x4, y4], linewidth)
        
    #drawing lines 3    
    for i in range(0, lines) :
        color = (205,200,int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        if 1 <= sel < 2 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        if 2 <= sel < 3 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*51) * .05+ time.time())),
                    int(127 + 127 * math.sin((i*51) * .01 + time.time())))
        if 3 <= sel < 4 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),42,75)
        if 4 <= sel < 5 :
            color = (75,int(127 + 127 * math.sin((i*51) * .1 + time.time())),42)
        if 5 <= sel < 6 :
            color = (42,75,int(127 + 127 * math.sin((i*51) * .1 + time.time())))
        if 6 <= sel < 7 :
            color = (int(127 + 127 * math.sin((i*51) * .1 + time.time())),255,127)
        if 1 > sel :
            color = (255,int(127 + 127 * math.sin((i*51) * .1 + time.time())),127)   
        a = sound*math.pi*.125
        xc = voffset + (i * vwidth)
        yc = 360
        linewidth = vwidth / 3 - int(etc.knob1 * 9)
        L = 4*vlength
        
        
        if etc.knob2 < .5 :
            x21 = (L/2)*math.cos(a)
            y21 = (L/2)*math.sin(a)
            x2 = int(xc+x21)
            y2 = int(yc-y21)
            x3 = int(xc-x21)
            y3 = int(yc+y21)
            pygame.draw.line(screen, (color), [x2,y2], [x3, y3], linewidth)
            
        if etc.knob2 > .5 :
            x11 = (L/2)*math.cos(a)
            y11 = (L/2)*math.sin(a)
            x1 = xc-x11
            y1 = yc+y11
            x4 = xc+x11
            y4 = yc-y11
            pygame.draw.line(screen, (color), [x1,y1], [x4, y4], linewidth)        
    
    #Trails
    veil = pygame.Surface((1280,720))  
    veil.set_alpha(int(etc.knob3 * 200))
    veil.fill((etc.bg_color[0],etc.bg_color[1],etc.bg_color[2])) 
    screen.blit(veil, (0,0))

