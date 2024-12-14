#!/bin/bash

cd ~/EYESY_OS
sudo chown -R music:music ./config/presets
sudo chown -R music:music /sdcard
cp --remove-destination -r ./config/presets/* /sdcard
sudo cp --remove-destination /etc/wpa_supplicant/wpa_supplicant.conf /sdcard/System/wpa_supplicant.conf

pushd /usr/lib/arm-linux-gnueabihf
sudo cp librtaudio.so librtaudio.so.5
popd

#sudo systemctl enable eyesy-web.service
#sudo systemctl enable eyesy-web-socket.service
#sudo systemctl start eyesy-web.service
#sudo systemctl start eyesy-web-socket.service

# configure systemd stuff
sudo systemctl disable eyesy-oflua.service  
sudo systemctl enable cherrypy.service  
sudo systemctl enable eyesy-pd.service  
sudo systemctl enable eyesy-python.service  
sudo systemctl enable splashscreen.service  
sudo systemctl enable ttymidi.service  
sudo systemctl start cherrypy.service  

# networking started by eyesy-pd
#systemctl disable dhcpcd.service
#systemctl disable wpa_supplicant.service
sudo systemctl disable createap.service  

sudo systemctl disable hciuart.service  

sudo systemctl daemon-reload

librtaudio.so.5
libcurl.so.4
libssl.so.1.0.2
libcrypto.so.1.0.2