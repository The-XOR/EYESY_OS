import os
import pygame
import math
import time

last_point = [320, 0]
last_point1 = [320, 0]

def setup(screen, etc):
    pass

def draw(screen, etc):
    
    global last_point, last_point1, speed, slide
    
    etc.color_picker_bg(etc.knob5)
    linewidth= int(16*etc.knob1)+1
    lines = 72
    spacehoriz = 180*etc.knob2+18
    spacevert = spacehoriz
    sel = etc.knob4*8
    
    for m in range(0, lines) :
        x = m*spacehoriz
        y = 360
        auDio = etc.audio_in[m] / 35
        if sel >= 7 :
            color = (int(127 + 127 * math.sin((m*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((m*1) * .05+ time.time())),
                    int(127 + 127 * math.sin((m*1) * .01 + time.time())))
        if 1 <= sel < 2 :
            color = (int(127 + 127 * math.sin((m*1) * .1 + time.time())),42,75)
        if 2 <= sel < 3 :
            color = (75,int(127 + 127 * math.sin((m*1) * .1 + time.time())),42)
        if 3 <= sel < 4 :
            color = (42,75,int(127 + 127 * math.sin((m*1) * .1 + time.time())))
        if 4 <= sel < 5 :
            color = (int(127 + 127 * math.sin((m*1) * .1 + time.time())),255,127)
        if 5 <= sel < 6 :
            color = (255,int(127 + 127 * math.sin((m*1) * .1 + time.time())),127)
        if 6 <= sel < 7 :
            color = (205,200,int(127 + 127 * math.sin((m*1) * .1 + time.time())))    
        if 1 > sel :
            color = (int(127 + 127 * math.sin((m*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((m*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((m*1) * .1 + time.time())))        
        
        if auDio < 0 : auDio = 0
        pygame.draw.line(screen, color, [x,0], [x, y-auDio], linewidth)

    for i in range(0, lines) :
        x = i*spacehoriz
        y = 360
        if sel >= 7 :
            color = (int(127 + 127 * math.sin((i*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*1) * .05+ time.time())),
                    int(127 + 127 * math.sin((i*1) * .01 + time.time())))
        if 1 <= sel < 2 :
            color = (int(127 + 127 * math.sin((i*1) * .1 + time.time())),42,75)
        if 2 <= sel < 3 :
            color = (75,int(127 + 127 * math.sin((i*1) * .1 + time.time())),42)
        if 3 <= sel < 4 :
            color = (42,75,int(127 + 127 * math.sin((i*1) * .1 + time.time())))
        if 4 <= sel < 5 :
            color = (int(127 + 127 * math.sin((i*1) * .1 + time.time())),255,127)
        if 5 <= sel < 6 :
            color = (255,int(127 + 127 * math.sin((i*1) * .1 + time.time())),127)
        if 6 <= sel < 7 :
            color = (205,200,int(127 + 127 * math.sin((i*1) * .1 + time.time())))    
        if 1 > sel :
            color = (int(127 + 127 * math.sin((i*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((i*1) * .1 + time.time())))        
        
        auDio = etc.audio_in[i] / 35
        if auDio > 0 : auDio = 0
        pygame.draw.line(screen, color, [x,720], [x, y-auDio], linewidth)
        
    for j in range(0,lines) :
        if sel >= 7 :
            color = (int(127 + 127 * math.sin((j*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((j*1) * .05+ time.time())),
                    int(127 + 127 * math.sin((j*1) * .01 + time.time())))
        if 1 <= sel < 2 :
            color = (int(127 + 127 * math.sin((j*1) * .1 + time.time())),42,75)
        if 2 <= sel < 3 :
            color = (75,int(127 + 127 * math.sin((j*1) * .1 + time.time())),42)
        if 3 <= sel < 4 :
            color = (42,75,int(127 + 127 * math.sin((j*1) * .1 + time.time())))
        if 4 <= sel < 5 :
            color = (int(127 + 127 * math.sin((j*1) * .1 + time.time())),255,127)
        if 5 <= sel < 6 :
            color = (255,int(127 + 127 * math.sin((j*1) * .1 + time.time())),127)
        if 6 <= sel < 7 :
            color = (205,200,int(127 + 127 * math.sin((j*1) * .1 + time.time())))    
        if 1 > sel :
            color = (int(127 + 127 * math.sin((j*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((j*1) * .1 + time.time())),
                    int(127 + 127 * math.sin((j*1) * .1 + time.time())))
        pygame.draw.line(screen, color, (-1,j*spacevert), (1280,j*spacevert), linewidth)
    
    
    #Trails
    veil = pygame.Surface((1280,720))  
    veil.set_alpha(int(etc.knob3 * 200))
    veil.fill((etc.bg_color[0],etc.bg_color[1],etc.bg_color[2])) 
    screen.blit(veil, (0,0))