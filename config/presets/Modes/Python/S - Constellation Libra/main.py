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
	offset=(80*etc.knob1)-40
	scale=5+(40*(etc.knob3))
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
		AX=int (offset+490+(scale*(etc.audio_in[(i*10)]/33000)))
		AY=int (offset+620+(scale*(etc.audio_in[(i*10)+1]/33000)))
		BX=int (offset+510+(scale*(etc.audio_in[(i*10)+2]/33000)))
		BY=int (offset+560+(scale*(etc.audio_in[(i*10)+3]/33000)))
		CX=int (offset+490+(scale*(etc.audio_in[(i*10)+4]/33000)))
		CY=int (offset+200+(scale*(etc.audio_in[(i*10)+5]/33000)))
		DX=int (offset+630+(scale*(etc.audio_in[(i*10)+6]/33000)))
		DY=int (offset+40+(scale*(etc.audio_in[(i*10)+7]/33000)))
		EX=int (offset+790+(scale*(etc.audio_in[(i*10)+8]/33000)))
		EY=int (offset+220+(scale*(etc.audio_in[(i*10)+9]/33000)))
		FX=int (offset+710+(scale*(etc.audio_in[(i*10)+10]/33000)))
		FY=int (offset+480+(scale*(etc.audio_in[(i*10)+11]/33000)))
		r = r+rscale
		g = g+gscale
		b = b+bscale
		thecolor=pygame.Color(r,g,b)
		pygame.draw.line(screen, thecolor, (AX,AY), (BX, BY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (DX, DY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (EX, EY), linewidth)
		pygame.draw.line(screen, thecolor, (DX,DY), (EX, EY), linewidth)
		pygame.draw.line(screen, thecolor, (EX,EY), (FX, FY), linewidth)
