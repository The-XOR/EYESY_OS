import RPi.GPIO as GPIO
import time

# Define GPIO pins
DATA_PIN = 22   # Q7 of second 74HC165
CLOCK_PIN = 27  # CP (Clock)
LATCH_PIN = 17  # PL (Parallel Load)

# Setup GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(DATA_PIN, GPIO.IN)  # Read input
GPIO.setup(CLOCK_PIN, GPIO.OUT, initial=GPIO.LOW)
GPIO.setup(LATCH_PIN, GPIO.OUT, initial=GPIO.HIGH)

def stable_read(pin):
    """Read a GPIO pin multiple times to reduce glitches."""
    value1 = GPIO.input(pin)
    time.sleep(0.00005)  # 500µs delay
    value2 = GPIO.input(pin)
    return value1 if value1 == value2 else 0  # If mismatch, assume low

def read_shift_registers():
    GPIO.output(LATCH_PIN, GPIO.LOW)  # Load parallel data
    time.sleep(0.0001)
    GPIO.output(LATCH_PIN, GPIO.HIGH)  # Latch data

    data = 0
    for i in range(16):
        bit = stable_read(DATA_PIN)  # Read stable data bit
        data = (data << 1) | bit  # Shift left and store bit
#        print(f"i={i} bit= {bit}")  # Print as binary
        GPIO.output(CLOCK_PIN, GPIO.HIGH)
        time.sleep(0.0001)  # Small delay
        GPIO.output(CLOCK_PIN, GPIO.LOW)
        time.sleep(0.0001)

    return data

try:
    while True:
        value = read_shift_registers()
        print(f"SR Value: {bin(value)} = {hex(value)}")  # Print as binary
        time.sleep(0.2)

except KeyboardInterrupt:
    GPIO.cleanup()
