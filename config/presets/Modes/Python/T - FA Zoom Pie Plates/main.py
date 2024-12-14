import os
import pygame
import time
import random
import pygame.gfxdraw

count = 0
size = 0

image_index = 0
width = 1280
height = 720
dwidth = width - 10
dheight = height - 10
last_screen = pygame.Surface((1280,720))



def setup(screen, etc):
    global a, last_screen, dwidth, dheight, width, height, count, size
    width = screen.get_width()
    height = screen.get_height()
    last_screen = pygame.Surface((width,height))
    pass

def draw(screen, etc):
    etc.color_picker_bg(etc.knob5)
    global a, last_screen, dwidth, dheight, width, height, count, size
    dwidth = int(etc.knob2 * (width - 2)) + 1
    dheight = int(etc.knob2 * (height - 2)) + 1

    if etc.audio_trig or etc.midi_note_new :
    #if 1 == 1 :
        x=random.randrange(0,1300)
        y=random.randrange(0,800)
        pierad=random.randrange(10,100) 
        arcstart=random.randrange(0,360)
        arcend=random.randrange(0, 360-arcstart)
        #fillrange = int(etc.knob2*100)+ 1
        fillrange = 50
        diameter = int(etc.knob1 * 1000)+1
        nest=int(random.randrange(0,10))
        #nest = int(etc.knob5 * 10)
        #nest = 8
        color = etc.color_picker(etc.knob4)
        
        for i in range(fillrange):
            size = diameter-(nest*i)
            if size < 0 : size = 5
            pygame.gfxdraw.pie(screen, x, y, size, arcstart + i*2, arcend - i*2, color)

    image = last_screen
    last_screen = screen.copy()
    #thing = pygame.transform.scale(image, (int(etc.knob3 * 1280), int(etc.knob4 * 720) ) ) 
    rotation = int(etc.knob3 * 180)
    thing = pygame.transform.rotate(image, (rotation - 90))
    thing = pygame.transform.scale(thing, ( dwidth / 2, dheight / 2 ) )
    screen.blit(thing, (  int((width - dwidth) / 2), int((height - dheight) / 2) )   )
    screen.blit(thing, (  int(((width - dwidth) / 2) + (dwidth / 2)), int((height - dheight) / 2) )   )
    screen.blit(thing, (  int((width - dwidth) / 2), int(((height - dheight) / 2) + (dheight / 2)) ) )
    screen.blit(thing, (  int (((width - dwidth) / 2) + (dwidth/2)) , int(((height - dheight) / 2) + (dheight / 2)) ) )
