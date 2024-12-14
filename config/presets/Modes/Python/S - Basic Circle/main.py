import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	size = (int (abs (etc.audio_in[0])/50))
	position = (510, 500)
	color = etc.color_picker(etc.knob4)
	etc.color_picker_bg(etc.knob5)  
	pygame.draw.circle(screen, color, position, size, 0)