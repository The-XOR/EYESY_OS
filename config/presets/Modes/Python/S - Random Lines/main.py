import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	color = etc.color_picker(etc.knob4)
	linewidth = int (1+ (etc.knob3)*10)
 	etc.color_picker_bg(etc.knob5)
	xoffset=(640*etc.knob1)-320
	yoffset=(360*etc.knob2)-180
   	for i in range(96):
		x1 = int (640 + (xoffset+(etc.audio_in[i])/50))
		y1 = int (360 + (yoffset+(etc.audio_in[(i+1)])/90))
		x2 = int (640 + (xoffset+(etc.audio_in[(i+2)])/50))
		y2 = int (360 + (yoffset+(etc.audio_in[(i+3)])/90))
		pygame.draw.line(screen, color, (x1,y1), (x2, y2), linewidth)