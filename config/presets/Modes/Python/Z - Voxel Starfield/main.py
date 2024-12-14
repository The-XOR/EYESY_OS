import pygame as pg
import random
import math

vec2, vec3 = pg.math.Vector2, pg.math.Vector3

RES = WIDTH, HEIGHT = 1280, 720
NUM_STARS = 500
CENTER = vec2(WIDTH // 2, HEIGHT // 2)


#Initializing variables
#RGB    =     R     G      B
red     =   (255,   0,      0)
green   =   (0,     255,    0)
blue    =   (0,     0,    255)
orange   =   (255, 165, 0)
purple   =   (160,     32,      240)
cyan   =   (0,     255,      255)
 
 
orangered = (255, 69, 0)
darkorange =	(255,	140,	0)
coral =	(255,	127,	80)	
sandybrown =	(244,	164,	96)	
seashell =	(255,	245,	238)	
palegoldenrod =	(238,	232,	170)	
lightcyan =	(224,	255,	255)	
honeydew =	(240,	255,	240)	
lightsteelblue =	(176,	196,	222)
cornflowerblue =	(100,	149,	237)
royalblue =	(65,	105,	225)
powderblue =	(176,	224,	230)


slategrey =	(112,	128,	144)
black =	(0,	0,	0)
white =	(255,	255,	255)
gainsboro =	(220,	220,	220)
dimgrey =	(105,	105,	105)
silver =	(192,	192,	192)
grey =	(190,	190,	190)
whitesmoke =	(245,	245,	245)


firebrick=	(178,	34,	34)
crimson=	(220,	20,	60)
indianred=	(205,	92,	92)
tomato=	(255,	99,	71)
darkred=	(139,	0,	0)
palevioletred=	(219,	112,	147)
fuchsia=	(255,	0,	255)
orchid= (218,	112,	214)
salmon=	(250,	128,	114)
maroon= (176,	48,	96)


yellow=	(255,	255,	0)
gold=	(255,	215,	0)
orange=	(255,	165,	0)
lemonchiffon=	(255,	250,	205)
greenyellow=	(173,	255,	47)
moccasin=	(255,	228,	181)


mediumspringgreen=	(0,	250,	154)
palegreen=	(152,	251,	152)
chartreuse=	(127,	255,	0)
lime=	(0,	255,	0)
aqua=	(0,	255,	255)
darkturquoise=	(0,	206,	209)
deepskyblue=	(0,	191,	255)
dodgerblue=	(30,	144,	255)
blue=	(0,	0,	255)
indigo=	(75,	0,	130)
mediumblue=	(0,	0,	205)
slateblue=	(106,	90,	205)

COLORS1 = [red, green, blue, orange, purple, cyan]
COLORS2 = [orangered, darkorange, coral, sandybrown, seashell, palegoldenrod, lightcyan, honeydew, lightsteelblue, cornflowerblue, royalblue, powderblue]
COLORS3 = [slategrey, black, white, gainsboro, dimgrey, silver, grey, whitesmoke]
COLORS4 = [red, firebrick, crimson, indianred, tomato, darkred, palevioletred, fuchsia, orchid, salmon, maroon]
COLORS5 = [yellow, gold, orange, lemonchiffon, greenyellow, moccasin]
COLORS6 = [mediumspringgreen, palegreen, chartreuse, lime, aqua, darkturquoise, deepskyblue, dodgerblue, blue, indigo, mediumblue, slateblue]
COLORS7 = [mediumspringgreen, palegreen, chartreuse, lime, aqua, darkturquoise, deepskyblue, dodgerblue, blue, indigo, mediumblue, slateblue, red, firebrick, crimson, indianred, tomato, darkred, palevioletred, fuchsia, orchid, salmon, maroon]
COLORS = COLORS7



# Z_DISTANCE = 40
ALPHA = 120
Z_DISTANCE = 140
# ALPHA = 30
SPINFACTOR = .2
PITCH = 0
YAW = 0
SPEEDFACTOR = 2
SOUND_IND = 0


def lerp(a, b, weight):
    return (weight * a) + ((1 - weight) * b)

def get_Color(name):
    color_list = [(v) for c, v in pg.color.THECOLORS.items() if name == c]
    return color_list[0]


class Star:
    def __init__(self, screen):
        global SOUND_IND
        self.screen = screen
        self.pos3d = self.get_pos3d()
        # self.vel = random.uniform(0.05, 0.25)
        self.vel = random.uniform(SPEEDFACTOR / 4, SPEEDFACTOR)
        self.color_ind = random.randint(0, len(COLORS))
        self.sound_ind = SOUND_IND
        self.screen_pos = vec2(0, 0)
        self.size = 10
        SOUND_IND += 1

    def get_pos3d(self, scale_pos=35):
        angle = random.uniform(0, 2 * math.pi)
        radius = random.randrange(HEIGHT // scale_pos, HEIGHT) * scale_pos
        if scale_pos > 130:
            radius = 5000
        # radius = random.randrange(HEIGHT // 4, HEIGHT//3) * scale_pos

        x = radius * math.cos(angle)
        y = radius * math.sin(angle)
        return vec3(x, y, Z_DISTANCE)

    def update(self, knob2, knob3):
        self.pos3d.z -= self.vel * knob2
        self.pos3d = self.get_pos3d(100 * knob3 + 32) if self.pos3d.z < 1 else self.pos3d

        self.screen_pos = vec2(self.pos3d.x, self.pos3d.y) / self.pos3d.z + CENTER
        self.size = (Z_DISTANCE - self.pos3d.z) / (0.2 * self.pos3d.z)
        # rotate xy
        self.pos3d = self.pos3d.rotate_z(SPINFACTOR)
        # lookAround
        # pov = CENTER - vec2(PITCH,YAW)
        # self.screen_pos += pov

    def draw(self, audioIn):
        s = self.size
        audio_size=(audioIn[self.sound_ind % 100]) / 1500
        if (audio_size < 2):
            audio_size=0
        if (-s < self.screen_pos.x < WIDTH + s) and (-s < self.screen_pos.y < HEIGHT + s):
            pg.draw.rect(self.screen, COLORS[self.color_ind % len(COLORS)], (self.screen_pos.x, self.screen_pos.y, self.size+audio_size, self.size+audio_size))


class Starfield:
    def __init__(self, screen):
        global SOUND_IND
        SOUND_IND = 0
        self.stars = [Star(screen) for i in range(NUM_STARS)]

    def run(self, knob2, knob3, audioIn):
        [star.update(knob2, knob3) for star in self.stars]
        self.stars.sort(key=lambda star: star.pos3d.z, reverse=True)
        [star.draw(audioIn) for star in self.stars]


def setup(screen, etc):
    global RES, WIDTH, HEIGHT, CENTER, SOUND_IND
    SOUND_IND = 0
    RES = WIDTH, HEIGHT = screen.get_width(), screen.get_height()
    CENTER = vec2(WIDTH // 2, HEIGHT // 2)
    #screen = pg.display.set_mode(RES)
    #etc.alpha_surface = pg.Surface(RES)
    #etc.alpha_surface.set_alpha(ALPHA)
    etc.starfield = Starfield(screen)


def draw(screen, etc):
    global Z_DISTANCE, ALPHA, SPINFACTOR, PITCH, YAW, SPEEDFACTOR, COLORS
    SPINFACTOR = -3 + etc.knob1 * 6
    if(etc.knob1 == 0):
        SPINFACTOR = 0
    SPEEDFACTOR = -1 + etc.knob2 * 2
    # PITCH = 1000* etc.knob2
    # YAW = 1000 * etc.knob3
    Z_DISTANCE = 150 * etc.knob5 + 20
    color_choice = int(etc.knob4 * 8)
    if color_choice == 0:
        COLORS = COLORS1
    elif color_choice == 1:
        COLORS = COLORS2
    elif color_choice == 2:
        COLORS = COLORS3
    elif color_choice == 3:
        COLORS = COLORS4
    elif color_choice == 4:
        COLORS = COLORS5
    elif color_choice == 5:
        COLORS = COLORS6
    elif color_choice >= 6:
        COLORS = COLORS7
    etc.starfield.run(etc.knob2, etc.knob3, etc.audio_in)
