# pip install spidev
import spidev
import time

# Inizializza SPI per MCP3008
spi = spidev.SpiDev()
spi.open(0, 0)  # Bus SPI 0, dispositivo CE0
spi.max_speed_hz = 1350000  # Frequenza massima

def read_adc(channel):
    if channel < 0 or channel > 7:
        raise ValueError("Il canale deve essere compreso tra 0 e 7")
    
    adc = spi.xfer2([1, (8 + channel) << 4, 0])
    data = ((adc[1] & 3) << 8) | adc[2]
    return data

# Loop principale
try:
    while True:
        # Leggi il valore analogico dal canale 0
        raw_value = read_adc(0)
        voltage = raw_value * 3.3 / 1023  # Converti in tensione (riferimento 3.3V)
        # Scrivi i dati sul display
        print(f"Valore ADC: {raw_value} = {voltage:.2f}V")
        time.sleep(0.5)
except KeyboardInterrupt:
    print("Interrotto dall'utente")
finally:
    spi.close()
