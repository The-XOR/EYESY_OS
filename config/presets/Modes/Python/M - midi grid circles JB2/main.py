import os
import pygame


def setup(screen, etc) :
    pass

def draw(screen, etc) :
    etc.color_picker_bg(etc.knob5)
    
    for i in range(0, 8) :
        for j in range(0, 16) :
            x = ((j+1)*(1280/17))
            y = ((i+1)*(720/9))
            
            rad = 10
            if etc.midi_notes[j+(i*16)] :
                rad = 50
            color = etc.color_picker(etc.knob4)
            pygame.draw.circle(screen, color, [x, y], rad)