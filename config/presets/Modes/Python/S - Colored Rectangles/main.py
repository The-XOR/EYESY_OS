import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
 	etc.color_picker_bg(etc.knob5)
   	for i in range(64):
		x=(i%8)*160+(i//8)*(80*etc.knob1)
		y=(i//8)*90+(i%8)*(45*etc.knob2)
		thewidth=int (abs (160 * (etc.knob3) * (etc.audio_in[(i)]/33000)))
		theheight=int (abs (90 * (etc.knob4) * (etc.audio_in[(i+1)]/33000)))
		therectangle=pygame.Rect(x,y,thewidth,theheight)
		r = int (abs (100 * (etc.audio_in[(i+2)]/33000)))
		g = int (abs (100 * (etc.audio_in[(i+3)]/33000)))
		b = int (abs (100 * (etc.audio_in[(i+4)]/33000)))
		thecolor=pygame.Color(r,g,b)
		pygame.draw.rect(screen, thecolor, therectangle, 0)