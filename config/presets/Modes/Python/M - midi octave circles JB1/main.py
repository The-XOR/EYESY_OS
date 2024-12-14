import os
import pygame


def setup(screen, etc) :
    pass

def draw(screen, etc) :
    etc.color_picker_bg(etc.knob5)
    
    for i in range(0, 10) :
        for j in range(0, 12) :
            x = ((j+1)*(1280/13))
            y = 360#((i+1)*(720/12))
            
            rad = 10
            if etc.midi_notes[j+(i*12)] :
                rad = 650-i*50
            color = etc.color_picker(etc.knob4)
            pygame.draw.rect(screen, color, (x, y-rad/2,80,rad))