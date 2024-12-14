"""
    T - Subliminal Messenger
    by Martin Werner
    Controls:
        Knob1: x/y position (0 = random, 1 = centered)
        Knob2: text angle (0 = straight, 1 = extreme angle)
        Knob3: trigger treshold (1-8, 1 = every trigger, 8 = every 8th trigger)
        Knob4: text color
        Knob5: background color
"""

from os import listdir
from os.path import abspath, dirname, join, splitext
from random import randint, random, uniform
import pygame


lc = 0
fc = 0
splitted_line = []


class UniqueRandomGenerator:
    """
    Generates a random number within a range,
    but never the same number twice in a row.
    """

    def __init__(self, min_val, max_val):
        self.min_val = min_val
        self.max_val = max_val
        self.prev_val = None

    def get(self):
        while True:
            new_val = randint(self.min_val, self.max_val)
            if new_val != self.prev_val:
                self.prev_val = new_val
                return new_val


def setup(screen, etc):
    global fonts, fonts_dir, fc, lines, lc, rndm_ln, rndm_fnt
    global trigger_count, trigger_treshold, word
    trigger_count = 0
    trigger_treshold = 1
    word = ""
    current_dir = dirname(abspath(__file__))
    fonts_dir = join(current_dir, "fonts")
    fonts = [f for f in listdir(fonts_dir) if splitext(f)[1].lower() == ".ttf"]
    lines_txt = join(current_dir, "txt", "lines.txt")
    with open(lines_txt, "r") as file:
        lines = file.read().splitlines()
    fc = len(fonts)
    lc = len(lines)
    rndm_ln = UniqueRandomGenerator(0, lc - 1)
    rndm_fnt = UniqueRandomGenerator(0, fc - 1)


def draw(screen, etc):
    global fonts, fonts_dir, lines, fc, lc, splitted_line, rndm_ln, rndm_fnt
    global trigger_count, trigger_treshold
    color = etc.color_picker(etc.knob4)
    etc.color_picker_bg(etc.knob5)
    """
    For faster music you might want to increase the trigger treshold.
    At 0 value, the text is displayed at every trigger. Moving towards 1,
    the text is displayed less often. At 1, the text is displayed every 8th
    trigger. If it is still too fast, you can increase the multiplicator
    in the line below from 7 to a higher value of your choice.
    """
    new_trigger_treshold = 1 + int(etc.knob3 * 7)
    if new_trigger_treshold < trigger_treshold:
        trigger_count = 0
    trigger_treshold = new_trigger_treshold
    if etc.audio_trig or etc.midi_note_new:
        trigger_count += 1
        if trigger_count == trigger_treshold:
            trigger_count = 0
            if not splitted_line:
                line_index = rndm_ln.get()
                splitted_line = lines[line_index].split(" ")
            elif splitted_line:
                try:
                    word = splitted_line.pop(0)
                except IndexError:
                    line_index = rndm_ln.get()
                    splitted_line = lines[line_index].split(" ")
                    word = splitted_line.pop(0)
                if len(word) >= 8:
                    font_size = randint(80, 120)
                else:
                    font_size = randint(80, 250)
                rndm_fnt = UniqueRandomGenerator(0, fc - 1)
                font_index = rndm_fnt.get()
                font = pygame.font.Font(
                    fonts_dir + "/" + fonts[font_index], font_size
                )

                """
                At position 0, the angle of the text is 0 degrees - straight.
                The further the position moves towards 1, the more extreme
                random values between -45 and 45 degrees get generated.
                """
                angle_range = etc.knob2 * 45
                angle = uniform(-angle_range, angle_range)
                # angle = (etc.knob2 * 90) - 45

                """
                At position 0, the text is displayed randomly across the entire
                screen. The further the position moves towards 1, the more
                centered the text is displayed to the middle of the screen.
                At position 1, it is 100% centered.
                """
                position = etc.knob1
                random_x = int(random() * screen.get_width())
                random_y = int(random() * screen.get_height())
                center_x = screen.get_width() // 2
                center_y = screen.get_height() // 2

                if position < 1.0:
                    x_position = int(
                        (1 - position) * random_x + position * center_x
                    )
                    y_position = int(
                        (1 - position) * random_y + position * center_y
                    )
                else:
                    x_position = center_x
                    y_position = center_y

                """
                The shadow of the text is displayed with a black color and
                an offset of 3 pixels to the right and 3 pixels down.
                """
                shadow_color = (0, 0, 0)  # Black for shadow
                shadow_offset = (3, 3)  # Offset of the shadow
                shadow_font = pygame.font.Font(
                    fonts_dir + "/" + fonts[font_index], font_size
                )
                shadow_text = shadow_font.render(word, True, shadow_color)
                shadow_text = pygame.transform.rotate(shadow_text, angle)
                shadow_textpos = shadow_text.get_rect()
                shadow_textpos.centerx = x_position + shadow_offset[0]
                shadow_textpos.centery = y_position + shadow_offset[1]
                screen_rect = screen.get_rect()  # Get the screen rect
                shadow_textpos.clamp_ip(screen_rect)  # Clamp the shadow text
                screen.blit(shadow_text, shadow_textpos)

                """
                The text is displayed with the chosen color and position.
                """
                text = font.render(word, True, color)
                text = pygame.transform.rotate(text, angle)
                textpos = text.get_rect()
                textpos.centerx = x_position
                textpos.centery = y_position
                textpos.clamp_ip(screen_rect)
                screen.blit(text, textpos)
