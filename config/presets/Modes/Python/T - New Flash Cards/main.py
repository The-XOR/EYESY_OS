import os
import pygame
import random
import pygame.freetype
import imp

words = []
word1 = ''
word2 = ''
count = 0
word_index = 0
range = 0

def setup(screen, etc):
    global words
    pygame.freetype.init()
    flashcards_words = imp.load_source('flashy',etc.mode_root +  '/flashcards.py')
    words = flashcards_words.words
    pass

def draw(screen, etc):
    global words, word1, word2, count, word_index, range
    

    etc.color_picker_bg(etc.knob5)
    range = len(words) - 1
    color = etc.color_picker(etc.knob4)
    size = etc.knob1 * 500 + 10
    x = etc.knob2 * 400
    y = etc.knob3 * 400
    font = pygame.freetype.Font(etc.mode_root + "/font.ttf", size)
    
    if etc.audio_trig or etc.midi_note_new : 
        count += 1
        count %= 3
        if count == 1 :
            word_index = random.randint(0,range)
            word1 = unicode(words[word_index][0])
        if count == 2 :
            word2 = unicode(words[word_index][1])
    
    if (count == 0) :
        pass
    
    if (count == 1) :
        (text, textpos1) = font.render(word1, color)
        textpos1 =(x, y)
        screen.blit(text, textpos1)
        
    if (count == 2) :
        (text, textpos1) = font.render(word1, color)
        textpos1 =(x, y)
        screen.blit(text, textpos1)
        (text, textpos1) = font.render(word2, color)
        textpos1 =(x, y + size)
        screen.blit(text, textpos1)


    
    
    
    
    
    



   

