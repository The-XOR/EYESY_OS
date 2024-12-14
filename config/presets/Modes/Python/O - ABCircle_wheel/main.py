#!/usr/bin/env python
"""C&G EYESY mode - O - ABCircles_wheel - v0.1 - Python 2 - Azotosome"""

# Setup Python ----------------------------------------------- #
import math
import pygame
import pygame.math

# Initialize ------------------------------------------------- #
trigger = False

# Circle variables.
circle_radius = 12
circle_spd_cntr = 0
circle_direction_toggle = False

# Spoke variables.
spoke_vect_len = 312

# wheelhub variables.
hub_vect_len = 0
hub_vect_len_cntr = 0
hub_vect_len_spd_fact = 0.05
hub_vect_len_ampl = 0
hub_rot_toggle = False
hub_rot_direction = 1
hub_vect_rot_cntr = 0
hub_vect_rot_spd_fact = 0

# Color variables.
color_anim = 0
color_anim_spd_cntr = 0
color_anim_spd_fact = 0.08
color_anim_ampl = 0.07


# Functions & Classes ---------------------------------------- #
def setup(screen, etc):
    global S_WIDTH, S_HEIGHT, S_WIDTH_H, S_HEIGHT_H
    S_WIDTH = etc.xres
    S_HEIGHT = etc.yres
    S_WIDTH_H = S_WIDTH // 2
    S_HEIGHT_H = S_HEIGHT // 2


def draw(screen, etc):
    global \
        trigger, \
        color, \
        circle_radius, \
        circle_spd_cntr, \
        circle_direction_toggle, \
        spoke_vect_len, \
        hub_vect_len, \
        hub_vect_len_cntr, \
        hub_vect_len_spd_fact, \
        hub_vect_len_ampl, \
        hub_vect_rot_cntr, \
        hub_vect_rot_spd_fact, \
        hub_rot_toggle, \
        hub_rot_direction, \
        color_anim, \
        color_anim_spd_cntr, \
        color_anim_spd_fact, \
        color_anim_ampl

    # Update ------------------------------------------------- #
    # User input -------- START -------- #
    # EYESY knob input.
    circle_offset = etc.knob1
    circle_amount = (etc.knob2 * 440) + 8
    circle_spd_fact = (etc.knob3) + 0.005
    color = etc.color_picker(etc.knob4 + color_anim)
    etc.color_picker_bg(etc.knob5)

    # EYESY audio trigger.
    # Toggle circle direction.
    if etc.audio_trig:
        circle_direction_toggle ^= True
    if circle_direction_toggle:
        circle_direction = -1
    else:
        circle_direction = 1

    # MIDI input.
    # Size of circles coarse-tune.
    if etc.midi_notes[60] and circle_radius >= 6:
        circle_radius -= 4
    if etc.midi_notes[61] and circle_radius <= 32:
        circle_radius += 4
    # Size of circles fine-tune.
    if etc.midi_notes[62] and circle_radius > 2:
        circle_radius -= 1
    if etc.midi_notes[63] and circle_radius < 36:
        circle_radius += 1

    # Size of spokes coarse-tune.
    if etc.midi_notes[64] and spoke_vect_len > 120:
        spoke_vect_len -= 32
    if etc.midi_notes[65] and spoke_vect_len < S_WIDTH:
        spoke_vect_len += 32
    # Size of spokes fine-tune.
    if etc.midi_notes[66] and spoke_vect_len > 120:
        spoke_vect_len -= 2
    if etc.midi_notes[67] and spoke_vect_len < S_WIDTH:
        spoke_vect_len += 2

    # Wheelhub x-axis position amplitide.
    if etc.midi_notes[68] and hub_vect_len_ampl > 0:
        hub_vect_len_ampl -= 4
    if etc.midi_notes[69] and hub_vect_len_ampl < 1024:
        hub_vect_len_ampl += 4
    # Wheelhub x-axis position oscillating speed.
    if etc.midi_notes[70] and hub_vect_len_spd_fact > 0.01:
        hub_vect_len_spd_fact -= 0.005
    if etc.midi_notes[71] and hub_vect_len_spd_fact < 2:
        hub_vect_len_spd_fact += 0.005

    # Wheelhub rotation speed.
    if etc.midi_notes[72] and hub_vect_rot_spd_fact > 0:
        hub_vect_rot_spd_fact -= 0.125
    if etc.midi_notes[73] and hub_vect_rot_spd_fact < 50:
        hub_vect_rot_spd_fact += 0.125

    # Toggle wheelhub rotation direction.
    if etc.midi_notes[74]:
        hub_rot_toggle ^= True
    if hub_rot_toggle:
        hub_rot_direction = -1
    else:
        hub_rot_direction = 1

    # Oscillating color amplitude/range.
    if etc.midi_notes[75] and color_anim_ampl > 0:
        color_anim_ampl -= 0.01
    if etc.midi_notes[76] and color_anim_ampl < 0.5:
        color_anim_ampl += 0.01
    # Oscillating color speed.
    if etc.midi_notes[77] and color_anim_spd_fact > 0.01:
        color_anim_spd_fact -= 0.01
    if etc.midi_notes[78] and color_anim_spd_fact < 0.75:
        color_anim_spd_fact += 0.01

    # User input -------- END -------- #

    # Oscillating color anim.
    if color_anim_ampl > 0:
        color_anim_spd_cntr += color_anim_spd_fact
        color_anim = math.sin(color_anim_spd_cntr) * color_anim_ampl

    # Setup and modify vectors.
    BASE_VECT = pygame.math.Vector2(S_WIDTH_H, S_HEIGHT_H)
    spoke_vect = pygame.math.Vector2(spoke_vect_len, 0)
    spoke_angle = 360 / circle_amount

    # Wheelhub transformations.
    if hub_vect_len_ampl > 0:
        hub_vect_len_cntr += hub_vect_len_spd_fact
        hub_vect_len = math.sin(hub_vect_len_cntr) * hub_vect_len_ampl
        if hub_vect_rot_spd_fact <= 0:
            # Oscillate wheelhub on x-axis position.
            hub_vect = pygame.math.Vector2(hub_vect_len, 0)
        elif hub_vect_rot_spd_fact > 0:
            # As above but also rotates around center of screen.
            hub_vect_rot_cntr += hub_vect_rot_spd_fact * hub_rot_direction
            hub_vect = pygame.math.Vector2(hub_vect_len, 0).rotate(hub_vect_rot_cntr)
    else:
        # Wheelhub stays in center of screen.
        hub_vect = pygame.math.Vector2(0, 0)

    # Oscillating speed and direction of circle.
    circle_spd_cntr += circle_spd_fact * circle_direction

    # Create spokes, add-up all vectors and draw circles.
    for circle in range(int(circle_amount)):
        adj_spoke_vect = spoke_vect.rotate(spoke_angle * circle) * math.sin(
            circle_spd_cntr + (circle * circle_offset)
        )
        pygame.draw.circle(
            screen,
            color,
            (
                int(BASE_VECT.x) + int(hub_vect.x) + int(adj_spoke_vect.x),
                int(BASE_VECT.y) + int(hub_vect.y) + int(adj_spoke_vect.y),
            ),
            circle_radius,
        )
