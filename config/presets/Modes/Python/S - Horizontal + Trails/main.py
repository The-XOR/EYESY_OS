import os
import pygame
import glob
import random
import math
import time

#Knob1 = Oscilloscope Shape & Size Selector - 3 divisions
#Knob2 = Size of 'Trails'
#Knob3 = 'Trails' Opacity
#Knob4 = Foreground Color - 8 positions
#Knob5 = Background Color

last_screen = pygame.Surface((1280,720))
xr = 320
yr = 240
lines = 100

def setup(screen, etc) :
    global last_screen, xr, yr
    
    xr = etc.xres
    yr = etc.yres
    last_screen = pygame.Surface((xr,yr))
    
    
def draw(screen, etc) :
    global last_screen, seg
    etc.color_picker_bg(etc.knob5)    


    for i in range(0, lines) :
        seg(screen, etc, i)
        
    lastScreenSize = 200

    image = last_screen
    last_screen = screen.copy()
    thingX = int(xr-(etc.knob2*lastScreenSize))
    thingY = int(yr-(etc.knob2*(lastScreenSize*0.5625)))
    placeX = int(xr/2)-int(((thingX/2)*xr)/1280)
    placeY = int(yr/2)-int(((thingY/2)*yr)/720)

    thing = pygame.transform.scale(image, (thingX, thingY)) # mirror screen scale
    thing.set_alpha(int(etc.knob3 * 180)) # adjust transparency on knob3
    screen.blit(thing, (placeX, placeY)) # mirror screen scale
    
    
def seg(screen, etc, i) :    
    space = etc.xres/(lines-2)
    y0 = 0
    y1 = (etc.audio_in[i] / 90)
    x = i*space
    position = etc.yres/2
    
    #set the size of the graphic elements with Knob 1:
    if etc.knob1 < 0.33 : 
        linewidth = int(((etc.knob1*3.5)*etc.xres)/(lines-75)+1)
        ballSize = 0 #no balls shown
    
    if etc.knob1 >= 0.33 and etc.knob1 < 0.66 :
        linewidth = 0 #no lines shown
        ballSize = int((((0.66-etc.knob1)*3)*etc.xres)/(lines-75)+1)
    
    if etc.knob1 >= 0.66 :
        linewidth = int(((etc.knob1-0.66)*1.5)*etc.xres/(lines-75))
        ballSize = int((((etc.knob1-0.66)*3)*etc.xres)/(lines-75))
    
    sel = etc.knob4*8 #color selector knob
    Cmod = 0.02 #how quickly the color shifts
    
    if 1 > sel :
        color = (int(127 + 127 * math.sin(i * 1*Cmod + time.time())),
                int(127 + 127 * math.sin(i * 1*Cmod + time.time())),
                int(127 + 127 * math.sin(i * 1*Cmod + time.time())))
    if 1 <= sel < 2 :
        color = (int(127+127 * math.sin(i * 1*Cmod + time.time())),0,45)
    if 2 <= sel < 3 :
        color = (255,int(155 + 100 * math.sin(i * 1*Cmod + time.time())),30)
    if 3 <= sel < 4 :
        color = (0,200,int(127 + 127 * math.sin(i * 1*Cmod + time.time())))
    if 5 > sel >= 4 :
        color = ((127*Cmod)%255,
                (127*Cmod)%255,
                int(127 + 127 * math.sin(i * (Cmod+.1) + time.time())))
    if 6 > sel >= 5 :
        color = ((127*Cmod)%255,
                int(127 + 127 * math.sin(i * (Cmod+.1) + time.time())),
                (127*Cmod)%255)
    if 7 > sel >= 6 :
        color = (int(127 + 127 * math.sin(i * (Cmod+.1) + time.time())),
                (127*Cmod)%255,
                (127*Cmod)%255)
    if  sel >= 7 :
        color = (int(127 + 127 * math.sin((i+30) * (1*Cmod+.01) + time.time())),
                int(127 + 127 * math.sin((i+30) * (.5*Cmod+.005) + time.time())),
                int(127 + 127 * math.sin((i+15) * (.1*Cmod+.001) + time.time())))
                
    pygame.draw.circle(screen,color,(x, y1+position),ballSize, 0)
    pygame.draw.line(screen, color, [x, y0+position], [x, y1+position], linewidth)
    
