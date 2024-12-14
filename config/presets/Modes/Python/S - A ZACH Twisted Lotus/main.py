import pygame
import pygame.gfxdraw
import time
import math
from pygame.locals import *

bg_color = [25,25,25]

white=(255,255,255)
w1 = 0
h1 = 0

#Adapted from Zach Lieberman, and graphing in polar coordinates: http://willfs.com/visual/python/polar-coordinates/

def setup(screen, etc) :
    global w1,h1,CENTER_WIDTH,CENTER_HEIGHT
    w1 = screen.get_width()
    h1 = screen.get_height()
    CENTER_WIDTH = w1/2
    CENTER_HEIGHT = (h1)/2
    pass
# END PYGAME SETUP


#def draw_polar_coord(r, t, color, size, scale, screen, k, etc):
#   startx, starty = draw_polar_coord(x[i], y[i], color, radius4, 290,  screen, k, etc)
#    return x, y


def gen_numbers(start, end, n):
    x = []
    y = []
    for i in range(start, end):
        y.append(i)
        x.append(math.sin(i*n))
    return x, y


def draw(screen, etc):
    global CENTER_WIDTH,CENTER_HEIGHT
    n = 0.002  + etc.knob1
    # MAIN LOOP
    x, y = gen_numbers(1, 1000, n)
    k=int(((500 ))+((500 )) *(math.sin(time.time()*(.3+etc.knob2*1.8))))
    #k=1000
    etc.color_picker_bg(etc.knob5)
    for i in range(0, len(x)-1, 1):
        color = (int(127 + 120 * math.sin(i * .01 + time.time())),
                 int(127 + 120 * math.sin(i * (.01 + etc.knob5*.01) + time.time())),
                 int(127 + 120 * math.sin(i * (.01 + etc.knob5*.02)+ time.time())))
        r1= (abs(etc.audio_in[i%100]))
        radius_2 = int( 40  - 20 * math.sin(i * (etc.knob2 * .2)+.0001 + time.time()))
        radius2 = int((etc.knob2/4.5) * radius_2+(.3)*(r1/500))
        #radius2 = int((.4)*(r1/400))
        radius4=int(radius2+ (math.cos(i * ( .2) + time.time())))
        scale =350#290
        r=x[i]
        t=y[i]
        size=radius4
        coordx = r * math.cos(t) * scale
        coordy = r * math.sin(t) * scale
        if(k-((500*2)+30)*etc.knob4-5) <= i <= (k+((500*2)+30)*etc.knob4+5):
            pygame.gfxdraw.filled_circle(screen, int(CENTER_WIDTH + coordx), int(CENTER_HEIGHT + coordy), size, color)
            # pygame.draw.line(win, color, (CENTER_WIDTH + last_x, CENTER_HEIGHT + last_y), (CENTER_WIDTH + x, CENTER_HEIGHT + y))
    #Trails
    veil = pygame.Surface((1280,720))  
    veil.set_alpha(int(etc.knob3 * 50))
    veil.fill((etc.bg_color[0],etc.bg_color[1],etc.bg_color[2])) 
    screen.blit(veil, (0,0))
