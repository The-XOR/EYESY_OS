# MIDI TEST
# pip install py-midi
from midi import MidiConnector
conn = MidiConnector('/dev/serial0', 38400)

print (conn)
while True:
        msg = conn.read()
        print(msg.type)

print("Done")
