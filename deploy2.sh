#!/bin/bash

cd ~/EYESY_OS
sudo chown -R music:music ./config/presets
sudo cp --remove-destination ./config/presets /sdcard

# ------------------ todo: controllare se servono ancora
#pushd /usr/lib/arm-linux-gnueabihf
#sudo cp librtaudio.so librtaudio.so.5
#popd

sudo systemctl enable eyesy-web.service
sudo systemctl enable eyesy-web-socket.service

# configure systemd stuff
systemctl disable eyesy-oflua.service  
systemctl enable cherrypy.service  
systemctl enable eyesy-pd.service  
systemctl enable eyesy-python.service  
systemctl enable splashscreen.service  
systemctl enable ttymidi.service  

# networking started by eyesy-pd
#systemctl disable dhcpcd.service
#systemctl disable wpa_supplicant.service
systemctl disable createap.service  
sudo systemctl start eyesy-web.service
sudo systemctl start eyesy-web-socket.service

systemctl daemon-reload
