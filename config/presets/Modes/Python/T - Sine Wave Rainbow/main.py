import os
import pygame
import random
import time
import math


def setup(screen, etc) :
    pass

def draw(screen, etc) :
    
    radius = 30
    color = etc.color_picker(etc.knob4)
    
    etc.color_picker_bg(etc.knob5)
    halfSies = list((c // 2 for c in color))
    
    
    
    if etc.audio_trig or etc.midi_note_new:
        for i in range(int(etc.knob3 * 720)):
            x = int(600 - 80 * math.sin(i * etc.knob1 / 10 + time.time()))
        
            radius = int(30 + math.sin(i * etc.knob2 / 10 + time.time()) * 20)
        
            color = (halfSies[0] + int(halfSies[0] * math.sin(i * .01 + time.time())),
                     halfSies[1] + int(halfSies[1] * math.sin(i * .01 + time.time())),
                     halfSies[2] + int(halfSies[2] * math.sin(i * .01 + time.time())))

            pygame.gfxdraw.filled_circle(screen,
                                         x,
                                         i,
                                         radius,
                                         color)
            pygame.gfxdraw.filled_circle(screen,
                                         x - 1280 // 4,
                                         i,
                                         radius,
                                         color)
            pygame.gfxdraw.filled_circle(screen,
                                         x + 1280 // 4,
                                         i,
                                         radius,
                                         color)
            
            pygame.gfxdraw.filled_circle(screen,
                                         x,
                                         720 - i,
                                         radius,
                                         color)
            pygame.gfxdraw.filled_circle(screen,
                                         x - 1280 // 4,
                                         720 - i,
                                         radius,
                                         color)
            pygame.gfxdraw.filled_circle(screen,
                                         x + 1280 // 4,
                                         720 - i,
                                         radius,
                                         color)
        
    else:
        for i in range(720):
            x = int(600 - 80 * math.sin(i * etc.knob1 / 10 + time.time()))
        
            radius = int(30 + math.sin(i * etc.knob2 / 10 + time.time()) * 30)
        
            color = (halfSies[0] + int(halfSies[0] * math.sin(i * .01 + time.time())),
                     halfSies[1] + int(halfSies[1] * math.sin(i * .015 + time.time())),
                     halfSies[2] + int(halfSies[2] * math.sin(i * .021 + time.time())))
            pygame.gfxdraw.filled_circle(screen,
                                         x,
                                         i,
                                         radius,
                                         color)