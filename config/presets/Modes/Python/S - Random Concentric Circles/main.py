import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	linewidth = int (1+(etc.knob4)*9)
 	etc.color_picker_bg(etc.knob5)
	xoffset=(640*etc.knob1)-320
	yoffset=(360*etc.knob2)-180
	for i in range(94):
		x = int (640 + xoffset+(etc.audio_in[i])/50)
		y = int (360 + yoffset+(etc.audio_in[(i+1)])/90)
		radius = int (11+(abs (etc.knob3 * (etc.audio_in[(i+2)])/90)))
		r = int (abs (100 * (etc.audio_in[(i+3)]/33000)))
		g = int (abs (100 * (etc.audio_in[(i+4)]/33000)))
		b = int (abs (100 * (etc.audio_in[(i+5)]/33000)))
		thecolor=pygame.Color(r,g,b)
		pygame.draw.circle(screen, thecolor, (x,y), radius, linewidth)