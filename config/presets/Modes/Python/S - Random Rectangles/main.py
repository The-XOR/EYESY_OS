import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	color = etc.color_picker(etc.knob4)
 	etc.color_picker_bg(etc.knob5)
	linewidth = int (1+ (etc.knob3)*10)
   	for i in range(64):
		x=(i%8)*160+(i//8)*(80*etc.knob1)+(40*(etc.audio_in[(i)]/33000))
		y=(i//8)*90+(i%8)*(45*etc.knob2)+(20*(etc.audio_in[(i+1)]/33000))
		x1=x+160+(40*(etc.audio_in[(i+2)]/33000))
		y1=y+(20*(etc.audio_in[(i+3)]/33000))
		x2=x1+(40*(etc.audio_in[(i+4)]/33000))
		y2=y1+90+(20*(etc.audio_in[(i+5)]/33000))
		x3=x+(40*(etc.audio_in[(i+6)]/33000))
		y3=y+90+(20*(etc.audio_in[(i+7)]/33000))
		pygame.draw.line(screen, color, (x,y), (x1, y1), linewidth)
		pygame.draw.line(screen, color, (x1,y1), (x2, y2), linewidth)
		pygame.draw.line(screen, color, (x2,y2), (x3, y3), linewidth)
		pygame.draw.line(screen, color, (x3,y3), (x, y), linewidth)