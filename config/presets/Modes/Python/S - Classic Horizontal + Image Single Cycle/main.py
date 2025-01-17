import os
import pygame
import time
import random
import glob

last_point = [0, 360]
i = 0

images = []
image_index = 0
counter =0

def setup(screen, etc):
    global images
    for filepath in sorted(glob.glob(etc.mode_root + '/Images/*.png')):
        filename = os.path.basename(filepath)
        print 'loading image file: ' + filename
        img = pygame.image.load(filepath).convert_alpha()
        images.append(img)

def draw(screen, etc):
    global last_point, images, i, image_index, counter
    
    etc.color_picker_bg(etc.knob5)  
    xoffset = 0
    y1 = int(etc.knob2 * 720) + (etc.audio_in[i] / 35)
    x = i * 13
    color = etc.color_picker(etc.knob4)
    max_circle = 400
    image_size = 1
    circle_size = 0
    line_width = 0
    if etc.knob3 <=.5 :
        circle_size = int(etc.knob3 * max_circle)
        line_width = 0
    if etc.knob3 >.501 :
        circle_size = abs(max_circle-int(etc.knob3 * max_circle)) 
        line_width =  abs(30-int(etc.knob3 * 30))

    pygame.draw.circle(screen,color,(x + xoffset, y1), circle_size, line_width)
    
    last_point = [x + xoffset, y1]
    
    image = images[image_index]
    image = pygame.transform.scale(image, (int(image.get_width() * image_size), int(image.get_height() * image_size)) )
    screen.blit(image, (x + xoffset, y1))
    
    i = (i + 1)
    counter += 1
   
    if i >= 100 :
        i = 0
        
    if counter >= int(etc.knob1 * 99) :
        image_index += 1 
        image_index = image_index % len(images)
        counter = 0
    
    