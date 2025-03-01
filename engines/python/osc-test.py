import os
import sys
import liblo
import osc
import time
import etc_system

osc_server = None
osc_target = None

cc_last = [0] * 5
pgm_last = 0
notes_last = [0] * 128
clk_last = 0

# OSC callbacks
def fallback(path, args):
    pass

def fs_callback(path, args):
    v = args
    if (v[0] > 0):
        print "foot pressed"

def midipgm_callback(path, args):
    txt = str('midi: ' + args[0])
    print txt

def midicc_callback(path, args):
    global cc_last
    val, num = args
    print "midi cc: " + str(num) + " " + str(val)

def midinote_callback(path, args):
    num, val = args
    print "midi note: " + str(num) + " " + str(val)

def trig_callback(path, args) :
    print "TRIGGER HAPPY"

def audio_scale_callback(path, args):
    val = args[0]
    print "Audio scale " + str(val)

def audio_trig_enable_callback(path, args):
    val = args[0]
    if val == 1 : print "Trigger 1"
    else : print "Trigger 0"

def link_present_callback(path, args):
    val = args[0]
    if val == 1 : print "link_connected 1"
    else : print "link_connected 0"

def mblob_callback(path, args):
    global cc_last, pgm_last, notes_last, clk_last
    midi_blob = args[0]
    
    for i in range(0, 5) :
        cc = midi_blob[16 + i]
        if cc != cc_last[i] :
            cc_last[i] = cc
            
    clk = midi_blob[21]
    if (clk != clk_last):
        clk_last = clk

    pgm = midi_blob[22]
    if (pgm != pgm_last):
        pgm_last = pgm

    # parse the notes outta the bit field
    for i in range(0, 16) :
        for j in range(0, 8) :
            if midi_blob[i] & (1<<j) :
                if(notes_last[(i*8)+j] != 1) : 
                    notes_last[(i*8)+j] = 1
            else :
                if(notes_last[(i*8)+j] != 0) : 
                    notes_last[(i*8)+j] = 0

def set_callback(path, args):
    name = args[0]
    print "set patch to: " + str(name)

def new_callback(path, args):
    name = args[0]

def reload_callback(path, args):
    print "reloading: " 

def midi_ch_callback(path, args):
    val = args[0]
    send("/midi_ch", val)

def trigger_source_callback(path, args):
    val = args[0]
    if val == 0 : print "audio trig enable"
    else : print "audio trig disable"

def knobs_callback(path, args):
    k1, k2, k3, k4, k5, k6 = args
    print "received message: " + str(args)

# for TouchOSC control
def knob1_callback(path, args):
    k1 = args[0]
    print "received message: k1 " + str(args)

def knob2_callback(path, args):
    k2 = args[0]
    print "received message: k2 " + str(args)

def knob3_callback(path, args):
    k3 = args[0]
    print "received message: k3 " + str(args)

def knob4_callback(path, args):
    k4 = args[0]
    print "received message: k4 " + str(args)

def knob5_callback(path, args):
    k5 = args[0]
    print "received message: k5 " + str(args)

def shift_callback(path, args) :
    stat = int(args[0])
    if stat == 1 : 
        print "SHIFFETE"
    else : 
        print "NO Shiffete"

def shift_line_callback(path, args) :
    k = args[0]
    print "shift line " + str(k + 1) 

def keys_callback(path, args) :
    k, v = args
    print "Key " + str(k) + "  arg = " + str(v)

def init (etc_object) :
    global osc_server, osc_target
    
    # OSC init server and client
    try:
        osc_target = liblo.Address(4001)
    except liblo.AddressError as err:
        print(err)

    try:
        osc_server = liblo.Server(4000)
    except liblo.ServerError as err:
        print (err)
    
    # added methods for TouchOsc template as it cannot send two arguments
    osc_server.add_method("/knobs/1", 'f', knob1_callback)
    osc_server.add_method("/knobs/2", 'f', knob2_callback)
    osc_server.add_method("/knobs/3", 'f', knob3_callback)
    osc_server.add_method("/knobs/4", 'f', knob4_callback)
    osc_server.add_method("/knobs/5", 'f', knob5_callback)
    osc_server.add_method("/key/1", 'f', singlekey_callback)
    osc_server.add_method("/key/2", 'f', singlekey_callback)
    osc_server.add_method("/key/3", 'f', singlekey_callback)
    osc_server.add_method("/key/4", 'f', singlekey_callback)
    osc_server.add_method("/key/5", 'f', singlekey_callback)
    osc_server.add_method("/key/6", 'f', singlekey_callback)
    osc_server.add_method("/key/7", 'f', singlekey_callback)
    osc_server.add_method("/key/8", 'f', singlekey_callback)
    osc_server.add_method("/key/9", 'f', singlekey_callback)
    osc_server.add_method("/key/10", 'f', singlekey_callback)
    osc_server.add_method("/key/11", 'f', singlekey_callback)

    # original osc methods
    osc_server.add_method("/knobs", 'iiiiii', knobs_callback)
    osc_server.add_method("/key", 'ii', keys_callback)
    osc_server.add_method("/mblob", 'b', mblob_callback)
    osc_server.add_method("/midicc", 'ii', midicc_callback)
    osc_server.add_method("/midipgm", 'i', midipgm_callback)
    osc_server.add_method("/midinote", 'ii', midinote_callback)
    osc_server.add_method("/reload", 'i', reload_callback)
    osc_server.add_method("/set", 's', set_callback)
    osc_server.add_method("/new", 's', new_callback)
    osc_server.add_method("/fs", 'i', fs_callback)
    osc_server.add_method("/shift", 'i', shift_callback)
    osc_server.add_method("/ascale", 'f', audio_scale_callback)
    osc_server.add_method("/trig", 'i', trig_callback)
    osc_server.add_method("/atrigen", 'i', audio_trig_enable_callback)
    osc_server.add_method("/linkpresent", 'i', link_present_callback)
    osc_server.add_method("/midi_ch", 'i', midi_ch_callback)
    osc_server.add_method("/trigger_source", 'i', trigger_source_callback)
    osc_server.add_method("/sline", None, shift_line_callback)
    osc_server.add_method(None, None, fallback)

def recv() :
    global osc_server
    while True:
        data = osc_server.recv(100)
        print "rcv " + str(data)

def send(addr, args) :
    global osc_target
    liblo.send(osc_target, addr, args) 

def send_params_pd():
    pass

etc = etc_system.System()
osc.init(etc)

while 1:
    osc.recv()
    time.sleep(1)
