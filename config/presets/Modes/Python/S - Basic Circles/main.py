import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	size = (int (abs (etc.audio_in[0])/100))
	size2 = (int (size/2))
	position = (640, 360)
	color = etc.color_picker(etc.knob4)
	color2 = etc.color_picker(etc.knob5)
	X=(int (320+(640*etc.knob2)))
	X2=(int (X+160-(310*etc.knob1)))
	Y=(int (180+(360*etc.knob3)))
	Y2=(int (Y+90-(180*etc.knob1)))
	etc.color_picker_bg(etc.knob5)  
	pygame.draw.circle(screen, color, (X,Y), size, 0)
	pygame.draw.circle(screen, color2, (X2,Y2), size2, 0)