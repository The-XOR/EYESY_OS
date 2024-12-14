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
	offset=(230*etc.knob1)-115
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
		AX=int (offset+820+(scale*(etc.audio_in[(i*9)]/33000)))
		AY=int (offset+125+(scale*(etc.audio_in[(i*9)+1]/33000)))
		BX=int (offset+670+(scale*(etc.audio_in[(i*9)+2]/33000)))
		BY=int (offset+215+(scale*(etc.audio_in[(i*9)+3]/33000)))
		CX=int (offset+520+(scale*(etc.audio_in[(i*9)+4]/33000)))
		CY=int (offset+315+(scale*(etc.audio_in[(i*9)+5]/33000)))
		DX=int (offset+640+(scale*(etc.audio_in[(i*9)+6]/33000)))
		DY=int (offset+375+(scale*(etc.audio_in[(i*9)+7]/33000)))
		EX=int (offset+730+(scale*(etc.audio_in[(i*9)+8]/33000)))
		EY=int (offset+375+(scale*(etc.audio_in[(i*9)+9]/33000)))
		FX=int (offset+510+(scale*(etc.audio_in[(i*9)+10]/33000)))
		FY=int (offset+395+(scale*(etc.audio_in[(i*9)+11]/33000)))
		GX=int (offset+470+(scale*(etc.audio_in[(i*9)+12]/33000)))
		GY=int (offset+405+(scale*(etc.audio_in[(i*9)+13]/33000)))
		HX=int (offset+460+(scale*(etc.audio_in[(i*9)+14]/33000)))
		HY=int (offset+455+(scale*(etc.audio_in[(i*9)+15]/33000)))
		IX=int (offset+570+(scale*(etc.audio_in[(i*9)+16]/33000)))
		IY=int (offset+605+(scale*(etc.audio_in[(i*9)+17]/33000)))
		JX=int (offset+600+(scale*(etc.audio_in[(i*9)+18]/33000)))
		JY=int (offset+525+(scale*(etc.audio_in[(i*9)+19]/33000)))
		KX=int (offset+690+(scale*(etc.audio_in[(i*9)+20]/33000)))
		KY=int (offset+515+(scale*(etc.audio_in[(i*9)+21]/33000)))
		LX=int (offset+770+(scale*(etc.audio_in[(i*9)+22]/33000)))
		LY=int (offset+585+(scale*(etc.audio_in[(i*9)+23]/33000)))
		r = r+rscale
		g = g+gscale
		b = b+bscale
		thecolor=pygame.Color(r,g,b)
		pygame.draw.line(screen, thecolor, (AX,AY), (BX, BY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (DX, DY), linewidth)
		pygame.draw.line(screen, thecolor, (DX,DY), (EX, EY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (FX, FY), linewidth)
		pygame.draw.line(screen, thecolor, (FX,FY), (GX, GY), linewidth)
		pygame.draw.line(screen, thecolor, (GX,GY), (HX, HY), linewidth)
		pygame.draw.line(screen, thecolor, (HX,HY), (IX, IY), linewidth)
		pygame.draw.line(screen, thecolor, (IX,IY), (JX, JY), linewidth)
		pygame.draw.line(screen, thecolor, (JX,JY), (KX, KY), linewidth)
		pygame.draw.line(screen, thecolor, (KX,KY), (LX, LY), linewidth)
