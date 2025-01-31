import os
import pygame
import time
import random
import math

def setup(screen, etc):
    pass

def draw(screen, etc):
	ORlinewidth = int (1+(etc.knob1)*10)
	GRlinewidth = int (1+(etc.knob2)*10)
	RElinewidth = int (1+(etc.knob3)*10)
	SIlinewidth = int (1+(etc.knob4)*10)
	etc.color_picker_bg(etc.knob5)
	ORscale=(55-(50*(etc.knob1)))
	GRscale=(55-(50*(etc.knob2)))
	REscale=(55-(50*(etc.knob3)))
	SIscale=(55-(50*(etc.knob4)))
	theorange=int (40+(20*(etc.knob1)))
	orangecolor=pygame.Color(99,theorange,0)
	thegreen=int (79+(20*(etc.knob2)))
	greencolor=pygame.Color(0,thegreen,0)
	thered=int (79+(20*(etc.knob3)))
	redcolor=pygame.Color(thered,0,0)
	theblue=int (80+(20*(etc.knob2)))
	bluecolor=pygame.Color(0,0,theblue)
	thesilver=int (46+(20*(etc.knob4)))
	silvercolor=pygame.Color(50,53,thesilver)
	j=int (9-(1+(7*etc.knob1)))
	for i in range(j):
		AX=int (340+(ORscale*(etc.audio_in[(i*11)]/33000)))
		AY=int (480+(ORscale*(etc.audio_in[(i*11)+1]/33000)))
		BX=int (800+(ORscale*(etc.audio_in[(i*11)+2]/33000)))
		BY=int (0+(ORscale*(etc.audio_in[(i*11)+3]/33000)))
		pygame.draw.line(screen, orangecolor, (AX,AY), (BX, BY), ORlinewidth)
	j=int (9-(1+(7*etc.knob2)))
	for i in range(j):
		CX=int (0+(GRscale*(etc.audio_in[(i*10)]/33000)))
		CY=int (160+(GRscale*(etc.audio_in[(i*10)+1]/33000)))
		DX=int (180+(GRscale*(etc.audio_in[(i*10)+2]/33000)))
		DY=int (0+(GRscale*(etc.audio_in[(i*10)+3]/33000)))
		EX=int (80+(GRscale*(etc.audio_in[(i*10)+4]/33000)))
		EY=int (300+(GRscale*(etc.audio_in[(i*10)+5]/33000)))
		FX=int (400+(GRscale*(etc.audio_in[(i*10)+6]/33000)))
		FY=int (0+(GRscale*(etc.audio_in[(i*10)+7]/33000)))
		GX=int (320+(GRscale*(etc.audio_in[(i*10)+8]/33000)))
		GY=int (300+(GRscale*(etc.audio_in[(i*10)+9]/33000)))
		HX=int (500+(GRscale*(etc.audio_in[(i*10)+10]/33000)))
		HY=int (120+(GRscale*(etc.audio_in[(i*10)+11]/33000)))
		IX=int (500+(GRscale*(etc.audio_in[(i*10)+12]/33000)))
		IY=int (0+(GRscale*(etc.audio_in[(i*10)+13]/33000)))
		pygame.draw.line(screen, greencolor, (CX,CY), (DX, DY), GRlinewidth)
		pygame.draw.line(screen, greencolor, (EX,EY), (FX, FY), GRlinewidth)
		pygame.draw.line(screen, greencolor, (GX,GY), (HX, HY), GRlinewidth)
		pygame.draw.line(screen, greencolor, (HX,HY), (IX, IY), GRlinewidth)
	j=int (9-(1+7*(etc.knob3)))
	for i in range(j):
		JX=int (840+(REscale*(etc.audio_in[(i*10)]/33000)))
		JY=int (0+(REscale*(etc.audio_in[(i*10)+1]/33000)))
		KX=int (920+(REscale*(etc.audio_in[(i*10)+2]/33000)))
		KY=int (100+(REscale*(etc.audio_in[(i*10)+3]/33000)))
		LX=int (920+(REscale*(etc.audio_in[(i*10)+4]/33000)))
		LY=int (380+(REscale*(etc.audio_in[(i*10)+5]/33000)))
		MX=int (860+(REscale*(etc.audio_in[(i*10)+6]/33000)))
		MY=int (440+(REscale*(etc.audio_in[(i*10)+7]/33000)))
		NX=int (860+(REscale*(etc.audio_in[(i*10)+8]/33000)))
		NY=int (620+(REscale*(etc.audio_in[(i*10)+9]/33000)))
		OX=int (680+(REscale*(etc.audio_in[(i*10)+10]/33000)))
		OY=int (620+(REscale*(etc.audio_in[(i*10)+11]/33000)))
		PX=int (1140+(REscale*(etc.audio_in[(i*10)+12]/33000)))
		PY=int (600+(REscale*(etc.audio_in[(i*10)+13]/33000)))
		QX=int (1140+(REscale*(etc.audio_in[(i*10)+14]/33000)))
		QY=int (660+(REscale*(etc.audio_in[(i*10)+15]/33000)))
		pygame.draw.line(screen, redcolor, (JX,JY), (KX, KY), RElinewidth)
		pygame.draw.line(screen, redcolor, (KX,KY), (LX, LY), RElinewidth)
		pygame.draw.line(screen, redcolor, (LX,LY), (MX, MY), RElinewidth)
		pygame.draw.line(screen, redcolor, (MX,MY), (NX, NY), RElinewidth)
		pygame.draw.line(screen, redcolor, (NX,NY), (OX, OY), RElinewidth)
		pygame.draw.line(screen, redcolor, (LX,LY), (PX, PY), RElinewidth)
		pygame.draw.line(screen, redcolor, (PX,PY), (QX, QY), RElinewidth)
	j=int (9-(1+(7*etc.knob4)))
	for i in range(j):
		RX=int (680+(SIscale*(etc.audio_in[(i*9)+2]/33000)))
		RY=int (360+(SIscale*(etc.audio_in[(i*9)+3]/33000)))
		SX=int (680+(SIscale*(etc.audio_in[(i*9)+4]/33000)))
		SY=int (120+(SIscale*(etc.audio_in[(i*9)+5]/33000)))
		TX=int (680+(SIscale*(etc.audio_in[(i*9)+6]/33000)))
		TY=int (60+(SIscale*(etc.audio_in[(i*9)+7]/33000)))
		UX=int (820+(SIscale*(etc.audio_in[(i*9)+8]/33000)))
		UY=int (60+(SIscale*(etc.audio_in[(i*9)+9]/33000)))
		VX=int (880+(SIscale*(etc.audio_in[(i*9)+10]/33000)))
		VY=int (60+(SIscale*(etc.audio_in[(i*9)+11]/33000)))
		WX=int (1000+(SIscale*(etc.audio_in[(i*9)+12]/33000)))
		WY=int (60+(SIscale*(etc.audio_in[(i*9)+13]/33000)))
		XX=int (1060+(SIscale*(etc.audio_in[(i*9)+14]/33000)))
		XY=int (0+(SIscale*(etc.audio_in[(i*9)+15]/33000)))
		YX=int (820+(SIscale*(etc.audio_in[(i*9)+16]/33000)))
		YY=int (120+(SIscale*(etc.audio_in[(i*9)+17]/33000)))
		ZX=int (820+(SIscale*(etc.audio_in[(i*9)+18]/33000)))
		ZY=int (0+(SIscale*(etc.audio_in[(i*9)+19]/33000)))
		pygame.draw.line(screen, silvercolor, (RX,RY), (SX, SY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (SX,SY), (TX, TY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (TX,TY), (UX, UY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (UX,UY), (VX, VY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (VX,VY), (WX, WY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (WX,WY), (XX, XY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (SX,SY), (YX, YY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (YX,YY), (VX, VY), SIlinewidth)
		pygame.draw.line(screen, silvercolor, (UX,UY), (ZX, ZY), SIlinewidth)


