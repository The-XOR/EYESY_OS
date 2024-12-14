import pygame
import math
import time
import random

# Define constants
SCREEN_WIDTH = 1290#1280
SCREEN_HEIGHT = 720

# Initialize Pygame
pygame.init()

# Setup function
def setup(screen, etc):
    # Initialize global variables
    global last_screen, r, g, b, counter
    last_screen = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
    r, g, b = 0, 0, 0
    counter = 0

# Draw function
def draw(screen, etc):
    # Global variables
    global last_screen, r, g, b, counter
    
    # Color picker background
    etc.color_picker_bg(etc.knob5)
    
    # Screen grab feedback loop
    image = last_screen
    last_screen = screen.copy()
    thing = pygame.transform.scale(image, (SCREEN_WIDTH, SCREEN_HEIGHT))
    screen.blit(thing, (0, 100*(-.5+etc.knob2))) 

    # Color shift loop
    if etc.knob4 < 1:
        counter += 1
        if counter > int(etc.knob4 * 75):
            r, g, b = random.randrange(0, 254), random.randrange(0, 254), random.randrange(0, 254)
            counter = 0
    
    colorshift = 20 - int(etc.knob4 * 20)
    r = (r + colorshift) % 255
    g = (g + colorshift) % 255
    b = (b + colorshift) % 255
    color = (r, g, b)
    
    # Set teeth number and shape
    teeth = int(etc.knob1 * 90+ 30)
    teethwidth = int(SCREEN_WIDTH - 15 * teeth)
    
    clench = 60 - teethwidth / 2
    if(etc.knob1 == 1):
        clench=0

    
    # Calculate y-offset
    y_offset =int(SCREEN_HEIGHT / 2) #int(SCREEN_HEIGHT / 3) * 2  # Move center down by 2/3 of the screen height
    
    # Draw waveform
    num_samples = len(etc.audio_in)
    num_segments = num_samples - 1
    segment_width = SCREEN_WIDTH / num_segments
    
    # Start drawing from the top
    y0_top = y_offset - int(SCREEN_HEIGHT / 6)
    y0_bottom = y_offset + int(SCREEN_HEIGHT / 6)
    x = 0
    
    for i in range(num_samples):
        # Calculate y-coordinate based on audio input and clench value
        y1_top = y_offset - int(abs(etc.audio_in[i] / 85) + clench)
        y1_bottom = y_offset + int(abs(etc.audio_in[i] / 85) + clench)
        
        # Draw line segments for top and bottom lines
        pygame.draw.line(screen, color, [int(x), y0_top], [int(x + segment_width), y1_top], 1)
        pygame.draw.line(screen, color, [int(x), y0_bottom], [int(x + segment_width), y1_bottom], 1)
        
        # Update starting x-coordinate for the next segment
        x += segment_width
        
        # Set the starting y-coordinate for the next segment
        y0_top = y1_top
        y0_bottom = y1_bottom
    
    # Print background color layer over entire image
    veil = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))  
    veil.set_alpha(int(etc.knob3 * 200))  # Adjust transparency on knob1
    veil.fill((etc.bg_color[0], etc.bg_color[1], etc.bg_color[2])) 
    screen.blit(veil, (0, 0))  # (0,0) = starts at top left 