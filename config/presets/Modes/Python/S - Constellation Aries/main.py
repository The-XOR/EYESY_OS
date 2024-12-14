import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	linewidth = int (1+(etc.knob4)*10)
 	etc.color_picker_bg(etc.knob5)
	offset=(280*etc.knob1)-140
	scale=5+(140*(etc.knob3))
	r = int (abs (100 * (etc.audio_in[0]/33000)))
	g = int (abs (100 * (etc.audio_in[1]/33000)))
	b = int (abs (100 * (etc.audio_in[2]/33000)))
	if r>50:
		rscale=-5
	else:
		rscale=5
	if g>50:
		gscale=-5
	else:
		gscale=5
	if b>50:
		bscale=-5
	else:
		bscale=5
	j=int (1+(8*etc.knob2))
	for i in range(j):
		AX=int (offset+45+(scale*(etc.audio_in[(i*8)]/33000)))
		AY=int (offset+45+(scale*(etc.audio_in[(i*8)+1]/33000)))
		BX=int (offset+885+(scale*(etc.audio_in[(i*8)+2]/33000)))
		BY=int (offset+325+(scale*(etc.audio_in[(i*8)+3]/33000)))
		CX=int (offset+1165+(scale*(etc.audio_in[(i*8)+4]/33000)))
		CY=int (offset+535+(scale*(etc.audio_in[(i*8)+5]/33000)))
		DX=int (offset+1235+(scale*(etc.audio_in[(i*8)+6]/33000)))
		DY=int (offset+675+(scale*(etc.audio_in[(i*8)+7]/33000)))
		r = r+rscale
		g = g+gscale
		b = b+bscale
		thecolor=pygame.Color(r,g,b)
		pygame.draw.line(screen, thecolor, (AX,AY), (BX, BY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (DX, DY), linewidth)