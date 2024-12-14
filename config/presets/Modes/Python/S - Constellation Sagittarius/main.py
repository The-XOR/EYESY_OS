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
	offset=(180*etc.knob1)-90
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
		AX=int (offset+530+(scale*(etc.audio_in[(i*7)]/33000)))
		AY=int (offset+90+(scale*(etc.audio_in[(i*7)+1]/33000)))
		BX=int (offset+550+(scale*(etc.audio_in[(i*7)+2]/33000)))
		BY=int (offset+120+(scale*(etc.audio_in[(i*7)+3]/33000)))
		CX=int (offset+610+(scale*(etc.audio_in[(i*7)+4]/33000)))
		CY=int (offset+190+(scale*(etc.audio_in[(i*7)+5]/33000)))
		DX=int (offset+650+(scale*(etc.audio_in[(i*7)+6]/33000)))
		DY=int (offset+170+(scale*(etc.audio_in[(i*7)+7]/33000)))
		EX=int (offset+660+(scale*(etc.audio_in[(i*7)+8]/33000)))
		EY=int (offset+280+(scale*(etc.audio_in[(i*7)+9]/33000)))
		FX=int (offset+700+(scale*(etc.audio_in[(i*7)+10]/33000)))
		FY=int (offset+300+(scale*(etc.audio_in[(i*7)+11]/33000)))
		GX=int (offset+770+(scale*(etc.audio_in[(i*7)+12]/33000)))
		GY=int (offset+280+(scale*(etc.audio_in[(i*7)+13]/33000)))
		HX=int (offset+850+(scale*(etc.audio_in[(i*7)+14]/33000)))
		HY=int (offset+200+(scale*(etc.audio_in[(i*7)+15]/33000)))
		IX=int (offset+800+(scale*(etc.audio_in[(i*7)+16]/33000)))
		IY=int (offset+370+(scale*(etc.audio_in[(i*7)+17]/33000)))
		JX=int (offset+850+(scale*(etc.audio_in[(i*7)+18]/33000)))
		JY=int (offset+390+(scale*(etc.audio_in[(i*7)+19]/33000)))
		KX=int (offset+940+(scale*(etc.audio_in[(i*7)+20]/33000)))
		KY=int (offset+350+(scale*(etc.audio_in[(i*7)+21]/33000)))
		LX=int (offset+780+(scale*(etc.audio_in[(i*7)+22]/33000)))
		LY=int (offset+450+(scale*(etc.audio_in[(i*7)+23]/33000)))
		MX=int (offset+790+(scale*(etc.audio_in[(i*7)+24]/33000)))
		MY=int (offset+500+(scale*(etc.audio_in[(i*7)+25]/33000)))
		NX=int (offset+630+(scale*(etc.audio_in[(i*7)+26]/33000)))
		NY=int (offset+360+(scale*(etc.audio_in[(i*7)+27]/33000)))
		OX=int (offset+610+(scale*(etc.audio_in[(i*7)+28]/33000)))
		OY=int (offset+310+(scale*(etc.audio_in[(i*7)+29]/33000)))
		PX=int (offset+470+(scale*(etc.audio_in[(i*7)+30]/33000)))
		PY=int (offset+250+(scale*(etc.audio_in[(i*7)+31]/33000)))
		QX=int (offset+340+(scale*(etc.audio_in[(i*7)+32]/33000)))
		QY=int (offset+320+(scale*(etc.audio_in[(i*7)+33]/33000)))
		RX=int (offset+430+(scale*(etc.audio_in[(i*7)+34]/33000)))
		RY=int (offset+600+(scale*(etc.audio_in[(i*7)+35]/33000)))
		SX=int (offset+550+(scale*(etc.audio_in[(i*7)+36]/33000)))
		SY=int (offset+560+(scale*(etc.audio_in[(i*7)+37]/33000)))
		TX=int (offset+560+(scale*(etc.audio_in[(i*7)+38]/33000)))
		TY=int (offset+630+(scale*(etc.audio_in[(i*7)+39]/33000)))
		r = r+rscale
		g = g+gscale
		b = b+bscale
		thecolor=pygame.Color(r,g,b)
		pygame.draw.line(screen, thecolor, (AX,AY), (BX, BY), linewidth)
		pygame.draw.line(screen, thecolor, (BX,BY), (CX, CY), linewidth)
		pygame.draw.line(screen, thecolor, (CX,CY), (DX, DY), linewidth)
		pygame.draw.line(screen, thecolor, (DX,DY), (EX, EY), linewidth)
		pygame.draw.line(screen, thecolor, (EX,EY), (FX, FY), linewidth)
		pygame.draw.line(screen, thecolor, (FX,FY), (GX, GY), linewidth)
		pygame.draw.line(screen, thecolor, (GX,GY), (HX, HY), linewidth)
		pygame.draw.line(screen, thecolor, (GX,GY), (IX, IY), linewidth)
		pygame.draw.line(screen, thecolor, (IX,IY), (JX, JY), linewidth)
		pygame.draw.line(screen, thecolor, (JX,JY), (KX, KY), linewidth)
		pygame.draw.line(screen, thecolor, (JX,JY), (LX, LY), linewidth)
		pygame.draw.line(screen, thecolor, (IX,IY), (LX, LY), linewidth)
		pygame.draw.line(screen, thecolor, (LX,LY), (MX, MY), linewidth)
		pygame.draw.line(screen, thecolor, (LX,LY), (NX, NY), linewidth)
		pygame.draw.line(screen, thecolor, (FX,FY), (NX, NY), linewidth)
		pygame.draw.line(screen, thecolor, (NX,NY), (OX, OY), linewidth)
		pygame.draw.line(screen, thecolor, (EX,EY), (OX, OY), linewidth)
		pygame.draw.line(screen, thecolor, (OX,OY), (PX, PY), linewidth)
		pygame.draw.line(screen, thecolor, (PX,PY), (QX, QY), linewidth)
		pygame.draw.line(screen, thecolor, (QX,QY), (RX, RY), linewidth)
		pygame.draw.line(screen, thecolor, (RX,RY), (SX, SY), linewidth)
		pygame.draw.line(screen, thecolor, (RX,RY), (TX, TY), linewidth)
