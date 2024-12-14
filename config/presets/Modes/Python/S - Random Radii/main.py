import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	linewidth = int (1+ (etc.knob4)*10)
 	etc.color_picker_bg(etc.knob5)
	xoffset=(640*etc.knob1)-320
	yoffset=(360*etc.knob2)-180
	X=int (640+xoffset)
	Y=int (360+yoffset)
   	for i in range(95):
		r = int (abs (100 * (etc.audio_in[(i+2)]/33000)))
		g = int (abs (100 * (etc.audio_in[(i+3)]/33000)))
		b = int (abs (100 * (etc.audio_in[(i+4)]/33000)))
		thecolor=pygame.Color(r,g,b)
		x2 = int (640 + (xoffset+etc.knob3*(etc.audio_in[(i)])/50))
		y2 = int (360 + (yoffset+etc.knob3*(etc.audio_in[(i+1)])/90))
		pygame.draw.line(screen, thecolor, (X,Y), (x2, y2), linewidth)