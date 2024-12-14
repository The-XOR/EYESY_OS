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
	offset=(140*etc.knob1)-70
	scale=5+(50*(etc.knob3))
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
		AX=int (offset+500+(scale*(etc.audio_in[(i*8)]/33000)))
		AY=int (offset+70+(scale*(etc.audio_in[(i*8)+1]/33000)))
		BX=int (offset+460+(scale*(etc.audio_in[(i*8)+2]/33000)))
		BY=int (offset+110+(scale*(etc.audio_in[(i*8)+3]/33000)))
		CX=int (offset+500+(scale*(etc.audio_in[(i*8)+4]/33000)))
		CY=int (offset+170+(scale*(etc.audio_in[(i*8)+5]/33000)))
		DX=int (offset+380+(scale*(etc.audio_in[(i*8)+6]/33000)))
		DY=int (offset+350+(scale*(etc.audio_in[(i*8)+7]/33000)))
		EX=int (offset+320+(scale*(etc.audio_in[(i*8)+8]/33000)))
		EY=int (offset+450+(scale*(etc.audio_in[(i*8)+9]/33000)))
		FX=int (offset+220+(scale*(etc.audio_in[(i*8)+10]/33000)))
		FY=int (offset+590+(scale*(etc.audio_in[(i*8)+11]/33000)))
		GX=int (offset+320+(scale*(etc.audio_in[(i*8)+12]/33000)))
		GY=int (offset+550+(scale*(etc.audio_in[(i*8)+13]/33000)))
		HX=int (offset+520+(scale*(etc.audio_in[(i*8)+14]/33000)))
		HY=int (offset+510+(scale*(etc.audio_in[(i*8)+15]/33000)))
		IX=int (offset+620+(scale*(etc.audio_in[(i*8)+16]/33000)))
		IY=int (offset+510+(scale*(etc.audio_in[(i*8)+17]/33000)))
		JX=int (offset+840+(scale*(etc.audio_in[(i*8)+18]/33000)))
		JY=int (offset+530+(scale*(etc.audio_in[(i*8)+19]/33000)))
		KX=int (offset+940+(scale*(etc.audio_in[(i*8)+20]/33000)))
		KY=int (offset+550+(scale*(etc.audio_in[(i*8)+21]/33000)))
		LX=int (offset+1000+(scale*(etc.audio_in[(i*8)+22]/33000)))
		LY=int (offset+550+(scale*(etc.audio_in[(i*8)+23]/33000)))
		MX=int (offset+1060+(scale*(etc.audio_in[(i*8)+24]/33000)))
		MY=int (offset+590+(scale*(etc.audio_in[(i*8)+25]/33000)))
		NX=int (offset+1000+(scale*(etc.audio_in[(i*8)+26]/33000)))
		NY=int (offset+650+(scale*(etc.audio_in[(i*8)+27]/33000)))
		OX=int (offset+920+(scale*(etc.audio_in[(i*8)+28]/33000)))
		OY=int (offset+630+(scale*(etc.audio_in[(i*8)+29]/33000)))
		r = r+rscale
		g = g+gscale
		b = b+bscale
		thecolor=pygame.Color(r,g,b)
		pygame.draw.line(screen, thecolor, (AX,AY), (BX, BY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (AX,AY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (DX, DY), linewidth)
		pygame.draw.line(screen, thecolor, (DX,DY), (EX, EY), linewidth)
		pygame.draw.line(screen, thecolor, (EX,EY), (FX, FY), linewidth)
		pygame.draw.line(screen, thecolor, (FX,FY), (GX, GY), linewidth)
		pygame.draw.line(screen, thecolor, (GX,GY), (HX, HY), linewidth)
		pygame.draw.line(screen, thecolor, (HX,HY), (IX, IY), linewidth)
		pygame.draw.line(screen, thecolor, (IX,IY), (JX, JY), linewidth)
		pygame.draw.line(screen, thecolor, (JX,JY), (KX, KY), linewidth)
		pygame.draw.line(screen, thecolor, (KX,KY), (LX, LY), linewidth)
		pygame.draw.line(screen, thecolor, (LX,LY), (MX, MY), linewidth)
		pygame.draw.line(screen, thecolor, (MX,MY), (NX, NY), linewidth)
		pygame.draw.line(screen, thecolor, (NX,NY), (OX, OY), linewidth)
		pygame.draw.line(screen, thecolor, (OX,OY), (KX, KY), linewidth)
