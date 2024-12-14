import pygame
from pygame.math import Vector2

import random
STAR_BORDER = 0.05  # percent of screen width margin for star spawns


def lerp(a, b, weight):
    return (weight * a) + ((1 - weight) * b)


class Star:

    def __init__(self):
        self.position = Vector2(0, 0)
        self.x = 0
        self.y = 0
        self.direction = Vector2(0, 0)

        self.speed = 0
        self.additional_speed = 0

        self.size = 0
        # self.additional_size = 0

        self.tail_length = 0
        # self.additional_tail = 0

        self.ticks = 0

    def initialize(self, x, y, direction, speed):
        self.position = Vector2(x, y)
        self.x = x
        self.y = y
        self.direction = direction.normalize()
        self.speed = speed
        self.tail_length = 5
        self.size = 0.001
        self.ticks = 0

    def update(self):
        # self.additional_speed = ext_speed_modifier
        # self.additional_size = ext_size_modifier
        # self.additional_tail = ext_tail_modifier
        # self.position += self.direction * (self._speed + ext_speed_modifier)
        self.x = self.position.x
        self.y = self.position.y
        self.ticks += 1
        self.speed += 0.01
        # self._tail_length = self._speed * 3
        self.size += 0.2

    # def size(self):
    #     return self._size + self.additional_size
    #
    # def tail_length(self):
    #     if self.ticks < 3:
    #         return 0
    #     return self._tail_length + self.additional_tail
    #
    # def speed(self):
    #     return self._speed + self.additional_speed


class StarFactory:

    def __init__(self, screen):
        self.width = screen.get_width()
        self.height = screen.get_height()
        self.center = Vector2(self.width / 2, self.height / 2)
        self.x_spawnable_lo = int(self.width * STAR_BORDER)
        self.x_spawnable_hi = int(self.width * (1 - STAR_BORDER))
        self.y_spawnable_lo = int(self.height * STAR_BORDER)
        self.y_spawnable_hi = int(self.height * (1 - STAR_BORDER))

    def birth_star(self, star=None):
        while True:
            x = random.randint(self.x_spawnable_lo, self.x_spawnable_hi)
            y = random.randint(self.y_spawnable_lo, self.y_spawnable_hi)
            position = Vector2(x, y)
            direction = position - self.center
            if direction.length() < 10:
                continue
            if star is None:
                star = Star()
            initial_speed = (self.center.x / direction.length()) / 10
            star.initialize(x, y, direction, initial_speed)
            return star

    def oob(self, star):
        return star.y < 0 or star.y > self.height or star.x < 0 or star.x > self.width


def setup(screen, etc):
    # Create a list of stars, each with a random position and velocity
    etc.stars = []
    etc.sf = StarFactory(screen)
    for i in range(50):
        etc.stars.append(etc.sf.birth_star())


def draw(screen, etc):
    # Adjust the speed of all stars based on the value of knob1
    speed_factor = etc.knob1 * 16 + 1

    # Determine the tail length factor based on the value of knob2
    tail_length_factor = int(etc.knob2 * 10)

    # Add a base size to the stars based on the value of knob3
    base_size = etc.knob3 * 16 + 1

    # Determine the star color based on the value of knob4
    color_pos = int(etc.knob4 * 255)

    # Change the background color based on the value of knob5
    bg_color = etc.color_picker_bg(etc.knob5)

    star_color = pygame.Color(255, 255, 255)
    if color_pos > 0:
        star_color.hsva = (color_pos, 100, 100)

    # Determine the size factor based on the value of audio_in
    size_factor = (abs(sum(etc.audio_in)) / 5000) * 0.5
    # print(size_factor)

    # Draw each star

    for star in etc.stars:
        # Move the star according to its velocity and the speed factor
        # star.update(speed_factor)
        adjusted_speed = (star.speed + speed_factor)
        star.position += star.direction * adjusted_speed
        star.update()

        if etc.sf.oob(star):
            # If the star goes off the screen, generate a new star in the field
            etc.sf.birth_star(star)
        # Draw the star as a small white square, with size adjusted based on velocity and audio input
        size = round(size_factor + star.size + base_size)
        size_2 = size/2
        size_3 = size/3

        # Draw the tail first for ordering reasons
        tail_length = int(star.tail_length + tail_length_factor)
        for i in reversed(range(tail_length)):
            factor = (tail_length - i - 1) / tail_length
            radius = int(lerp(size_2, size_3, factor))
            width = int(lerp(size, size_2, factor))
            tail_color = pygame.Color(int(lerp(star_color.r, bg_color[0], factor)),
                                      int(lerp(star_color.g, bg_color[1], factor)),
                                      int(lerp(star_color.b, bg_color[2], factor)),
                                      int(255 * ((tail_length - i - 1) / tail_length)))
            tail_pos = star.position - (i * star.direction * (adjusted_speed/5))
            pygame.draw.circle(screen, tail_color, (int(tail_pos.x), int(tail_pos.y)), radius, radius)
        pygame.draw.circle(screen, star_color, (int(star.x), int(star.y)), int(size_2), int(size_2))