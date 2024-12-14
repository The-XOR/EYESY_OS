import os
import pygame
import glob
import random

image_index = 0
last_screen = pygame.Surface((800,600))
width=800
height=600
dwidth=790
dheight=590



def setup(screen, etc):
    global last_screen, dwidth, dheight, width, height
    width = screen.get_width()
    height = screen.get_height()
    last_screen = pygame.Surface((width,height))
    #etc.auto_clear = False
    pass

def draw(screen, etc) :
    if (etc.auto_clear) : etc.auto_clear = False
    global last_screen, dwidth, dheight, width, height
    dwidth = int(etc.knob1 * (width * 2))+ 1
    dheight = int(etc.knob1 * (height *2)) + 1
    #if 1 == 1 :
    if etc.audio_trig or etc.midi_note_new :
        color = etc.color_picker(etc.knob4) 
        x = random.randrange(0,1280)
        y = random.randrange(0,720)
        xlen = random.randrange (1,400)
        ylen = random.randrange (1,300)
        pygame.draw.circle(screen,color,[x,y],int(etc.knob3*200)+10,int(etc.knob3*50)+2)
        #pygame.draw.line(screen,(r,g,b),[x - (xlen),y - ylen],[x + xlen ,y+ylen],10)

    image = last_screen
    last_screen = screen.copy()
    rotation = int(etc.knob2 * 90)
    thing = pygame.transform.rotate(image, (rotation - 45))
    #thing.fill((255, 255, 255, etc.knob4 * 255), None, pygame.BLEND_RGBA_MULT)
    thing = pygame.transform.scale(thing, ( dwidth, dheight ) )
    screen.blit(thing, (  ((width - dwidth) / 2), ((height - dheight) / 2) )   )