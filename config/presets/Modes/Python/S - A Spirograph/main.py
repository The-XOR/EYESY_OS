import pygame
import math
import time

# Define constants
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

# Initialize Pygame
pygame.init()

# Setup function
def setup(screen, etc):
    pass

# Draw function
def draw(screen, etc):
    # Clear the screen with the background color controlled by knob5
    etc.color_picker_bg(etc.knob5) 

    # Calculate the radius of the circular waveform based on knob1
    radius = int(etc.knob1 * min(SCREEN_WIDTH, SCREEN_HEIGHT) / 8)

    # Calculate the center of the screen
    center_x = SCREEN_WIDTH // 2
    center_y = SCREEN_HEIGHT // 2

    # Calculate the number of samples controlled by knob2
    num_samples = int(etc.knob2 * len(etc.audio_in))

    # Calculate the angle increment based on the number of samples
    angle_increment = 2 * math.pi / num_samples if num_samples > 0 else 0

    # Calculate color variation based on knob3
    color_variation = etc.knob3 * 360 + time.time()*etc.knob3*500# Map knob3 value to hue in degrees

    # Draw circular waveform
    for i in range(num_samples):
        # Calculate the angle for this sample
        angle = i * angle_increment

        # Calculate the position of the point on the circular path
        x = center_x + int(radius * math.cos(angle) * etc.audio_in[i] / 100)
        y = center_y + int(radius * math.sin(angle) * etc.audio_in[i] / 100)

        # Calculate color based on knob3
        hue = (color_variation + i * etc.knob4 * 360 / num_samples) % 360  # Add variation based on knob4
        saturation = 100
        lightness = 50
        alpha = 1

        # Create a Color object with HSLA color values
        color = pygame.Color(0)
        color.hsla = (hue, saturation, lightness, alpha)

        # Draw a line from the previous point to this point
        if i > 0:
            pygame.draw.line(screen, color, (prev_x, prev_y), (x, y), 1)

        # Remember this point for the next iteration
        prev_x, prev_y = x, y