import alsaaudio, audioop
import time
import math

inp = None
etc = None
trig_this_time = 0
trig_last_time = 0
sin = [0] * 100
i = 0

def init (etc_object) :
    global inp, etc, trig_this_time, trig_last_time, sin
    etc = etc_object
    #setup alsa for sound in
    inp = alsaaudio.PCM(alsaaudio.PCM_CAPTURE,alsaaudio.PCM_NONBLOCK)
    inp.setchannels(2)
    inp.setrate(96000)
    inp.setformat(alsaaudio.PCM_FORMAT_S32_LE)
    inp.setperiodsize(300)
    trig_last_time = time.time()
    trig_this_time = time.time()
    
    for k in range(0,100) :
        sin[k] = int(math.sin(2 * 3.1459 * k / 100) * 32700)

def dump() :
    inp.dumpinfo()
    print "PCM pcmtype()", inp.pcmtype()
    print "PCM pcmmode()", inp.pcmmode()
    print "Card name", inp.cardname()

def recv() :
    global inp, etc, trig_this_time, trig_last_time, sin
    # get audio
    while 1:
        l,data32 = inp.read()
        if l > 0: break
        time.sleep(.01)

    peak = 0
    dataptr = 0
    while l - dataptr >= 6:
        data = audioop.lin2lin(data32, 4, 2) # convert to 16 bit
        try :
            avgL = audioop.getsample(data, 2, dataptr)
            avgL += audioop.getsample(data, 2,dataptr + 2)
            avgL += audioop.getsample(data, 2,dataptr + 4)
            avgL = avgL / 3
            avgR = audioop.getsample(data, 2, dataptr+1)
            avgR += audioop.getsample(data, 2,dataptr + 3)
            avgR += audioop.getsample(data, 2,dataptr + 5)
            dataptr += 6
            avgR = avgL / 3
            avg = (avgL + avgR) / 2 # in mono
            avg = int(avg * etc.audio_scale)
            if (avg > 20000) :
                trig_this_time = time.time()
                if (trig_this_time - trig_last_time) > .05:
                    if etc.audio_trig_enable: etc.audio_trig = True
                    trig_last_time = trig_this_time
            if avg > peak :
                etc.audio_peak = avg
                peak = avg
            # if the trigger button is held
            if (etc.trig_button) :
                etc.audio_in[i] = sin[i] 
            else :
                etc.audio_in[i] = avg
            i = (i + 1) % 100
            if i == 0 :
                break
        except :
            pass


# import etc_system
# etc = etc_system.System()
# etc.clear_flags()
# init(etc)
# dump()
# while 1:
#     recv()
#     print(etc.audio_peak)
#     time.sleep(.01)
