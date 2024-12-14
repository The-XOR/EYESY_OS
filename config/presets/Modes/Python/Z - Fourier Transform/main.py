import pygame
import random
from pygame.locals import *
import pygame.gfxdraw
import math
import glob
import os

#holds Images
images = []

# initializing pygame
pygame.font.init()
 
# check whether font is initialized
# or not
pygame.font.get_init()

#Global Vars
time = 0.0
time_step = 0.05
image_index = 0

circle_x = 250
circle_y = 250
sin_line_length = 100
circle_max_radius = 150
line_weight = 3
mem_depth = 300

num_iterations = 11

wave = []

w1 = 0
h1 = 0

def setup(screen, etc) :
    
    global circle_x, circle_y, images,w1,h1
    
    w1 = screen.get_width()
    h1 = screen.get_height()
    
    circle_x = w1/2
    circle_y = h1/2
    
    for filepath in sorted(glob.glob(etc.mode_root + '/Images/*.png')):
        filename = os.path.basename(filepath)
        #print 'loading image file: ' + filename
        img = pygame.image.load(filepath)
        images.append(img)

def draw(screen, etc) :
    
    global time,circle_x,circle_y, sin_line_length, wave,circle_max_radius,line_weight,mem_depth,num_iterations,w1,h1,image_index,time_step
    
    image_index = (int( (len(images)-1)  * etc.knob2) )
    
    #select Images
    image = images[image_index]
    
    #Set BG color  
    etc.color_picker_bg(etc.knob5)

    #get user input for Circle size and color
    circleColor =  etc.color_picker(etc.knob1)
    
    x = circle_x
    y = circle_y
    

    #image = pygame.transform.scale(image,(100, 100))
    #image_size_x=int(image.get_width())
    #image_size_y=int(image.get_height())
    
    i = 0
    while ( i < int((etc.knob4 *num_iterations))):
        n = i * 2 + 1        
        
        prev_x = x
        prev_y = y
        radius = etc.knob3*circle_max_radius * (4 / (n * math.pi))
        
        #Draw large Circle
        pygame.gfxdraw.filled_circle(screen,x,y,int(radius),circleColor)
        #pygame.gfxdraw.filled_circle(screen,x,y,int(radius-line_weight),bg_color)

        image = pygame.transform.scale(image,(int(radius*2.1), int(radius*2.1)))
        image_size_x=int(image.get_width())
        image_size_y=int(image.get_height())
        
        screen.blit(image,((x - (image_size_x/2)) ,(y- (image_size_y/2))))
        x += int(radius * math.cos(n * time)) #+ circle_x
        y += int(radius * math.sin(n * time)) #+ circle_y
        
        #add to wave
        wave.insert(0,y)
    
    
        #Draw Small Circle
        #pygame.gfxdraw.filled_circle(screen,x,y,5,etc.color_picker(etc.knob3))
        
        #draw radius line
        #pygame.gfxdraw.line(screen, prev_x + circle_x, prev_y + circle_y, x, y, etc.color_picker(0.1))


    #draw sine line
    #pygame.gfxdraw.hline(screen, x, circle_x + sin_line_length, y,  etc.color_picker(0.1))
    
    #draw sine wave
    #j=0
    #while (j< len(wave)):
        #pygame.gfxdraw.filled_circle(screen,j  + circle_x + sin_line_length ,wave[j],3,circleColor)
        #j+=1
        i += 1
        
    while len(wave) > (etc.knob4 * mem_depth):
        wave.pop()
    

    
    
    time -= time_step