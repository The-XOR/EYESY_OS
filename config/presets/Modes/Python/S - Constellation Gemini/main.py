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
		AX=int (offset+400+(scale*(etc.audio_in[(i*7)]/33000)))
		AY=int (offset+110+(scale*(etc.audio_in[(i*7)+1]/33000)))
		BX=int (offset+540+(scale*(etc.audio_in[(i*7)+2]/33000)))
		BY=int (offset+170+(scale*(etc.audio_in[(i*7)+3]/33000)))
		CX=int (offset+660+(scale*(etc.audio_in[(i*7)+4]/33000)))
		CY=int (offset+70+(scale*(etc.audio_in[(i*7)+5]/33000)))
		DX=int (offset+700+(scale*(etc.audio_in[(i*7)+6]/33000)))
		DY=int (offset+310+(scale*(etc.audio_in[(i*7)+7]/33000)))
		EX=int (offset+840+(scale*(etc.audio_in[(i*7)+8]/33000)))
		EY=int (offset+390+(scale*(etc.audio_in[(i*7)+9]/33000)))
		FX=int (offset+880+(scale*(etc.audio_in[(i*7)+10]/33000)))
		FY=int (offset+390+(scale*(etc.audio_in[(i*7)+11]/33000)))
		GX=int (offset+960+(scale*(etc.audio_in[(i*7)+12]/33000)))
		GY=int (offset+370+(scale*(etc.audio_in[(i*7)+13]/33000)))
		HX=int (offset+800+(scale*(etc.audio_in[(i*7)+14]/33000)))
		HY=int (offset+450+(scale*(etc.audio_in[(i*7)+15]/33000)))
		IX=int (offset+440+(scale*(etc.audio_in[(i*7)+16]/33000)))
		IY=int (offset+230+(scale*(etc.audio_in[(i*7)+17]/33000)))
		JX=int (offset+320+(scale*(etc.audio_in[(i*7)+18]/33000)))
		JY=int (offset+230+(scale*(etc.audio_in[(i*7)+19]/33000)))
		KX=int (offset+380+(scale*(etc.audio_in[(i*7)+20]/33000)))
		KY=int (offset+250+(scale*(etc.audio_in[(i*7)+21]/33000)))
		LX=int (offset+320+(scale*(etc.audio_in[(i*7)+22]/33000)))
		LY=int (offset+310+(scale*(etc.audio_in[(i*7)+23]/33000)))
		MX=int (offset+460+(scale*(etc.audio_in[(i*7)+24]/33000)))
		MY=int (offset+390+(scale*(etc.audio_in[(i*7)+25]/33000)))
		NX=int (offset+580+(scale*(etc.audio_in[(i*7)+26]/33000)))
		NY=int (offset+430+(scale*(etc.audio_in[(i*7)+27]/33000)))
		OX=int (offset+740+(scale*(etc.audio_in[(i*7)+28]/33000)))
		OY=int (offset+550+(scale*(etc.audio_in[(i*7)+29]/33000)))
		PX=int (offset+480+(scale*(etc.audio_in[(i*7)+30]/33000)))
		PY=int (offset+550+(scale*(etc.audio_in[(i*7)+31]/33000)))
		QX=int (offset+700+(scale*(etc.audio_in[(i*7)+32]/33000)))
		QY=int (offset+650+(scale*(etc.audio_in[(i*7)+33]/33000)))
		r = r+rscale
		g = g+gscale
		b = b+bscale
		thecolor=pygame.Color(r,g,b)
		pygame.draw.line(screen, thecolor, (AX,AY), (BX, BY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (DX, DY), linewidth)
		pygame.draw.line(screen, thecolor, (DX,DY), (EX, EY), linewidth)
		pygame.draw.line(screen, thecolor, (EX,EY), (FX, FY), linewidth)
		pygame.draw.line(screen, thecolor, (FX,FY), (GX, GY), linewidth)
		pygame.draw.line(screen, thecolor, (DX,DY), (HX, HY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (IX, IY), linewidth)
		pygame.draw.line(screen, thecolor, (IX,IY), (KX, KY), linewidth)
		pygame.draw.line(screen, thecolor, (JX,JY), (KX, KY), linewidth)
		pygame.draw.line(screen, thecolor, (LX,LY), (KX, KY), linewidth)
		pygame.draw.line(screen, thecolor, (KX,KY), (MX, MY), linewidth)
		pygame.draw.line(screen, thecolor, (MX,MY), (NX, NY), linewidth)
		pygame.draw.line(screen, thecolor, (NX,NY), (OX, OY), linewidth)
		pygame.draw.line(screen, thecolor, (MX,MY), (PX, PY), linewidth)
		pygame.draw.line(screen, thecolor, (PX,PY), (QX, QY), linewidth)
